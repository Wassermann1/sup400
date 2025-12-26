package main

type MMC3Config struct {
	Bytes [9]uint8
}

// BuildMMC3Config builds MMC3 configuration using proper VT03 bank switching formulas
// According to documentation, program bank mapping uses case-based formulas from $410B & 0x07
func BuildMMC3Config(game *NESGame, romOffset uint32) MMC3Config {
	startsAtBoundary := StartsAtChunkBoundary(game, romOffset)
	isSmallGame := IsSmallGame(game)

	chrStart := romOffset + game.PRGSize
	reg4100_video, reg2018, reg201A := CalcVideoRegisters(chrStart, game.PRGSize, startsAtBoundary, isSmallGame)

	// Use BankMapper to calculate proper program bank registers
	// According to documentation, we need to:
	// 1. Calculate PA24-21 from romOffset (for $4100 bits D7-4)
	// 2. Calculate bank numbers for each slot ($8000, $A000, $C000, $E000)
	// 3. Use proper case-based formula (typically Case 0 for MMC3)

	// Calculate PA24-21 from physical address (bits 24-21)
	pa24_21 := uint8((romOffset >> 21) & 0x0F)

	// Combine video VA24-21 (D3-0) and program PA24-21 (D7-4) in $4100
	// Note: $4100 is shared between program and video memory
	reg4100 := (pa24_21 << 4) | (reg4100_video & 0x0F)

	// Calculate bank numbers for each program address slot
	// $8000-$9FFF: PQ0 ($4107)
	bank4 := calculateBankForAddress(romOffset)
	// $A000-$BFFF: PQ1 ($4108)
	bank5 := calculateBankForAddress(romOffset + 8192)

	// For $C000 and $E000, use last banks of PRG ROM
	var bank6, bank7 uint8
	switch game.PRGSize {
	case 128 * 1024:
		bank6 = calculateBankForAddress(romOffset + (14 * 8192))
		bank7 = calculateBankForAddress(romOffset + (15 * 8192))
	case 256 * 1024:
		bank6 = calculateBankForAddress(romOffset + (30 * 8192))
		bank7 = calculateBankForAddress(romOffset + (31 * 8192))
	default:
		lastBankOffset := romOffset + game.PRGSize - 16384
		bank6 = calculateBankForAddress(lastBankOffset)
		bank7 = calculateBankForAddress(lastBankOffset + 8192)
	}

	byte8 := uint8(0x00)
	if game.CHRSize > 128*1024 {
		byte8 = 0x80
	}

	return MMC3Config{
		Bytes: [9]uint8{
			reg4100,
			reg2018,
			reg201A,
			0x02, // MMC3 mode (PS2-0 = 0, which is Case 0)
			bank4,
			bank5,
			bank6,
			bank7,
			byte8,
		},
	}
}

// calculateBankForAddress calculates the bank number needed to map physicalAddr to programAddr
// This uses the reverse of the documentation formula
func calculateBankForAddress(physicalAddr uint32) uint8 {
	// Align to 8KB boundary
	physicalAddr = (physicalAddr / 8192) * 8192

	// Calculate bank number (0-255)
	bankNum := physicalAddr / 8192

	// For Case 0: (($4100&0xF0)<<17)+(($410A&0xC0)|(BANK&0x3F))<<13
	// To reverse: we need to extract BANK from the formula
	// Since we're using Case 0, BANK is in the lower 6 bits of the register
	// For $8000-$FFFF slots, we can use the bank number directly

	// According to documentation PS2-0=0 mode:
	// - For $8000-$FFFF: banks are selected directly
	// - Bank number is just the 8KB bank index
	return uint8(bankNum & 0xFF)
}
