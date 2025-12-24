package main

import (
	"bufio"
	"encoding/hex"
	"fmt"
	"os"
	"strconv"
	"strings"
)

func main() {
	fmt.Println("Введите 16 байт NES-заголовка в HEX (например: 4E45531A081040000000000000000000):")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	hexStr := strings.ReplaceAll(strings.TrimSpace(scanner.Text()), " ", "")
	header, err := hex.DecodeString(hexStr)
	if err != nil || len(header) != 16 {
		panic("Неверный заголовок: должен быть 16 байт в HEX")
	}

	if string(header[0:4]) != "NES\x1a" {
		panic("Заголовок не начинается с 'NES\\x1A'")
	}

	fmt.Print("Введите смещение в ROM (hex, например 0x100000): ")
	scanner.Scan()
	romOffsetStr := strings.TrimSpace(scanner.Text())
	var romOffset uint32
	if strings.HasPrefix(strings.ToLower(romOffsetStr), "0x") {
		n, err := strconv.ParseUint(romOffsetStr[2:], 16, 32)
		if err != nil {
			panic(err)
		}
		romOffset = uint32(n)
	} else {
		n, err := strconv.ParseUint(romOffsetStr, 10, 32)
		if err != nil {
			panic(err)
		}
		romOffset = uint32(n)
	}

	// Парсим заголовок
	prg16K := header[4] // в 16KB units
	chr8K := header[5]  // в 8KB units
	flags6 := header[6]
	flags7 := header[7]

	mapper := int((flags7 & 0xF0) | (flags6 >> 4))
	prgSize := uint32(prg16K) * 16384
	chrSize := uint32(chr8K) * 8192

	verticalMirroring := (flags6 & 0x01) != 0
	// fourScreen := (flags6 & 0x08) != 0

	fmt.Printf("\n--- Информация об игре ---\n")
	fmt.Printf("Mapper #: %d\n", mapper)
	fmt.Printf("PRG: %d KiB (%d × 16K)\n", prgSize/1024, prg16K)
	fmt.Printf("CHR: %d KiB (%d × 8K)\n", chrSize/1024, chr8K)
	fmt.Printf("Mirroring: %s\n", map[bool]string{true: "Vertical", false: "Horizontal"}[verticalMirroring])
	fmt.Printf("ROM Offset: 0x%06X\n", romOffset)

	// Вычисляем начало CHR
	chrStart := romOffset + prgSize

	// Байт 8: флаг CHR > 128K
	var byte8 uint8
	if chrSize > 128*1024 {
		byte8 = 0x80
	} else {
		byte8 = 0x00
	}

	// Байт 3 и остальные — по мапперу
	var config [9]uint8

	switch mapper {
	case 0: // NROM
		config = calcNROM(romOffset, prgSize, chrStart, verticalMirroring)
	case 1: // MMC1
		config = calcMMC1(romOffset, prgSize, chrStart, verticalMirroring, byte8)
	case 4: // MMC3
		config = calcMMC3(romOffset, prgSize, chrStart, verticalMirroring, chr8K, byte8)
		if chr8K > 16 {
			config[6] = config[6] + 10
			config[7] = config[7] + 10
		}
	default:
		panic(fmt.Sprintf("Маппер %d не поддерживается", mapper))
	}

	config[8] = byte8

	fmt.Printf("\n--- Конфигурация (9 байт) ---\n")
	for i, b := range config {
		fmt.Printf("%02X ", b)
		if i == 8 {
			fmt.Println()
		}
	}
}

// Общая функция для вычисления $4100, $2018, $201A на основе chrAddr
func calcVideoRegisters(chrAddr uint32, prgSize uint32) (reg4100, reg2018, reg201A uint8) {
	var base uint32
	var caseMode uint8

	// Для игр с PRG >= 128K — используем смещение 128K
	if prgSize >= 128*1024 {
		base = chrAddr - 0x20000
		caseMode = 0x81 // Case 1 + 128K offset
	} else {
		base = chrAddr
		caseMode = 0x02 // Case 2 (для NROM)
	}

	va24_21 := (base >> 21) & 0x0F
	reg4100 = uint8(va24_21 * 0x11) // 0x00, 0x11, 0x22, ...

	remainder := base & 0x1FFFFF
	reg2018 = uint8((remainder >> 14) & 0x70)
	reg201A = caseMode
	return
}

func calcNROM(romOffset, prgSize, chrStart uint32, vertical bool) [9]uint8 {
	reg4100, reg2018, reg201A := calcVideoRegisters(chrStart, prgSize)

	var mirroringByte uint8
	if vertical {
		mirroringByte = 0x01
	} else {
		mirroringByte = 0x00
	}

	// Банки: NROM — обычно фиксированные
	// Используем 8K-банки от начала ROM
	bank0 := uint8(romOffset / 8192)
	bank1 := bank0 + 1
	chrBank0 := uint8(chrStart / 8192)
	chrBank1 := chrBank0 + 1

	return [9]uint8{
		reg4100,
		reg2018,
		reg201A,
		0x04, // режим NROM
		bank0,
		bank1,
		chrBank0,
		chrBank1,
		mirroringByte, // будет перезаписан
	}
}

func calcMMC1(romOffset, prgSize, chrStart uint32, vertical bool, byte8 uint8) [9]uint8 {
	reg4100, reg2018, reg201A := calcVideoRegisters(chrStart, prgSize)

	// Банки: MMC1 использует 16K PRG и 8K CHR
	prgBank0 := uint8(romOffset / 16384)
	prgBank1 := prgBank0 + 1
	chrBank0 := uint8(chrStart / 8192)
	chrBank1 := chrBank0 + 1

	return [9]uint8{
		reg4100,
		reg2018,
		reg201A,
		0x01, // режим MMC1
		prgBank0,
		prgBank1,
		chrBank0,
		chrBank1,
		0x00,
	}
}

func calcMMC3(romOffset, prgSize, chrStart uint32, vertical bool, chr8K, byte8 uint8) [9]uint8 {
	reg4100, reg2018, reg201A := calcVideoRegisters(chrStart, prgSize)

	baseBank := romOffset >> 13 // 8K banks from start of ROM

	prgBank0 := uint8(baseBank)
	prgBank1 := uint8(baseBank + 1)

	// Смещение до последних двух CHR-банков
	chrOffset := uint8(chr8K - 2)

	chrBank0 := prgBank0 + chrOffset
	chrBank1 := prgBank1 + chrOffset

	return [9]uint8{
		reg4100,
		reg2018,
		reg201A,
		0x02, // MMC3 mode
		prgBank0,
		prgBank1,
		chrBank0,
		chrBank1,
		0x00, // will be set to 0x80 if chrSize > 128K
	}
}
