package main

func CalcVideoRegisters(chrAddr uint32, prgSize uint32) (reg4100, reg2018, reg201A uint8) {
	var base uint32
	if prgSize >= 128*1024 {
		base = chrAddr - 0x20000
	} else {
		base = chrAddr
	}

	va24_21 := (base >> 21) & 0x0F
	reg4100 = uint8(va24_21 * 0x11) // 0x00, 0x11, 0x22...
	remainder := base & 0x1FFFFF
	reg2018 = uint8((remainder >> 14) & 0x70)

	if prgSize >= 128*1024 {
		reg201A = 0x81 // Case 1 + 128K offset
	} else {
		reg201A = 0x02 // Case 2
	}
	return
}
