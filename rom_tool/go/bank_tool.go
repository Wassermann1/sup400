package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const (
	bankSize = 8192 // 8 KiB
)

// programBankTool is a standalone interactive tool for calculating program memory bank registers.
// It is not used by the main builder but kept for reference/debugging purposes.
func programBankTool() {
	fmt.Println("=== VT03 Memory Bank Switching Tool ===")
	fmt.Println("Based on official VT03 documentation")
	fmt.Println()

	scanner := bufio.NewScanner(os.Stdin)

	// Get physical ROM address
	fmt.Println("Enter physical ROM address (hex with 0x or decimal):")
	scanner.Scan()
	addrInput := strings.TrimSpace(scanner.Text())

	var physicalAddr uint32
	if strings.HasPrefix(strings.ToLower(addrInput), "0x") {
		addr64, err := strconv.ParseUint(addrInput[2:], 16, 32)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing hex address: %v\n", err)
			os.Exit(1)
		}
		physicalAddr = uint32(addr64)
	} else {
		addr64, err := strconv.ParseUint(addrInput, 10, 32)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing decimal address: %v\n", err)
			os.Exit(1)
		}
		physicalAddr = uint32(addr64)
	}

	// Align to 8KB boundary
	if physicalAddr%bankSize != 0 {
		fmt.Printf("⚠️  Address 0x%06X not aligned to 8KB boundary. Aligning down.\n", physicalAddr)
		physicalAddr = (physicalAddr / bankSize) * bankSize
	}

	// Get program address (where this bank should be mapped)
	fmt.Println("\nEnter program address where bank should be mapped (hex with 0x or decimal):")
	fmt.Println("  $0000-$1FFF: Bank 0 slot")
	fmt.Println("  $2000-$3FFF: Bank 1 slot")
	fmt.Println("  $4000-$5FFF: Bank 2 slot")
	fmt.Println("  $6000-$7FFF: Bank 3 slot")
	fmt.Println("  $8000-$9FFF: PQ0 slot")
	fmt.Println("  $A000-$BFFF: PQ1 slot")
	fmt.Println("  $C000-$DFFF: PQ2 slot")
	fmt.Println("  $E000-$FFFF: PQ3 slot")
	scanner.Scan()
	progInput := strings.TrimSpace(scanner.Text())

	var programAddr uint32
	if strings.HasPrefix(strings.ToLower(progInput), "0x") {
		addr64, err := strconv.ParseUint(progInput[2:], 16, 32)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing hex program address: %v\n", err)
			os.Exit(1)
		}
		programAddr = uint32(addr64)
	} else {
		addr64, err := strconv.ParseUint(progInput, 10, 32)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing decimal program address: %v\n", err)
			os.Exit(1)
		}
		programAddr = uint32(addr64)
	}

	// Get PS2-0 mode ($410B & 0x07)
	fmt.Println("\nEnter PS2-0 mode ($410B & 0x07, 0-7, default 0):")
	scanner.Scan()
	ps20Input := strings.TrimSpace(scanner.Text())
	ps20 := uint8(0)
	if ps20Input != "" {
		ps20Val, err := strconv.ParseUint(ps20Input, 10, 8)
		if err == nil && ps20Val <= 7 {
			ps20 = uint8(ps20Val)
		}
	}

	// Create bank mapper
	bm := &BankMapper{
		Reg410B: ps20,
	}

	// Calculate bank and register values
	bank, regs := bm.CalculateProgramBank(physicalAddr, programAddr)
	regs.PS20 = ps20

	// Display results
	fmt.Println("\n" + strings.Repeat("=", 60))
	fmt.Println("PROGRAM MEMORY BANK MAPPING")
	fmt.Println(strings.Repeat("=", 60))
	fmt.Printf("Physical ROM Address: 0x%06X\n", physicalAddr)
	fmt.Printf("Program Address:      0x%04X\n", programAddr)
	fmt.Printf("Bank Number:          %d (0x%02X)\n", bank, bank)
	fmt.Printf("PS2-0 Mode:           %d (Case %d)\n", ps20, ps20)

	fmt.Println("\nRegister Values:")
	fmt.Printf("  $4100 (PA24-21):    0x%02X = %08b  (bits D7-4)\n", regs.PA2421<<4, regs.PA2421<<4)
	fmt.Printf("  $4107 (PQ0):        0x%02X = %08b  → $8000-$9FFF\n", regs.PQ0, regs.PQ0)
	fmt.Printf("  $4108 (PQ1):        0x%02X = %08b  → $A000-$BFFF\n", regs.PQ1, regs.PQ1)
	fmt.Printf("  $4109 (PQ2):        0x%02X = %08b  → $C000-$DFFF\n", regs.PQ2, regs.PQ2)
	fmt.Printf("  $410A (PQ3):        0x%02X = %08b  → $E000-$FFFF\n", regs.PQ3, regs.PQ3)
	fmt.Printf("  $410B (PS2-0):      0x%02X = %08b  (bits D2-0)\n", regs.PS20, regs.PS20)

	// Show formula based on case
	fmt.Println("\nAddress Calculation Formula (Case", regs.PS20, "):")
	switch regs.PS20 {
	case 0:
		fmt.Println("  (($4100 & 0xF0) << 17) + (($410A & 0xC0) | (BANK & 0x3F)) << 13")
	case 1:
		fmt.Println("  (($4100 & 0xF0) << 17) + (($410A & 0xE0) | (BANK & 0x1F)) << 13")
	case 2:
		fmt.Println("  (($4100 & 0xF0) << 17) + (($410A & 0xF0) | (BANK & 0x0F)) << 13")
	case 3:
		fmt.Println("  (($4100 & 0xF0) << 17) + (($410A & 0xF8) | (BANK & 0x07)) << 13")
	case 4:
		fmt.Println("  (($4100 & 0xF0) << 17) + (($410A & 0xFC) | (BANK & 0x03)) << 13")
	case 5:
		fmt.Println("  (($4100 & 0xF0) << 17) + (($410A & 0xFE) | (BANK & 0x01)) << 13")
	case 6:
		fmt.Println("  (($4100 & 0xF0) << 17) + $410A << 13")
	case 7:
		fmt.Println("  (($4100 & 0xF0) << 17) + BANK << 13")
	}

	// Verify calculation
	bm.Reg4100 = regs.PA2421 << 4
	bm.Reg410A = regs.PQ3
	calculatedAddr := bm.CalculateProgramAddress(programAddr&0x1FFF, bank)
	fmt.Printf("\nVerification - Calculated Physical Address: 0x%06X\n", calculatedAddr)
	if (calculatedAddr & 0xFFFFE000) == (physicalAddr & 0xFFFFE000) {
		fmt.Println("✓ Address matches (within 8KB bank)")
	} else {
		fmt.Printf("⚠️  Address mismatch! Expected: 0x%06X\n", physicalAddr)
	}

	// Show video memory mapping info
	fmt.Println("\n" + strings.Repeat("=", 60))
	fmt.Println("VIDEO MEMORY BANK MAPPING")
	fmt.Println(strings.Repeat("=", 60))
	fmt.Println("Video address formulas (normal and extension modes):")
	fmt.Println("  Normal mode:    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + VBANK<<10")
	fmt.Println("  Extension mode: ($4100&0x0F)<<21 + VBANK<<13 + EVA<<10")
	fmt.Println("\nNote: Use video bank tool for detailed video memory calculations")
}
