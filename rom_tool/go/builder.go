package main

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

type BuildResult struct {
	ROM         []byte
	ConfigTable []string
	TotalGames  int
	FinalOffset uint32
}

func BuildMulticart(games []*NESGame, startOffset uint32, romSize uint32) (*BuildResult, error) {
	rom := make([]byte, romSize)
	for i := range rom {
		rom[i] = 0xFF
	}

	var currentOffset = startOffset
	var configTable []string

	for _, game := range games {
		gameSize := game.PRGSize + game.CHRSize
		if currentOffset+gameSize > romSize {
			return nil, fmt.Errorf("недостаточно места")
		}
		copy(rom[currentOffset:], game.RawData[:gameSize])

		// Конфигурация
		cfg := BuildMMC3Config(game, currentOffset)
		cfgStr := fmt.Sprintf("%s: %02X %02X %02X %02X %02X %02X %02X %02X %02X",
			game.Filename,
			cfg.Bytes[0], cfg.Bytes[1], cfg.Bytes[2], cfg.Bytes[3],
			cfg.Bytes[4], cfg.Bytes[5], cfg.Bytes[6], cfg.Bytes[7], cfg.Bytes[8])
		configTable = append(configTable, cfgStr)

		currentOffset += gameSize
	}

	return &BuildResult{
		ROM:         rom,
		ConfigTable: configTable,
		TotalGames:  len(games),
		FinalOffset: currentOffset,
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
		if game.Mapper != 4 {
			fmt.Printf("Пропускаем %s: mapper %d (ожидается MMC3 = 4)\n", game.Filename, game.Mapper)
			continue
		}
		games = append(games, game)
	}

	return games, nil
}
