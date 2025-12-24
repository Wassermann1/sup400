package main

type MMC3Config struct {
	Bytes [9]uint8
}

// mmc3.go
func BuildMMC3Config(game *NESGame, romOffset uint32) MMC3Config {
	startsAtBoundary := StartsAtChunkBoundary(game, romOffset)
	isSmallGame := IsSmallGame(game)

	chrStart := romOffset + game.PRGSize
	reg4100, reg2018, reg201A := CalcVideoRegisters(chrStart, game.PRGSize, game.CHRSize, startsAtBoundary, isSmallGame)

	baseBank := romOffset >> 13

	var bank4, bank5, bank6, bank7 uint8

	// Для PRG = 128K (8×16K = 16×8K)
	if game.PRGSize == 128*1024 {
		bank4 = uint8(baseBank)      // $8000
		bank5 = uint8(baseBank + 1)  // $A000
		bank6 = uint8(baseBank + 14) // $C000 (последние 16K: банки 14,15)
		bank7 = uint8(baseBank + 15) // $E000
	} else if game.PRGSize == 256*1024 {
		// Для PRG = 256K: первые 8K и последние 16K
		bank4 = uint8(baseBank)
		bank5 = uint8(baseBank + 1)
		bank6 = uint8(baseBank + 30) // 256K = 32×8K → последние: 30,31
		bank7 = uint8(baseBank + 31)
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
			0x02, // MMC3 mode
			bank4,
			bank5,
			bank6,
			bank7,
			byte8,
		},
	}
}
