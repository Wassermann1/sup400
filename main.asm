; ============================================
; Основной модуль игры
; Адаптация кода с адреса $FAA6
; ============================================

.include "constants.inc" ; Общие константы
.include "variables.inc" ; Переменные
.include "macros.inc"    ; Макросы
.include "prg_banks.asm"  ; Настройка банков программы на VT03
.include "display_setup.asm" ; Предположительно инициализация дисплея


.segment "OAM"
oam_buffer:     .res 256  ; Буфер для спрайтов

.segment "BSS"
; Неинициализированные данные
ram_0000:       .res 256  ; $0000-$00FF
ram_0100:       .res 256  ; $0100-$01FF
; ... и так далее до $0700

.segment "CODE"
; ============================================
; ТОЧКА ВХОДА - Reset Handler
; Аналог sub_FAA6 из дизассемблированного кода
; ============================================
.proc reset_handler
    ; 1. Инициализация APU и регистров
    lda #$DC
    sta REG_412D           ; Нестандартный регистр (возможно, кастомный маппер)
    lda #$81
    sta REG_4137           ; Еще один нестандартный регистр

    ; 2. Настройка APU
    lda #$C0
    sta JOY2           ; $4017 - APU frame counter, отключить IRQ
    
    ; 2. Базовые настройки процессора
    sei                 ; Запретить прерывания
    cld                 ; Очистить decimal mode
    
    ; 4. Инициализация PPU
    ldy #0
    sty PPU_CTRL       ; $2000 - отключить NMI
    sty PPU_MASK       ; $2001 - отключить рендеринг
    sty $E000      ; Банк Е1
    
    ; 5. Ожидание стабилизации PPU (3 кадра)
    ldx #2
wait_vbl_loop:
    bit PPU_STATUS     ; Проверка VBlank
    bpl wait_vbl_loop  ; Ждем начала VBlank
wait_no_vbl:
    bit PPU_STATUS
    bmi wait_no_vbl    ; Ждем конца VBlank
    dex
    bpl wait_vbl_loop
    
    ; 5. Инициализация стека
    txs                 ; X = $FF после цикла
    
    ; 7. Настройка APU/PSG
    lda #$0F
    sta APU_STATUS     ; $4015 - включить все каналы звука
    sty $4010          ; Отключить DMC (Y = 0)
    
    lda #$C0
    sta JOY2           ; $4017 - APU frame counter режим
    
    ; 8. Очистка видеопамяти PPU
    lda PPU_STATUS     ; Сброс latch
    lda #$10
    tax
clear_ppu_loop:
    sta PPU_ADDR       ; Адрес $10xx
    sta PPU_ADDR       ; Повтор для latch
    eor #0             ; Ничего не меняет, но в оригинале есть
    dex
    bne clear_ppu_loop
    
    ; 9. Настройка маппера/банкирования
    ; В оригинале: STA sub_A000+1 и STA sub_A000
    ; Подключаем банк с меню
    lda #$80
    sta VECTOR_A000+1  ; Сохраняем для банкирования
    lda #1
    sta VECTOR_A000
    ; 10. Очистка всей RAM ($0000-$07FF)
    ldy COUNTER_3CB    ; Загружаем сохраненное значение
    lda #0
    tax
clear_ram_loop:
    sta $0000, x
    sta $0100, x
    sta $0200, x
    sta $0300, x
    sta $0400, x
    sta $0500, x
    sta $0600, x
    sta $0700, x
    inx
    bne clear_ram_loop
    
    ; 11. Восстановление/инициализация сохраненного значения
    cpy #0
    bne save_counter
    ldy #$5A           ; Значение по умолчанию 'Z'
save_counter:
    sty COUNTER_3CB
    ; 12. Очистка экрана в PPU
    ldy #$20           ; Адрес экрана $2000
    sty PPU_ADDR
    lda #0
    sta PPU_ADDR
    ldx #0
clear_screen:
    sta PPU_DATA       ; Записываем 0 (тайл 0)
    inx
    bne clear_screen
    iny
    cpy #$40           ; До адреса $3F00
    bne clear_screen
    ; 13. Загрузка палитры (все цвета = $0F)
    ldx #$3F
    stx PPU_ADDR
    ldx #0
    stx PPU_ADDR
    lda #$0F           ; Черный цвет
load_palette_loop:
    sta PPU_DATA
    inx
    cpx #$20           ; 32 цвета
    bne load_palette_loop
    ; 14. Инициализация OAM через DMA
    lda #2
    sta OAM_DMA        ; $4014 - DMA из страницы $0200
    ; 15. Сброс скроллинга
    lda #0
    sta PPU_SCROLL
    sta PPU_SCROLL
    ; 16. Настройка дополнительных регистров VT03
    lda #$0B
    sta REG_4138       ; $4138 - неизвестный регистр
    lda #2
    sta REG_4139       ; $4139 - неизвестный регистр
    nop                ; Пустая операция из оригинала
    lda #5
    sta REG_411C       ; $411C - неизвестный регистр
    ; 17. Вызов инициализирующих подпрограмм
    jsr setup_prg_banks       ; Настройка банков программы FD43
    jsr sub_FC43       ; Следующая подпрограмма fc43
    jsr sub_EFD9       ; Инициализация дисплея
    jsr sub_FC70       ; И еще одна
    
    
    ; 19. Бесконечный основной цикл
main_loop:
    jsr sub_FCBF       ; Основная игровая логика
    jmp main_loop
    
.endproc

; ============================================
; ПОДКЛЮЧЕНИЕ ВНЕШНИХ МОДУЛЕЙ
; ============================================
.include "sub_fc43.asm"   ; sub_FC43  
.include "sub_efd9.asm"   ; sub_EFD9
.include "sub_fc70.asm"   ; sub_FC70
.include "sub_fcbf.asm"   ; sub_FCBF - основной игровой цикл

; ============================================
; ВЕКТОРА ПРЕРЫВАНИЙ
; ============================================
.segment "VECTORS"
    .word NMI_HANDLER    ; $FFFA - NMI
    .word VECTOR_RESET  ; $FFFC - Reset
    .word IRQ_HADLER    ; $FFFE - IRQ

; ============================================
; ДАННЫЕ
; ============================================
.segment "RODATA"
; Константные данные (таблицы, строки и т.д.)

.segment "CHARS"
; Графика (CHR-ROM)
.incbin "graphics.chr"  ; Ваш файл с графикой