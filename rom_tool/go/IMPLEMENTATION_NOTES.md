# Implementation Notes: VT03 Memory Bank Switching

## Comparison with Documentation

This implementation is based on the official VT03 documentation provided. Below is a comparison of what was implemented vs. the documentation.

## Program Memory Bank Mapping

### ✅ Implemented Formulas (Case-based)

All 8 cases from `$410B & 0x07` are implemented:

- **Case 0 (Default)**: `(($4100&0xF0)<<17)+(($410A&0xC0)|(BANK&0x3F))<<13`
- **Case 1**: `(($4100&0xF0)<<17)+(($410A&0xE0)|(BANK&0x1F))<<13`
- **Case 2**: `(($4100&0xF0)<<17)+(($410A&0xF0)|(BANK&0x0F))<<13`
- **Case 3**: `(($4100&0xF0)<<17)+(($410A&0xF8)|(BANK&0x07))<<13`
- **Case 4**: `(($4100&0xF0)<<17)+(($410A&0xFC)|(BANK&0x03))<<13`
- **Case 5**: `(($4100&0xF0)<<17)+(($410A&0xFE)|(BANK&0x01))<<13`
- **Case 6**: `(($4100&0xF0)<<17)+$410A<<13`
- **Case 7**: `(($4100&0xF0)<<17)+BANK<<13`

### ✅ PS2-0 Modes

Based on the program bank allocation table:

- **PS2-0=0**
  - $0000-$1FFF: PQ37-6=0 (first 512KB)
  - $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks
  - $80000-$81FFF: PQ37-6=1, etc.
  
- **PS2-0=6**
  - $0000-$1FFF: PQ37-0 select 256 banks
  - $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks

- **PS2-0=7**
  - $0000-$1FFF: PQ27-0, PQ17-0, PQ07-0 select 256 banks
  - $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks

### ✅ PA24-21 Mapping

Based on the documentation table:

- 0x000000-0x1FFFFF: PA24-21=0
- 0x200000-0x3FFFFF: PA24-21=1
- 0x400000-0x5FFFFF: PA24-21=2
- 0x600000-0x7FFFFF: PA24-21=3
- 0x800000-0xFFFFFF: PA24-21=4-7 (8M bytes)
- 0x1000000-0x1FFFFFF: PA24-21=8-F (16M bytes)

## Video Memory Bank Mapping

### ✅ Normal Mode Formulas

All cases from `$201A & 0x07` are implemented:

- **Case 0**: `($4100&0x0F)<<21+($2018&0x70)<<14+VBANK<<10`
- **Case 1**: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0x80)|(VBANK&0x7F))<<10`
- **Case 2**: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xC0)|(VBANK&0x3F))<<10`
- **Case 4**: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xE0)|(VBANK&0x1F))<<10`
- **Case 5**: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xF0)|(VBANK&0x0F))<<10`
- **Case 6**: `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xF8)|(VBANK&0x07))<<10`

### ✅ Extension Mode Formulas

- **Case 0**: `($4100&0x0F)<<21+VBANK<<13+EVA<<10`
- **Case 1**: `($4100&0x0F)<<21+(($201A&0x80)|(VBANK&0x7F))<<13+EVA<<10`
- **Case 2**: `($4100&0x0F)<<21+(($201A&0xC0)|(VBANK&0x3F))<<13+EVA<<10`
- **Case 4**: `($4100&0x0F)<<21+(($201A&0xE0)|(VBANK&0x1F))<<13+EVA<<10`
- **Case 5**: `($4100&0x0F)<<21+(($201A&0xF0)|(VBANK&0x0F))<<13+EVA<<10`
- **Case 6**: `($4100&0x0F)<<21+(($201A&0xF8)|(VBANK&0x07))<<13+EVA<<10`

### ✅ Address Exchange Condition

Implemented: `CheckAddressExchange()` returns true when `$4105 & 0x80 != 0`, which causes `$0000-$0FFF` and `$1000-$1FFF` to exchange.

### ⚠️ EVA Table

The EVA table from documentation shows:

- Background display extension address mode ($2011&0x02=1): HV, BG4, BG3
- Background display extension address mode ($2011&0x02=0): BKPAGE, BG4, BG3
- Sprite display extension address mode: SPEVA2, SPEVA1, SPEVA0
- R/W extension address mode: VRWB2, VRWB1, VRWB0

**Note**: The EVA table mapping is not fully implemented in the tool yet. The tool accepts EVA as a direct input (0-7), but the actual EVA calculation from the table would require additional register values (HV, BG4, BG3, BKPAGE, SPEVA2-0, VRWB2-0).

### ⚠️ Address Shift Condition

Documentation states: "When background or 16*8 sprite is 16 colors, the actual address should be shift one bit to the left as the above table."

**Note**: This shift condition is not yet implemented in the tool.

## Differences from Original Code

### Original `main.go`

- Simple bank calculation: `bank = addr / 8192`
- No case-based formulas
- No PS2-0 mode handling
- No PA24-21 calculation

### Original `mode4.go`

- 512KB subbank calculation
- Basic PQ3 encoding with subbank bits
- No case-based formulas
- No proper PS2-0 mode handling

### New Implementation

- ✅ Full case-based formula implementation
- ✅ PS2-0 mode support (0, 6, 7)
- ✅ PA24-21 calculation
- ✅ Video memory mapping
- ✅ Reverse calculation (registers → physical address)
- ✅ Extension mode support

## Testing Recommendations

1. Test with known game ROM addresses from `games metadata.csv`
2. Verify register values match expected values from console dumps
3. Test all PS2-0 modes (0, 6, 7)
4. Test video bank calculations with different cases
5. Verify address exchange condition behavior

## Future Enhancements

1. Implement full EVA table calculation
2. Implement address shift condition for 16-color modes
3. Add batch processing for multiple addresses
4. Add validation against known game configurations
5. Add support for larger ROM sizes (>2MB)
