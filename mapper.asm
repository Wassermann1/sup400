; ============================================
; МОДУЛЬ: Mapper functions (MMC3)
; sub_D772 и sub_D7A1
; ============================================

.ifndef MAPPER_INC
MAPPER_INC = 1

.include "constants.inc"
.include "variables.inc"

.segment "CODE"

; ============================================
; PROC: sub_D772
; Назначение: Установка 4 последовательных банков PRG
; Вход: A - начальный номер банка
; Использует: X, сохраняет его в стеке
; ============================================
.proc sub_D772
    sta TEMP_401          ; Сохраняем параметр во временную переменную
    
    ; Сохраняем X
    txa
    pha
    
    ; Начинаем с банка 2 (PRG банк $8000-$9FFF)
    ldx #2                ; Банк #2 в терминах MMC3
    
    ; Устанавливаем банк 0
    stx MAPPER_SELECT     ; Выбираем регистр банка #2
    lda TEMP_401
    sta MAPPER_DATA       ; Устанавливаем номер банка
    
    ; Устанавливаем банк 1 (следующий)
    inx                   ; Банк #3
    stx MAPPER_SELECT     ; Выбираем регистр банка #3
    
    clc
    adc #1                ; Следующий банк (параметр + 1)
    sta MAPPER_DATA
    
    ; Устанавливаем банк 2
    inx                   ; Банк #4
    stx MAPPER_SELECT     ; Выбираем регистр банка #4
    
    clc
    adc #1                ; Параметр + 2
    sta MAPPER_DATA
    
    ; Устанавливаем банк 3
    inx                   ; Банк #5
    stx MAPPER_SELECT     ; Выбираем регистр банка #5
    
    clc
    adc #1                ; Параметр + 3
    sta MAPPER_DATA
    
    ; Восстанавливаем X
    pla
    tax
    
    rts
.endproc

; ============================================
; PROC: sub_D7A1
; Назначение: Установка 2 последовательных банков PRG
; Вход: A - начальный номер банка
; Использует: X, сохраняет его в стеке
; Разница: начинает с банка 0, прибавляет 2
; ============================================
.proc sub_D7A1
    sta TEMP_401          ; Сохраняем параметр
    
    ; Сохраняем X
    txa
    pha
    
    ; Начинаем с банка 0
    ldx #0                ; Банк #0 в терминах MMC3
    
    ; Устанавливаем банк 0
    stx MAPPER_SELECT     ; Выбираем регистр банка #0
    lda TEMP_401
    sta MAPPER_DATA       ; Устанавливаем номер банка
    
    ; Устанавливаем банк 1
    inx                   ; Банк #1
    stx MAPPER_SELECT     ; Выбираем регистр банка #1
    
    clc
    adc #2                !!! ВАЖНО: Здесь +2, а не +1 !!!
    sta MAPPER_DATA
    
    ; Восстанавливаем X
    pla
    tax
    
    rts
.endproc

; ============================================
; ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ МАППЕРА
; ============================================

; Инициализация MMC3 маппера
.proc init_mmc3_mapper
    ; Установка зеркалирования (vertical)
    lda #%01000000        ; Vertical mirroring
    sta MAPPER_SELECT
    lda #0
    sta MAPPER_DATA
    
    ; Установка защиты от записи в PRG-RAM (если есть)
    lda #%10000000
    sta MAPPER_SELECT
    lda #0
    sta MAPPER_DATA
    
    ; Установка банков CHR по умолчанию
    jsr set_default_chr_banks
    
    rts
.endproc

; Установка банков CHR по умолчанию
.proc set_default_chr_banks
    ; Устанавливаем 2KB банк для фона (банк 0)
    ldx #CHR_BANK_0
    stx MAPPER_SELECT
    lda #0
    sta MAPPER_DATA
    
    ; 2KB банк для фона продолжение (банк 1)
    ldx #CHR_BANK_1
    stx MAPPER_SELECT
    lda #2                ; Следующие 2KB
    sta MAPPER_DATA
    
    ; 1KB банки для спрайтов (банки 2-5)
    ldx #CHR_BANK_2
    stx MAPPER_SELECT
    lda #4                ; Первый 1KB банк спрайтов
    sta MAPPER_DATA
    
    ldx #CHR_BANK_3
    stx MAPPER_SELECT
    lda #5
    sta MAPPER_DATA
    
    ldx #CHR_BANK_4
    stx MAPPER_SELECT
    lda #6
    sta MAPPER_DATA
    
    ldx #CHR_BANK_5
    stx MAPPER_SELECT
    lda #7
    sta MAPPER_DATA
    
    rts
.endproc

; Установка конкретного банка PRG
; Вход: X - номер регистра банка (0-5), A - номер банка
.proc set_prg_bank
    stx MAPPER_SELECT
    sta MAPPER_DATA
    rts
.endproc

; Установка конкретного банка CHR
; Вход: X - номер регистра банка (0-7), A - номер банка
.proc set_chr_bank
    stx MAPPER_SELECT
    sta MAPPER_DATA
    rts
.endproc

.endif ; MAPPER_INC