; ============================================
; МОДУЛЬ: sub_A006 - Полный диспетчер состояний меню
; Анализирует $0110-$0112 и выбирает соответствующий обработчик
; ============================================

.ifndef MODULE_A006_INC
MODULE_A006_INC = 1

.include "constants.inc"

.segment "CODE"

.proc sub_A000
    JSR sub_A006
    RTS
.endproc

; ============================================
; PROC: sub_A006
; ============================================
.proc sub_A006
    ; Начальные вызовы
    jsr sub_A7AF
    jsr sub_A9C4
    
    ; ========================================
    ; ГРУППА 1: $0110 = 8
    ; ========================================
    lda MENU_STATE_110
    cmp #8
    bne @group_2
    
    lda MENU_STATE_111
    cmp #4
    beq @set_1E_A51A
    cmp #$F1
    beq @set_1E_A51A
    jmp @group_2
    
@set_1E_A51A:
    lda #$1E
    sta MENU_ACTION_116
    jmp loc_A51A
    
    ; ========================================
    ; ГРУППА 2: с sub_A96A
    ; ========================================
@group_2:
    jsr sub_A96A
    
    lda MENU_STATE_111
    cmp #3
    bne @group_3
    
    lda MENU_STATE_112
    cmp #1
    bne @group_3
    
    lda #$25
    sta MENU_ACTION_116
    jmp loc_A53B
    
    ; ========================================
    ; ГРУППА 3: $0111 = $93, $0112 = 3
    ; ========================================
@group_3:
    lda MENU_STATE_111
    cmp #$93
    bne @group_4
    
    lda MENU_STATE_112
    cmp #3
    bne @group_4
    
    lda #$26
    sta MENU_ACTION_116
    jmp loc_A546
    
    ; ========================================
    ; ГРУППА 4: с sub_A965
    ; ========================================
@group_4:
    jsr sub_A965
    
    lda MENU_STATE_111
    cmp #$93
    bne @group_5
    
    lda MENU_STATE_112
    cmp #6
    bne @group_5
    
    lda #1
    sta MENU_ACTION_116
    jmp loc_A4A1
    
    ; ========================================
    ; ГРУППА 5: $0111 = $30, $0112 = $33
    ; ========================================
@group_5:
    lda MENU_STATE_111
    cmp #$30
    bne @group_6
    
    lda MENU_STATE_112
    cmp #$33
    bne @group_6
    
    lda #$32
    sta MENU_ACTION_116
    jmp loc_A50F
    
    ; ========================================
    ; ГРУППА 6: $0110 = $85, $0111 = $85, $0112 = $52
    ; ========================================
@group_6:
    lda MENU_STATE_110
    cmp #$85
    bne @group_7
    
    lda MENU_STATE_111
    cmp #$85
    bne @group_7
    
    lda MENU_STATE_112
    cmp #$52
    bne @group_7
    
    lda #2
    sta MENU_ACTION_116
    jmp loc_A4B7
    
    ; ========================================
    ; ГРУППА 7: $0110 = $77, $0111 = $89
    ; ========================================
@group_7:
    lda MENU_STATE_110
    cmp #$77
    bne @group_8
    
    lda MENU_STATE_111
    cmp #$89
    bne @group_8
    
    lda #$2B
    sta MENU_ACTION_116
    jmp loc_A4B7
    
    ; ========================================
    ; ГРУППА 8: $0111 = $93, $0112 = 2
    ; ========================================
@group_8:
    lda MENU_STATE_111
    cmp #$93
    bne @group_9
    
    lda MENU_STATE_112
    cmp #2
    bne @group_9
    
    lda #3
    sta MENU_ACTION_116
    jmp loc_A4C2
    
    ; ========================================
    ; ГРУППА 9: $0111 = $30, $0112 = $33 (второй раз)
    ; ========================================
@group_9:
    lda MENU_STATE_111
    cmp #$30
    bne @group_10
    
    lda MENU_STATE_112
    cmp #$33
    bne @group_10
    
    lda #$1B
    sta MENU_ACTION_116
    jmp loc_A4F9
    
    ; ========================================
    ; ГРУППА 10: $0110 = $30, $0111 = $31
    ; ========================================
@group_10:
    lda MENU_STATE_110
    cmp #$30
    bne @group_11
    
    lda MENU_STATE_111
    cmp #$31
    bne @group_11
    
    lda #$22
    sta MENU_ACTION_116
    jmp loc_A68C
    
    ; ========================================
    ; ГРУППА 11: $0110 = $38, $0111 = $80, $0112 = 0
    ; ========================================
@group_11:
    lda MENU_STATE_110
    cmp #$38
    bne @group_12
    
    lda MENU_STATE_111
    cmp #$80
    bne @group_12
    
    lda MENU_STATE_112
    cmp #0
    bne @group_12
    
    lda #$23
    sta MENU_ACTION_116
    jmp loc_A530
    
    ; ========================================
    ; ГРУППА 12: $0110 = $7C, $0111 = $80, $0112 = 0
    ; ========================================
@group_12:
    lda MENU_STATE_110
    cmp #$7C
    bne @group_13
    
    lda MENU_STATE_111
    cmp #$80
    bne @group_13
    
    lda MENU_STATE_112
    cmp #0
    bne @group_13
    
    lda #$2A
    sta MENU_ACTION_116
    jmp loc_A530
    
    ; ========================================
    ; ГРУППА 13: $0111 = $93, $0112 = 4
    ; ========================================
@group_13:
    lda MENU_STATE_111
    cmp #$93
    bne @group_14
    
    lda MENU_STATE_112
    cmp #4
    bne @group_14
    
    lda #$24
    sta MENU_ACTION_116
    jmp loc_A4AC
    
    ; ========================================
    ; ГРУППА 14: $0110 = $38, $0111 = $80 (без проверки $0112)
    ; ========================================
@group_14:
    lda MENU_STATE_110
    cmp #$38
    bne @group_15
    
    lda MENU_STATE_111
    cmp #$80
    bne @group_15
    
    lda #$2F
    sta MENU_ACTION_116
    jmp loc_A55C
    
    ; ========================================
    ; ГРУППА 15: с sub_A974
    ; ========================================
@group_15:
    jsr sub_A974
    
    lda MENU_STATE_111
    cmp #$93
    bne @group_16
    
    lda MENU_STATE_112
    cmp #$41
    bne @group_16
    
    lda #4
    sta MENU_ACTION_116
    jmp loc_A4CD
    
    ; ========================================
    ; ГРУППА 16: $0111 = $93, $0112 = $40
    ; ========================================
@group_16:
    lda MENU_STATE_111
    cmp #$93
    bne @group_17
    
    lda MENU_STATE_112
    cmp #$40
    bne @group_17
    
    lda #$2E
    sta MENU_ACTION_116
    jmp loc_A4E3
    
    ; ========================================
    ; ГРУППА 17: $0111 = $31, $0112 = $29
    ; ========================================
@group_17:
    lda MENU_STATE_111
    cmp #$31
    bne @group_18
    
    lda MENU_STATE_112
    cmp #$29
    bne @group_18
    
    lda #$1C
    sta MENU_ACTION_116
    jmp loc_A504
    
    ; ========================================
    ; ГРУППА 18: $0110 = $31, $0111 = $30, $0112 = $32
    ; ========================================
@group_18:
    lda MENU_STATE_110
    cmp #$31
    bne @group_19
    
    lda MENU_STATE_111
    cmp #$30
    bne @group_19
    
    lda MENU_STATE_112
    cmp #$32
    bne @group_19
    
    lda #$31
    sta MENU_ACTION_116
    jmp loc_A50F
    
    ; ========================================
    ; ГРУППА 19: с sub_A979
    ; ========================================
@group_19:
    jsr sub_A979
    
    lda MENU_STATE_111
    cmp #$93
    bne @group_20
    
    lda MENU_STATE_112
    cmp #$40
    bne @group_20
    
    lda #5
    sta MENU_ACTION_116
    jmp loc_A4D8
    
    ; ========================================
    ; ГРУППА 20: с sub_A915
    ; ========================================
@group_20:
    jsr sub_A915
    
    lda MENU_STATE_111
    cmp #$47
    bne @group_21
    
    lda #7
    sta MENU_ACTION_116
    jmp loc_A65E
    
    ; ========================================
    ; ГРУППА 21: $0111 = $46
    ; ========================================
@group_21:
    lda MENU_STATE_111
    cmp #$46
    bne @group_22
    
    lda #$20
    sta MENU_ACTION_116
    jmp loc_A669
    
    ; ========================================
    ; ГРУППА 22: с sub_A96F
    ; ========================================
@group_22:
    jsr sub_A96F
    
    lda MENU_STATE_110
    cmp #1
    bne @group_23
    
    lda MENU_STATE_111
    cmp #$21
    bne @group_23
    
    lda #$27
    sta MENU_ACTION_116
    jmp loc_A551
    
    ; ========================================
    ; ГРУППА 23: $0110 = 1, $0111 = 0
    ; ========================================
@group_23:
    lda MENU_STATE_110
    cmp #1
    bne @group_24
    
    lda MENU_STATE_111
    cmp #0
    bne @group_24
    
    lda #$28
    sta MENU_ACTION_116
    jmp loc_A551
    
    ; ========================================
    ; ГРУППА 24: с sub_A910
    ; ========================================
@group_24:
    jsr sub_A910
    
    lda MENU_STATE_110
    and #$0F
    cmp #8
    bne @group_25
    
    lda MENU_STATE_111
    cmp #9
    bne @group_25
    
    lda #6
    sta MENU_ACTION_116
    jmp loc_A57A
    
    ; ========================================
    ; ГРУППА 25: $0110 = $68, $0111 = 7
    ; ========================================
@group_25:
    lda MENU_STATE_110
    cmp #$68
    bne @group_26
    
    lda MENU_STATE_111
    cmp #7
    bne @group_26
    
    lda #6
    sta MENU_ACTION_116
    jmp loc_A57A
    
    ; ========================================
    ; ГРУППА 26: $0110 = $68, $0111 = 1
    ; ========================================
@group_26:
    lda MENU_STATE_110
    cmp #$68
    bne @group_27
    
    lda MENU_STATE_111
    cmp #1
    bne @group_27
    
    lda #6
    sta MENU_ACTION_116
    jmp loc_A57A
    
    ; ========================================
    ; ГРУППА 27: $0110 & $0F = 3, $0111 = $25, с sub_A93D
    ; ========================================
@group_27:
    lda MENU_STATE_110
    and #$0F
    cmp #3
    bne @group_28
    
    lda MENU_STATE_111
    cmp #$25
    bne @group_28
    
    jsr sub_A93D
    
    lda MENU_STATE_112
    cmp #$74
    beq @set_0C_A590
    cmp #$44
    beq @set_0B_A585
    
    lda #$0A
    sta MENU_ACTION_116
    jmp loc_A585
    
@set_0B_A585:
    lda #$0B
    sta MENU_ACTION_116
    jmp loc_A585
    
@set_0C_A590:
    lda #$0C
    sta MENU_ACTION_116
    jmp loc_A590
    
    ; ========================================
    ; ГРУППА 28: $0110 & $0F = 3, $0111 = $28
    ; ========================================
@group_28:
    lda MENU_STATE_110
    and #$0F
    cmp #3
    bne @group_29
    
    lda MENU_STATE_111
    cmp #$28
    bne @group_29
    
    lda #9
    sta MENU_ACTION_116
    jmp loc_A585
    
    ; ========================================
    ; ГРУППА 29: $0110 & $0F = 3, $0111 = $20
    ; ========================================
@group_29:
    lda MENU_STATE_110
    and #$0F
    cmp #3
    bne @group_30
    
    lda MENU_STATE_111
    cmp #$20
    bne @group_30
    
    lda #$0D
    sta MENU_ACTION_116
    jmp loc_A609
    
    ; ========================================
    ; ГРУППА 30: $0111 = $47
    ; ========================================
@group_30:
    lda MENU_STATE_111
    cmp #$47
    bne @group_31
    
    lda #8
    sta MENU_ACTION_116
    jmp loc_A63D
    
    ; ========================================
    ; ГРУППА 31: $0111 = $75
    ; ========================================
@group_31:
    lda MENU_STATE_111
    cmp #$75
    bne @group_32
    
    lda #$1D
    sta MENU_ACTION_116
    jmp loc_A648
    
    ; ========================================
    ; ГРУППА 32: $0111 = $95
    ; ========================================
@group_32:
    lda MENU_STATE_111
    cmp #$95
    bne @group_33
    
    lda #$2C
    sta MENU_ACTION_116
    jmp loc_A648
    
    ; ========================================
    ; ГРУППА 33: $0111 = $67
    ; ========================================
@group_33:
    lda MENU_STATE_111
    cmp #$67
    bne @group_34
    
    lda #$2D
    sta MENU_ACTION_116
    jmp loc_A653
    
    ; ========================================
    ; ГРУППА 34: $0110 = 1, $0111 = $39
    ; ========================================
@group_34:
    lda MENU_STATE_110
    cmp #1
    bne @group_35
    
    lda MENU_STATE_111
    cmp #$39
    bne @group_35
    
    lda #$0E
    sta MENU_ACTION_116
    jmp loc_A59B
    
    ; ========================================
    ; ГРУППА 35: $0110 & $0F = 5, $0111 = $35
    ; ========================================
@group_35:
    lda MENU_STATE_110
    and #$0F
    cmp #5
    bne @group_36
    
    lda MENU_STATE_111
    cmp #$35
    bne @group_36
    
    lda #$0F
    sta MENU_ACTION_116
    jmp loc_A5A6
    
    ; ========================================
    ; ГРУППА 36: $0110 & $0F = 5, $0111 = 5, с sub_A942
    ; ========================================
@group_36:
    lda MENU_STATE_110
    and #$0F
    cmp #5
    bne @group_37
    
    lda MENU_STATE_111
    cmp #5
    bne @group_37
    
    jsr sub_A942
    
    lda MENU_STATE_112
    bne @set_12_A61F
    
    lda #$11
    sta MENU_ACTION_116
    jmp loc_A614
    
@set_12_A61F:
    lda #$12
    sta MENU_ACTION_116
    jmp loc_A61F
    
    ; ========================================
    ; ГРУППА 37: $0110 & $0F = 5, $0111 = $31
    ; ========================================
@group_37:
    lda MENU_STATE_110
    and #$0F
    cmp #5
    bne @group_38
    
    lda MENU_STATE_111
    cmp #$31
    bne @group_38
    
    lda #$10
    sta MENU_ACTION_116
    jmp loc_A5B1
    
    ; ========================================
    ; ГРУППА 38: $0110 & $0F = 9, $0111 = $89
    ; ========================================
@group_38:
    lda MENU_STATE_110
    and #$0F
    cmp #9
    bne @group_39
    
    lda MENU_STATE_111
    cmp #$89
    bne @group_39
    
    lda #$13
    sta MENU_ACTION_116
    jmp loc_A5C7
    
    ; ========================================
    ; ГРУППА 39: $0110 & $0F = 9, $0111 = $97
    ; ========================================
@group_39:
    lda MENU_STATE_110
    and #$0F
    cmp #9
    bne @group_40
    
    lda MENU_STATE_111
    cmp #$97
    bne @group_40
    
    lda #$1A
    sta MENU_ACTION_116
    jmp loc_A5D2
    
    ; ========================================
    ; ГРУППА 40: $0110 & $0F = 4, $0111 = 8
    ; ========================================
@group_40:
    lda MENU_STATE_110
    and #$0F
    cmp #4
    bne @group_41
    
    lda MENU_STATE_111
    cmp #8
    bne @group_41
    
    lda #$14
    sta MENU_ACTION_116
    jmp loc_A5DD
    
    ; ========================================
    ; ГРУППА 41: $0110 = 1, $0111 = $54
    ; ========================================
@group_41:
    lda MENU_STATE_110
    cmp #1
    bne @group_42
    
    lda MENU_STATE_111
    cmp #$54
    bne @group_42
    
    lda #$16
    sta MENU_ACTION_116
    jmp loc_A5BC
    
    ; ========================================
    ; ГРУППА 42: $0110 & $0F = 5, $0111 = $80
    ; ========================================
@group_42:
    lda MENU_STATE_110
    and #$0F
    cmp #5
    bne @group_43
    
    lda MENU_STATE_111
    cmp #$80
    bne @group_43
    
    lda #$17
    sta MENU_ACTION_116
    jmp loc_A5E8
    
    ; ========================================
    ; ГРУППА 43: $0110 & $0F = 7, $0111 = $83
    ; ========================================
@group_43:
    lda MENU_STATE_110
    and #$0F
    cmp #7
    bne @group_44
    
    lda MENU_STATE_111
    cmp #$83
    bne @group_44
    
    lda #$18
    sta MENU_ACTION_116
    jmp loc_A5FE
    
    ; ========================================
    ; ГРУППА 44: $0110 & $0F = 3, $0111 = $35
    ; ========================================
@group_44:
    lda MENU_STATE_110
    and #$0F
    cmp #3
    bne @group_45
    
    lda MENU_STATE_111
    cmp #$35
    bne @group_45
    
    lda #$19
    sta MENU_ACTION_116
    jmp loc_A5F3
    
    ; ========================================
    ; ГРУППА 45: $0110 & $0F = 3, $0111 = $31
    ; ========================================
@group_45:
    lda MENU_STATE_110
    and #$0F
    cmp #3
    bne @group_46
    
    lda MENU_STATE_111
    cmp #$31
    bne @group_46
    
    lda #$1F
    sta MENU_ACTION_116
    jmp loc_A5F3
    
    ; ========================================
    ; ГРУППА 46: $0110 & $0F = 9, $0111 = $67
    ; ========================================
@group_46:
    lda MENU_STATE_110
    and #$0F
    cmp #9
    bne @group_47
    
    lda MENU_STATE_111
    cmp #$67
    bne @group_47
    
    lda #$21
    sta MENU_ACTION_116
    jmp loc_A62A
    
    ; ========================================
    ; ГРУППА 47: с sub_A97E
    ; ========================================
@group_47:
    jsr sub_A97E
    
    lda MENU_STATE_110
    cmp #$95
    beq @set_30_A567
    cmp #$75
    beq @set_30_A567
    cmp #$71
    beq @set_30_A567
    
    jmp @default_case
    
@set_30_A567:
    lda #$30
    sta MENU_ACTION_116
    jmp loc_A567
    
    ; ========================================
    ; ДЕФОЛТНЫЙ СЛУЧАЙ
    ; ========================================
@default_case:
    lda #0
    sta MENU_ACTION_116
    jmp loc_A67C
.endproc

.endif ; MODULE_A006_INC