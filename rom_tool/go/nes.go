package main

import (
	"os"
	"path/filepath"
)

type NESGame struct {
	Filename string
	PRGSize  uint32 // in bytes
	CHRSize  uint32
	Mapper   int
	Vertical bool
	RawData  []byte // без заголовка
}

func StartsAtChunkBoundary(game *NESGame, romOffset uint32) bool {
	const chunkSize = 256 * 1024 // 0x40000
	return romOffset%chunkSize == 0
}

func IsSmallGame(game *NESGame) bool {
	gameSize := game.PRGSize + game.CHRSize
	return gameSize < 256*1024
}

func ParseNESFile(path string) (*NESGame, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}

	if len(data) < 16 {
		return nil, ErrTooShort
	}

	header := data[:16]
	if string(header[0:4]) != "NES\x1a" {
		return nil, ErrNotNES
	}

	prg16K := header[4]
	chr8K := header[5]
	flags6 := header[6]
	flags7 := header[7]

	mapper := int((flags7 & 0xF0) | (flags6 >> 4))
	vertical := (flags6 & 0x01) != 0

	return &NESGame{
		Filename: filepath.Base(path),
		PRGSize:  uint32(prg16K) * 16384,
		CHRSize:  uint32(chr8K) * 8192,
		Mapper:   mapper,
		Vertical: vertical,
		RawData:  data[16:],
	}, nil
}

var (
	ErrTooShort = errorf("файл короче 16 байт")
	ErrNotNES   = errorf("нет NES-заголовка")
)

type errorf string

func (e errorf) Error() string { return string(e) }
