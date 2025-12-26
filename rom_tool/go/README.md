# VT03 Memory Bank Switching Tools

This directory contains Go tools for calculating memory bank switching values for the VT03 NES clone console, based on the official VT03 documentation.

## Files

- `bank_mapper.go` - Core bank mapping logic implementing formulas from documentation
- `bank_tool.go` - Program memory bank mapping tool (function)
- `video_bank_tool.go` - Video memory bank mapping tool (function)
- `reverse_tool.go` - Reverse calculation tool (function)
- `main.go` - Main multicart builder

## Building

The main builder:

```bash
cd rom_tool/go
go build -o multicart-builder .
```

The bank switching tools are available as functions that can be called programmatically. They are used internally by the builder via `BankMapper`.

### Program Memory Bank Mapping

Calculates register values ($4100, $4107-$410A, $410B) needed to map a physical ROM address to a program address.

**Formula Implementation:**

- Case 0 (Default): `(($4100&0xF0)<<17)+(($410A&0xC0)|(BANK&0x3F))<<13`
- Case 1: `(($4100&0xF0)<<17)+(($410A&0xE0)|(BANK&0x1F))<<13`
- Case 2: `(($4100&0xF0)<<17)+(($410A&0xF0)|(BANK&0x0F))<<13`
- Case 3: `(($4100&0xF0)<<17)+(($410A&0xF8)|(BANK&0x07))<<13`
- Case 4: `(($4100&0xF0)<<17)+(($410A&0xFC)|(BANK&0x03))<<13`
- Case 5: `(($4100&0xF0)<<17)+(($410A&0xFE)|(BANK&0x01))<<13`
- Case 6: `(($4100&0xF0)<<17)+$410A<<13`
- Case 7: `(($4100&0xF0)<<17)+BANK<<13`

**PS2-0 Modes:**

- Mode 0: PQ37-6 determines 512KB subbank for $0000-$1FFF
- Mode 6: PQ37-0 select 256 banks for $0000-$1FFF
- Mode 7: PQ27-0, PQ17-0, PQ07-0 select 256 banks for $0000-$1FFF

### Video Memory Bank Mapping

Calculates video memory addresses based on video bank (VBANK) and extension video address (EVA).

**Normal Mode Formula:**

- Case 0: `($4100&0x0F)<<21+($2018&0x70)<<14+VBANK<<10`
- Case 1: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0x80)|(VBANK&0x7F))<<10`
- Case 2: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xC0)|(VBANK&0x3F))<<10`
- Case 4: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xE0)|(VBANK&0x1F))<<10`
- Case 5: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xF0)|(VBANK&0x0F))<<10`
- Case 6: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xF8)|(VBANK&0x07))<<10`

**Extension Mode Formula:**

- Case 0: `($4100&0x0F)<<21+VBANK<<13+EVA<<10`
- Similar cases with different bit masks for VBANK

## Register Reference

### Program Memory Registers

- `$4100` - PA24-21 (bits D7-4): High address bits for program memory
- `$4107` - PQ0: Bank for $8000-$9FFF
- `$4108` - PQ1: Bank for $A000-$BFFF
- `$4109` - PQ2: Bank for $C000-$DFFF
- `$410A` - PQ3: Bank for $E000-$FFFF
- `$410B` - PS2-0 (bits D2-0): Mapping mode selector

### Video Memory Registers

- `$4100` - VA24-21 (bits D3-0): High address bits for video memory
- `$2018` - VA20-10 (bits D6-4), EVA12-10 (bits D2-0)
- `$201A` - Video bank control (case selector via bits D2-0)
- `$2011` - LCD control (bit 1 for extension mode)
- `$4105` - Address exchange condition (bit 7)

## Documentation Reference

This implementation is based on the official VT03 documentation showing:

1. Program memory bank mapping formulas
2. Video memory bank mapping formulas (normal and extension modes)
3. Address range tables for different PS2-0 modes
4. EVA table for extension address modes

## Notes

- All addresses are aligned to 8KB boundaries (minimum bank size)
- Physical ROM addresses are limited to 2MB in most cases
- PA24-21 values determine which 2MB segment is accessed (0-15 for up to 16MB)
- Address exchange condition: When $4105&0x80 != 0, $0000-$0FFF and $1000-$1FFF exchange
