

.proc sub_FAA6:       ; CODE XREF: j
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
    STY     byte_E000
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
    LDA     #$80
    STA     sub_A000+1
    LDA     #1
    STA     sub_A000
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
    JSR     sub_FD43
    JSR     sub_FC43
    JSR     sub_EFD9
    JSR     sub_FC70
loc_FB77:       ; CODE XREF: sub_FAA6+D4↓j
    JSR     sub_FCBF
    JMP     loc_FB77
.endproc

.proc sub_FD43:       ; CODE XREF: sub_FAA6+C5↑p
    LDA     #$3C ; '<'
    STA     $4107
    LDA     #$3D ; '='
    STA     $4108
    LDA     #0
    JSR     sub_D772
    LDA     #4
    JSR     sub_D7A1
    RTS
.endproc

.proc sub_D772:       ; CODE XREF: sub_FD43+C↓p
    STA     $401
    TXA
    PHA
    LDX     #2
    STX     byte_8000
    LDA     $401
    STA     byte_8001
    INX
    STX     byte_8000
    CLC
    ADC     #1
    STA     byte_8001
    INX
    STX     byte_8000
    ADC     #1
    STA     byte_8001
    INX
    STX     byte_8000
    ADC     #1
    STA     byte_8001
    PLA
    TAX
    RTS
.endproc

.proc sub_D7A1:       ; CODE XREF: sub_FBF4+14↓p
    ; p ...
    STA     $401
    TXA
    PHA
    LDX     #0
    STX     byte_8000
    LDA     $401
    STA     byte_8001
    INX
    STX     byte_8000
    CLC
    ADC     #2
    STA     byte_8001
    PLA
    TAX
    RTS
.endproc

.proc sub_EFD9:       ; CODE XREF: sub_FAA6+CB↓p
    LDA     #$3C ; '<'
    STA     $4107
    JSR     sub_A000
    RTS
.endproc

.proc sub_FC70:       ; CODE XREF: sub_FAA6+CE↑p
; FUNCTION CHUNK AT SIZE 00000013 BYTES
    JSR     sub_D01E
    LDA     $3BD
    AND     #$40 ; '@'
    CMP     #$40 ; '@'
    BNE     locret_FC84
    LDA     #1
    STA     $3F0
    JMP     loc_FF00
; ---------------------------------------------------------------------------
locret_FC84:    ; CODE XREF: sub_FC70+A↑j
    RTS
.endproc

loc_FF00:       ; CODE XREF: sub_FC70+11↑j
    LDY     #0
loc_FF02:       ; CODE XREF: sub_FC70+29B↓j
    LDA     $FF14,Y
    STA     $408,Y
    INY
    CPY     #$3A ; ':'
    BCC     loc_FF02
    JSR     sub_FF4E
    JMP     $408

.proc sub_FF4E:       ; CODE XREF: sub_FC70+29D↑p
    LDA     #0
    STA     $2016
    LDA     #2
    STA     $2017
    LDA     #4
    STA     $2012
    LDA     #5
    STA     $2013
    LDA     #6
    STA     $2014
    LDA     #7
    STA     $2015
    RTS
.endproc