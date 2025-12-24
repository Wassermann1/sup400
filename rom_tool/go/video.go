package main

func CalcVideoRegisters(chrAddr uint32, prgSize uint32, chrSize uint32, startsAtBoundary bool, isSmallGame bool) (reg4100, reg2018, reg201A uint8) {
	if startsAtBoundary && !isSmallGame {
		// Режим 1: Normal Mode, Case 1 with offset
		var base uint32
		if prgSize >= 128*1024 {
			base = chrAddr - 0x20000
		} else {
			base = chrAddr
		}

		va24_21 := (base >> 21) & 0x0F
		reg4100 = uint8(va24_21 * 0x11)
		remainder := base & 0x1FFFFF
		reg2018 = uint8((remainder >> 14) & 0x70)
		reg201A = 0x81 // Case 1 + 128K offset if needed
	} else {
		// Режим 2: Extension Mode, Case 1 without offset
		reg4100 = uint8((chrAddr >> 21) & 0x0F * 0x11)
		reg2018 = uint8((chrAddr >> 14) & 0x70)
		reg201A = 0x01 // Case 1, no 128K offset
	}
	return
}
