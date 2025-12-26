package main

// CalcVideoRegisters calculates video memory registers according to VT03 documentation
// Documentation: VA24-21 <- $4100(D3-0), VA17-10 <- $2012-$2017(D7-0),$201A(D7-0)
//
//	EVA12-10 <- $2018(D2-0), VA20-10 <- $2018(D6-4)
func CalcVideoRegisters(chrAddr uint32, prgSize uint32, startsAtBoundary bool, isSmallGame bool) (reg4100, reg2018, reg201A uint8) {
	// According to documentation:
	// - $4100 bits D3-0 contain VA24-21 for video memory
	// - $2018 bits D6-4 contain VA20-10, bits D2-0 contain EVA12-10
	// - $201A bits D2-0 determine the case (0-7)

	// Calculate VA24-21 from chrAddr (bits 24-21 of video address)
	va24_21 := uint8((chrAddr >> 21) & 0x0F)

	// $4100: VA24-21 in bits D3-0 (NOT multiplied by 0x11 - that was incorrect)
	// Note: $4100 may also have PA24-21 in bits D7-4 for program memory, but for video we only use D3-0
	reg4100 = va24_21

	// Calculate VA20-10 from chrAddr (bits 20-10)
	// $2018 bits D6-4 = (chrAddr >> 14) & 0x70
	va20_10 := uint8((chrAddr >> 14) & 0x70)

	// EVA12-10: For extension mode, calculate from address
	// For now, we'll set EVA12-10 to 0 in normal mode, or calculate from address in extension mode
	eva12_10 := uint8(0)

	if startsAtBoundary && !isSmallGame {
		// Normal Mode, Case 1
		// Formula: ($4100&0x0F)<<21 + ($2018&0x70)<<14 + (($201A&0x80)|(VBANK&0x7F))<<10
		// We need to adjust if there's a 128K offset
		var base uint32
		if prgSize >= 128*1024 {
			base = chrAddr - 0x20000
			va24_21 = uint8((base >> 21) & 0x0F)
			reg4100 = va24_21
			va20_10 = uint8((base >> 14) & 0x70)
		}

		reg2018 = va20_10 | eva12_10 // D6-4: VA20-10, D2-0: EVA12-10
		reg201A = 0x01               // Case 1 (bits D2-0 = 001), bit 7 may be set for offset
		if prgSize >= 128*1024 {
			reg201A = 0x81 // Case 1 + bit 7 for 128K offset
		}
	} else {
		// Extension Mode, Case 1
		// Formula: ($4100&0x0F)<<21 + (($201A&0x80)|(VBANK&0x7F))<<13 + EVA<<10
		// In extension mode, EVA12-10 comes from $2018(D2-0)
		// For now, calculate EVA from address if needed
		eva12_10 = uint8((chrAddr >> 10) & 0x07) // EVA12-10 from address bits 12-10

		reg2018 = va20_10 | eva12_10
		reg201A = 0x01 // Case 1
	}

	return
}
