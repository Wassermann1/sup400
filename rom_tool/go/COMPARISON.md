# Comparison: Implementation vs Documentation

## Changes Made to Match Documentation

### 1. video.go - Video Register Calculation

**Before (INCORRECT):**

```go
reg4100 = uint8(va24_21 * 0x11)  // Wrong: multiplies by 0x11
```

**After (CORRECT per documentation):**

```go
// $4100 bits D3-0 contain VA24-21 for video memory
reg4100 = va24_21  // Just the 4 bits, no multiplication
```

**Documentation Reference:**

- `VA24-21 <- $4100(D3-0)` - Video address bits 24-21 come from $4100 bits D3-0
- No multiplication by 0x11 mentioned in documentation

### 2. mmc3.go - Program Bank Calculation

**Before (INCORRECT):**

```go
baseBank := romOffset >> 13  // Simple shift, doesn't use case-based formulas
bank4 = uint8(baseBank)      // Direct assignment
```

**After (CORRECT per documentation):**

```go
// Use BankMapper with proper case-based formulas
// Case 0: (($4100&0xF0)<<17)+(($410A&0xC0)|(BANK&0x3F))<<13
bm := &BankMapper{
    Reg4100: reg4100,
    Reg410B: 0x00, // Case 0 (PS2-0 = 0)
}
bank4 := calculateBankForAddress(bm, romOffset, 0x8000)
```

**Documentation Reference:**

- Program memory bank mapping uses case-based formulas from `$410B & 0x07`
- Case 0 formula: `(($4100&0xF0)<<17)+(($410A&0xC0)|(BANK&0x3F))<<13`
- Simple `>> 13` doesn't account for the case-based bit masking

### 3. BankMapper Implementation

**New file: `bank_mapper.go`**

- Implements all 8 cases from `$410B & 0x07` for program memory
- Implements all cases from `$201A & 0x07` for video memory (normal and extension modes)
- Properly handles PS2-0 modes (0, 6, 7) for different address ranges
- Calculates PA24-21 based on physical address ranges

**Documentation Compliance:**

- ✅ All case formulas implemented exactly as documented
- ✅ PS2-0 mode handling matches documentation tables
- ✅ PA24-21 calculation matches address range table
- ✅ Video address formulas match both normal and extension modes

## Formula Verification

### Program Memory Formulas (All Cases Implemented)

| Case | Formula | Status |
| ---- | ------- | ------ |
| 0 | `(($4100&0xF0)<<17)+(($410A&0xC0)\|(BANK&0x3F))<<13` | ✅ |
| 1 | `(($4100&0xF0)<<17)+(($410A&0xE0)\|(BANK&0x1F))<<13` | ✅ |
| 2 | `(($4100&0xF0)<<17)+(($410A&0xF0)\|(BANK&0x0F))<<13` | ✅ |
| 3 | `(($4100&0xF0)<<17)+(($410A&0xF8)\|(BANK&0x07))<<13` | ✅ |
| 4 | `(($4100&0xF0)<<17)+(($410A&0xFC)\|(BANK&0x03))<<13` | ✅ |
| 5 | `(($4100&0xF0)<<17)+(($410A&0xFE)\|(BANK&0x01))<<13` | ✅ |
| 6 | `(($4100&0xF0)<<17)+$410A<<13` | ✅ |
| 7 | `(($4100&0xF0)<<17)+BANK<<13` | ✅ |

### Video Memory Formulas (Normal Mode)

| Case | Formula | Status |
| ---- | ------- | ------ |
| 0 | `($4100&0x0F)<<21+($2018&0x70)<<14+VBANK<<10` | ✅ |
| 1 | `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0x80)\|(VBANK&0x7F))<<10` | ✅ |
| 2 | `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xC0)\|(VBANK&0x3F))<<10` | ✅ |
| 4 | `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xE0)\|(VBANK&0x1F))<<10` | ✅ |
| 5 | `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xF0)\|(VBANK&0x0F))<<10` | ✅ |
| 6 | `($4100&0x0F)<<21+($2018&0x70)<<14+(($201A&0xF8)\|(VBANK&0x07))<<10` | ✅ |

### Video Memory Formulas (Extension Mode)

| Case | Formula | Status |
| ---- | ------- | ------ |
| 0 | `($4100&0x0F)<<21+VBANK<<13+EVA<<10` | ✅ |
| 1 | `($4100&0x0F)<<21+(($201A&0x80)\|(VBANK&0x7F))<<13+EVA<<10` | ✅ |
| 2 | `($4100&0x0F)<<21+(($201A&0xC0)\|(VBANK&0x3F))<<13+EVA<<10` | ✅ |
| 4 | `($4100&0x0F)<<21+(($201A&0xE0)\|(VBANK&0x1F))<<13+EVA<<10` | ✅ |
| 5 | `($4100&0x0F)<<21+(($201A&0xF0)\|(VBANK&0x0F))<<13+EVA<<10` | ✅ |
| 6 | `($4100&0x0F)<<21+(($201A&0xF8)\|(VBANK&0x07))<<13+EVA<<10` | ✅ |

## PS2-0 Mode Handling

### Mode 0 (PS2-0 = 0)

- ✅ $0000-$1FFF: PQ37-6=0 (first 512KB)
- ✅ $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks
- ✅ $80000-$81FFF: PQ37-6=1, etc.

### Mode 6 (PS2-0 = 6)

- ✅ $0000-$1FFF: PQ37-0 select 256 banks
- ✅ $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks

### Mode 7 (PS2-0 = 7)

- ✅ $0000-$1FFF: PQ27-0, PQ17-0, PQ07-0 select 256 banks
- ✅ $2000-$3FFF: PQ25-0, PQ15-0, PQ05-0 select 64 banks

## PA24-21 Address Range Mapping

| Physical Address Range | PA24-21 | Status |
| ---------------------- | ------- | ------ |
| 0x000000-0x1FFFFF | 0 | ✅ |
| 0x200000-0x3FFFFF | 1 | ✅ |
| 0x400000-0x5FFFFF | 2 | ✅ |
| 0x600000-0x7FFFFF | 3 | ✅ |
| 0x800000-0xFFFFFF | 4-7 (8M bytes) | ✅ |
| 0x1000000-0x1FFFFFF | 8-F (16M bytes) | ✅ |

## Remaining Items

### Not Yet Implemented (from documentation)

1. **EVA Table**: Full EVA calculation from HV, BG4, BG3, BKPAGE, SPEVA2-0, VRWB2-0
   - Currently accepts EVA as direct input
   - Would need additional register values to calculate from table

2. **Address Shift Condition**: When background or 16*8 sprite is 16 colors, shift address one bit left
   - Not yet implemented in video calculations

3. **Address Exchange**: When $4105&0x80 != 0, $0000-$0FFF and $1000-$1FFF exchange
   - Function exists (`CheckAddressExchange()`) but not integrated into calculations

## Testing Recommendations

1. Compare calculated register values with known game configurations from `games metadata.csv`
2. Verify bank calculations produce correct physical addresses using reverse calculation
3. Test all PS2-0 modes (0, 6, 7) with different address ranges
4. Test video bank calculations with different cases and extension modes
5. Validate against actual console behavior if possible
