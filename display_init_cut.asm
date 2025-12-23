
.segment "CODE"
.org $FA30

.proc Pre_setup
    lda #$DC
    sta $412D ;Нестандартный регистр (возможно, кастомный маппер)
    lda #$81
    sta $4137 ;Еще один нестандартный регистр
    lda #$C0
    sta JOY2
    SEI
    CLD
    JMP $EDA8 ; Стандартный Reset Handler
.endproc

.proc lcd_init_sequence ;вставить после VBlank
    lda #$0B
    sta $4138       ; $4138 - неизвестный регистр
    lda #2
    sta $4139       ; $4139 - неизвестный регистр
    nop    ; Пустая операция из оригинала
    lda #5
    sta $411C       ; $411C - неизвестный регистр

    ; Скрипт инициализации
    JSR     sub_F372
    LDA     #$E8
    JSR     sub_F37E
    LDA     #$2E ; '.'
    JSR     sub_F372
    LDA     #$79 ; 'y'
    JSR     sub_F37E
    LDA     #$EE
    JSR     sub_F37E
    LDA     #$C
    JSR     sub_F37E
    LDA     #$EA
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #$EB
    JSR     sub_F372
    LDA     #$20 ; ' '
    JSR     sub_F37E
    LDA     #$EC
    JSR     sub_F372
    LDA     #8
    JSR     sub_F37E
    LDA     #$ED
    JSR     sub_F372
    LDA     #$C4
    JSR     sub_F37E
    LDA     #$E8
    JSR     sub_F372
    LDA     #$40 ; '@'
    JSR     sub_F37E
    LDA     #$E9
    JSR     sub_F372
    LDA     #$38 ; '8'
    JSR     sub_F37E
    LDA     #$F1
    JSR     sub_F372
    LDA     #1
    JSR     sub_F37E
    LDA     #$F2
    JSR     sub_F372
    LDA     #$10
    JSR     sub_F37E
    LDA     #$27 ; '''
    JSR     sub_F372
    LDA     #$A3
    JSR     sub_F37E
    LDA     #$40 ; '@'
    JSR     sub_F372
    LDA     #1
    JSR     sub_F37E
    LDA     #$41 ; 'A'
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #$42 ; 'B'
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #$43 ; 'C'
    JSR     sub_F372
    LDA     #$10
    JSR     sub_F37E
    LDA     #$44 ; 'D'
    JSR     sub_F372
    LDA     #$E
    JSR     sub_F37E
    LDA     #$45 ; 'E'
    JSR     sub_F372
    LDA     #$24 ; '$'
    JSR     sub_F37E
    LDA     #$46 ; 'F'
    JSR     sub_F372
    LDA     #4
    JSR     sub_F37E
    LDA     #$47 ; 'G'
    JSR     sub_F372
    LDA     #$50 ; 'P'
    JSR     sub_F37E
    LDA     #$48 ; 'H'
    JSR     sub_F372
    LDA     #2
    JSR     sub_F37E
    LDA     #$49 ; 'I'
    JSR     sub_F372
    LDA     #$13
    JSR     sub_F37E
    LDA     #$4A ; 'J'
    JSR     sub_F372
    LDA     #$19
    JSR     sub_F37E
    LDA     #$4B ; 'K'
    JSR     sub_F372
    LDA     #$19
    JSR     sub_F37E
    LDA     #$4C ; 'L'
    JSR     sub_F372
    LDA     #$16
    JSR     sub_F37E
    LDA     #$50 ; 'P'
    JSR     sub_F372
    LDA     #$1B
    JSR     sub_F37E
    LDA     #$51 ; 'Q'
    JSR     sub_F372
    LDA     #$31 ; '1'
    JSR     sub_F37E
    LDA     #$52 ; 'R'
    JSR     sub_F372
    LDA     #$2F ; '/'
    JSR     sub_F37E
    LDA     #$53 ; 'S'
    JSR     sub_F372
    LDA     #$3F ; '?'
    JSR     sub_F37E
    LDA     #$54 ; 'T'
    JSR     sub_F372
    LDA     #$3F ; '?'
    JSR     sub_F37E
    LDA     #$55 ; 'U'
    JSR     sub_F372
    LDA     #$3E ; '>'
    JSR     sub_F37E
    LDA     #$56 ; 'V'
    JSR     sub_F372
    LDA     #$2F ; '/'
    JSR     sub_F37E
    LDA     #$57 ; 'W'
    JSR     sub_F372
    LDA     #$7B ; '{'
    JSR     sub_F37E
    LDA     #$58 ; 'X'
    JSR     sub_F372
    LDA     #9
    JSR     sub_F37E
    LDA     #$59 ; 'Y'
    JSR     sub_F372
    LDA     #6
    JSR     sub_F37E
    LDA     #$5A ; 'Z'
    JSR     sub_F372
    LDA     #6
    JSR     sub_F37E
    LDA     #$5B ; '['
    JSR     sub_F372
    LDA     #$C
    JSR     sub_F37E
    LDA     #$5C ; '\'
    JSR     sub_F372
    LDA     #$1D
    JSR     sub_F37E
    LDA     #$5D ; ']'
    JSR     sub_F372
    LDA     #$CC
    JSR     sub_F37E
    LDA     #$1B
    JSR     sub_F372
    LDA     #$1B
    JSR     sub_F37E
    LDA     #$1A
    JSR     sub_F372
    LDA     #1
    JSR     sub_F37E
    LDA     #$24 ; '$'
    JSR     sub_F372
    LDA     #$2F ; '/'
    JSR     sub_F37E
    LDA     #$25 ; '%'
    JSR     sub_F372
    LDA     #$6E ; 'n'
    JSR     sub_F37E
    LDA     #$23 ; '#'
    JSR     sub_F372
    LDA     #$86
    JSR     sub_F37E
    LDA     #$18
    JSR     sub_F372
    LDA     #$36 ; '6'
    JSR     sub_F37E
    LDA     #$19
    JSR     sub_F372
    LDA     #1
    JSR     sub_F37E
    LDA     #1
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #$1F
    JSR     sub_F372
    LDA     #$88
    JSR     sub_F37E
    JSR     sub_F33A
    LDA     #$1F
    JSR     sub_F372
    LDA     #$80
    JSR     sub_F37E
    JSR     sub_F33A
    LDA     #$1F
    JSR     sub_F372
    LDA     #$90
    JSR     sub_F37E
    JSR     sub_F33A
    LDA     #$1F
    JSR     sub_F372
    LDA     #$D0
    JSR     sub_F37E
    JSR     sub_F33A
    LDA     #$17
    JSR     sub_F372
    LDA     #5
    JSR     sub_F37E
    LDA     #$36 ; '6'
    JSR     sub_F372
    LDA     #$C
    JSR     sub_F37E
    LDA     #$28 ; '('
    JSR     sub_F372
    LDA     #$38 ; '8'
    JSR     sub_F37E
    LDA     #$28 ; '('
    JSR     sub_F372
    LDA     #$3C ; '<'
    JSR     sub_F37E
    LDA     #2
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #3
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #4
    JSR     sub_F372
    LDA     #1
    JSR     sub_F37E
    LDA     #5
    JSR     sub_F372
    LDA     #$3F ; '?'
    JSR     sub_F37E
    LDA     #6
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #7
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #8
    JSR     sub_F372
    LDA     #0
    JSR     sub_F37E
    LDA     #9
    JSR     sub_F372
    LDA     #$EF
    JSR     sub_F37E
    JSR     sub_F341
    LDA     #$22 ; '"'
    JSR     sub_F372
    NOP
    NOP
    NOP
    NOP
    JSR     sub_F2B5
loc_F272:       ; CODE XREF: j
    LDA     $2002
    AND     #$80
    BEQ     loc_F272
loc_F279:       ; CODE XREF: j
    LDA     $2002
    AND     #$80
    BEQ     loc_F279
loc_F280:       ; CODE XREF: j
    LDA     $2002
    AND     #$80
    BEQ     loc_F280
    LDA     #$81
    STA     $4FF6
    RTS  
.endproc

.proc sub_F372       ; CODE XREF: p
    LDX     #0
    STX     $4FF8
    STA     $4FF7
    JSR     sub_F2D9
    RTS
.endproc

.proc sub_F2B5       ; CODE XREF: ↑p
    LDA     #$B7
    STA     $4FF0
    LDA     #$FF
    STA     $4FF1
    LDA     #$A4
    STA     $4FF2
    LDA     #$5A ; 'Z'
    STA     $4FF3
    LDA     #$9A
    STA     $4FF4
    LDA     #$FD
    STA     $4FF5
    LDA     #$D
    STA     $4FFA
    RTS
.endproc

.proc sub_F2D9       ; CODE XREF: sub_F372+8↓p
    LDA     #$51 ; 'Q'
    STA     $4FF0
    LDA     #$11
    STA     $4FF0
    LDA     #$11
    STA     $4FF0
    LDA     #1
    STA     $4FF0
    LDA     #1
    STA     $4FF0
    LDA     #1
    STA     $4FF0
    LDA     #1
    STA     $4FF0
    LDA     #$11
    STA     $4FF0
    LDA     #$11
    STA     $4FF0
    RTS
.endproc

.proc sub_F37E       ; CODE XREF: p
    LDX     #0
    STX     $4FF8
    STA     $4FF7
    JSR     sub_F307
    RTS
.endproc

.proc sub_F33A       ; CODE XREF: p
    JSR     sub_F341
    JSR     sub_F341
    RTS
.endproc

.proc sub_F341       ; CODE XREF: p
    LDX     #0
    LDY     #0
loc_F345:       ; CODE XREF: sub_F341+5↓j
    DEX
    BNE     loc_F345
    DEY
    BNE     loc_F345
    RTS
.endproc

.proc sub_F307       ; CODE XREF: sub_F37E+8↓p
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #$21 ; '!'
    STA     $4FF0
    LDA     #$21 ; '!'
    STA     $4FF0
    LDA     #$21 ; '!'
    STA     $4FF0
    LDA     #$21 ; '!'
    STA     $4FF0
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #$71 ; 'q'
    STA     $4FF0
    RTS
.endproc

; .proc Init_LCD

; ; 1. Инициализация APU и регистров
;     lda #$DC
;     sta $412D ;Нестандартный регистр (возможно, кастомный маппер)
;     lda #$81
;     sta $4137 ;Еще один нестандартный регистр

;     lda #$C0
;     sta $4017

;     txs 

;     lda #$0F
;     sta $4015     ; $4015 - включить все каналы звука
;     sty $4010          ; Отключить DMC (Y = 0)
    
;     lda #$C0
;     sta $4017 

;     ; 16. Настройка дополнительных регистров VT03
;     lda #$0B
;     sta $4138       ; $4138 - неизвестный регистр
;     lda #2
;     sta $4139       ; $4139 - неизвестный регистр
;     nop    ; Пустая операция из оригинала
;     lda #5
;     sta $411C       ; $411C - неизвестный регистр

;     ; Скрипт инициализации
;     JSR     sub_F372
;     LDA     #$E8
;     JSR     sub_F37E
;     LDA     #$2E ; '.'
;     JSR     sub_F372
;     LDA     #$79 ; 'y'
;     JSR     sub_F37E
;     LDA     #$EE
;     JSR     sub_F37E
;     LDA     #$C
;     JSR     sub_F37E
;     LDA     #$EA
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #$EB
;     JSR     sub_F372
;     LDA     #$20 ; ' '
;     JSR     sub_F37E
;     LDA     #$EC
;     JSR     sub_F372
;     LDA     #8
;     JSR     sub_F37E
;     LDA     #$ED
;     JSR     sub_F372
;     LDA     #$C4
;     JSR     sub_F37E
;     LDA     #$E8
;     JSR     sub_F372
;     LDA     #$40 ; '@'
;     JSR     sub_F37E
;     LDA     #$E9
;     JSR     sub_F372
;     LDA     #$38 ; '8'
;     JSR     sub_F37E
;     LDA     #$F1
;     JSR     sub_F372
;     LDA     #1
;     JSR     sub_F37E
;     LDA     #$F2
;     JSR     sub_F372
;     LDA     #$10
;     JSR     sub_F37E
;     LDA     #$27 ; '''
;     JSR     sub_F372
;     LDA     #$A3
;     JSR     sub_F37E
;     LDA     #$40 ; '@'
;     JSR     sub_F372
;     LDA     #1
;     JSR     sub_F37E
;     LDA     #$41 ; 'A'
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #$42 ; 'B'
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #$43 ; 'C'
;     JSR     sub_F372
;     LDA     #$10
;     JSR     sub_F37E
;     LDA     #$44 ; 'D'
;     JSR     sub_F372
;     LDA     #$E
;     JSR     sub_F37E
;     LDA     #$45 ; 'E'
;     JSR     sub_F372
;     LDA     #$24 ; '$'
;     JSR     sub_F37E
;     LDA     #$46 ; 'F'
;     JSR     sub_F372
;     LDA     #4
;     JSR     sub_F37E
;     LDA     #$47 ; 'G'
;     JSR     sub_F372
;     LDA     #$50 ; 'P'
;     JSR     sub_F37E
;     LDA     #$48 ; 'H'
;     JSR     sub_F372
;     LDA     #2
;     JSR     sub_F37E
;     LDA     #$49 ; 'I'
;     JSR     sub_F372
;     LDA     #$13
;     JSR     sub_F37E
;     LDA     #$4A ; 'J'
;     JSR     sub_F372
;     LDA     #$19
;     JSR     sub_F37E
;     LDA     #$4B ; 'K'
;     JSR     sub_F372
;     LDA     #$19
;     JSR     sub_F37E
;     LDA     #$4C ; 'L'
;     JSR     sub_F372
;     LDA     #$16
;     JSR     sub_F37E
;     LDA     #$50 ; 'P'
;     JSR     sub_F372
;     LDA     #$1B
;     JSR     sub_F37E
;     LDA     #$51 ; 'Q'
;     JSR     sub_F372
;     LDA     #$31 ; '1'
;     JSR     sub_F37E
;     LDA     #$52 ; 'R'
;     JSR     sub_F372
;     LDA     #$2F ; '/'
;     JSR     sub_F37E
;     LDA     #$53 ; 'S'
;     JSR     sub_F372
;     LDA     #$3F ; '?'
;     JSR     sub_F37E
;     LDA     #$54 ; 'T'
;     JSR     sub_F372
;     LDA     #$3F ; '?'
;     JSR     sub_F37E
;     LDA     #$55 ; 'U'
;     JSR     sub_F372
;     LDA     #$3E ; '>'
;     JSR     sub_F37E
;     LDA     #$56 ; 'V'
;     JSR     sub_F372
;     LDA     #$2F ; '/'
;     JSR     sub_F37E
;     LDA     #$57 ; 'W'
;     JSR     sub_F372
;     LDA     #$7B ; '{'
;     JSR     sub_F37E
;     LDA     #$58 ; 'X'
;     JSR     sub_F372
;     LDA     #9
;     JSR     sub_F37E
;     LDA     #$59 ; 'Y'
;     JSR     sub_F372
;     LDA     #6
;     JSR     sub_F37E
;     LDA     #$5A ; 'Z'
;     JSR     sub_F372
;     LDA     #6
;     JSR     sub_F37E
;     LDA     #$5B ; '['
;     JSR     sub_F372
;     LDA     #$C
;     JSR     sub_F37E
;     LDA     #$5C ; '\'
;     JSR     sub_F372
;     LDA     #$1D
;     JSR     sub_F37E
;     LDA     #$5D ; ']'
;     JSR     sub_F372
;     LDA     #$CC
;     JSR     sub_F37E
;     LDA     #$1B
;     JSR     sub_F372
;     LDA     #$1B
;     JSR     sub_F37E
;     LDA     #$1A
;     JSR     sub_F372
;     LDA     #1
;     JSR     sub_F37E
;     LDA     #$24 ; '$'
;     JSR     sub_F372
;     LDA     #$2F ; '/'
;     JSR     sub_F37E
;     LDA     #$25 ; '%'
;     JSR     sub_F372
;     LDA     #$6E ; 'n'
;     JSR     sub_F37E
;     LDA     #$23 ; '#'
;     JSR     sub_F372
;     LDA     #$86
;     JSR     sub_F37E
;     LDA     #$18
;     JSR     sub_F372
;     LDA     #$36 ; '6'
;     JSR     sub_F37E
;     LDA     #$19
;     JSR     sub_F372
;     LDA     #1
;     JSR     sub_F37E
;     LDA     #1
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #$1F
;     JSR     sub_F372
;     LDA     #$88
;     JSR     sub_F37E
;     JSR     sub_F33A
;     LDA     #$1F
;     JSR     sub_F372
;     LDA     #$80
;     JSR     sub_F37E
;     JSR     sub_F33A
;     LDA     #$1F
;     JSR     sub_F372
;     LDA     #$90
;     JSR     sub_F37E
;     JSR     sub_F33A
;     LDA     #$1F
;     JSR     sub_F372
;     LDA     #$D0
;     JSR     sub_F37E
;     JSR     sub_F33A
;     LDA     #$17
;     JSR     sub_F372
;     LDA     #5
;     JSR     sub_F37E
;     LDA     #$36 ; '6'
;     JSR     sub_F372
;     LDA     #$C
;     JSR     sub_F37E
;     LDA     #$28 ; '('
;     JSR     sub_F372
;     LDA     #$38 ; '8'
;     JSR     sub_F37E
;     LDA     #$28 ; '('
;     JSR     sub_F372
;     LDA     #$3C ; '<'
;     JSR     sub_F37E
;     LDA     #2
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #3
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #4
;     JSR     sub_F372
;     LDA     #1
;     JSR     sub_F37E
;     LDA     #5
;     JSR     sub_F372
;     LDA     #$3F ; '?'
;     JSR     sub_F37E
;     LDA     #6
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #7
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #8
;     JSR     sub_F372
;     LDA     #0
;     JSR     sub_F37E
;     LDA     #9
;     JSR     sub_F372
;     LDA     #$EF
;     JSR     sub_F37E
;     JSR     sub_F341
;     LDA     #$22 ; '"'
;     JSR     sub_F372
;     NOP
;     NOP
;     NOP
;     NOP
;     JSR     sub_F2B5
; loc_F272:       ; CODE XREF: j
;     LDA     $2002
;     AND     #$80
;     BEQ     loc_F272
; loc_F279:       ; CODE XREF: j
;     LDA     $2002
;     AND     #$80
;     BEQ     loc_F279
; loc_F280:       ; CODE XREF: j
;     LDA     $2002
;     AND     #$80
;     BEQ     loc_F280
;     LDA     #$81
;     STA     $4FF6
;     RTS   ; <---- тут должен быть прыжок к оригинальному reset handler
; .endproc