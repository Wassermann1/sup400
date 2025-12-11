	.include	"vt03.inc"
	
	
	.export		_InitPalette
	.export		_InitSystem
	.export		_ClearScreen
	.export		_Outputxy
	.export		_ReadJoystick1
	.export		_RunGame
	.export		_InitMenuSprite
	
	.import		popax,incsp2
	.import		_PaletteUpdate
	.import		_PatternUpdate
	.import		_WaitPatternUpdate
	.import		leave
	.import		enter
	.import		_GameIndex
	.importzp	Joy1_PressFlag
	.importzp	Joy1_Press
	.importzp	Joy1_Button,Joy2_Button
	
	.import		_JoyStick
	.importzp	NMICount
	.import		_MusicNMIProcess

	
.define	db	.byte
.define	dw	.addr
.macro	dd 	no       
	.byte	$3E				;to $4107,$410A
	.byte	$00 				;to $4100
	.addr	((.LOWORD(no) & $1FFF) + $8000) 		; µº µÿ÷∑
.endmacro

NMIScreenBuffer	=	$0300

SpriteBuffer = $200
SpriteBuff = $200
SpritePtr = $106
SpriteStack = $107
.code	
.export _InitSprite	
_InitSprite:
	lda	#$FE
	ldx	#$00
@0:
	sta	SpriteBuffer,x
	inx
	bne	@0
	lda	#$00
	sta	SpritePtr
	sta	SpriteStack
	rts
.export	_SpriteUpdate
_SpriteUpdate:
	lda	#%10000000
	ora	NMIControl
	sta	NMIControl
	rts

.import	Music_Flag2
.export	_MusicLoop
.proc	_MusicLoop
	ldx	#$00	
	lda	Music_Flag2-1
	rts
.endproc

.export _InitLCD
.proc	_InitLCD
		LDA	#$00
		STA	NMIControl
;==============================================================================
; TD025THEA3 - NTSC of VT09
p_EnableLCD:
		lda	#$01
		sta	$412C
		lda	#$06
		sta	$4118
		lda	#$13
		sta	$4121
		lda	#$97
		sta	$4123
		lda	#$01
		sta	$412A
		lda	#$AB
		sta	$4120
		lda	#$01
		sta	$412B
		lda	#$00
		sta	$4116
;
		ldy	#$00
@r:		lda	#$00
		sta	$412c
		lda	LCD_DATA,y
		cmp	#$ff
		beq	@e
		jsr	lcdport
		iny
		lda	LCD_DATA,y
		jsr	lcdport
		lda	#$01
		sta	$412c
		iny
		bne	@r
@e:		rts
LCD_DATA:
		.byte	$05,$57,$08,$06,$40,$2f,$44,$3f,$50,$78,$54,$22,$58,$01,$5c,$00,$60,$08,$FF,$FF
;------------------------------------------------------------------------------
lcdport:		
		sta	$4113
		asl
		sta	$4112
		asl
		sta	$4112
		asl
		sta	$4112
		asl
		sta	$4112
		asl
		sta	$4112
		asl
		sta	$4112
		asl
		sta	$4112
		asl
		sta	$4112
		rts
;==============================================================================
.endproc

;
;.proc	_InitLCD
;	
;	LDA	#$00
;	STA	NMIControl
;
;	LDA     #$01
;	STA     $412C
;	LDA     #$06
;	STA     $4118
;	LDA     #$13
;	STA     $4121
;	LDA     #$97
;	STA     $4123
;	LDA     #$01
;	STA     $412A
;	LDA     #$AB
;	STA     $4120
;	LDA     #$01
;	STA     $412B
;	LDA     #$00
;	STA     $4116
;	JSR     LCDON  
;	rts
;;	
;LCDON:                                ;
;           LDA     #$00              ;
;           STA     $412C             ;
;           LDA     #$05              ;
;           JSR     SPI8H
;           LDA     #$57              ;
;           JSR     SPI8H
;           LDA     #$01              ;
;           STA     $412C             ;
;           LDA     #$00              ;
;           STA     $412C             ;
;           LDA     #$08              ;
;           JSR     SPI8H
;           LDA     #$06              ;
;           JSR     SPI8H
;           LDA     #$01              ;
;           STA     $412C             ;
;           RTS                       ;
;SPI8H:
;           STA     $4113             ;
;           ASL                  ;
;SPI8B:
;           STA     $4112         ;
;           ASL                 ;
;           STA     $4112         ;
;           ASL                 ;
;           STA     $4112         ;
;           ASL                ;
;           STA     $4112         ;
;           ASL                 ;
;           STA     $4112         ;
;           ASL                ;
;           STA     $4112         ;
;           ASL                ;
;           STA     $4112         ;
;           ASL                ;
;           STA     $4112         ;
;           RTS
;.endproc           	

.proc	_InitSystem
	sei
	lda	#$00
	sta	DMASourceAddressL
	sta	IRQTimer1
	sta	IRQTimer2
	sta	IRQTimerClose
	tax
@0:
	sta	NMIScreenIndex,x
	inx
	cpx	#$10
	bcc	@0
	lda	#$00
	sta	ScreenPositionX
	sta	ScreenPositionY
	sta	NMIControl
	lda	#%00000000		
	sta	SystemControlTemp
	lda	#%00000110
	sta	VideoControlTemp
	lda	#$00
	sta	$2010	
	ldx	#$E8		;DC		;$7B000
	stx	$2012
	stx	$2016
	inx
	stx	$2013
	inx
	stx	$2014
	stx	$2017	
	inx
	stx	$2015
	ldx	#%00010000
	stx	$2018
	lda	#$00
	sta	$201A
	lda	#$00
	sta	$4100
	lda	#$3C
	sta	$4107
	lda	#$3D
	sta	$4108
	
	lda	#$01
	sta	$4106
	lda	#$00
	sta	SystemControlTemp
	rts	
.endproc

     
.proc	_InitPalette
	ldx	#$00
	ldy	#$00
@0:	lda	MENU_PNT_palette,x
	sta	PaletteBuffer,y
	sta	PaletteBuffer+$10,y   
	inx
	iny
	cpx	#$04
	bcc	@0
	ldx	#$10
@1:	lda	MENU_PNT_palette,x
	sta	PaletteBuffer,y
	sta	PaletteBuffer+$10,y    
	inx
	iny
	cpx	#$14
	bcc	@1
	ldx	#$20
@2:	lda	MENU_PNT_palette,x
	sta	PaletteBuffer,y
	sta	PaletteBuffer+$10,y    
	inx
	iny
	cpx	#$24
	bcc	@2
	ldx	#$30
@3:	lda	MENU_PNT_palette,x
	sta	PaletteBuffer,y
	sta	PaletteBuffer+$10,y    
	inx
	iny
	cpx	#$34
	bcc	@3
	
	lda	#$16
	sta	PaletteBuffer+$13
	
	jmp	_PaletteUpdate

.endproc

.proc	_InitMenuSprite
	ldx	#$00
@0:	
	lda	SpriteData,x
	sta	$0200,x
	inx
	cpx	#$04
	bcc	@0
	lda	#$FE
@1:	
	sta	$0200,x
	inx
	bne	@1
	lda	#%10000000
	ora	NMIControl
	sta	NMIControl
	lda	#%00010000
	ora	VideoControlTemp
	sta	VideoControlTemp
	rts

SpriteData:
	.byte	$38,$03,$40,$20
.endproc

.export _InitSystemTestSprite
.proc	_InitSystemTestSprite
	ldx	#$00
@0:	
	lda	SpriteData,x
	sta	$0200,x
	inx
	cpx	#32
	bcc	@0
	lda	#$FE
@1:	
	sta	$0200,x
	inx
	bne	@1
	lda	#%10000000
	ora	NMIControl
	sta	NMIControl
	lda	#%00010000
	ora	VideoControlTemp
	sta	VideoControlTemp
	rts
SpriteData:
	.byte	$80,$55,$00,$40		;UP
	.byte	$A0,$44,$00,$40		;DOWN
	.byte	$90,$4C,$00,$30		;LEFT
	.byte	$90,$52,$00,$50		;RIGHT
	.byte	$90,$53,$00,$70		;SELECT
	.byte	$90,$53,$00,$90		;START
	.byte	$90,$41,$00,$B0		;A
	.byte	$90,$42,$00,$D0		;B
.endproc

.proc	_ClearScreen
	lda	#$20
	sta	$2006
	lda	#$00
	sta	$2006
	ldy	#$04	
	lda	#$00
@0:
	sta	$2007
	inx
	bne	@0
	dey
	bne	@0
	rts
.endproc

.proc	_Outputxy
	sta	addr0
	stx	addr0+1
	jsr	incsp2	
	jsr	popax
	sta	Temp0		;y point
	jsr	popax
	sta	Temp1		;x point
	clc
	adc	#<MENU_PNT_pnt0	;//ScreenLine	
	sta	addr1
	lda	#$00
	adc	#>MENU_PNT_pnt0	;//ScreenLine
	sta	addr1+1
	ldx	Temp0
@B:	clc
	lda	#$20
	adc	addr1
	sta	addr1
	lda	#$00
	adc	addr1+1
	sta	addr1+1
	dex	
	bne	@B
	
@a:	
	jsr	SearchBuffer
	sty	Temp2
	tya
	lsr
	tax
	lda	BufferIndex,x
	tax
	
	ldy	#$00
@0:
	lda	(addr0),y
	beq	@1
	cmp	#$20
	bne	@C
	lda	(addr1),y	
@C:
	sta	NMIScreenBuffer,x	
	iny
	inx
	cpy	#$10
	bcc	@0
	ldy	Temp2	
	clc
	ldx	Temp0
	lda	ppuaddrindex_l,x	
	adc	Temp1
	sta	NMIScreenIndex-1,y
	lda	ppuaddrindex_h,x
	sta	NMIScreenIndex,y
	clc
	lda	addr0
	adc	#$10
	sta	addr0
	lda	addr0+1
	adc	#$00
	sta	addr0+1
;================
	clc
	lda	addr1
	adc	#$10
	sta	addr1
	lda	addr1+1
	adc	#$00
	sta	addr1+1
;================	
	clc
	lda	Temp1
	adc	#$10
	sta	Temp1
	cmp	#$20
	bcc	@a
	and	#$1F
	sta	Temp1	
	inc	Temp0
	jmp	@a		
@1:	
	;lda	#$00
@2:	
	lda	(addr1),y
	sta	NMIScreenBuffer,x
	inx
	iny
	cpy	#$10
	bcc	@2	
	ldy	Temp2	
	clc
	ldx	Temp0
	lda	ppuaddrindex_l,x	
	adc	Temp1
	sta	NMIScreenIndex-1,y
	lda	ppuaddrindex_h,x
	sta	NMIScreenIndex,y
	rts

BufferIndex:
	.byte	$00,$10,$20,$30,$40,$50,$60,$70
ppuaddrindex_l:	
	.byte	$00,$20,$40,$60,$80,$A0,$C0,$E0	
	.byte	$00,$20,$40,$60,$80,$A0,$C0,$E0	
	.byte	$00,$20,$40,$60,$80,$A0,$C0,$E0	
	.byte	$00,$20,$40,$60,$80,$A0
ppuaddrindex_h:
	.byte	$20,$20,$20,$20,$20,$20,$20,$20
	.byte	$21,$21,$21,$21,$21,$21,$21,$21
	.byte	$22,$22,$22,$22,$22,$22,$22,$22
	.byte	$23,$23,$23,$23,$23,$23	
SearchBuffer:
@0:
	ldy	#$01
@1:	
	lda	NMIScreenIndex,y
	beq	@2
	iny
	iny
	cpy	#$10
	bcc	@1
	bcs	@0
@2:	
	rts
.endproc

_ReadJoystick1:
	ldx	Joy1_Press
	beq	@0
	txa							; clear press flag
	ora	Joy1_PressFlag
	sta	Joy1_PressFlag
	lda	#$00
	sta	Joy1_Press
	txa
	ldx	#$00
	rts
@0:	lda	#$00
	rts
;	
.export _ReadJoystick2 
_ReadJoystick2                                            :
	lda	Joy1_Button
	ldx	#$00
	rts
;
.import	_RunGameSub

.proc	_RunGame	
	ldx	#$FF
	txs
	ldx	#$00
@0:	lda	Data,x
	sta	$01BC,x
	inx
	cpx	#(DataEnd-Data)
	bcc	@0
	jsr	popax
	sta	GetGameData+1
	stx	GetGameData+2
	jsr	popax
	sta	RunGameA+1
	stx	RunGameX+1	
	ldx	#$06
	jsr	GetGameData
	sta	RunGameSub+1
	ldx	#$07
	jsr	GetGameData
	sta	RunGameSub+2	
	lda	#$C0
	sta	$4017
@1:	lda	$2002
	bpl	@1
@2:	lda	$2002
	bpl	@2	
	sei
	ldx	#$00
	stx	$2000
	stx	$2001	
	ldx	#$00
	jsr	GetGameData
	sta	Set4106+1
	inx
	jsr	GetGameData
	sta	Set4100+1
	inx
	jsr	GetGameData
	sta	Set410A+1
	inx
	jsr	GetGameData
	sta	Set410B+1
	inx
	jsr	GetGameData
	sta	Set201A+1
	inx
	jsr	GetGameData
	sta	Set2018+1
	lda	#$00
	ldx	#$00
@3:	sta	$00,x
	sta	$200,x
	sta	$300,x
	sta	$400,x
	sta	$500,x
	sta	$600,x
	sta	$700,x
	inx
	bne	@3
@4:	sta	$100,x
	inx
	cpx	#$C0
	bcc	@4
	
	ldx	#$00
	stx	$2016
	inx
	inx
	stx	$2017
	inx
	inx
	stx	$2012
	inx
	stx	$2013
	inx
	stx	$2014
	inx
	stx	$2015
	ldx	#$C0
	stx	$4017
	ldx	#$FF
	txs
	jmp	RunGameA
Data:	
	.org	$01BC
GetGameData:
	lda	$0200,x
	rts
RunGameA:	
	lda	#$00
RunGameX:	
	ldx	#$00
RunGameSub:	
	jsr	$0000		
Set2018:
	ldx	#$00
	stx	$2018
Set201A:
	ldx	#$00	
	stx	$201A	
Set4106:
	ldx	#$00	
	stx	$4106
Set410A:	
	ldx	#$00
	stx	$410A
Set4100:
	ldx	#$00
	stx	$4100
Set410B:	
	ldx	#$00
	stx	$410B	
	ldx	#$00
	stx	$4107
	inx
	stx	$4108
	jmp	($FFFC)	
	.RELOC
DataEnd:
.endproc
	
	
.segment       	"STARTUP"
; ------------------------------------------------------------------------
; System V-Blank Interupt
; ------------------------------------------------------------------------
.export _UserNMI
_UserNMI:
	jsr	_MusicNMIProcess
	jsr	_JoyStick
	rts
.export	_nmi	
.proc	_nmi
	pha
        tya
        pha
        txa
        pha
	lda	NMIControl
	bpl	@a
  	lda	#$00
	sta	SpriteStartAddress
	
	lda	#$02
	sta	DMASourceAddressH	    
@a:
	lda	NMIControl 
	and	#%00100000
	beq	@b
	jsr	NMIPalette
@b:	
	jsr	NMIScreen
	lda	#$80
	and	NMIControl 
	sta	NMIControl
	lda	SystemControlTemp
	sta	SystemControl
	lda	VideoControlTemp
	sta	VideoControl
	lda	ScreenPositionX
	sta	ScreenPosition
	lda	ScreenPositionY
	sta	ScreenPosition		
;	
	inc	NMICount
	jsr	_MusicNMIProcess
	jsr	_JoyStick
	pla
	tax
	pla
	tay
	pla
        rti
.endproc

.proc	NMIScreen
	lda	NMIScreenIndex+$01
	beq	@a
	sta	VRAMAddress
	lda	NMIScreenIndex+$00
	sta	VRAMAddress
	lda	NMIScreenBuffer+$00
	sta	VRAMData
	lda	NMIScreenBuffer+$01
	sta	VRAMData
	lda	NMIScreenBuffer+$02
	sta	VRAMData
	lda	NMIScreenBuffer+$03
	sta	VRAMData
	lda	NMIScreenBuffer+$04
	sta	VRAMData
	lda	NMIScreenBuffer+$05
	sta	VRAMData
	lda	NMIScreenBuffer+$06
	sta	VRAMData
	lda	NMIScreenBuffer+$07
	sta	VRAMData
	lda	NMIScreenBuffer+$08
	sta	VRAMData
	lda	NMIScreenBuffer+$09
	sta	VRAMData
	lda	NMIScreenBuffer+$0A
	sta	VRAMData
	lda	NMIScreenBuffer+$0B
	sta	VRAMData
	lda	NMIScreenBuffer+$0C
	sta	VRAMData
	lda	NMIScreenBuffer+$0D
	sta	VRAMData
	lda	NMIScreenBuffer+$0E
	sta	VRAMData
	lda	NMIScreenBuffer+$0F
	sta	VRAMData
	lda	#$00
	sta	NMIScreenIndex+$01
@a:
	lda	NMIScreenIndex+$03
	beq	@b
	sta	VRAMAddress
	lda	NMIScreenIndex+$02
	sta	VRAMAddress
	lda	NMIScreenBuffer+$10
	sta	VRAMData
	lda	NMIScreenBuffer+$11
	sta	VRAMData
	lda	NMIScreenBuffer+$12
	sta	VRAMData
	lda	NMIScreenBuffer+$13
	sta	VRAMData
	lda	NMIScreenBuffer+$14
	sta	VRAMData
	lda	NMIScreenBuffer+$15
	sta	VRAMData
	lda	NMIScreenBuffer+$16
	sta	VRAMData
	lda	NMIScreenBuffer+$17
	sta	VRAMData
	lda	NMIScreenBuffer+$18
	sta	VRAMData
	lda	NMIScreenBuffer+$19
	sta	VRAMData
	lda	NMIScreenBuffer+$1A
	sta	VRAMData
	lda	NMIScreenBuffer+$1B
	sta	VRAMData
	lda	NMIScreenBuffer+$1C
	sta	VRAMData
	lda	NMIScreenBuffer+$1D
	sta	VRAMData
	lda	NMIScreenBuffer+$1E
	sta	VRAMData
	lda	NMIScreenBuffer+$1F
	sta	VRAMData	
	lda	#$00
	sta	NMIScreenIndex+$03
@b:
	lda	NMIScreenIndex+$05
	beq	@c
	sta	VRAMAddress
	lda	NMIScreenIndex+$04
	sta	VRAMAddress
	lda	NMIScreenBuffer+$20
	sta	VRAMData
	lda	NMIScreenBuffer+$21
	sta	VRAMData
	lda	NMIScreenBuffer+$22
	sta	VRAMData
	lda	NMIScreenBuffer+$23
	sta	VRAMData
	lda	NMIScreenBuffer+$24
	sta	VRAMData
	lda	NMIScreenBuffer+$25
	sta	VRAMData
	lda	NMIScreenBuffer+$26
	sta	VRAMData
	lda	NMIScreenBuffer+$27
	sta	VRAMData
	lda	NMIScreenBuffer+$28
	sta	VRAMData
	lda	NMIScreenBuffer+$29
	sta	VRAMData
	lda	NMIScreenBuffer+$2A
	sta	VRAMData
	lda	NMIScreenBuffer+$2B
	sta	VRAMData
	lda	NMIScreenBuffer+$2C
	sta	VRAMData
	lda	NMIScreenBuffer+$2D
	sta	VRAMData
	lda	NMIScreenBuffer+$2E
	sta	VRAMData
	lda	NMIScreenBuffer+$2F
	sta	VRAMData	
	lda	#$00
	sta	NMIScreenIndex+$05
@c:
	lda	NMIScreenIndex+$07
	beq	@d
	sta	VRAMAddress
	lda	NMIScreenIndex+$06
	sta	VRAMAddress
	lda	NMIScreenBuffer+$30
	sta	VRAMData
	lda	NMIScreenBuffer+$31
	sta	VRAMData
	lda	NMIScreenBuffer+$32
	sta	VRAMData
	lda	NMIScreenBuffer+$33
	sta	VRAMData
	lda	NMIScreenBuffer+$34
	sta	VRAMData
	lda	NMIScreenBuffer+$35
	sta	VRAMData
	lda	NMIScreenBuffer+$36
	sta	VRAMData
	lda	NMIScreenBuffer+$37
	sta	VRAMData
	lda	NMIScreenBuffer+$38
	sta	VRAMData
	lda	NMIScreenBuffer+$39
	sta	VRAMData
	lda	NMIScreenBuffer+$3A
	sta	VRAMData
	lda	NMIScreenBuffer+$3B
	sta	VRAMData
	lda	NMIScreenBuffer+$3C
	sta	VRAMData
	lda	NMIScreenBuffer+$3D
	sta	VRAMData
	lda	NMIScreenBuffer+$3E
	sta	VRAMData
	lda	NMIScreenBuffer+$3F
	sta	VRAMData
	lda	#$00
	sta	NMIScreenIndex+$07
@d:
	lda	NMIScreenIndex+$09
	beq	@e
	sta	VRAMAddress
	lda	NMIScreenIndex+$08
	sta	VRAMAddress
	lda	NMIScreenBuffer+$40
	sta	VRAMData
	lda	NMIScreenBuffer+$41
	sta	VRAMData
	lda	NMIScreenBuffer+$42
	sta	VRAMData
	lda	NMIScreenBuffer+$43
	sta	VRAMData
	lda	NMIScreenBuffer+$44
	sta	VRAMData
	lda	NMIScreenBuffer+$45
	sta	VRAMData
	lda	NMIScreenBuffer+$46
	sta	VRAMData
	lda	NMIScreenBuffer+$47
	sta	VRAMData
	lda	NMIScreenBuffer+$48
	sta	VRAMData
	lda	NMIScreenBuffer+$49
	sta	VRAMData
	lda	NMIScreenBuffer+$4A
	sta	VRAMData
	lda	NMIScreenBuffer+$4B
	sta	VRAMData
	lda	NMIScreenBuffer+$4C
	sta	VRAMData
	lda	NMIScreenBuffer+$4D
	sta	VRAMData
	lda	NMIScreenBuffer+$4E
	sta	VRAMData
	lda	NMIScreenBuffer+$4F
	sta	VRAMData
	lda	#$00
	sta	NMIScreenIndex+$09
@e:
	lda	NMIScreenIndex+$0B
	beq	@f
	sta	VRAMAddress
	lda	NMIScreenIndex+$0A
	sta	VRAMAddress
	lda	NMIScreenBuffer+$50
	sta	VRAMData
	lda	NMIScreenBuffer+$51
	sta	VRAMData
	lda	NMIScreenBuffer+$52
	sta	VRAMData
	lda	NMIScreenBuffer+$53
	sta	VRAMData
	lda	NMIScreenBuffer+$54
	sta	VRAMData
	lda	NMIScreenBuffer+$55
	sta	VRAMData
	lda	NMIScreenBuffer+$56
	sta	VRAMData
	lda	NMIScreenBuffer+$57
	sta	VRAMData
	lda	NMIScreenBuffer+$58
	sta	VRAMData
	lda	NMIScreenBuffer+$59
	sta	VRAMData
	lda	NMIScreenBuffer+$5A
	sta	VRAMData
	lda	NMIScreenBuffer+$5B
	sta	VRAMData
	lda	NMIScreenBuffer+$5C
	sta	VRAMData
	lda	NMIScreenBuffer+$5D
	sta	VRAMData
	lda	NMIScreenBuffer+$5E
	sta	VRAMData
	lda	NMIScreenBuffer+$5F
	sta	VRAMData
	lda	#$00
	sta	NMIScreenIndex+$0B
@f:
	lda	NMIScreenIndex+$0D
	beq	@g
	sta	VRAMAddress
	lda	NMIScreenIndex+$0C
	sta	VRAMAddress
	lda	NMIScreenBuffer+$60
	sta	VRAMData
	lda	NMIScreenBuffer+$61
	sta	VRAMData
	lda	NMIScreenBuffer+$62
	sta	VRAMData
	lda	NMIScreenBuffer+$63
	sta	VRAMData
	lda	NMIScreenBuffer+$64
	sta	VRAMData
	lda	NMIScreenBuffer+$65
	sta	VRAMData
	lda	NMIScreenBuffer+$66
	sta	VRAMData
	lda	NMIScreenBuffer+$67
	sta	VRAMData
	lda	NMIScreenBuffer+$68
	sta	VRAMData
	lda	NMIScreenBuffer+$69
	sta	VRAMData
	lda	NMIScreenBuffer+$6A
	sta	VRAMData
	lda	NMIScreenBuffer+$6B
	sta	VRAMData
	lda	NMIScreenBuffer+$6C
	sta	VRAMData
	lda	NMIScreenBuffer+$6D
	sta	VRAMData
	lda	NMIScreenBuffer+$6E
	sta	VRAMData
	lda	NMIScreenBuffer+$6F
	sta	VRAMData
	lda	#$00
	sta	NMIScreenIndex+$0D
@g:
	lda	NMIScreenIndex+$0F
	beq	@h
	sta	VRAMAddress
	lda	NMIScreenIndex+$0E
	sta	VRAMAddress
	lda	NMIScreenBuffer+$70
	sta	VRAMData
	lda	NMIScreenBuffer+$71
	sta	VRAMData
	lda	NMIScreenBuffer+$72
	sta	VRAMData
	lda	NMIScreenBuffer+$73
	sta	VRAMData
	lda	NMIScreenBuffer+$74
	sta	VRAMData
	lda	NMIScreenBuffer+$75
	sta	VRAMData
	lda	NMIScreenBuffer+$76
	sta	VRAMData
	lda	NMIScreenBuffer+$77
	sta	VRAMData
	lda	NMIScreenBuffer+$78
	sta	VRAMData
	lda	NMIScreenBuffer+$79
	sta	VRAMData
	lda	NMIScreenBuffer+$7A
	sta	VRAMData
	lda	NMIScreenBuffer+$7B
	sta	VRAMData
	lda	NMIScreenBuffer+$7C
	sta	VRAMData
	lda	NMIScreenBuffer+$7D
	sta	VRAMData
	lda	NMIScreenBuffer+$7E
	sta	VRAMData
	lda	NMIScreenBuffer+$7F
	sta	VRAMData
	lda	#$00
	sta	NMIScreenIndex+$0F
@h:	
	rts
.endproc
	
.proc	NMIPalette
	ldx	#$00
	lda	#$3F
	sta	VRAMAddress
	lda	#$00
	sta	VRAMAddress
	lda	PaletteBuffer+$00
	sta	VRAMData
	lda	PaletteBuffer+$01
	sta	VRAMData
	lda	PaletteBuffer+$02
	sta	VRAMData
	lda	PaletteBuffer+$03
	sta	VRAMData
	lda	PaletteBuffer+$04
	sta	VRAMData
	lda	PaletteBuffer+$05
	sta	VRAMData
	lda	PaletteBuffer+$06
	sta	VRAMData
	lda	PaletteBuffer+$07
	sta	VRAMData
	lda	PaletteBuffer+$08
	sta	VRAMData
	lda	PaletteBuffer+$09
	sta	VRAMData
	lda	PaletteBuffer+$0a
	sta	VRAMData
	lda	PaletteBuffer+$0b
	sta	VRAMData
	lda	PaletteBuffer+$0c
	sta	VRAMData
	lda	PaletteBuffer+$0d
	sta	VRAMData
	lda	PaletteBuffer+$0e
	sta	VRAMData
	lda	PaletteBuffer+$0f
	sta	VRAMData
	lda	PaletteBuffer+$10
	sta	VRAMData
	lda	PaletteBuffer+$11
	sta	VRAMData
	lda	PaletteBuffer+$12
	sta	VRAMData
	lda	PaletteBuffer+$13
	sta	VRAMData
	lda	PaletteBuffer+$14
	sta	VRAMData
	lda	PaletteBuffer+$15
	sta	VRAMData
	lda	PaletteBuffer+$16
	sta	VRAMData
	lda	PaletteBuffer+$17
	sta	VRAMData
	lda	PaletteBuffer+$18
	sta	VRAMData
	lda	PaletteBuffer+$19
	sta	VRAMData
	lda	PaletteBuffer+$1a
	sta	VRAMData
	lda	PaletteBuffer+$1b
	sta	VRAMData
	lda	PaletteBuffer+$1c
	sta	VRAMData
	lda	PaletteBuffer+$1d
	sta	VRAMData
	lda	PaletteBuffer+$1e
	sta	VRAMData
	lda	PaletteBuffer+$1f
	sta	VRAMData
	rts	
.endproc

.export _irq0
_irq0:
	rts
.export	_irq	
.proc	_irq
	pha
	lda	#$00
	sta	IRQTimer1
	sta	IRQTimer2
	sta	IRQTimerClose
	pla
	rti
.endproc
	
.RODATA
.export	_PICTable
_PICTable:
	dd	PIC_MENU		;00
	dd	PIC_MENU		;01
	dd	PIC_MENU		;02
	dd	PIC_MENU		;03
			
PIC_MENU:
	db	vPNT
	dd	MENU_PNT_pnt0
	dw	$2000,$0400
	db	vEND

.align	$100
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db	$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF


.include "image\Menu_pnt.asm"
	
VROMBank	=	$10
;============================================================
.segment	"DEFINE"
ASCPGT:			
.include	"char2.inc"
.incbin	"image\Menu_pgt.bin",$600,$A00
.export	_GamesDefine
.include	"gamedef.inc"
.code
.include	"midi02.inc"	
.zeropage
NMIScreenIndex:	.res   	16