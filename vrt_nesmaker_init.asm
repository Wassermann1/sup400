; размер не должен поменяться - длинна не более AE

.proc EDA8 loc_EDA8:       
    NOP     
    STA     $1C
    STA     $2000 ;PPU CTRL
    STA     $1D
    STA     $2001 ;PPU MASK
    TAX
loc_EDB7:       
    STA     0,X
    STA     $100,X
    STA     $200,X
    STA     $300,X
    STA     $400,X
    STA     $500,X
    STA     $600,X
    STA     $700,X
    INX
    BNE     loc_EDB7
    LDX     #$FF
    TXS
    INX
    STX     $4016
    STX     $4015
    LDX     #$C0
    STX     $4017
    LDA     #$4C ; 'L'
    STA     $100
    LDA     #$56 ; 'V'
    STA     $101
    LDA     #$EE
    STA     $102
    LDA     #$4C ; 'L'
    STA     $103
    LDA     #$56 ; 'V'
    STA     $104
    LDA     #$EE
    STA     $105
    LDX     #5
loc_EE00:       
    LDA     $2002 ; PPU STATUS
    BMI     loc_EE00
loc_EE05:       
    LDA     $2002
    BPL     loc_EE05 ;PPU Status
    DEX
    BNE     loc_EE00
    JSR     $FA44 ;lcd_init_sequence инициализация LCD после VBlank (Подставить реальный адрес)
    LDA     #$96
    STA     $A
    LDA     #$ED
    STA     $B
    LDA     #0
    STA     $C
    LDA     #4
    STA     $D
    LDX     #0
loc_EE1F:       
    BEQ     loc_EE31
    LDY     #0
loc_EE23:       
    LDA     ($A),Y
    STA     ($C),Y
    INY
    BNE     loc_EE23
    INC     $B
    INC     $D
    DEX
    BNE     loc_EE1F
loc_EE31:       
    LDY     #0
loc_EE33:       
    LDA     ($A),Y
    STA     ($C),Y
    INY
    CPY     #$12
    BNE     loc_EE33
    LDA     #0
    STA     2
    LDA     #8
    STA     3
    JSR     sub_EE57
    JSR     sub_D7DD
    JSR     sub_F3A9
    JSR     sub_F392
    JSR     sub_F3B2
    JMP     loc_EDA8
.endproc