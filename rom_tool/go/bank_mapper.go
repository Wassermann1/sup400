package main

// BankMapper implements memory bank switching according to VT03 documentation
type BankMapper struct {
	// Program memory registers
	Reg4100 uint8 // PA24-21 (bits D7-4)
	Reg4107 uint8 // PQ07-0 (PQ0)
	Reg4108 uint8 // PQ17-0 (PQ1)
	Reg4109 uint8 // PQ27-0 (PQ2)
	Reg410A uint8 // PQ37-0 (PQ3)
	Reg410B uint8 // PS2-0 (bits D2-0) - mapping mode

	// Video memory registers
	Reg2018 uint8 // VA20-10 (bits D6-4), EVA12-10 (bits D2-0)
	Reg201A uint8 // Video bank control
	Reg2011 uint8 // LCD control (bit 1 for extension mode)
	Reg4105 uint8 // Address exchange condition (bit 7)
}

// CalculateProgramAddress calculates the physical ROM address from program address
// based on the case determined by $410B & 0x07
func (bm *BankMapper) CalculateProgramAddress(programAddr uint32, bank uint8) uint32 {
	caseNum := bm.Reg410B & 0x07

	// Base: ($4100 & 0xF0) << 17
	base := uint32(bm.Reg4100&0xF0) << 17

	var secondTerm uint32
	switch caseNum {
	case 0: // Default
		// (($410A & 0xC0) | (BANK & 0x3F)) << 13
		secondTerm = uint32((bm.Reg410A&0xC0)|(bank&0x3F)) << 13
	case 1:
		// (($410A & 0xE0) | (BANK & 0x1F)) << 13
		secondTerm = uint32((bm.Reg410A&0xE0)|(bank&0x1F)) << 13
	case 2:
		// (($410A & 0xF0) | (BANK & 0x0F)) << 13
		secondTerm = uint32((bm.Reg410A&0xF0)|(bank&0x0F)) << 13
	case 3:
		// (($410A & 0xF8) | (BANK & 0x07)) << 13
		secondTerm = uint32((bm.Reg410A&0xF8)|(bank&0x07)) << 13
	case 4:
		// (($410A & 0xFC) | (BANK & 0x03)) << 13
		secondTerm = uint32((bm.Reg410A&0xFC)|(bank&0x03)) << 13
	case 5:
		// (($410A & 0xFE) | (BANK & 0x01)) << 13
		secondTerm = uint32((bm.Reg410A&0xFE)|(bank&0x01)) << 13
	case 6:
		// $410A << 13
		secondTerm = uint32(bm.Reg410A) << 13
	case 7:
		// BANK << 13
		secondTerm = uint32(bank) << 13
	}

	// Physical address = base + secondTerm + (programAddr & 0x1FFF)
	return base + secondTerm + (programAddr & 0x1FFF)
}

// CalculateProgramBank calculates which bank should be mapped to a program address
// Returns the bank number and register values needed
// This works backwards: given physical address and program address, determine register values
func (bm *BankMapper) CalculateProgramBank(physicalAddr uint32, programAddr uint32) (bank uint8, regs ProgramBankRegs) {
	ps20 := bm.Reg410B & 0x07
	bankNum := physicalAddr / 8192 // 8KB bank number (0-255 for 2MB ROM)

	// Determine which program address range we're mapping to
	// Note: Program addresses $8000-$FFFF are mapped via PQ0-PQ3
	// Program addresses $0000-$7FFF are internal ranges

	// For addresses $8000-$FFFF, determine which slot
	var targetSlot int
	switch {
	case programAddr >= 0x8000 && programAddr < 0xA000:
		targetSlot = 0 // PQ0 → $8000-$9FFF
	case programAddr >= 0xA000 && programAddr < 0xC000:
		targetSlot = 1 // PQ1 → $A000-$BFFF
	case programAddr >= 0xC000 && programAddr < 0xE000:
		targetSlot = 2 // PQ2 → $C000-$DFFF
	case programAddr >= 0xE000:
		targetSlot = 3 // PQ3 → $E000-$FFFF
	default:
		// For $0000-$7FFF ranges, use different logic based on PS2-0
		targetSlot = -1
	}

	switch ps20 {
	case 0:
		// PS2-0=0 mode
		if targetSlot >= 0 {
			// $8000-$FFFF: Use bank number directly for the target slot
			bank = uint8(bankNum & 0xFF)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
			regs.PQ3 = bank
		} else if programAddr < 0x2000 {
			// $0000-$1FFF: PQ37-6=0 (first 512KB)
			// Bank must be in range 0-63
			bank = uint8(bankNum & 0x3F)
			regs.PQ0 = 0
			regs.PQ1 = 0
			regs.PQ2 = 0
			regs.PQ3 = 0
		} else if programAddr >= 0x2000 && programAddr < 0x4000 {
			// $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks
			bank = uint8(bankNum & 0x3F)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
		} else {
			// Higher internal addresses: use PQ3 with subbank encoding
			subbank := uint8((physicalAddr / (512 * 1024)) & 0x3)
			localBank := uint8((physicalAddr % (512 * 1024)) / 8192)
			bank = localBank & 0x3F
			regs.PQ3 = (subbank << 6) | bank
		}
	case 6:
		// PS2-0=6: PQ37-0 select 256 banks for $0000-$1FFF
		if targetSlot >= 0 {
			bank = uint8(bankNum & 0xFF)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
			regs.PQ3 = bank
		} else if programAddr < 0x2000 {
			// $0000-$1FFF: PQ37-0 select 256 banks
			bank = uint8(bankNum & 0xFF)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
			regs.PQ3 = bank
		} else if programAddr >= 0x2000 && programAddr < 0x4000 {
			// $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks
			bank = uint8(bankNum & 0x3F)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
		}
	case 7:
		// PS2-0=7: PQ27-0, PQ17-0, PQ07-0 select 256 banks for $0000-$1FFF
		if targetSlot >= 0 {
			bank = uint8(bankNum & 0xFF)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
			regs.PQ3 = bank
		} else if programAddr < 0x2000 {
			// $0000-$1FFF: PQ27-0, PQ17-0, PQ07-0 select 256 banks
			bank = uint8(bankNum & 0xFF)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
		} else if programAddr >= 0x2000 && programAddr < 0x4000 {
			// $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks
			bank = uint8(bankNum & 0x3F)
			regs.PQ0 = bank
			regs.PQ1 = bank
			regs.PQ2 = bank
		}
	default:
		// Other cases - use simple bank calculation
		bank = uint8(bankNum & 0xFF)
		regs.PQ0 = bank
		regs.PQ1 = bank
		regs.PQ2 = bank
		regs.PQ3 = bank
	}

	// Set PA24-21 based on physical address range (from documentation table)
	if physicalAddr < 0x200000 {
		regs.PA2421 = 0
	} else if physicalAddr >= 0x200000 && physicalAddr < 0x400000 {
		regs.PA2421 = 1
	} else if physicalAddr >= 0x400000 && physicalAddr < 0x600000 {
		regs.PA2421 = 2
	} else if physicalAddr >= 0x600000 && physicalAddr < 0x800000 {
		regs.PA2421 = 3
	} else if physicalAddr >= 0x800000 && physicalAddr < 0x1000000 {
		regs.PA2421 = 4 // 4-7 for 8M bytes
	} else if physicalAddr >= 0x1000000 {
		regs.PA2421 = 8 // 8-F for 16M bytes
	}

	return bank, regs
}

// ProgramBankRegs holds the register values for program bank switching
type ProgramBankRegs struct {
	PA2421 uint8 // $4100 bits D7-4
	PQ0    uint8 // $4107
	PQ1    uint8 // $4108
	PQ2    uint8 // $4109
	PQ3    uint8 // $410A
	PS20   uint8 // $410B bits D2-0
}

// CalculateVideoAddress calculates video memory address in normal mode
func (bm *BankMapper) CalculateVideoAddress(vbank uint8) uint32 {
	caseNum := bm.Reg201A & 0x07

	// Base: ($4100 & 0x0F) << 21
	base := uint32(bm.Reg4100&0x0F) << 21

	// ($2018 & 0x70) << 14
	va2018 := uint32(bm.Reg2018&0x70) << 14

	var vbankTerm uint32
	switch caseNum {
	case 0: // Default
		// VBANK << 10
		vbankTerm = uint32(vbank) << 10
	case 1:
		// (($201A & 0x80) | (VBANK & 0x7F)) << 10
		vbankTerm = uint32((bm.Reg201A&0x80)|(vbank&0x7F)) << 10
	case 2:
		// (($201A & 0xC0) | (VBANK & 0x3F)) << 10
		vbankTerm = uint32((bm.Reg201A&0xC0)|(vbank&0x3F)) << 10
	case 4:
		// (($201A & 0xE0) | (VBANK & 0x1F)) << 10
		vbankTerm = uint32((bm.Reg201A&0xE0)|(vbank&0x1F)) << 10
	case 5:
		// (($201A & 0xF0) | (VBANK & 0x0F)) << 10
		vbankTerm = uint32((bm.Reg201A&0xF0)|(vbank&0x0F)) << 10
	case 6:
		// (($201A & 0xF8) | (VBANK & 0x07)) << 10
		vbankTerm = uint32((bm.Reg201A&0xF8)|(vbank&0x07)) << 10
	default:
		// Case 3, 7 - use default
		vbankTerm = uint32(vbank) << 10
	}

	return base + va2018 + vbankTerm
}

// CalculateVideoAddressExtension calculates video memory address in extension mode
func (bm *BankMapper) CalculateVideoAddressExtension(vbank uint8, eva uint8) uint32 {
	caseNum := bm.Reg201A & 0x07

	// Base: ($4100 & 0x0F) << 21
	base := uint32(bm.Reg4100&0x0F) << 21

	var vbankTerm uint32
	switch caseNum {
	case 0: // Default
		// VBANK << 13
		vbankTerm = uint32(vbank) << 13
	case 1:
		// (($201A & 0x80) | (VBANK & 0x7F)) << 13
		vbankTerm = uint32((bm.Reg201A&0x80)|(vbank&0x7F)) << 13
	case 2:
		// (($201A & 0xC0) | (VBANK & 0x3F)) << 13
		vbankTerm = uint32((bm.Reg201A&0xC0)|(vbank&0x3F)) << 13
	case 4:
		// (($201A & 0xE0) | (VBANK & 0x1F)) << 13
		vbankTerm = uint32((bm.Reg201A&0xE0)|(vbank&0x1F)) << 13
	case 5:
		// (($201A & 0xF0) | (VBANK & 0x0F)) << 13
		vbankTerm = uint32((bm.Reg201A&0xF0)|(vbank&0x0F)) << 13
	case 6:
		// (($201A & 0xF8) | (VBANK & 0x07)) << 13
		vbankTerm = uint32((bm.Reg201A&0xF8)|(vbank&0x07)) << 13
	default:
		// Case 3, 7 - use default
		vbankTerm = uint32(vbank) << 13
	}

	// EVA << 10
	evaTerm := uint32(eva) << 10

	return base + vbankTerm + evaTerm
}

// CheckAddressExchange returns true if $4105&0x80 != 0, which causes
// $0000-$0FFF and $1000-$1FFF to exchange
func (bm *BankMapper) CheckAddressExchange() bool {
	return (bm.Reg4105 & 0x80) != 0
}
