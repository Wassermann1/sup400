package main

// cnrom.go
func BuildNROMConfig(game *NESGame, romOffset uint32) MMC3Config {
	// Video registers
	chrStart := romOffset + game.PRGSize
	reg4100_video, reg2018, reg201A := calcNromVideo(chrStart, game.Mapper)

	pa24_21 := uint8((romOffset >> 21) & 0x0F)
	reg4100 := (pa24_21 << 4) | (reg4100_video & 0x0F)

	var bank6, bank7 uint8
	bank4 := calculateBankForAddress(romOffset)
	bank5 := calculateBankForAddress(romOffset + 8192)
	bank6 = calculateBankForAddress(romOffset + game.PRGSize - 2*8192)
	bank7 = calculateBankForAddress(romOffset + game.PRGSize - 8192)

	// Mirroring
	byte8 := uint8(0x01)
	if game.Vertical {
		byte8 = 0x00
	}

	var mode uint8 = 0x05
	if game.PRGSize >= 4*8192 {
		mode = 0x04
	}

	return MMC3Config{
		Bytes: [9]uint8{
			reg4100,
			reg2018,
			reg201A,
			mode,
			bank4,
			bank5,
			bank6,
			bank7,
			byte8,
		},
	}
}

func calcNromVideo(chrAddr uint32, mapper int) (reg4100, reg2018, reg201A uint8) {

	chrAddr += 0x1800

	if mapper == 3 {
		chrAddr += 0x4000
	}

	// BANK2: 2MB windows
	reg4100 = uint8((chrAddr >> 21) & 0x0F)

	// BANK1: 256KB chunks within current 2MB window
	offsetIn2MB := chrAddr & 0x1FFFFF   // mask to 21 bits
	bank1Index := offsetIn2MB / 0x40000 // 256KB = 0x40000
	reg2018 = uint8(bank1Index << 4)

	// BANK0: 1KB banks
	reg201A = uint8((chrAddr >> 10) & 0xFF)

	return
}
