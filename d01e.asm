; ============================================
; МОДУЛЬ: d01e
; настройка украна
; ============================================

.proc sub_D01E
JMP loc_D02A
loc_D02A:     
    PHA
    TXA
    PHA
    TYA
    PHA
    LDA     #1
    STA     $4016
    LDA     #0
    STA     $4016
    LDX     #8
    LDY     #0
loc_D03D:      
    LDA     $4016
    LSR     A
    BCS     loc_D044
    LSR     A
loc_D044:       
    ROL     $3BD
    DEX
    BNE     loc_D03D
    LDX     #8
    LDY     #0
loc_D04E:       
    LDA     $4017
    LSR     A
    BCS     loc_D055
    LSR     A
loc_D055:      
    ROL     $3BE
    DEX
    BNE     loc_D04E
    PLA
    TAY
    PLA
    TAX
    PLA
    RTS
.endproc
