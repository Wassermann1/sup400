package main

type MMC3Config struct {
	Bytes [9]uint8
}

func BuildMMC3Config(game *NESGame, romOffset uint32) MMC3Config {
	chrStart := romOffset + game.PRGSize
	reg4100, reg2018, reg201A := CalcVideoRegisters(chrStart, game.PRGSize)

	baseBank := romOffset >> 13
	chr8K := game.CHRSize / 8192
	chrOffset := uint8(chr8K - 2)

	byte8 := uint8(0x00)
	if game.CHRSize > 128*1024 {
		byte8 = 0x80
	}

	return MMC3Config{
		Bytes: [9]uint8{
			reg4100,
			reg2018,
			reg201A,
			0x02, // MMC3 mode
			uint8(baseBank),
			uint8(baseBank + 1),
			uint8(baseBank) + chrOffset,
			uint8(baseBank+1) + chrOffset,
			byte8,
		},
	}
}

func GetAllocatedSize(game *NESGame) (size uint32, windows int) {
	const window = 256 * 1024 // 0x40000

	if game.PRGSize <= 128*1024 && game.CHRSize <= 128*1024 {
		return window, 1
	}
	return 2 * window, 2
}
