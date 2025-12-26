package main

import (
	"bufio"
	"flag"
	"fmt"
	"os"
	"strconv"
	"strings"
)

const (
	minROMSize = 2 * 1024 * 1024  // 2 MB
	maxROMSize = 32 * 1024 * 1024 // 32 MB
)

func main() {
	// Parse command-line flags
	reverseMode := flag.Bool("r", false, "Run in reverse/debug mode (calculate physical address from registers)")
	reverseModeLong := flag.Bool("reverse", false, "Run in reverse/debug mode (calculate physical address from registers)")
	progBanksMode := flag.Bool("pb", false, "Run program memory bank mapping tool")
	progBanksModeLong := flag.Bool("progbanks", false, "Run program memory bank mapping tool")
	videoBanksMode := flag.Bool("vb", false, "Run video memory bank mapping tool")
	videoBanksModeLong := flag.Bool("videobanks", false, "Run video memory bank mapping tool")

	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [options]\n\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "VT03 Multicart Builder - Builds multicart ROMs with proper bank switching\n\n")
		fmt.Fprintf(os.Stderr, "Options:\n")
		flag.PrintDefaults()
		fmt.Fprintf(os.Stderr, "\nExamples:\n")
		fmt.Fprintf(os.Stderr, "  %s              # Normal mode: interactive multicart builder\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s -r           # Debug mode: reverse calculate physical address\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s --reverse    # Debug mode: reverse calculate physical address\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s -pb          # Debug mode: program memory bank mapping tool\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s --progbanks  # Debug mode: program memory bank mapping tool\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s -vb          # Debug mode: video memory bank mapping tool\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "  %s --videobanks # Debug mode: video memory bank mapping tool\n", os.Args[0])
	}
	flag.Parse()

	// Check which debug mode is requested (only one at a time)
	if *reverseMode || *reverseModeLong {
		reverseCalculationTool()
		return
	}
	if *progBanksMode || *progBanksModeLong {
		programBankTool()
		return
	}
	if *videoBanksMode || *videoBanksModeLong {
		videoBankTool()
		return
	}

	scanner := bufio.NewScanner(os.Stdin)

	fmt.Println("=== VT03 Multicart Builder ===")
	fmt.Println("Based on official VT03 documentation")
	fmt.Println()

	// Get starting offset
	fmt.Println("Enter starting ROM offset (hex with 0x or decimal):")
	fmt.Println("  Example: 0x100000 or 1048576")
	scanner.Scan()
	offsetInput := strings.TrimSpace(scanner.Text())

	startOffset, err := parseAddress(offsetInput)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing starting offset: %v\n", err)
		os.Exit(1)
	}

	// Align to 8KB boundary
	const bankSize = 8192 // 8 KiB
	if startOffset%bankSize != 0 {
		fmt.Printf("⚠️  Starting offset 0x%06X not aligned to 8KB boundary. Aligning down.\n", startOffset)
		startOffset = (startOffset / bankSize) * bankSize
		fmt.Printf("Aligned offset: 0x%06X\n", startOffset)
	}

	// Get ROM size
	fmt.Println("\nEnter ROM size in MB (2-32, default 2):")
	scanner.Scan()
	sizeInput := strings.TrimSpace(scanner.Text())

	romSizeMB := int(minROMSize / (1024 * 1024)) // default: 2 MB
	if sizeInput != "" {
		sizeVal, err := strconv.ParseUint(sizeInput, 10, 8)
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error parsing ROM size: %v\n", err)
			os.Exit(1)
		}
		minMB := int(minROMSize / (1024 * 1024))
		maxMB := int(maxROMSize / (1024 * 1024))
		if sizeVal < uint64(minMB) || sizeVal > uint64(maxMB) {
			fmt.Fprintf(os.Stderr, "ROM size must be between %d and %d MB\n", minMB, maxMB)
			os.Exit(1)
		}
		romSizeMB = int(sizeVal)
	}

	romSize := uint32(romSizeMB) * 1024 * 1024

	// Validate offset fits in ROM size
	if startOffset >= romSize {
		fmt.Fprintf(os.Stderr, "Starting offset 0x%06X exceeds ROM size 0x%06X\n", startOffset, romSize)
		os.Exit(1)
	}

	fmt.Printf("\nConfiguration:\n")
	fmt.Printf("  Starting offset: 0x%06X (%d bytes)\n", startOffset, startOffset)
	fmt.Printf("  ROM size:       %d MB (0x%06X bytes)\n", romSizeMB, romSize)
	fmt.Printf("  Available space: 0x%06X bytes\n", romSize-startOffset)
	fmt.Println()

	// Load games
	fmt.Println("Loading games from ./games directory...")
	games, err := LoadGamesFromDir("./games")
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading games: %v\n", err)
		os.Exit(1)
	}

	if len(games) == 0 {
		fmt.Println("No suitable games found in ./games")
		return
	}

	fmt.Printf("Found %d game(s)\n", len(games))
	fmt.Println()

	// Build multicart
	result, err := BuildMulticart(games, startOffset, romSize)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error building multicart: %v\n", err)
		os.Exit(1)
	}

	gameMap := make(GameConfigMap)
	for _, entry := range result.GameConfigs {
		gameMap[entry.Filename] = entry.Config
	}

	if err := WriteGameLists(result.ROM, gameMap); err != nil {
		fmt.Fprintf(os.Stderr, "Error writing game lists: %v\n", err)
		os.Exit(1)
	}

	if err := WriteResults(result, startOffset); err != nil {
		fmt.Fprintf(os.Stderr, "Error writing results: %v\n", err)
		os.Exit(1)
	}

	fmt.Printf("✅ Successfully built multicart with %d game(s)\n", result.TotalGames)
	fmt.Printf("   Final offset: 0x%06X\n", result.FinalOffset)
	fmt.Printf("   Used space:   %d bytes (%.1f%%)\n", result.FinalOffset-startOffset, float64(result.FinalOffset-startOffset)/float64(romSize-startOffset)*100)
	fmt.Println("\nOutput files:")
	fmt.Println("  multicart.bin")
	fmt.Println("  config_table.txt")
}

// parseAddress parses a hex (with 0x prefix) or decimal string to uint32
func parseAddress(s string) (uint32, error) {
	s = strings.TrimSpace(s)
	if strings.HasPrefix(strings.ToLower(s), "0x") {
		n, err := strconv.ParseUint(s[2:], 16, 32)
		return uint32(n), err
	}
	n, err := strconv.ParseUint(s, 10, 32)
	return uint32(n), err
}
