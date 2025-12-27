package main

import (
	_ "embed"
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

const windowSize uint32 = 0x200000 // 2 MiB

//go:embed original_menu.rom
var originalMenuROM []byte

type BuildResult struct {
	ROM             []byte
	ConfigTable     []string
	GameConfigs     []GameConfigEntry
	TotalGames      int
	FinalMMC3Offset uint32
	FinalNROMOffset uint32
}

type GameConfigEntry struct {
	Filename string
	Config   [9]uint8
}

func BuildMulticart(games []*NESGame, startOffset uint32, romSize uint32) (*BuildResult, error) {
	rom := make([]byte, romSize)

	copy(rom, originalMenuROM)

	for i := len(originalMenuROM); i < len(rom); i++ {
		rom[i] = 0xFF
	}

	var currentMMC3Offset = uint32(0x200000)
	var currentNROMOffset = uint32(0x80000)
	var NROMLimit = uint32(0x1FFFFF)
	var configTable []string
	var gameConfigs []GameConfigEntry

	for _, game := range games {
		if game.Mapper == 4 {
			gameSize := game.PRGSize + game.CHRSize
			// === Проверка на пересечение границы 2МБ окна ===
			windowBase := (currentMMC3Offset / windowSize) * windowSize
			windowEnd := windowBase + windowSize // не включительно
			if currentMMC3Offset+gameSize > windowEnd {
				// Перейти к началу следующего 2МБ-окна
				currentMMC3Offset = windowBase + windowSize
			}

			if currentMMC3Offset+gameSize > romSize {
				return nil, fmt.Errorf("недостаточно места")
			}
			copy(rom[currentMMC3Offset:], game.RawData[:gameSize])

			// Конфигурация
			cfg := BuildMMC3Config(game, currentMMC3Offset)
			gameConfigs = append(gameConfigs, GameConfigEntry{
				Filename: game.Filename,
				Config:   cfg.Bytes,
			})
			cfgStr := fmt.Sprintf("%s: %02X %02X %02X %02X %02X %02X %02X %02X %02X",
				game.Filename,
				cfg.Bytes[0], cfg.Bytes[1], cfg.Bytes[2], cfg.Bytes[3],
				cfg.Bytes[4], cfg.Bytes[5], cfg.Bytes[6], cfg.Bytes[7], cfg.Bytes[8])
			configTable = append(configTable, cfgStr)

			currentMMC3Offset += gameSize
		} else {
			gameSize := game.PRGSize + game.CHRSize
			if currentNROMOffset+gameSize > NROMLimit {
				return nil, fmt.Errorf("недостаточно места")
			}
			copy(rom[currentNROMOffset:], game.RawData[:gameSize])

			// Конфигурация
			cfg := BuildNROMConfig(game, currentNROMOffset)
			gameConfigs = append(gameConfigs, GameConfigEntry{
				Filename: game.Filename,
				Config:   cfg.Bytes,
			})
			cfgStr := fmt.Sprintf("%s: %02X %02X %02X %02X %02X %02X %02X %02X %02X",
				game.Filename,
				cfg.Bytes[0], cfg.Bytes[1], cfg.Bytes[2], cfg.Bytes[3],
				cfg.Bytes[4], cfg.Bytes[5], cfg.Bytes[6], cfg.Bytes[7], cfg.Bytes[8])
			configTable = append(configTable, cfgStr)

			currentNROMOffset += gameSize + (gameSize % 0x4000)
		}

	}

	return &BuildResult{
		ROM:             rom,
		ConfigTable:     configTable,
		GameConfigs:     gameConfigs,
		TotalGames:      len(games),
		FinalMMC3Offset: currentMMC3Offset,
		FinalNROMOffset: currentNROMOffset,
	}, nil
}

func WriteResults(result *BuildResult, startOffset uint32) error {
	if err := os.WriteFile("multicart.bin", result.ROM, 0644); err != nil {
		return err
	}

	tableOut := fmt.Sprintf("# Multi-cart конфигурация\n# Начало: 0x%06X\n\n", startOffset)
	for _, line := range result.ConfigTable {
		tableOut += line + "\n"
	}
	return os.WriteFile("config_table.txt", []byte(tableOut), 0644)
}

func LoadGamesFromDir(dir string) ([]*NESGame, error) {
	entries, err := os.ReadDir(dir)
	if err != nil {
		return nil, err
	}

	var files []string
	for _, e := range entries {
		if !e.IsDir() && strings.HasSuffix(strings.ToLower(e.Name()), ".nes") {
			files = append(files, filepath.Join(dir, e.Name()))
		}
	}

	sort.Strings(files)

	var games []*NESGame
	for _, path := range files {
		game, err := ParseNESFile(path)
		if err != nil {
			fmt.Printf("Пропускаем %s: %v\n", path, err)
			continue
		}
		if game.Mapper != 0 && game.Mapper != 3 && game.Mapper != 4 {
			fmt.Printf("Пропускаем %s: mapper %d (ожидается NROM = 0, CNROM = 3, MMC3 = 4)\n", game.Filename, game.Mapper)
			continue
		}
		games = append(games, game)
	}

	return games, nil
}
