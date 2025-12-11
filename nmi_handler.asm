; ============================================
; NMI HANDLER (Vertical Blank) FB7D
; ============================================
.proc nmi_handler
    PHA
    TYA
    PHA
    TXA
    PHA
    JSR     sub_FBF4
    JSR     sub_FBC7
    LDA     #2
    STA     $4014
    JSR     sub_FBA7
    JSR     sub_FCEB
    JSR     sub_FBD0
    JSR     sub_FDA2
    LDA     $51A
    BEQ     loc_FBA1
    DEC     $51A
loc_FBA1:
    PLA
    TAX
    PLA
    TAY
    PLA
    RTI
.endproc

.proc sub_FBF4
    LDA     $406
    BEQ     locret_FC10
    LDA     $43E
    SEC
    SBC     #1
    JSR     sub_FC11 ; ->>> IRQ HANDLER
    LDA     $402
    STA     $405
    JSR     sub_D7A1 ; ->>> MAPPER
    LDA     #0
    STA     $403
locret_FC10: 
    RTS
.endproc

.proc sub_FBC7
    LDA     $3B2
    BEQ     locret_FBCF
    JMP     ($80)
; ---------------------------------------------------------------------------
locret_FBCF: 
    RTS
.endproc

.proc sub_FBA7
    LDA     $429
    BNE     loc_FBB4
    LDA     #0
    STA     $2006
    STA     $2006
loc_FBB4: 
    LDA     $3FE
    STA     $2005
    LDA     $3FF
    STA     $2005
    LDA     $3FB
    STA     $2000
    RTS
.endproc

.proc sub_FCEB
    LDA     $3F1
    BNE     loc_FCF4
    JSR     sub_FD20
    RTS
; ---------------------------------------------------------------------------
loc_FCF4:
    LDA     $3F6
    BEQ     locret_FD1F
    LDA     $3EF
    ASL     A
    TAX
    LDA     $FDE8,X
    STA     $8E
    LDA     $FDE9,X
    STA     $8F
    LDA     $3F0
    ASL     A
    TAY
    LDA     ($8E),Y
    STA     $90
    INY
    LDA     ($8E),Y
    STA     $91
    INY
    LDA     ($8E),Y
    STA     $434
    JMP     ($90)
; ---------------------------------------------------------------------------
locret_FD1F:
    RTS
.endproc

        .proc sub_FD20
            JSR     sub_FD27
            JSR     sub_FD32
            RTS
        .endproc

                .proc sub_FD27
                    LDX     #0
                    LDA     #$F0
                loc_FD2B: 
                    STA     $200,X
                    INX
                    BNE     loc_FD2B
                    RTS

                .endproc

                .proc sub_FD32
                    LDX     #0
                loc_FD34: 
                    LDA     #$FF
                    STA     $300,X
                    TXA
                    CLC
                    ADC     #8
                    TAX
                    CPX     #$B0
                    BNE     loc_FD34
                    RTS
                .endproc

.proc sub_FBD0
    LDA     $3CB
    BNE     loc_FBDA
    LDA     #$F
    STA     $3CC
loc_FBDA: 
    JSR     sub_D01E
    LDA     #0
    STA     $3B1
    INC     $92
    INC     $3F5
    LDA     $3F5
    CMP     #7
    BNE     locret_FBF3
    LDA     #0
    STA     $3F5
locret_FBF3: 
    RTS
.endproc

.proc sub_FDA2
    LDA     #6
    STA     $8000
    LDA     #$3A 
    STA     $8001
    LDA     #7
    STA     $8000
    LDA     #$3A 
    CLC
    ADC     #1
    STA     $8001
    JSR     $8000
    LDA     #6
    STA     $8000
    LDA     $3C9
    STA     $8001
    LDA     #7
    STA     $8000
    LDA     $3C9
    CLC
    ADC     #1
    STA     $8001
    RTS
.endproc