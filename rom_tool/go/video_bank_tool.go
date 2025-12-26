package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// videoBankTool is a standalone interactive tool for calculating video memory bank registers.
// It is not used by the main builder but kept for reference/debugging purposes.
func videoBankTool() {
	fmt.Println("=== VT03 Video Memory Bank Mapping Tool ===")
	fmt.Println("Based on official VT03 documentation")
	fmt.Println()

	scanner := bufio.NewScanner(os.Stdin)

	// Get video bank number
	fmt.Println("Enter video bank number (VBANK, 0-255):")
	scanner.Scan()
	vbankInput := strings.TrimSpace(scanner.Text())
	vbank64, err := strconv.ParseUint(vbankInput, 10, 8)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing video bank: %v\n", err)
		os.Exit(1)
	}
	vbank := uint8(vbank64)

	// Get case number ($201A & 0x07)
	fmt.Println("\nEnter case number ($201A & 0x07, 0-7, default 0):")
	scanner.Scan()
	caseInput := strings.TrimSpace(scanner.Text())
	caseNum := uint8(0)
	if caseInput != "" {
		caseVal, err := strconv.ParseUint(caseInput, 10, 8)
		if err == nil && caseVal <= 7 {
			caseNum = uint8(caseVal)
		}
	}

	// Get $4100 value (VA24-21)
	fmt.Println("\nEnter $4100 value (PA24-21, bits D3-0, hex, default 0x00):")
	scanner.Scan()
	reg4100Input := strings.TrimSpace(scanner.Text())
	reg4100 := uint8(0)
	if reg4100Input != "" {
		if strings.HasPrefix(strings.ToLower(reg4100Input), "0x") {
			val, err := strconv.ParseUint(reg4100Input[2:], 16, 8)
			if err == nil {
				reg4100 = uint8(val)
			}
		} else {
			val, err := strconv.ParseUint(reg4100Input, 10, 8)
			if err == nil {
				reg4100 = uint8(val)
			}
		}
	}

	// Get $2018 value
	fmt.Println("\nEnter $2018 value (VA20-10 bits D6-4, EVA12-10 bits D2-0, hex, default 0x00):")
	scanner.Scan()
	reg2018Input := strings.TrimSpace(scanner.Text())
	reg2018 := uint8(0)
	if reg2018Input != "" {
		if strings.HasPrefix(strings.ToLower(reg2018Input), "0x") {
			val, err := strconv.ParseUint(reg2018Input[2:], 16, 8)
			if err == nil {
				reg2018 = uint8(val)
			}
		} else {
			val, err := strconv.ParseUint(reg2018Input, 10, 8)
			if err == nil {
				reg2018 = uint8(val)
			}
		}
	}

	// Get $201A value
	fmt.Println("\nEnter $201A value (video bank control, hex, default 0x00):")
	scanner.Scan()
	reg201AInput := strings.TrimSpace(scanner.Text())
	reg201A := uint8(0)
	if reg201AInput != "" {
		if strings.HasPrefix(strings.ToLower(reg201AInput), "0x") {
			val, err := strconv.ParseUint(reg201AInput[2:], 16, 8)
			if err == nil {
				reg201A = uint8(val)
			}
		} else {
			val, err := strconv.ParseUint(reg201AInput, 10, 8)
			if err == nil {
				reg201A = uint8(val)
			}
		}
	}

	// Check if extension mode
	fmt.Println("\nIs extension mode active? ($2011 & 0x02 = 1) [y/N]:")
	scanner.Scan()
	extModeInput := strings.ToLower(strings.TrimSpace(scanner.Text()))
	extMode := extModeInput == "y" || extModeInput == "yes"

	// Get EVA if extension mode
	eva := uint8(0)
	if extMode {
		fmt.Println("\nEnter EVA value (extension video address, 0-7):")
		scanner.Scan()
		evaInput := strings.TrimSpace(scanner.Text())
		if evaInput != "" {
			evaVal, err := strconv.ParseUint(evaInput, 10, 8)
			if err == nil && evaVal <= 7 {
				eva = uint8(evaVal)
			}
		}
	}

	// Create bank mapper
	bm := &BankMapper{
		Reg4100: reg4100,
		Reg2018: reg2018,
		Reg201A: reg201A,
	}

	// Calculate addresses
	var normalAddr, extAddr uint32
	normalAddr = bm.CalculateVideoAddress(vbank)
	if extMode {
		extAddr = bm.CalculateVideoAddressExtension(vbank, eva)
	}

	// Display results
	fmt.Println("\n" + strings.Repeat("=", 60))
	fmt.Println("VIDEO MEMORY BANK MAPPING")
	fmt.Println(strings.Repeat("=", 60))
	fmt.Printf("Video Bank (VBANK):   %d (0x%02X)\n", vbank, vbank)
	fmt.Printf("Case Number:          %d ($201A & 0x07)\n", caseNum)
	fmt.Printf("Extension Mode:       %v\n", extMode)
	if extMode {
		fmt.Printf("EVA:                  %d\n", eva)
	}

	fmt.Println("\nRegister Values:")
	fmt.Printf("  $4100:              0x%02X = %08b  (VA24-21 from D3-0)\n", reg4100, reg4100)
	fmt.Printf("  $2018:              0x%02X = %08b  (VA20-10 from D6-4, EVA12-10 from D2-0)\n", reg2018, reg2018)
	fmt.Printf("  $201A:              0x%02X = %08b  (case control)\n", reg201A, reg201A)

	fmt.Println("\nAddress Calculation Formulas:")
	fmt.Println("  Normal Mode (Case", caseNum, "):")
	switch caseNum {
	case 0:
		fmt.Println("    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + VBANK<<10")
	case 1:
		fmt.Println("    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + (($201A&0x80)|(VBANK&0x7F))<<10")
	case 2:
		fmt.Println("    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + (($201A&0xC0)|(VBANK&0x3F))<<10")
	case 4:
		fmt.Println("    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + (($201A&0xE0)|(VBANK&0x1F))<<10")
	case 5:
		fmt.Println("    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + (($201A&0xF0)|(VBANK&0x0F))<<10")
	case 6:
		fmt.Println("    ($4100&0x0F)<<21 + ($2018&0x70)<<14 + (($201A&0xF8)|(VBANK&0x07))<<10")
	default:
		fmt.Println("    (Case 3 or 7 - use default formula)")
	}

	if extMode {
		fmt.Println("\n  Extension Mode (Case", caseNum, "):")
		switch caseNum {
		case 0:
			fmt.Println("    ($4100&0x0F)<<21 + VBANK<<13 + EVA<<10")
		case 1:
			fmt.Println("    ($4100&0x0F)<<21 + (($201A&0x80)|(VBANK&0x7F))<<13 + EVA<<10")
		case 2:
			fmt.Println("    ($4100&0x0F)<<21 + (($201A&0xC0)|(VBANK&0x3F))<<13 + EVA<<10")
		case 4:
			fmt.Println("    ($4100&0x0F)<<21 + (($201A&0xE0)|(VBANK&0x1F))<<13 + EVA<<10")
		case 5:
			fmt.Println("    ($4100&0x0F)<<21 + (($201A&0xF0)|(VBANK&0x0F))<<13 + EVA<<10")
		case 6:
			fmt.Println("    ($4100&0x0F)<<21 + (($201A&0xF8)|(VBANK&0x07))<<13 + EVA<<10")
		default:
			fmt.Println("    (Case 3 or 7 - use default formula)")
		}
	}

	fmt.Println("\nCalculated Addresses:")
	fmt.Printf("  Normal Mode:        0x%06X\n", normalAddr)
	if extMode {
		fmt.Printf("  Extension Mode:     0x%06X\n", extAddr)
	}

	// Address exchange condition
	fmt.Println("\nAddress Exchange Condition:")
	fmt.Println("  When $4105 & 0x80 != 0, $0000-$0FFF and $1000-$1FFF exchange")
}
