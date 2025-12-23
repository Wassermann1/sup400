package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const bankSize = 8192 // 8 KiB

func main() {
	fmt.Println("Введите физический ROM-адрес (в hex с 0x или dec):")
	scanner := bufio.NewScanner(os.Stdin)
	scanner.Scan()
	input := strings.TrimSpace(scanner.Text())

	var addr uint64
	var err error

	if strings.HasPrefix(strings.ToLower(input), "0x") {
		addr, err = strconv.ParseUint(input[2:], 16, 32)
	} else {
		addr, err = strconv.ParseUint(input, 10, 32)
	}
	if err != nil {
		fmt.Fprintf(os.Stderr, "Ошибка парсинга адреса: %v\n", err)
		os.Exit(1)
	}

	if addr >= 2*1024*1024 {
		fmt.Fprintf(os.Stderr, "Адрес выходит за пределы 2 МБ ROM!\n")
		os.Exit(1)
	}

	if addr%bankSize != 0 {
		fmt.Printf("⚠️  Адрес 0x%06X не выровнен на границу 8 КБ (%d байт).\n", addr, bankSize)
		aligned := (addr / bankSize) * bankSize
		fmt.Printf("Ближайший выровненный адрес: 0x%06X\n", aligned)
		addr = aligned
	}

	bank := addr / bankSize // 0–255

	if bank > 255 {
		fmt.Fprintf(os.Stderr, "Номер банка %d выходит за пределы 0–255!\n", bank)
		os.Exit(1)
	}

	fmt.Printf("\nФизический адрес: 0x%06X\n", addr)
	fmt.Printf("Номер 8KB-банка: %d (0x%02X)\n", bank, bank)

	// Предположим, вы хотите использовать этот банк в слоте $8000 (PQ0)
	// Но выведем значения для всех слотов на случай необходимости

	pq0 := uint8(bank)
	pq1 := uint8(bank)
	pq2 := uint8(bank)
	pq3 := uint8(bank)

	fmt.Println("\nРегистры (для отображения этого банка в соответствующий слот):")
	fmt.Printf("$4107 (PQ0 → $8000–$9FFF): 0x%02X = %08b\n", pq0, pq0)
	fmt.Printf("$4108 (PQ1 → $A000–$BFFF): 0x%02X = %08b\n", pq1, pq1)
	fmt.Printf("$4109 (PQ2 → $C000–$DFFF): 0x%02X = %08b\n", pq2, pq2)
	fmt.Printf("$410A (PQ3 → $E000–$FFFF): 0x%02X = %08b\n", pq3, pq3)

	// Дополнительно: если вы используете $4100 (PA24-21) — обычно 0
	fmt.Printf("$4100 (PA24-21):          0x%02X = %08b  (обычно 0 для 2MB ROM)\n", 0, 0)

	// PS2-0 — режим; часто 0 или 7
	fmt.Printf("$410B (PS2-0):            0x%02X = %08b  (уточните в доке; часто 0)\n", 0, 0)
}
