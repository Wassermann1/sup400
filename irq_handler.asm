; ============================================
; IRQ HANDLER
; ============================================

.ifndef irq_handler
IRQ_HADNLER_INC = 1

.include "constants.inc"
.include "variables.inc"
.include "mapper.asm"

.segment "CODE"

.proc irq_handler ; IRQ VECOTR FC1B
    PHA
    TYA
    PHA
    TXA
    PHA
    LDA     #0
    STA     $E000
    INC     $403
    LDA     $403
    ASL     A
    TAX
    LDA     $43E,X
    CMP     #$FF
    BEQ     loc_FC37
    JSR     sub_FC11
loc_FC37:    
    LDA     $43F,X
    JSR     sub_D7A1 ; from mapper.asm
    PLA
    TAX
    PLA
    TAY
    PLA
    RTI
.endproc

.proc sub_FC11
    STA     $C000
    STA     $C001
    STA     $E001
    RTS
.endproc

.endif ; MAPPER_INC