

; РОМ запускается только с ТВ, звука нет, LCD не работает
.segment "CODE"
.org $FA30

.proc Pre_setup
    lda #$DC
    sta $412D ;Нестандартный регистр (возможно, кастомный маппер)
    lda #$81
    sta $4137 ;Еще один нестандартный регистр
    lda #$C0
    sta $4017
    SEI
    CLD
    ;lda #$A0
    ;sta $410D  ; $410D=#$A0: LCD pins tri-state when PPU_MASK ($2001)=00
    ;
    JMP $EDA8 ; Стандартный Reset Handler
.endproc

.proc lcd_init_sequence ;вставить после VBlank
    lda #$B
    sta $4138       ; $4138 - неизвестный регистр
    lda #2
    sta $4139       ; $4139 - неизвестный регистр
    nop    ; Пустая операция из оригинала
    lda #5
    sta $411C       ; $411C - неизвестный регистр

    ; Переключение банков

    ; Скрипт инициализации
    JSR $B5F0

    ; Включение подсветки 02 4B 0B
    lda #$4B
    sta $4138       ; $4138 - неизвестный регистр

    LDA     #$1F
    STA     $413F
    ;LDA     $4139
    LDA     #3
    STA     $4139
    RTS
.endproc

.proc orig_handler       ; CODE XREF: j
    ; j ...
    LDA     #$DC
    STA     $412D
    LDA     #$81
    STA     $4137
    LDA     #$C0
    STA     $4017
    SEI
    CLD
    LDY     #0
    STY     $2000
    STY     $2001
    ;STY     byte_E000
    LDX     #2
loc_FAC4:       ; CODE XREF: sub_FAA6+21↓j
    ; sub_FAA6+29↓j
    BIT     $2002
    BPL     loc_FAC4
loc_FAC9:       ; CODE XREF: sub_FAA6+26↓j
    BIT     $2002
    BMI     loc_FAC9
    DEX
    BPL     loc_FAC4
    TXS
    LDA     #$F
    STA     $4015
    STY     $4010
    LDA     #$C0
    STA     $4017
    LDA     $2002
    LDA     #$10
    TAX
loc_FAE5:       ; CODE XREF: sub_FAA6+48↓j
    STA     $2006
    STA     $2006
    EOR     #0
    DEX
    BNE     loc_FAE5
    ;LDA     #$80
    ;STA     sub_A000+1
    ;LDA     #1
    ;STA     sub_A000
    LDY     $3CB
    LDA     #0
    TAX
loc_FB00:       ; CODE XREF: sub_FAA6+72↓j
    STA     0,X
    STA     $100,X
    STA     $200,X
    STA     $300,X
    STA     $400,X
    STA     $500,X
    STA     $600,X
    STA     $700,X
    INX
    BNE     loc_FB00
    CPY     #0
    BNE     loc_FB20
    LDY     #$5A ; 'Z'
loc_FB20:       ; CODE XREF: sub_FAA6+76↑j
    STY     $3CB
    LDY     #$20 ; ' '
    STY     $2006
    LDA     #0
    STA     $2006
    LDX     #0
loc_FB2F:       ; CODE XREF: sub_FAA6+8D↓j
    ; sub_FAA6+92↓j
    STA     $2007
    INX
    BNE     loc_FB2F
    INY
    CPY     #$40 ; '@'
    BNE     loc_FB2F
    LDX     #$3F ; '?'
    STX     $2006
    LDX     #0
    STX     $2006
    LDA     #$F
loc_FB46:       ; CODE XREF: sub_FAA6+A6↓j
    STA     $2007
    INX
    CPX     #$20 ; ' '
    BNE     loc_FB46
    LDA     #2
    STA     $4014
    LDA     #0
    STA     $2005
    STA     $2005
    LDA     #$B
    STA     $4138
    LDA     #2
    STA     $4139
    NOP
    LDA     #5
    STA     $411C
    JSR     lcd_init_sequence
    JMP     $FC60 ; конец ориг reset_hadnler EE39
.endproc