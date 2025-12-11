; ============================================
; МОДУЛЬ: Вспомогательные функции для sub_A006
; ============================================

.include "constants.inc"

.segment "CODE"

; ========================================
; PROC: sub_A7AF
; ========================================
.proc sub_A7AF
    lda #$DC
    sta REG_412D
    lda #$C1
    sta MENU_COMPLETE_FLAG
    lda #$71
    sta $4FF0
    lda #2
    sta REG_4139
    lda #$FF
    sta $410F
    jsr sub_AA09
    jsr sub_AA09
    lda #$DF
    sta $410F
    jsr sub_AA09
    jsr sub_AA09
    lda #$FF
    sta $410F
    jsr sub_AA09
    rts
.endproc

; ========================================
; PROC: sub_A9C4
; ========================================
.proc sub_A9C4
    lda #$0A
    jsr sub_A84E
    lda #$FC
    sta REG_412D
    jsr sub_A8BF
    jsr sub_A8BF
    sta MENU_STATE_110
    lda #2
    sta REG_4139
    lda #$71
    sta $4FF0
    lda #$DC
    sta REG_412D
    lda #$F1
    jsr sub_A84E
    lda #$FC
    sta REG_412D
    jsr sub_A8BF
    jsr sub_A8BF
    sta MENU_STATE_111
    lda #2
    sta REG_4139
    lda #$71
    sta $4FF0
    lda #$DC
    sta REG_412D
    rts
.endproc

; ========================================
; PROC: sub_A6F6 (обработчик mode 0)
; ========================================
.proc sub_A6F6
    ldy #0
@loop:
    lda (MENU_DATA_PTR_L),y
    cmp #0
    beq @delay
    jsr sub_A84E
    iny
@process_char:
    lda (MENU_DATA_PTR_L),y
    cmp #$FE
    beq @next_line
    cmp #$FF
    beq @end
    jsr sub_A884
    iny
    jmp @process_char

@next_line:
    iny
    jmp @loop

@delay:
    iny
    lda (MENU_DATA_PTR_L),y
    tax
@delay_loop:
    jsr sub_AA1C
    dex
    bne @delay_loop
    jmp @next_line

@end:
    rts
.endproc

; ========================================
; PROC: sub_A725 (обработчик mode 1)
; ========================================
.proc sub_A725
    ldy #0
@loop:
    lda (MENU_DATA_PTR_L),y
    cmp #$FF
    beq @check_delay
    jsr sub_A84E
    iny
    lda (MENU_DATA_PTR_L),y
    sta $4FF8
    iny
    lda (MENU_DATA_PTR_L),y
    sta $4FF7
    jsr sub_A88C
    iny
    jmp @loop

@check_delay:
    iny
    lda (MENU_DATA_PTR_L),y
    cmp #$FF
    beq @end
    tax
    jsr sub_AA1C
    iny
    jmp @loop

@end:
    lda #$22
    jsr sub_A84E
    rts
.endproc

; ========================================
; PROC: sub_A758 (обработчик mode 2)
; ========================================
.proc sub_A758
    ldy #0
@loop:
    lda (MENU_DATA_PTR_L),y
    cmp #$FF
    beq @check_delay
    jsr sub_A84E
    iny
    lda (MENU_DATA_PTR_L),y
    jsr sub_A884
    iny
    jmp @loop

@check_delay:
    iny
    lda (MENU_DATA_PTR_L),y
    cmp #$FF
    beq @end
    tax
    jsr sub_AA1C
    iny
    jmp @loop

@end:
    lda #$22
    jsr sub_A84E
    rts
.endproc

; ========================================
; PROC: sub_A782 (обработчик mode 3)
; ========================================
.proc sub_A782
    ldy #0
@loop:
    lda (MENU_DATA_PTR_L),y
    cmp #$FF
    beq @check_delay
    sta $4FF8
    iny
    lda (MENU_DATA_PTR_L),y
    sta $4FF7
    jsr sub_A856
    lda #$51
    sta $4FF0
    iny
    jmp @loop

@check_delay:
    iny
    lda (MENU_DATA_PTR_L),y
    cmp #$FF
    beq @end
    tax
    jsr sub_AA1C
    iny
    jmp @loop

@end:
    rts
.endproc

; ========================================
; PROC: sub_A7E2 (финальная обработка)
; ========================================
.proc sub_A7E2
    lda #$B7
    sta $4FF0
    lda #$FF
    sta $4FF1
    lda #$A4
    sta $4FF2
    lda #$5A
    sta $4FF3
    lda #$9A
    sta $4FF4
    lda #$FE
    sta $4FF5
    lda #$0E
    sta $4FFA
    rts
.endproc

; ========================================
; PROC: sub_A806 (доп. обработка mode 4)
; ========================================
.proc sub_A806
    lda #$BD
    sta $4FF0
    lda #$FF
    sta $4FF1
    lda #$52
    sta $4FF2
    lda #$58
    sta $4FF3
    lda #$98
    sta $4FF4
    lda #$FD
    sta $4FF5
    lda #$0D
    sta $4FFA
    rts
.endproc

; ========================================
; PROC: sub_A82A (доп. обработка mode 3)
; ========================================
.proc sub_A82A
    lda #$BD
    sta $4FF0
    lda #$FF
    sta $4FF1
    lda #$52
    sta $4FF2
    lda #$58
    sta $4FF3
    lda #$98
    sta $4FF4
    lda #$FD
    sta $4FF5
    lda #$0D
    sta $4FFA
    rts
.endproc

; ========================================
; PROC: sub_A84E (отправка команды)
; ========================================
.proc sub_A84E
    sta $4FF7
    lda #0
    sta $4FF8
    rts
.endproc

; ========================================
; PROC: sub_A856
; ========================================
.proc sub_A856
    lda #$51
    sta $4FF0
    lda #$11
    sta $4FF0
    lda #$11
    sta $4FF0
    lda #1
    sta $4FF0
    lda #1
    sta $4FF0
    lda #1
    sta $4FF0
    lda #1
    sta $4FF0
    lda #$11
    sta $4FF0
    lda #$11
    sta $4FF0
    rts
.endproc

; ========================================
; PROC: sub_A884 (отправка данных с инициализацией)
; ========================================
.proc sub_A884
    sta $4FF7
    lda #0
    sta $4FF8
    ; Fall-through в реализацию протокола
@_protocol:  ; Внутренняя метка
    lda #$31
    sta $4FF0
    lda #$21
    sta $4FF0
    lda #$21
    sta $4FF0
    lda #$21
    sta $4FF0
    lda #$21
    sta $4FF0
    lda #$31
    sta $4FF0
    lda #$31
    sta $4FF0
    lda #$31
    sta $4FF0
    lda #$31
    sta $4FF0
    lda #$71
    sta $4FF0
    rts
.endproc

; ========================================
; PROC: sub_A88C (протокол без инициализации)
; ========================================
.proc sub_A88C
    jmp sub_A884::@_protocol  ; Прыжок внутрь sub_A884
.endproc

; ========================================
; PROC: sub_A8BF (чтение данных)
; ========================================
.proc sub_A8BF
    lda #$31
    sta $4FF0
    lda #2
    sta REG_4139
    lda #2
    sta REG_4139
    lda #0
    sta REG_4139
    lda #0
    sta REG_4139
    lda $4135
    rts
.endproc

; ========================================
; PROC: sub_A8DC (расширенное чтение)
; ========================================
.proc sub_A8DC
    lda #$31
    sta $4FF0
    lda #2
    sta REG_4139
    lda #2
    sta REG_4139
    lda #0
    sta REG_4139
    lda #0
    sta REG_4139
    ldx $4136
    lda #2
    sta REG_4139
    lda #2
    sta REG_4139
    lda #0
    sta REG_4139
    lda #0
    sta REG_4139
    lda $4135
    rts
.endproc

; ========================================
; PROC: sub_A910
; ========================================
.proc sub_A910
    lda #0
    jmp sub_A915_common
.endproc

; ========================================
; PROC: sub_A915
; ========================================
.proc sub_A915
    lda #$67
    jmp sub_A915_common
.endproc

; Общая часть для sub_A910 и sub_A915
.proc sub_A915_common
    jsr sub_A84E
    lda #$FC
    sta REG_412D
    jsr sub_A8DC
    stx MENU_STATE_110
    sta MENU_STATE_111
    lda #2
    sta REG_4139
    lda #$71
    sta $4FF0
    lda #$DC
    sta REG_412D
    rts
.endproc

; ========================================
; PROC: sub_A93D
; ========================================
.proc sub_A93D
    lda #$CD
    jmp sub_A942_common
.endproc

; ========================================
; PROC: sub_A942
; ========================================
.proc sub_A942
    lda #$28
    jmp sub_A942_common
.endproc

; Общая часть для sub_A93D и sub_A942
.proc sub_A942_common
    jsr sub_A84E
    lda #$FC
    sta REG_412D
    jsr sub_A8DC
    sta MENU_STATE_112
    lda #2
    sta REG_4139
    lda #$71
    sta $4FF0
    lda #$DC
    sta REG_412D
    rts
.endproc

; ========================================
; PROC: sub_A965
; ========================================
.proc sub_A965
    lda #4
    jmp sub_A96A_common
.endproc

; ========================================
; PROC: sub_A96A
; ========================================
.proc sub_A96A
    lda #0
    jmp sub_A96A_common
.endproc

; ========================================
; PROC: sub_A96F
; ========================================
.proc sub_A96F
    lda #$C3
    jmp sub_A96A_common
.endproc

; ========================================
; PROC: sub_A974
; ========================================
.proc sub_A974
    lda #$D3
    jmp sub_A96A_common
.endproc

; ========================================
; PROC: sub_A979
; ========================================
.proc sub_A979
    lda #$D5
    jmp sub_A96A_common
.endproc

; ========================================
; PROC: sub_A97E
; ========================================
.proc sub_A97E
    lda #$B9
    jsr sub_A84E
    lda #$FF
    jsr sub_A884
    lda #$83
    jsr sub_A884
    lda #$47
    jsr sub_A884
    lda #$D0
    jmp sub_A96A_common
.endproc

; Общая часть для функций чтения состояния
.proc sub_A96A_common
    jsr sub_A84E
    lda #$FC
    sta REG_412D
    jsr sub_A8BF
    jsr sub_A8BF
    sta MENU_STATE_110
    jsr sub_A8BF
    sta MENU_STATE_111
    jsr sub_A8BF
    sta MENU_STATE_112
    lda #2
    sta REG_4139
    lda #$71
    sta $4FF0
    lda #$DC
    sta REG_412D
    rts
.endproc

; ========================================
; PROC: sub_AA09 (задержка большая)
; ========================================
.proc sub_AA09
    pha
    txa
    pha
    tya
    pha
    ldx #0
    ldy #$40
@loop:
    dex
    bne @loop
    dey
    bne @loop
    pla
    tay
    pla
    tax
    pla
    rts
.endproc

; ========================================
; PROC: sub_AA1C (задержка маленькая)
; ========================================
.proc sub_AA1C
    pha
    txa
    pha
    tya
    pha
    ldx #0
    ldy #1
@loop:
    dex
    bne @loop
    dey
    bne @loop
    pla
    tay
    pla
    tax
    pla
    rts
.endproc