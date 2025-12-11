; ============================================
; МОДУЛЬ: Все обработчики переходов для sub_A006
; ============================================

.ifndef MODULE_HANDLERS_INC
MODULE_HANDLERS_INC = 1

.segment "CODE"

; ========================================
; ОБРАБОТЧИКИ ТИПА A ($0114 = 0)
; ========================================

; Обработчик 1A
loc_A4A1:
    lda #$2F
    sta MENU_DATA_PTR_L
    lda #$AA
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 1B
loc_A4AC:
    lda #$79
    sta MENU_DATA_PTR_L
    lda #$AB
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 1C
loc_A4B7:
    lda #5
    sta MENU_DATA_PTR_L
    lda #$AD
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 1D
loc_A4C2:
    lda #$5F
    sta MENU_DATA_PTR_L
    lda #$AD
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 1E
loc_A4CD:
    lda #$A8
    sta MENU_DATA_PTR_L
    lda #$AD
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 1F
loc_A4D8:
    lda #$2B
    sta MENU_DATA_PTR_L
    lda #$AC
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 20
loc_A4E3:
    lda #$AC
    sta MENU_DATA_PTR_L
    lda #$AC
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 21
loc_A4F9:
    lda #$CB
    sta MENU_DATA_PTR_L
    lda #$AE
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 22
loc_A504:
    lda #2
    sta MENU_DATA_PTR_L
    lda #$B0
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 23
loc_A50F:
    lda #$60
    sta MENU_DATA_PTR_L
    lda #$AF
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 24
loc_A51A:
    lda #$92
    sta MENU_DATA_PTR_L
    lda #$B0
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 25
loc_A530:
    lda #$3A
    sta MENU_DATA_PTR_L
    lda #$B2
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 26
loc_A53B:
    lda #$E8
    sta MENU_DATA_PTR_L
    lda #$AB
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 27
loc_A546:
    lda #$24
    sta MENU_DATA_PTR_L
    lda #$AB
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 28
loc_A551:
    lda #$9F
    sta MENU_DATA_PTR_L
    lda #$B2
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 29
loc_A55C:
    lda #$29
    sta MENU_DATA_PTR_L
    lda #$B3
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; Обработчик 2A
loc_A567:
    lda #$AE
    sta MENU_DATA_PTR_L
    lda #$AA
    sta MENU_DATA_PTR_H
    jmp common_handler_A572

; ========================================
; ОБЩИЙ ОБРАБОТЧИК ТИПА A
; ========================================
common_handler_A572:
    lda #0
    sta MENU_MODE_114
    jmp final_processing_A69C

; ========================================
; ОБРАБОТЧИКИ ТИПА B ($0114 = 1)
; ========================================

; Обработчик 2B
loc_A57A:
    lda #$DC
    sta MENU_DATA_PTR_L
    lda #$B5
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 2C
loc_A585:
    lda #$62
    sta MENU_DATA_PTR_L
    lda #$B6
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 2D
loc_A590:
    lda #$F7
    sta MENU_DATA_PTR_L
    lda #$B6
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 2E
loc_A59B:
    lda #$8F
    sta MENU_DATA_PTR_L
    lda #$B7
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 2F
loc_A5A6:
    lda #9
    sta MENU_DATA_PTR_L
    lda #$B8
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 30
loc_A5B1:
    lda #$42
    sta MENU_DATA_PTR_L
    lda #$BA
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 31
loc_A5BC:
    lda #$C5
    sta MENU_DATA_PTR_L
    lda #$BA
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 32
loc_A5C7:
    lda #$39
    sta MENU_DATA_PTR_L
    lda #$BB
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 33
loc_A5D2:
    lda #$B6
    sta MENU_DATA_PTR_L
    lda #$BB
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 34
loc_A5DD:
    lda #$2A
    sta MENU_DATA_PTR_L
    lda #$BC
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 35
loc_A5E8:
    lda #$E0
    sta MENU_DATA_PTR_L
    lda #$BC
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 36
loc_A5F3:
    lda #$6F
    sta MENU_DATA_PTR_L
    lda #$BD
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 37
loc_A5FE:
    lda #7
    sta MENU_DATA_PTR_L
    lda #$BE
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 38
loc_A609:
    lda #$89
    sta MENU_DATA_PTR_L
    lda #$B8
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 39
loc_A614:
    lda #$2A
    sta MENU_DATA_PTR_L
    lda #$B9
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 3A
loc_A61F:
    lda #$B9
    sta MENU_DATA_PTR_L
    lda #$B9
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; Обработчик 3B
loc_A62A:
    lda #$72
    sta MENU_DATA_PTR_L
    lda #$BE
    sta MENU_DATA_PTR_H
    jmp common_handler_A635

; ========================================
; ОБЩИЙ ОБРАБОТЧИК ТИПА B
; ========================================
common_handler_A635:
    lda #1
    sta MENU_MODE_114
    jmp final_processing_A69C

; ========================================
; ОБРАБОТЧИКИ ТИПА C ($0114 = 2)
; ========================================

; Обработчик 3C
loc_A63D:
    lda #$72
    sta MENU_DATA_PTR_L
    lda #$B3
    sta MENU_DATA_PTR_H
    jmp common_handler_A674

; Обработчик 3D
loc_A648:
    lda #$F2
    sta MENU_DATA_PTR_L
    lda #$B3
    sta MENU_DATA_PTR_H
    jmp common_handler_A674

; Обработчик 3E
loc_A653:
    lda #$7C
    sta MENU_DATA_PTR_L
    lda #$B4
    sta MENU_DATA_PTR_H
    jmp common_handler_A674

; Обработчик 3F
loc_A65E:
    lda #$FC
    sta MENU_DATA_PTR_L
    lda #$B4
    sta MENU_DATA_PTR_H
    jmp common_handler_A674

; Обработчик 40
loc_A669:
    lda #$74
    sta MENU_DATA_PTR_L
    lda #$B5
    sta MENU_DATA_PTR_H
    jmp common_handler_A674

; ========================================
; ОБЩИЙ ОБРАБОТЧИК ТИПА C
; ========================================
common_handler_A674:
    lda #2
    sta MENU_MODE_114
    jmp final_processing_A69C

; ========================================
; СПЕЦИАЛЬНЫЕ ОБРАБОТЧИКИ
; ========================================

; Обработчик дефолтный
loc_A67C:
    lda #$CE
    sta MENU_DATA_PTR_L
    lda #$BE
    sta MENU_DATA_PTR_H
    lda #0
    sta MENU_MODE_114
    jmp final_processing_A69C

; Обработчик с $0114 = 4
loc_A68C:
    lda #$A1
    sta MENU_DATA_PTR_L
    lda #$B1
    sta MENU_DATA_PTR_H
    lda #4
    sta MENU_MODE_114
    jmp final_processing_A69C

; ============================================
; PROC: final_processing_A69C
; ============================================
.proc final_processing_A69C
    ; Это то же самое, что loc_A69C
    lda MENU_MODE_114
    cmp #1
    beq @mode_1
    cmp #2
    beq @mode_2
    cmp #3
    beq @mode_3
    cmp #4
    beq @mode_4

    ; Mode 0 (default)
    jsr sub_A6F6
    jmp @wait_vblank

@mode_1:
    jsr sub_A725
    jmp @wait_vblank

@mode_2:
    jsr sub_A758
    jmp @wait_vblank

@mode_3:
    jsr sub_A782
    nop
    nop
    nop
    nop
    jsr sub_A82A
    jmp @process

@mode_4:
    jsr sub_A6F6
    nop
    nop
    nop
    nop
    jsr sub_A806
    jmp @process

@process:
    nop
    nop
    nop
    nop

@wait_vblank:
    jsr sub_A7E2

    ; Ожидание VBlank
:   lda PPU_STATUS
    and #$80
    beq :-

    ; Ещё раз (сброс флага)
:   lda PPU_STATUS
    and #$80
    beq :-

    ; Установка флага завершения
    lda #$81
    sta MENU_COMPLETE_FLAG
    rts
.endproc

.endif ; MODULE_HANDLERS_INC