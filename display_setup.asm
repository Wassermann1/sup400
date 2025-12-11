; ============================================
; МОДУЛЬ: sub_EFD9
; Точная копия из дизассемблированного кода
; ============================================

.ifndef SUB_EFD9_INC
SUB_EFD9_INC = 1

.include "constants.inc"
.include "display_init.asm"

.segment "CODE"

; ============================================
; PROC: sub_EFD9
; Код точно как в дизассемблировании
; ============================================
.proc sub_EFD9
    lda #$3C
    sta $4107           ; PRG_BANK0 = $3C
    
    jsr $A000           ; → JMP ($8001) → код в банке $3C (sub_A000)
    
    rts
.endproc

.endif ; SUB_EFD9_INC