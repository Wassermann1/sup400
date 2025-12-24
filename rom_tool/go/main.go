package main

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

const ROM_SIZE = 2 * 1024 * 1024 // 2 МБ

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Использование: multicart-builder 0x100000")
		os.Exit(1)
	}

	startOffset, err := parseOffset(os.Args[1])
	if err != nil {
		fmt.Printf("Ошибка парсинга смещения: %v\n", err)
		os.Exit(1)
	}

	games, err := LoadGamesFromDir("./games")
	if err != nil {
		panic(err)
	}

	if len(games) == 0 {
		fmt.Println("Нет подходящих игр в ./games")
		return
	}

	result, err := BuildMulticart(games, startOffset, ROM_SIZE)
	if err != nil {
		panic(err)
	}

	if err := WriteResults(result, startOffset); err != nil {
		panic(err)
	}

	fmt.Printf("✅ Успешно собрано %d игр\n", result.TotalGames)
	fmt.Println("Файлы:")
	fmt.Println("  multicart.nes")
	fmt.Println("  config_table.txt")
}

func parseOffset(s string) (uint32, error) {
	s = strings.TrimSpace(s)
	if strings.HasPrefix(strings.ToLower(s), "0x") {
		n, err := strconv.ParseUint(s[2:], 16, 32)
		return uint32(n), err
	}
	n, err := strconv.ParseUint(s, 10, 32)
	return uint32(n), err
}
