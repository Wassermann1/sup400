# Build Instructions

## Main Builder (Multicart Builder)

The main builder is the primary tool for building multicart ROMs:

```bash
cd rom_tool/go
go build -o multicart-builder main.go mmc3.go video.go bank_mapper.go nes.go builder.go menu.go reverse_tool.go
```

Or simply:

```bash
go build -o multicart-builder .
```

This builds the main multicart builder that processes games from the `./games` directory.

## Bank Switching Functions

The bank switching tools are available as functions (`programBankTool()`, `videoBankTool()`, `reverseCalculationTool()`) in the package. They are used internally by the builder via `BankMapper` for calculating register values according to the VT03 documentation.

## File Organization

### Core Files (Used by both tools)

- `bank_mapper.go` - Core bank mapping logic with all formulas
- `reverse_tool.go` - Reverse calculation tool and `parseHexOrDec()` utility

### Main Builder Files

- `main.go` - Main builder entry point
- `mmc3.go` - MMC3 configuration builder (uses BankMapper)
- `video.go` - Video register calculation (uses documentation formulas)
- `nes.go` - NES file parsing
- `builder.go` - Multicart building logic
- `menu.go` - Menu generation

### Bank Switching Tool Files (Functions)

- `bank_tool.go` - Program memory bank mapping function
- `video_bank_tool.go` - Video memory bank mapping function
- `reverse_tool.go` - Reverse calculation function

The bank switching functions are used internally by the builder. The `BankMapper` type provides the core functionality for calculating bank register values according to VT03 documentation formulas.

## Usage

### Main Builder

```bash
./multicart-builder 0x100000
```
