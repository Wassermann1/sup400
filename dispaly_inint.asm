
; ============================================
; МОДУЛЬ: dispaly_init
; настройка эукрана
; ============================================

.ifndef SUB_A7AF_INC
SUB_A7AF_INC = 1

.include "constants.inc"

.segment "CODE"

.proc sub_A7AF:
 LDA     #$DC
 STA     $412D
 LDA     #$C1
 STA     $4FF6
 LDA     #$71 
 STA     $4FF0
 LDA     #2
 STA     $4139
 LDA     #$FF
 STA     $410F
 JSR     sub_AA09
 JSR     sub_AA09
 LDA     #$DF
 STA     $410F
 JSR     sub_AA09
 JSR     sub_AA09
 LDA     #$FF
 STA     $410F
 JSR     sub_AA09
 RTS

.endproc

.proc sub_AA09: 
         
 TXA
 PHA
 TYA
 PHA
 LDX     #0
 LDY     #$40 ; '@'
@loc_AA11:       
 DEX
 BNE     loc_AA11
 DEY
 BNE     loc_AA11
 PLA
 TAY
 PLA
 TAX
 RTS
.endproc

; ============================================
; PROC: sub_A9C4 
; ============================================
.proc sub_A9C4
    LDA #$0A
    JSR sub_A84E
    LDA #$FC
    STA $412D
    JSR sub_A8BF
    JSR sub_A8BF        ; Еще раз
    LDA $4135
    STA $0110           ; MENU_STATE_110
    LDA #2
    STA $4139
    LDA #$71
    STA $4FF0
    LDA #$DC
    STA $412D
    LDA #$F1
    JSR sub_A84E
    LDA #$FC
    STA $412D
    JSR sub_A8BF
    JSR sub_A8BF        ; Еще раз
    LDA $4135
    STA $0111           ; MENU_STATE_111
    LDA #2
    STA $4139
    LDA #$71
    STA $4FF0
    LDA #$DC
    STA $412D
    RTS
.endproc

; ============================================
; PROC: sub_A84E (отправка данных)
; ============================================
.proc sub_A84E
    STA $4FF7
    LDA #0
    STA $4FF8
    
    LDA #$51
    STA $4FF0
    LDA #$11
    STA $4FF0
    LDA #$11
    STA $4FF0
    LDA #$01
    STA $4FF0
    LDA #$01
    STA $4FF0
    LDA #$01
    STA $4FF0
    LDA #$01
    STA $4FF0
    LDA #$11
    STA $4FF0
    LDA #$11
    STA $4FF0
    RTS
.endproc

; ============================================
; PROC: sub_A8BF (чтение состояния)
; ============================================
.proc sub_A8BF
    LDA #$31
    STA $4FF0
    LDA #2
    STA $4139
    STA $4139           ; Два раза!
    LDA #0
    STA $4139
    STA $4139           ; Два раза!
    LDA $4135           ; Чтение состояния
    RTS
.endproc

.endif ; DISPLAY_INIT_INC