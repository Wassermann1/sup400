;init_game_vars_structured

.ifndef SUB_FС43_INC
SUB_FС43_INC = 1

.include "constants.inc"
.include "variables.inc"

.proc sub_FC43 ; опрос позиции по меню
JSR     sub_FCB2
LDA     #0
STA     var_3EF
LDA     #0
STA     var_3F0
LDA     #$20 
STA     var_3B0
LDA     #$88
STA     var_3FB
LDA     #$1E
STA     var_3FC
LDA     #0
STA     var_46D
LDA     #0
STA     var_46E
STA     var_46F
STA     var_470
RTS
.endproc

.proc sub_FCB2 
LDX     #0
LDA     #$E
loc_FCB6:
STA     $407,X
INX
CPX     #MENU_BUFFER_LEN
BNE     loc_FCB6
RTS
.endproc