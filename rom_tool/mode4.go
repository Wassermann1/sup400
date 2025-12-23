package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const (
	bankSize    = 8192            // 8 KiB
	subbankSize = 512 * 1024      // 512 KiB
	romSize     = 2 * 1024 * 1024 // 2 MiB
)

func main() {
	fmt.Println("Введите физический ROM-адрес (в hex с 0x или dec):")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	input := strings.TrimSpace(scanner.Text())

	var addr uint32

	if strings.HasPrefix(strings.ToLower(input), "0x") {
		addr64, err := strconv.ParseUint(input[2:], 16, 32)
		if err != nil {
			panic(fmt.Sprintf("неверный hex: %v", err))
		}
		addr = uint32(addr64)
	} else {
		addr64, err := strconv.ParseUint(input, 10, 32)
		if err != nil {
			panic(fmt.Sprintf("неверный dec: %v", err))
		}
		addr = uint32(addr64)
	}

	if addr >= romSize {
		fmt.Fprintf(os.Stderr, "Адрес 0x%06X выходит за пределы 2 МБ ROM!\n", addr)
		os.Exit(1)
	}

	// Выравнивание на 8KB
	if addr%bankSize != 0 {
		fmt.Printf("⚠️  Адрес 0x%06X не выровнен на 8KB. Выравниваем вниз.\n", addr)
		addr = (addr / bankSize) * bankSize
	}

	subbank := (addr / subbankSize) & 0x3        // 0–3
	localBank := (addr % subbankSize) / bankSize // 0–63

	if localBank > 63 {
		panic("localBank > 63 — это ошибка!")
	}

	pq0 := uint8(localBank)
	pq1 := uint8(localBank)
	pq2 := uint8(localBank)
	pq3 := uint8((subbank << 6) | localBank) // subbank в битах 7-6, localBank — в 5-0

	fmt.Printf("\nФизический адрес: 0x%06X\n", addr)
	fmt.Printf("Подбанк (512KB):   %d (смещение 0x%06X)\n", subbank, subbank*subbankSize)
	fmt.Printf("Локальный банк:    %d (внутри подбанка)\n", localBank)

	fmt.Println("\nРегистры:")
	fmt.Printf("$4107 (PQ0 → $8000): 0x%02X = %08b\n", pq0, pq0)
	fmt.Printf("$4108 (PQ1 → $A000): 0x%02X = %08b\n", pq1, pq1)
	fmt.Printf("$4109 (PQ2 → $C000): 0x%02X = %08b\n", pq2, pq2)
	fmt.Printf("$410A (PQ3 → $E000): 0x%02X = %08b  [биты 7-6 = подбанк %d]\n", pq3, pq3, subbank>>0)

	// Дополнительно: $4100, $410B
	fmt.Printf("$4100 (PA24-21):    0x%02X = %08b  (обычно не нужен)\n", 0, 0)
	fmt.Printf("$410B (PS2-0):      0x%02X = %08b  (уточните режим)\n", 0, 0)
}
