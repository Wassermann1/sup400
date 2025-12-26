package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// reverseCalculationTool is a standalone interactive tool for reverse-calculating physical addresses from register values.
// It is not used by the main builder but kept for reference/debugging purposes.
func reverseCalculationTool() {
	fmt.Println("\n=== Reverse Calculation: Physical Address from Registers ===")
	scanner := bufio.NewScanner(os.Stdin)

	// Get program address
	fmt.Println("Enter program address (hex with 0x or decimal):")
	scanner.Scan()
	progInput := strings.TrimSpace(scanner.Text())
	var programAddr uint32
	if strings.HasPrefix(strings.ToLower(progInput), "0x") {
		addr64, _ := strconv.ParseUint(progInput[2:], 16, 32)
		programAddr = uint32(addr64)
	} else {
		addr64, _ := strconv.ParseUint(progInput, 10, 32)
		programAddr = uint32(addr64)
	}

	// Get register values
	fmt.Println("\nEnter register values (hex with 0x or decimal, 0 for default):")

	fmt.Print("  $4100 (PA24-21, bits D7-4): ")
	scanner.Scan()
	reg4100 := parseHexOrDec(scanner.Text())

	fmt.Print("  $4107 (PQ0): ")
	scanner.Scan()
	reg4107 := parseHexOrDec(scanner.Text())

	fmt.Print("  $4108 (PQ1): ")
	scanner.Scan()
	reg4108 := parseHexOrDec(scanner.Text())

	fmt.Print("  $4109 (PQ2): ")
	scanner.Scan()
	reg4109 := parseHexOrDec(scanner.Text())

	fmt.Print("  $410A (PQ3): ")
	scanner.Scan()
	reg410A := parseHexOrDec(scanner.Text())

	fmt.Print("  $410B (PS2-0, bits D2-0): ")
	scanner.Scan()
	reg410B := parseHexOrDec(scanner.Text()) & 0x07

	// Determine which bank register to use based on program address
	var bank uint8
	switch {
	case programAddr >= 0x8000 && programAddr < 0xA000:
		bank = reg4107 // PQ0
	case programAddr >= 0xA000 && programAddr < 0xC000:
		bank = reg4108 // PQ1
	case programAddr >= 0xC000 && programAddr < 0xE000:
		bank = reg4109 // PQ2
	case programAddr >= 0xE000:
		bank = reg410A // PQ3
	default:
		bank = reg4107 // Default to PQ0
	}

	// Create mapper and calculate
	bm := &BankMapper{
		Reg4100: reg4100,
		Reg410A: reg410A,
		Reg410B: reg410B,
	}

	physicalAddr := bm.CalculateProgramAddress(programAddr, bank)

	fmt.Println("\n" + strings.Repeat("=", 60))
	fmt.Println("CALCULATED PHYSICAL ADDRESS")
	fmt.Println(strings.Repeat("=", 60))
	fmt.Printf("Program Address:  0x%04X\n", programAddr)
	fmt.Printf("Bank Used:        %d (0x%02X)\n", bank, bank)
	fmt.Printf("Physical Address: 0x%06X\n", physicalAddr)
}

// parseHexOrDec parses a hex (with 0x prefix) or decimal string to uint8
func parseHexOrDec(input string) uint8 {
	input = strings.TrimSpace(input)
	if input == "" {
		return 0
	}
	if strings.HasPrefix(strings.ToLower(input), "0x") {
		val, _ := strconv.ParseUint(input[2:], 16, 8)
		return uint8(val)
	}
	val, _ := strconv.ParseUint(input, 10, 8)
	return uint8(val)
}
