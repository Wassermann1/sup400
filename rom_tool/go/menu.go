package main

import (
	"bytes"
	"sort"
	"strings"
	"unicode"
)

const (
	menuStart       = 0x79000
	menuEnd         = 0x79FFF
	menuHeaderEnd   = 0x79010
	configTableAddr = 0x7C000
)

var menuConstants = []byte{
	0x14, 0x00, 0x08, 0x08, 0x08, 0x04, 0x04, 0x08,
	0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
}

// GameConfigMap: имя файла → конфигурация (9 байт)
type GameConfigMap map[string][9]uint8

func WriteGameLists(rom []byte, games GameConfigMap) error {
	if len(rom) < 0x80000 {
		return ErrROMTooSmall
	}

	// Сортируем имена
	var names []string
	for name := range games {
		names = append(names, name)
	}
	sort.Strings(names) // не забудьте import "sort"

	// Подготавливаем списки
	var nameList [][]byte
	var configs [][9]uint8

	for _, name := range names {
		cleanName := cleanGameName(name)
		if cleanName == "" {
			continue
		}
		nameList = append(nameList, []byte(cleanName))
		configs = append(configs, games[name]) // копируем массив
	}

	// === Запись меню ===
	menuSize := menuEnd - menuStart + 1
	menuData := bytes.Repeat([]byte{0xFF}, int(menuSize))

	// Количество игр
	numGames := uint16(len(nameList))
	menuData[0] = byte(numGames)
	menuData[1] = byte(numGames >> 8)

	// Константы
	copy(menuData[2:], menuConstants)

	// Имена
	offset := menuHeaderEnd - menuStart
	for _, name := range nameList {
		if offset+len(name)+1 > len(menuData) {
			break
		}
		copy(menuData[offset:], name)
		menuData[offset+len(name)] = 0x00
		offset += len(name) + 1
	}

	copy(rom[menuStart:], menuData)

	// === Запись конфигураций ===
	configOffset := configTableAddr
	for _, cfg := range configs {
		if configOffset+9 > len(rom) {
			break
		}
		copy(rom[configOffset:], cfg[:])
		configOffset += 9
	}

	return nil
}

func cleanGameName(name string) string {
	// Удаляем всё после первой скобки '('
	if idx := strings.Index(name, "("); idx != -1 {
		name = name[:idx]
	}

	// Удаляем расширение .nes
	if strings.HasSuffix(strings.ToLower(name), ".nes") {
		name = name[:len(name)-4]
	}

	// Преобразуем в верхний регистр
	name = strings.ToUpper(name)

	// Оставляем только допустимые символы
	var clean strings.Builder
	for _, r := range name {
		if unicode.IsLetter(r) || unicode.IsDigit(r) || r == ' ' {
			clean.WriteRune(r)
		}
		// Игнорируем всё остальное: ', `, -, и т.д.
	}

	// Удаляем лишние пробелы
	cleanStr := strings.TrimSpace(clean.String())
	cleanStr = strings.Join(strings.Fields(cleanStr), " ") // нормализуем пробелы

	return cleanStr
}

var ErrROMTooSmall = errorf("ROM должен быть >= 512 КБ")
