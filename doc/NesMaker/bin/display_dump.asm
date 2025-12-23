; Сложный алгоритм выбора дисплея из оригинала

.segment "CODE"
.org $B5F0


.proc sub_A006       ; CODE XREF: sub_A000↑p
    JSR     sub_A7AF
    JSR     sub_A9C4
    LDA     $110
    CMP     #8
    BNE     loc_A022
    LDA     $111
    CMP     #4
    BNE     loc_A022
    LDA     #$1E
    STA     $116
    JMP     loc_A51A
; ---------------------------------------------------------------------------
loc_A022:       ; CODE XREF: sub_A006+B↑j
    ; sub_A006+12↑j
    LDA     $110
    CMP     #8
    BNE     loc_A038
    LDA     $111
    CMP     #$F1
    BNE     loc_A038
    LDA     #$1E
    STA     $116
    JMP     loc_A51A
; ---------------------------------------------------------------------------
loc_A038:       ; CODE XREF: sub_A006+21↑j
    ; sub_A006+28↑j
    JSR     sub_A96A
    LDA     $111
    CMP     #3
    BNE     loc_A051
    LDA     $112
    CMP     #1
    BNE     loc_A051
    LDA     #$25 ; '%'
    STA     $116
    JMP     loc_A53B
; ---------------------------------------------------------------------------
loc_A051:       ; CODE XREF: sub_A006+3A↑j
    ; sub_A006+41↑j
    LDA     $111
    CMP     #$93
    BNE     loc_A067
    LDA     $112
    CMP     #3
    BNE     loc_A067
    LDA     #$26 ; '&'
    STA     $116
    JMP     loc_A546
; ---------------------------------------------------------------------------
loc_A067:       ; CODE XREF: sub_A006+50↑j
    ; sub_A006+57↑j
    JSR     sub_A965
    LDA     $111
    CMP     #$93
    BNE     loc_A080
    LDA     $112
    CMP     #6
    BNE     loc_A080
    LDA     #1
    STA     $116
    JMP     loc_A4A1
; ---------------------------------------------------------------------------
loc_A080:       ; CODE XREF: sub_A006+69↑j
    ; sub_A006+70↑j
    LDA     $111
    CMP     #$30 ; '0'
    BNE     loc_A096
    LDA     $112
    CMP     #$33 ; '3'
    BNE     loc_A096
    LDA     #$32 ; '2'
    STA     $116
    JMP     loc_A50F
; ---------------------------------------------------------------------------
loc_A096:       ; CODE XREF: sub_A006+7F↑j
    ; sub_A006+86↑j
    LDA     $110
    CMP     #$85
    BNE     loc_A0B3
    LDA     $111
    CMP     #$85
    BNE     loc_A0B3
    LDA     $112
    CMP     #$52 ; 'R'
    BNE     loc_A0B3
    LDA     #2
    STA     $116
    JMP     loc_A4B7
; ---------------------------------------------------------------------------
loc_A0B3:       ; CODE XREF: sub_A006+95↑j
    ; sub_A006+9C↑j ...
    LDA     $110
    CMP     #$77 ; 'w'
    BNE     loc_A0C9
    LDA     $111
    CMP     #$89
    BNE     loc_A0C9
    LDA     #$2B ; '+'
    STA     $116
    JMP     loc_A4B7
; ---------------------------------------------------------------------------
loc_A0C9:       ; CODE XREF: sub_A006+B2↑j
    ; sub_A006+B9↑j
    LDA     $111
    CMP     #$93
    BNE     loc_A0DF
    LDA     $112
    CMP     #2
    BNE     loc_A0DF
    LDA     #3
    STA     $116
    JMP     loc_A4C2
; ---------------------------------------------------------------------------
loc_A0DF:       ; CODE XREF: sub_A006+C8↑j
    ; sub_A006+CF↑j
    LDA     $111
    CMP     #$30 ; '0'
    BNE     loc_A0F5
    LDA     $112
    CMP     #$33 ; '3'
    BNE     loc_A0F5
    LDA     #$1B
    STA     $116
    JMP     loc_A4F9
; ---------------------------------------------------------------------------
loc_A0F5:       ; CODE XREF: sub_A006+DE↑j
    ; sub_A006+E5↑j
    LDA     $110
    CMP     #$30 ; '0'
    BNE     loc_A10B
    LDA     $111
    CMP     #$31 ; '1'
    BNE     loc_A10B
    LDA     #$22 ; '"'
    STA     $116
    JMP     loc_A68C
; ---------------------------------------------------------------------------
loc_A10B:       ; CODE XREF: sub_A006+F4↑j
    ; sub_A006+FB↑j
    LDA     $110
    CMP     #$38 ; '8'
    BNE     loc_A128
    LDA     $111
    CMP     #$80
    BNE     loc_A128
    LDA     $112
    CMP     #0
    BNE     loc_A128
    LDA     #$23 ; '#'
    STA     $116
    JMP     loc_A530
; ---------------------------------------------------------------------------
loc_A128:       ; CODE XREF: sub_A006+10A↑j
    ; sub_A006+111↑j ...
    LDA     $110
    CMP     #$7C ; '|'
    BNE     loc_A145
    LDA     $111
    CMP     #$80
    BNE     loc_A145
    LDA     $112
    CMP     #0
    BNE     loc_A145
    LDA     #$2A ; '*'
    STA     $116
    JMP     loc_A530
; ---------------------------------------------------------------------------
loc_A145:       ; CODE XREF: sub_A006+127↑j
    ; sub_A006+12E↑j ...
    LDA     $111
    CMP     #$93
    BNE     loc_A15B
    LDA     $112
    CMP     #4
    BNE     loc_A15B
    LDA     #$24 ; '$'
    STA     $116
    JMP     loc_A4AC
; ---------------------------------------------------------------------------
loc_A15B:       ; CODE XREF: sub_A006+144↑j
    ; sub_A006+14B↑j
    LDA     $110
    CMP     #$38 ; '8'
    BNE     loc_A171
    LDA     $111
    CMP     #$80
    BNE     loc_A171
    LDA     #$2F ; '/'
    STA     $116
    JMP     loc_A55C
; ---------------------------------------------------------------------------
loc_A171:       ; CODE XREF: sub_A006+15A↑j
    ; sub_A006+161↑j
    JSR     sub_A974
    LDA     $111
    CMP     #$93
    BNE     loc_A18A
    LDA     $112
    CMP     #$41 ; 'A'
    BNE     loc_A18A
    LDA     #4
    STA     $116
    JMP     loc_A4CD
; ---------------------------------------------------------------------------
loc_A18A:       ; CODE XREF: sub_A006+173↑j
    ; sub_A006+17A↑j
    LDA     $111
    CMP     #$93
    BNE     loc_A1A0
    LDA     $112
    CMP     #$40 ; '@'
    BNE     loc_A1A0
    LDA     #$2E ; '.'
    STA     $116
    JMP     loc_A4E3
; ---------------------------------------------------------------------------
loc_A1A0:       ; CODE XREF: sub_A006+189↑j
    ; sub_A006+190↑j
    LDA     $111
    CMP     #$31 ; '1'
    BNE     loc_A1B6
    LDA     $112
    CMP     #$29 ; ')'
    BNE     loc_A1B6
    LDA     #$1C
    STA     $116
    JMP     loc_A504
; ---------------------------------------------------------------------------
loc_A1B6:       ; CODE XREF: sub_A006+19F↑j
    ; sub_A006+1A6↑j
    LDA     $110
    CMP     #$31 ; '1'
    BNE     loc_A1D3
    LDA     $111
    CMP     #$30 ; '0'
    BNE     loc_A1D3
    LDA     $112
    CMP     #$32 ; '2'
    BNE     loc_A1D3
    LDA     #$31 ; '1'
    STA     $116
    JMP     loc_A50F
; ---------------------------------------------------------------------------
loc_A1D3:       ; CODE XREF: sub_A006+1B5↑j
    ; sub_A006+1BC↑j ...
    JSR     sub_A979
    LDA     $111
    CMP     #$93
    BNE     loc_A1EC
    LDA     $112
    CMP     #$40 ; '@'
    BNE     loc_A1EC
    LDA     #5
    STA     $116
    JMP     loc_A4D8
; ---------------------------------------------------------------------------
loc_A1EC:       ; CODE XREF: sub_A006+1D5↑j
    ; sub_A006+1DC↑j
    JSR     sub_A915
    LDA     $111
    CMP     #$47 ; 'G'
    BNE     loc_A1FE
    LDA     #7
    STA     $116
    JMP     loc_A65E
; ---------------------------------------------------------------------------
loc_A1FE:       ; CODE XREF: sub_A006+1EE↑j
    LDA     $111
    CMP     #$46 ; 'F'
    BNE     loc_A20D
    LDA     #$20 ; ' '
    STA     $116
    JMP     loc_A669
; ---------------------------------------------------------------------------
loc_A20D:       ; CODE XREF: sub_A006+1FD↑j
    JSR     sub_A96F
    LDA     $110
    CMP     #1
    BNE     loc_A226
    LDA     $111
    CMP     #$21 ; '!'
    BNE     loc_A226
    LDA     #$27 ; '''
    STA     $116
    JMP     loc_A551
; ---------------------------------------------------------------------------
loc_A226:       ; CODE XREF: sub_A006+20F↑j
    ; sub_A006+216↑j
    LDA     $110
    CMP     #1
    BNE     loc_A23C
    LDA     $111
    CMP     #0
    BNE     loc_A23C
    LDA     #$28 ; '('
    STA     $116
    JMP     loc_A551
; ---------------------------------------------------------------------------
loc_A23C:       ; CODE XREF: sub_A006+225↑j
    ; sub_A006+22C↑j
    JSR     sub_A910
    LDA     $110
    AND     #$F
    CMP     #8
    BNE     loc_A257
    LDA     $111
    CMP     #9
    BNE     loc_A257
    LDA     #6
    STA     $116
    JMP     loc_A57A
; ---------------------------------------------------------------------------
loc_A257:       ; CODE XREF: sub_A006+240↑j
    ; sub_A006+247↑j
    LDA     $110
    CMP     #$68 ; 'h'
    BNE     loc_A26D
    LDA     $111
    CMP     #7
    BNE     loc_A26D
    LDA     #6
    STA     $116
    JMP     loc_A57A
; ---------------------------------------------------------------------------
loc_A26D:       ; CODE XREF: sub_A006+256↑j
    ; sub_A006+25D↑j
    LDA     $110
    CMP     #$68 ; 'h'
    BNE     loc_A283
    LDA     $111
    CMP     #1
    BNE     loc_A283
    LDA     #6
    STA     $116
    JMP     loc_A57A
; ---------------------------------------------------------------------------
loc_A283:       ; CODE XREF: sub_A006+26C↑j
    ; sub_A006+273↑j
    LDA     $110
    AND     #$F
    CMP     #3
    BNE     loc_A2B9
    LDA     $111
    CMP     #$25 ; '%'
    BNE     loc_A2B9
    JSR     sub_A93D
    LDA     $112
    CMP     #$74 ; 't'
    BEQ     loc_A2B1
    CMP     #$44 ; 'D'
    BEQ     loc_A2A9
    LDA     #$A
    STA     $116
    JMP     loc_A585
; ---------------------------------------------------------------------------
loc_A2A9:       ; CODE XREF: sub_A006+299↑j
    LDA     #$B
    STA     $116
    JMP     loc_A585
; ---------------------------------------------------------------------------
loc_A2B1:       ; CODE XREF: sub_A006+295↑j
    LDA     #$C
    STA     $116
    JMP     loc_A590
; ---------------------------------------------------------------------------
loc_A2B9:       ; CODE XREF: sub_A006+284↑j
    ; sub_A006+28B↑j
    LDA     $110
    AND     #$F
    CMP     #3
    BNE     loc_A2D1
    LDA     $111
    CMP     #$28 ; '('
    BNE     loc_A2D1
    LDA     #9
    STA     $116
    JMP     loc_A585
; ---------------------------------------------------------------------------
loc_A2D1:       ; CODE XREF: sub_A006+2BA↑j
    ; sub_A006+2C1↑j
    LDA     $110
    AND     #$F
    CMP     #3
    BNE     loc_A2E9
    LDA     $111
    CMP     #$20 ; ' '
    BNE     loc_A2E9
    LDA     #$D
    STA     $116
    JMP     loc_A609
; ---------------------------------------------------------------------------
loc_A2E9:       ; CODE XREF: sub_A006+2D2↑j
    ; sub_A006+2D9↑j
    LDA     $111
    CMP     #$47 ; 'G'
    BNE     loc_A2F8
    LDA     #8
    STA     $116
    JMP     loc_A63D
; ---------------------------------------------------------------------------
loc_A2F8:       ; CODE XREF: sub_A006+2E8↑j
    LDA     $111
    CMP     #$75 ; 'u'
    BNE     loc_A307
    LDA     #$1D
    STA     $116
    JMP     loc_A648
; ---------------------------------------------------------------------------
loc_A307:       ; CODE XREF: sub_A006+2F7↑j
    LDA     $111
    CMP     #$95
    BNE     loc_A316
    LDA     #$2C ; ','
    STA     $116
    JMP     loc_A648
; ---------------------------------------------------------------------------
loc_A316:       ; CODE XREF: sub_A006+306↑j
    LDA     $111
    CMP     #$67 ; 'g'
    BNE     loc_A325
    LDA     #$2D ; '-'
    STA     $116
    JMP     loc_A653
; ---------------------------------------------------------------------------
loc_A325:       ; CODE XREF: sub_A006+315↑j
    LDA     $110
    CMP     #1
    BNE     loc_A33B
    LDA     $111
    CMP     #$39 ; '9'
    BNE     loc_A33B
    LDA     #$E
    STA     $116
    JMP     loc_A59B
; ---------------------------------------------------------------------------
loc_A33B:       ; CODE XREF: sub_A006+324↑j
    ; sub_A006+32B↑j
    LDA     $110
    AND     #$F
    CMP     #5
    BNE     loc_A353
    LDA     $111
    CMP     #$35 ; '5'
    BNE     loc_A353
    LDA     #$F
    STA     $116
    JMP     loc_A5A6
; ---------------------------------------------------------------------------
loc_A353:       ; CODE XREF: sub_A006+33C↑j
    ; sub_A006+343↑j
    LDA     $110
    AND     #$F
    CMP     #5
    BNE     loc_A37B
    LDA     $111
    CMP     #5
    BNE     loc_A37B
    JSR     sub_A942
    LDA     $112
    BNE     loc_A373
    LDA     #$11
    STA     $116
    JMP     loc_A614
; ---------------------------------------------------------------------------
loc_A373:       ; CODE XREF: sub_A006+363↑j
    LDA     #$12
    STA     $116
    JMP     loc_A61F
; ---------------------------------------------------------------------------
loc_A37B:       ; CODE XREF: sub_A006+354↑j
    ; sub_A006+35B↑j
    LDA     $110
    AND     #$F
    CMP     #5
    BNE     loc_A393
    LDA     $111
    CMP     #$31 ; '1'
    BNE     loc_A393
    LDA     #$10
    STA     $116
    JMP     loc_A5B1
; ---------------------------------------------------------------------------
loc_A393:       ; CODE XREF: sub_A006+37C↑j
    ; sub_A006+383↑j
    LDA     $110
    AND     #$F
    CMP     #9
    BNE     loc_A3AB
    LDA     $111
    CMP     #$89
    BNE     loc_A3AB
    LDA     #$13
    STA     $116
    JMP     loc_A5C7
; ---------------------------------------------------------------------------
loc_A3AB:       ; CODE XREF: sub_A006+394↑j
    ; sub_A006+39B↑j
    LDA     $110
    AND     #$F
    CMP     #9
    BNE     loc_A3C3
    LDA     $111
    CMP     #$97
    BNE     loc_A3C3
    LDA     #$1A
    STA     $116
    JMP     loc_A5D2
; ---------------------------------------------------------------------------
loc_A3C3:       ; CODE XREF: sub_A006+3AC↑j
    ; sub_A006+3B3↑j
    LDA     $110
    AND     #$F
    CMP     #4
    BNE     loc_A3DB
    LDA     $111
    CMP     #8
    BNE     loc_A3DB
    LDA     #$14
    STA     $116
    JMP     loc_A5DD
; ---------------------------------------------------------------------------
loc_A3DB:       ; CODE XREF: sub_A006+3C4↑j
    ; sub_A006+3CB↑j
    LDA     $110
    CMP     #1
    BNE     loc_A3F1
    LDA     $111
    CMP     #$54 ; 'T'
    BNE     loc_A3F1
    LDA     #$16
    STA     $116
    JMP     loc_A5BC
; ---------------------------------------------------------------------------
loc_A3F1:       ; CODE XREF: sub_A006+3DA↑j
    ; sub_A006+3E1↑j
    LDA     $110
    AND     #$F
    CMP     #5
    BNE     loc_A409
    LDA     $111
    CMP     #$80
    BNE     loc_A409
    LDA     #$17
    STA     $116
    JMP     loc_A5E8
; ---------------------------------------------------------------------------
loc_A409:       ; CODE XREF: sub_A006+3F2↑j
    ; sub_A006+3F9↑j
    LDA     $110
    AND     #$F
    CMP     #7
    BNE     loc_A421
    LDA     $111
    CMP     #$83
    BNE     loc_A421
    LDA     #$18
    STA     $116
    JMP     loc_A5FE
; ---------------------------------------------------------------------------
loc_A421:       ; CODE XREF: sub_A006+40A↑j
    ; sub_A006+411↑j
    LDA     $110
    AND     #$F
    CMP     #3
    BNE     loc_A439
    LDA     $111
    CMP     #$35 ; '5'
    BNE     loc_A439
    LDA     #$19
    STA     $116
    JMP     loc_A5F3
; ---------------------------------------------------------------------------
loc_A439:       ; CODE XREF: sub_A006+422↑j
    ; sub_A006+429↑j
    LDA     $110
    AND     #$F
    CMP     #3
    BNE     loc_A451
    LDA     $111
    CMP     #$31 ; '1'
    BNE     loc_A451
    LDA     #$1F
    STA     $116
    JMP     loc_A5F3
; ---------------------------------------------------------------------------
loc_A451:       ; CODE XREF: sub_A006+43A↑j
    ; sub_A006+441↑j
    LDA     $110
    AND     #$F
    CMP     #9
    BNE     loc_A469
    LDA     $111
    CMP     #$67 ; 'g'
    BNE     loc_A469
    LDA     #$21 ; '!'
    STA     $116
    JMP     loc_A62A
; ---------------------------------------------------------------------------
loc_A469:       ; CODE XREF: sub_A006+452↑j
    ; sub_A006+459↑j
    JSR     sub_A97E
    LDA     $110
    CMP     #$95
    BNE     loc_A47B
    LDA     #$30 ; '0'
    STA     $116
    JMP     loc_A567
; ---------------------------------------------------------------------------
loc_A47B:       ; CODE XREF: sub_A006+46B↑j
    LDA     $110
    CMP     #$75 ; 'u'
    BNE     loc_A48A
    LDA     #$30 ; '0'
    STA     $116
    JMP     loc_A567
; ---------------------------------------------------------------------------
loc_A48A:       ; CODE XREF: sub_A006+47A↑j
    LDA     $110
    CMP     #$71 ; 'q'
    BNE     loc_A499
    LDA     #$30 ; '0'
    STA     $116
    JMP     loc_A567
; ---------------------------------------------------------------------------
loc_A499:       ; CODE XREF: sub_A006+489↑j
    LDA     #0
    STA     $116
    JMP     loc_A67C
; ---------------------------------------------------------------------------
loc_A4A1:       ; CODE XREF: sub_A006+77↑j
    LDA     #$2F ; '/'
    STA     $F8
    LDA     #$AA
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4AC:       ; CODE XREF: sub_A006+152↑j
    LDA     #$79 ; 'y'
    STA     $F8
    LDA     #$AB
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4B7:       ; CODE XREF: sub_A006+AA↑j
    ; sub_A006+C0↑j
    LDA     #5
    STA     $F8
    LDA     #$AD
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4C2:       ; CODE XREF: sub_A006+D6↑j
    LDA     #$5F ; '_'
    STA     $F8
    LDA     #$AD
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4CD:       ; CODE XREF: sub_A006+181↑j
    LDA     #$A8
    STA     $F8
    LDA     #$AD
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4D8:       ; CODE XREF: sub_A006+1E3↑j
    LDA     #$2B ; '+'
    STA     $F8
    LDA     #$AC
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4E3:       ; CODE XREF: sub_A006+197↑j
    LDA     #$AC
    STA     $F8
    LDA     #$AC
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
    LDA     #$20 ; ' '
    STA     $F8
    LDA     #$AE
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A4F9:       ; CODE XREF: sub_A006+EC↑j
    LDA     #$CB
    STA     $F8
    LDA     #$AE
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A504:       ; CODE XREF: sub_A006+1AD↑j
    LDA     #2
    STA     $F8
    LDA     #$B0
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A50F:       ; CODE XREF: sub_A006+8D↑j
    ; sub_A006+1CA↑j
    LDA     #$60 ; '`'
    STA     $F8
    LDA     #$AF
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A51A:       ; CODE XREF: sub_A006+19↑j
    ; sub_A006+2F↑j
    LDA     #$92
    STA     $F8
    LDA     #$B0
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
    LDA     #$17
    STA     $F8
    LDA     #$B1
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A530:       ; CODE XREF: sub_A006+11F↑j
    ; sub_A006+13C↑j
    LDA     #$3A ; ':'
    STA     $F8
    LDA     #$B2
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A53B:       ; CODE XREF: sub_A006+48↑j
    LDA     #$E8
    STA     $F8
    LDA     #$AB
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A546:       ; CODE XREF: sub_A006+5E↑j
    LDA     #$24 ; '$'
    STA     $F8
    LDA     #$AB
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A551:       ; CODE XREF: sub_A006+21D↑j
    ; sub_A006+233↑j
    LDA     #$9F
    STA     $F8
    LDA     #$B2
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A55C:       ; CODE XREF: sub_A006+168↑j
    LDA     #$29 ; ')'
    STA     $F8
    LDA     #$B3
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A567:       ; CODE XREF: sub_A006+472↑j
    ; sub_A006+481↑j ...
    LDA     #$AE
    STA     $F8
    LDA     #$AA
    STA     $F9
    JMP     loc_A572
; ---------------------------------------------------------------------------
loc_A572:       ; CODE XREF: sub_A006+4A3↑j
    ; sub_A006+4AE↑j ...
    LDA     #0
    STA     $114
    JMP     loc_A69C
; ---------------------------------------------------------------------------
loc_A57A:       ; CODE XREF: sub_A006+24E↑j
    ; sub_A006+264↑j ...
    LDA     #$DC
    STA     $F8
    LDA     #$B5
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A585:       ; CODE XREF: sub_A006+2A0↑j
    ; sub_A006+2A8↑j ...
    LDA     #$62 ; 'b'
    STA     $F8
    LDA     #$B6
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A590:       ; CODE XREF: sub_A006+2B0↑j
    LDA     #$F7
    STA     $F8
    LDA     #$B6
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A59B:       ; CODE XREF: sub_A006+332↑j
    LDA     #$8F
    STA     $F8
    LDA     #$B7
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5A6:       ; CODE XREF: sub_A006+34A↑j
    LDA     #9
    STA     $F8
    LDA     #$B8
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5B1:       ; CODE XREF: sub_A006+38A↑j
    LDA     #$42 ; 'B'
    STA     $F8
    LDA     #$BA
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5BC:       ; CODE XREF: sub_A006+3E8↑j
    LDA     #$C5
    STA     $F8
    LDA     #$BA
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5C7:       ; CODE XREF: sub_A006+3A2↑j
    LDA     #$39 ; '9'
    STA     $F8
    LDA     #$BB
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5D2:       ; CODE XREF: sub_A006+3BA↑j
    LDA     #$B6
    STA     $F8
    LDA     #$BB
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5DD:       ; CODE XREF: sub_A006+3D2↑j
    LDA     #$2A ; '*'
    STA     $F8
    LDA     #$BC
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5E8:       ; CODE XREF: sub_A006+400↑j
    LDA     #$E0
    STA     $F8
    LDA     #$BC
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5F3:       ; CODE XREF: sub_A006+430↑j
    ; sub_A006+448↑j
    LDA     #$6F ; 'o'
    STA     $F8
    LDA     #$BD
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A5FE:       ; CODE XREF: sub_A006+418↑j
    LDA     #7
    STA     $F8
    LDA     #$BE
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A609:       ; CODE XREF: sub_A006+2E0↑j
    LDA     #$89
    STA     $F8
    LDA     #$B8
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A614:       ; CODE XREF: sub_A006+36A↑j
    LDA     #$2A ; '*'
    STA     $F8
    LDA     #$B9
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A61F:       ; CODE XREF: sub_A006+372↑j
    LDA     #$B9
    STA     $F8
    LDA     #$B9
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A62A:       ; CODE XREF: sub_A006+460↑j
    LDA     #$72 ; 'r'
    STA     $F8
    LDA     #$BE
    STA     $F9
    JMP     loc_A635
; ---------------------------------------------------------------------------
loc_A635:       ; CODE XREF: sub_A006+57C↑j
    ; sub_A006+587↑j ...
    LDA     #1
    STA     $114
    JMP     loc_A69C
; ---------------------------------------------------------------------------
loc_A63D:       ; CODE XREF: sub_A006+2EF↑j
    LDA     #$72 ; 'r'
    STA     $F8
    LDA     #$B3
    STA     $F9
    JMP     loc_A674
; ---------------------------------------------------------------------------
loc_A648:       ; CODE XREF: sub_A006+2FE↑j
    ; sub_A006+30D↑j
    LDA     #$F2
    STA     $F8
    LDA     #$B3
    STA     $F9
    JMP     loc_A674
; ---------------------------------------------------------------------------
loc_A653:       ; CODE XREF: sub_A006+31C↑j
    LDA     #$7C ; '|'
    STA     $F8
    LDA     #$B4
    STA     $F9
    JMP     loc_A674
; ---------------------------------------------------------------------------
loc_A65E:       ; CODE XREF: sub_A006+1F5↑j
    LDA     #$FC
    STA     $F8
    LDA     #$B4
    STA     $F9
    JMP     loc_A674
; ---------------------------------------------------------------------------
loc_A669:       ; CODE XREF: sub_A006+204↑j
    LDA     #$74 ; 't'
    STA     $F8
    LDA     #$B5
    STA     $F9
    JMP     loc_A674
; ---------------------------------------------------------------------------
loc_A674:       ; CODE XREF: sub_A006+63F↑j
    ; sub_A006+64A↑j ...
    LDA     #2
    STA     $114
    JMP     loc_A69C
; ---------------------------------------------------------------------------
loc_A67C:       ; CODE XREF: sub_A006+498↑j
    LDA     #$CE
    STA     $F8
    LDA     #$BE
    STA     $F9
    LDA     #0
    STA     $114
    JMP     loc_A69C
; ---------------------------------------------------------------------------
loc_A68C:       ; CODE XREF: sub_A006+102↑j
    LDA     #$A1
    STA     $F8
    LDA     #$B1
    STA     $F9
    LDA     #4
    STA     $114
    JMP     loc_A69C
; ---------------------------------------------------------------------------
loc_A69C:       ; CODE XREF: sub_A006+571↑j
    ; sub_A006+634↑j ...
    LDA     $114
    CMP     #1
    BEQ     loc_A6B5
    CMP     #2
    BEQ     loc_A6BB
    CMP     #3
    BEQ     loc_A6C1
    CMP     #4
    BEQ     loc_A6CE
    JSR     sub_A6F6
    JMP     loc_A6DB
; ---------------------------------------------------------------------------
loc_A6B5:       ; CODE XREF: sub_A006+69B↑j
    JSR     sub_A725
    JMP     loc_A6DB
; ---------------------------------------------------------------------------
loc_A6BB:       ; CODE XREF: sub_A006+69F↑j
    JSR     sub_A758
    JMP     loc_A6DB
; ---------------------------------------------------------------------------
loc_A6C1:       ; CODE XREF: sub_A006+6A3↑j
    JSR     sub_A782
    NOP
    NOP
    NOP
    NOP
    JSR     sub_A806
    JMP     loc_A6E2
; ---------------------------------------------------------------------------
loc_A6CE:       ; CODE XREF: sub_A006+6A7↑j
    JSR     sub_A6F6
    NOP
    NOP
    NOP
    NOP
    JSR     sub_A806
    JMP     loc_A6E2
; ---------------------------------------------------------------------------
loc_A6DB:       ; CODE XREF: sub_A006+6AC↑j
    ; sub_A006+6B2↑j ...
    NOP
    NOP
    NOP
    NOP
    JSR     sub_A7E2
loc_A6E2:       ; CODE XREF: sub_A006+6C5↑j
    ; sub_A006+6D2↑j ...
    LDA     $2002
    AND     #$80
    BEQ     loc_A6E2
loc_A6E9:       ; CODE XREF: sub_A006+6E8↓j
    LDA     $2002
    AND     #$80
    BEQ     loc_A6E9
    LDA     #$81
    STA     $4FF6
    RTS
; End of function sub_A006
.endproc


.proc sub_A7AF                               ; CODE XREF: sub_A006↑p
    LDA     #$DC
    STA     $412D
    LDA     #$C1
    STA     $4FF6
    LDA     #$71 ; 'q'
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

.proc sub_A9C4                               ; CODE XREF: sub_A006+3↑p
    LDA     #$A
    JSR     sub_A84E
    LDA     #$FC
    STA     $412D
    JSR     sub_A8BF
    JSR     sub_A8BF
    STA     $110
    LDA     #2
    STA     $4139
    LDA     #$71 ; 'q'
    STA     $4FF0
    LDA     #$DC
    STA     $412D
    LDA     #$F1
    JSR     sub_A84E
    LDA     #$FC
    STA     $412D
    JSR     sub_A8BF
    JSR     sub_A8BF
    STA     $111
    LDA     #2
    STA     $4139
    LDA     #$71 ; 'q'
    STA     $4FF0
    LDA     #$DC
    STA     $412D
    RTS
.endproc

;.global loc_A91C, loc_A947, loc_A997

.proc sub_A96A                               ; CODE XREF: sub_A006:loc_A038↑p
    LDA     #0
    JMP     loc_A997
.endproc

.proc sub_A965                               ; CODE XREF: sub_A006:loc_A067↑p
    LDA     #4
    JMP     loc_A997
.endproc

.proc sub_A974                               ; CODE XREF: sub_A006:loc_A171↑p
    LDA     #$D3
    JMP     loc_A997
.endproc

.proc sub_A979                               ; CODE XREF: sub_A006:loc_A1D3↑p
    LDA     #$D5
    JMP     loc_A997
.endproc

.proc sub_A910                               ; CODE XREF: sub_A006:loc_A23C↑p
    LDA     #0
    JMP     loc_A91C
.endproc

.proc sub_A915                               ; CODE XREF: sub_A006:loc_A1EC↑p
    LDA     #$67 ; 'g'
    JMP     loc_A91C
    LDA     #$F4
.endproc
loc_A91C:                               ; CODE XREF: sub_A910+2↑j
    JSR     sub_A84E
    LDA     #$FC
    STA     $412D
    JSR     sub_A8DC
    STX     $110
    STA     $111
    LDA     #2
    STA     $4139
    LDA     #$71 ; 'q'
    STA     $4FF0
    LDA     #$DC
    STA     $412D
    RTS

.proc sub_A96F                               ; CODE XREF: sub_A006:loc_A20D↑p
    LDA     #$C3
    JMP     loc_A997
.endproc

.proc sub_A93D                               ; CODE XREF: sub_A006+28D↑p
    LDA     #$CD
    JMP     loc_A947
.endproc

.proc sub_A942                               ; CODE XREF: sub_A006+35D↑p
    LDA     #$28 ; '('
    JMP     loc_A947
.endproc
loc_A947:                               ; CODE XREF: sub_A93D+2↑j
    JSR     sub_A84E
    LDA     #$FC
    STA     $412D
    JSR     sub_A8DC
    STA     $112
    LDA     #2
    STA     $4139
    LDA     #$71 ; 'q'
    STA     $4FF0
    LDA     #$DC
    STA     $412D
    RTS

.proc sub_A97E                               ; CODE XREF: sub_A006:loc_A469↑p
    LDA     #$B9
    JSR     sub_A84E
    LDA     #$FF
    JSR     sub_A884
    LDA     #$83
    JSR     sub_A884
    LDA     #$47 ; 'G'
    JSR     sub_A884
    LDA     #$D0
    JMP     loc_A997
.endproc
; ---------------------------------------------------------------------------
loc_A997:                            ; CODE XREF: sub_A965+2↑j
    JSR     sub_A84E
    LDA     #$FC
    STA     $412D
    JSR     sub_A8BF
    JSR     sub_A8BF
    STA     $110
    JSR     sub_A8BF
    STA     $111
    JSR     sub_A8BF
    STA     $112
    LDA     #2
    STA     $4139
    LDA     #$71 ; 'q'
    STA     $4FF0
    LDA     #$DC
    STA     $412D
    RTS

.proc sub_A6F6                               ; CODE XREF: sub_A006+6A9↑p
    LDY     #0
loc_A6F8:                               ; CODE XREF: sub_A6F6+1E↓j
    LDA     ($F8),Y
    CMP     #0
    BEQ     loc_A717
    JSR     sub_A84E
    INY
loc_A702:                               ; CODE XREF: sub_A6F6+1A↓j
    LDA     ($F8),Y
    CMP     #$FE
    BEQ     loc_A713
    CMP     #$FF
    BEQ     locret_A724
    JSR     sub_A884
    INY
    JMP     loc_A702
; ---------------------------------------------------------------------------
loc_A713:                               ; CODE XREF: sub_A6F6+10↑j
    INY
    JMP     loc_A6F8
; ---------------------------------------------------------------------------
loc_A717:                               ; CODE XREF: sub_A6F6+6↑j
    INY
    LDA     ($F8),Y
    TAX
loc_A71B:                               ; CODE XREF: sub_A6F6+29↓j
    JSR     sub_AA1C
    DEX
    BNE     loc_A71B
    JMP     loc_A713
; ---------------------------------------------------------------------------
locret_A724:                            ; CODE XREF: sub_A6F6+14↑j
    RTS
.endproc

.proc sub_A725                               ; CODE XREF: sub_A006:loc_A6B5↑p
    LDY     #0
loc_A727:                               ; CODE XREF: sub_A725+1B↓j
    LDA     ($F8),Y
    CMP     #$FF
    BEQ     loc_A743
    JSR     sub_A84E
    INY
    LDA     ($F8),Y
    STA     $4FF8
    INY
    LDA     ($F8),Y
    STA     $4FF7
    JSR     sub_A88C
    INY
    JMP     loc_A727
; ---------------------------------------------------------------------------
loc_A743:                               ; CODE XREF: sub_A725+6↑j
    INY
    LDA     ($F8),Y
    CMP     #$FF
    BEQ     loc_A752
    TAX
    JSR     sub_AA1C
    INY
    JMP     loc_A727
; ---------------------------------------------------------------------------
loc_A752:                               ; CODE XREF: sub_A725+23↑j
    LDA     #$22 ; '"'
    JSR     sub_A84E
    RTS
.endproc

.proc sub_A758                               ; CODE XREF: sub_A006:loc_A6BB↑p
    LDY     #0
loc_A75A:                               ; CODE XREF: sub_A758+12↓j
    LDA     ($F8),Y
    CMP     #$FF
    BEQ     loc_A76D
    JSR     sub_A84E
    INY
    LDA     ($F8),Y
    JSR     sub_A884
    INY
    JMP     loc_A75A
; ---------------------------------------------------------------------------
loc_A76D:                               ; CODE XREF: sub_A758+6↑j
    INY
    LDA     ($F8),Y
    CMP     #$FF
    BEQ     loc_A77C
    TAX
    JSR     sub_AA1C
    INY
    JMP     loc_A75A
; ---------------------------------------------------------------------------
loc_A77C:                               ; CODE XREF: sub_A758+1A↑j
    LDA     #$22 ; '"'
    JSR     sub_A84E
    RTS
.endproc

.proc sub_A782                               ; CODE XREF: sub_A006:loc_A6C1↑p
    LDY     #0
loc_A784:                               ; CODE XREF: sub_A782+1A↓j
    LDA     ($F8),Y
    CMP     #$FF
    BEQ     loc_A79F
    STA     $4FF8
    INY
    LDA     ($F8),Y
    STA     $4FF7
    JSR     sub_A856
    LDA     #$51 ; 'Q'
    STA     $4FF0
    INY
    JMP     loc_A784
; ---------------------------------------------------------------------------
loc_A79F:                               ; CODE XREF: sub_A782+6↑j
    INY
    LDA     ($F8),Y
    CMP     #$FF
    BEQ     locret_A7AE
    TAX
    JSR     sub_AA1C
    INY
    JMP     loc_A784
; ---------------------------------------------------------------------------
locret_A7AE:                            ; CODE XREF: sub_A782+22↑j
    RTS
.endproc

.proc sub_A806                               ; CODE XREF: sub_A006+6CF↑p
    LDA     #$BD
    STA     $4FF0
    LDA     #$FF
    STA     $4FF1
    LDA     #$52 ; 'R'
    STA     $4FF2
    LDA     #$58 ; 'X'
    STA     $4FF3
    LDA     #$98
    STA     $4FF4
    LDA     #$FD
    STA     $4FF5
    LDA     #$D
    STA     $4FFA
    RTS
.endproc

.proc sub_A7E2                               ; CODE XREF: sub_A006+6D9↑p
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
    LDA     #$FE
    STA     $4FF5
    LDA     #$E
    STA     $4FFA
    RTS
.endproc

.proc sub_AA09                               ; CODE XREF: sub_A7AF+19↑p
    TXA
    PHA
    TYA
    PHA
    LDX     #0
    LDY     #$40 ; '@'
loc_AA11:                               ; CODE XREF: sub_AA09+9↓j
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

.proc sub_AA1C                               ; CODE XREF: sub_A6F6:loc_A71B↑p
    TXA
    PHA
    TYA
    PHA
    LDX     #0
    LDY     #1
loc_AA24:                               ; CODE XREF: sub_AA1C+9↓j
    DEX
    BNE     loc_AA24
    DEY
    BNE     loc_AA24
    PLA
    TAY
    PLA
    TAX
    RTS
.endproc

.proc sub_A84E                               ; CODE XREF: sub_A6F6+8↑p
    STA     $4FF7
    LDA     #0
    STA     $4FF8
.endproc ; fall-throug to sub_A856

.proc sub_A856                               ; CODE XREF: sub_A782+11↑p
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

.proc sub_A884                               ; CODE XREF: sub_A6F6+16↑p
    STA     $4FF7
    LDA     #0
    STA     $4FF8
.endproc

.proc sub_A88C                               ; CODE XREF: sub_A725+17↑p
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

.proc sub_A8BF                               ; CODE XREF: sub_A97E+21↓p
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #2
    STA     $4139
    LDA     #2
    STA     $4139
    LDA     #0
    STA     $4139
    LDA     #0
    STA     $4139
    LDA     $4135
    RTS
.endproc

.proc sub_A8DC                               ; CODE XREF: sub_A915+F↓p
    LDA     #$31 ; '1'
    STA     $4FF0
    LDA     #2
    STA     $4139
    LDA     #2
    STA     $4139
    LDA     #0
    STA     $4139
    LDA     #0
    STA     $4139
    LDX     $4136
    LDA     #2
    STA     $4139
    LDA     #2
    STA     $4139
    LDA     #0
    STA     $4139
    LDA     #0
    STA     $4139
    LDA     $4135
    RTS
.endproc

