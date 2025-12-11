SystemControl		=	$2000		; VT03 System Control Register :
						;	D0, D1 : Page selection of background graphics for
						;		   screen, Thease two bits set display pages.
						;			0 0 - Page 0 (Up and Left side page).
						;			0 1 - Page 1 (Up and Right side page).
						;			1 0 - Page 2 (Low and Left side page).
						;			1 1 - Page 3 (Low and Right side page).
						;
						;	D2 : Increment amount of address counter during
						;	        Read or Write data into VRAM, this function
						;	        refer to port $2006 and $2007 register.
						;		D2 = 0, VRAM increment by 1 byte for
						;			 horizontal sequence;
						;		D2 = 1, VRAM increment by 32 bytes for
						;			 vertical sequence;
						;
						;	D3 : A12 of VRAM page select for sprite pattern.
						;
						;	D4 : A12 of VRAM page select for background
						;	        graphic pattern.
						;
						;	D5 : Pattern size select sprite.
						;	 	D5 = 0, 8 X 8 pixels for each pattern;
						;		D5 = 1, 8 X 16 pixels for each pattern;
						;
						;	D6 : Reseved bit.
						;
						;	D7 : NMI request control register.
						;		D7 = 0, Disable the NMI requeset during
						;			 Vertical Blank;
						;		D7 = 1, Enable the NMI request during
						;			 Vertical Blank;
VideoControl		=	$2001		; Video ouput function control register :
						;	D0 : Video output control.
						;		D0 = 0, Color output mode;
						;		D0 = 1, Black and White output mode;
						;
						;	D1 : Horizontal resulotion control for background.
						;		D1 = 0, Horizontal resulotion is 248, the
						;			 range start from X=8 to X=255;
						;		D1 = 1, Horizontal resulotion is 256, the
						;			 range start from X=0 to X=255;
						;
						;	D2 : Sprite display range control.
						;		D2 = 0, ?
						;		D2 = 1, No range limited;
						;
						;	D3 : Background graphic display control.
						;		D3 = 0, Disable background display;
						;		D3 = 1, Enable background display;
						;
						;	D4 : Sprite display control.
						;		D4 = 0, Disable sprite display;
						;		D4 = 1, Enable sprite display;
						;
						;	D5 : Blue color output control.
						;		D5 = 0, Blue color enhance output;
						;		D5 = 1, Blue color normal output;
						;
						;	D6 : Green color output control.
						;		D6 = 0, Blue color enhance output;
						;		D6 = 1, Blue color normal output;
						;
						;	D7 : Red color output control.
						;		D7 = 0, Blue color enhance output;
						;		D7 = 1, Blue color normal output;
						;

PPUStatus		=	$2002		; PPU status register :
						;	D0~D4 : Reseved bits;
						;	D5 : Over 8  sprites on same horizontal line flag.
						;		D5 = 0, Not over 8 sprites on any line;
						;		D5 = 1, Over 8 sprites on same line;
						;
						;	D6 : Pattern 1 of sprite collides with background
						;	        pattern.
						;		D6 = 0, No collides happen;
						;		D6 = 1, Sprite pattern collides with
						;			 background pattern;
						;
						;	D7 : NMI flag.
						;		D7 = 0, PPU Not during Vertical balnk;
						;		D7 = 1, PPU just during Vertical blank;
						;
						
SpriteStartAddress	=	$2003		; Preset Sprite data start adress for Sprite data string, because
						; total 256 bytes memory on the VRAM as sprite buffer, who is
						; used for store total 64 sprites data, and user can change the
						; start address before transfer sprite data into Sprite buffer by
						; SpriteDMA, change start address of sprite buffer will cause
						; the sprite priority change during displaying.

SpriteDataPort		=	$2004		; Entry port for transfer sprite data into Sprite Buffer in VRAM,
						; this port function as  a interface port between CPU and sprite
						; buffer. To use this port must transfer 4 bytes data as a group
						; by sequency store command or Sprite DMA, The 4 bytes
						; data spec as follow:
						;	Byte 0 : Vertical position for Sprite;
						;	Byte 1 : PGT index number;
						;	Byte 2 : Sprite Control parameter
						;			D7 - Vertical mirror control bit;
						;			D6 - Horizontal mirror control bit;
						;			D5 - Priority Control bit;
						;			D4, D3, D2 - Unused bits;
						;			D1, D0 - Color pallete number;
						;	Byte 4 : Horizontal position for Sprite;

ScreenPosition		=	$2005		; Display origin point setup register.
						; This register is used for setting the display area of
						; background graphics. The software must write 2
						; bytes data into this register for setup the X, Y position,
						; first byte for X position then second byte for Y.
						
VRAMAddress		=	$2006		; VRAM start address setup register.
						; This register is used for setting the start address of VRAM
						; or background pattern ROM. This register need 2 bytes
						; data for a complete address(16 bits), first byte data set to
						; 'GA15~GA8', then second byte set to 'GA7~GA0'.

VRAMData		=	$2007		; VRAM data read or write register.
						; The CPU read or write data to VRAM must though
						; this register. After setup the VRAM address from $2006h,
						; the CPU can read or write into VRAM from $2007. After
						; each read or write action, the VRAM address counter will
						; increase by 1 or 32 automaticlly(refer to $2000h).
						; Note : Each time try to read the VRAM data after set
						;	 address into $2006h or after write data into $2007,
						;	 the first read action will turn mode of $2007 to read
						;	 mode, so the first read action will be inhibited, then
						;	 second read action will get first VRAM data which
						;	 are you want and other read action will be normal.
												
VideoModeControl0	=	$2010		;Setup system video mode
						;	D0,Sprite 16 colors or 16 pixs
						;	d0 = 0,Sprite select 16 colors mode
						;	d0 = 1,Sprite select 16 pixs mode
						;	D1,Backgroud 4 colors or 16 colors mode
						;	d1 = 0,Backgroud is 4 colors mode
						;	d1 = 1,Backgroud is 16 colors mode

VideoModeControl1	=	$2011		;Setup system video mode

VROMBankM		=	$2018
VROMBank0		=	$2012
VROMBank1		=	$2013
VROMBank2		=	$2014
VROMBank3		=	$2015
VROMBank4		=	$2016
VROMBank5		=	$2017

PSGControlAddress	=	$4000
PSGDPCMControl		=	$4010
PSGDPCMVolume		=	$4011
PSGDPCMAddress		=	$4012
PSGDPCMLength		=	$4013
DMASourceAddressH	=	$4014
PSGIRQStatus		=	$4015
PCMDataPort		=	$4027
DMASourceAddressL	=	$4034	

IRQTimer1		=	$4101
IRQTimer2		=	$4102
IRQTimerClose		=	$4103	
IRQTimerOpen		=	$4104	

ProgramBank0		=	$4107
ProgramBank1		=	$4108
ProgramBank2		=	$4109

TVSystem		=	$4119			


;SpriteBuffer		=	$0200		;Sprite Buffer size $100
PaletteBuffer		=	$0300
;-------------------------------------------------------------------------------
; Music Macro define
nC			=	0	; 1
nCb			=	1	; 1#
nD			=	2	; 2
nDb			=	3	; 2#
nE			=	4	; 3
nF			=	5	; 4
nFb			=	6	; 4#
nG			=	7	; 5
nGb			=	8	; 5#
nA			=	9	; 6
nAb			=	10	; 6#
nB			=	11	; 7
;-------------------------------------------------------------------------------
; MPBI = Music Play Buffer Index
;
MPBI_SQUARE1		=	0*6
MPBI_SQUARE2		=	1*6
MPBI_TRIANGLE		=	2*6
MPBI_NOISE		=	3*6
MPBI_DPCM		=	4*6
;...........................................................
; MPCC = Music Play Control Code
;
MPCC_Wait		=	$00
MPCC_Timbre		=	$80
MPCC_Volume		=	$90
MPCC_Inside		=	$A0
MPCC_Loop		=	$B0
MPCC_ToneSet		=	$C0

; $D0 --> $E0 free

MPCC_FlagSet		=	$F0+$00
MPCC_FlagInc		=	$F0+$01
MPCC_FlagDec		=	$F0+$02
MPCC_FlagBne		=	$F0+$03
MPCC_FlagBeq		=	$F0+$04
MPCC_FlagBneCall	=	$F0+$05
MPCC_FlagBeqCall	=	$F0+$06
MPCC_SpeedSet		=	$F0+$07
MPCC_SpeedUp		=	$F0+$08
MPCC_SpeedDown		=	$F0+$09
MPCC_ToneUp		=	$F0+$0A
MPCC_ToneDown		=	$F0+$0B
MPCC_User		=	$F0+$0C
MPCC_Call		=	$F0+$0D
MPCC_Jump		=	$F0+$0E
MPCC_End		=	$F0+$0F
;-------------------------------------------------------------------------------
; MTBI = Music Tone Buffer Index
;
MTBI_SQUARE1		=	0*20
MTBI_SQUARE2		=	1*20
MTBI_TRIANGLE		=	2*20
MTBI_NOISE		=	3*20
MTBI_DPCM		=	4*20
;-------------------------------------------------------------------------------
; MTCC = Music Tone Control Code
;
MTCC_Wait		=	$00
MTCC_Out		=	$80
MTCC_Put		=	$90
MTCC_Or			=	$A0
MTCC_OutPut		=	$B0
MTCC_Setup		=	$C0

MTCC_IndexOut		=	$D0+0
MTCC_VolumeIndexOut	=	$D0+1
MTCC_ToneIndexOut	=	$D0+2
MTCC_VolumeToneIndexOut	=	$D0+3

MTCC_Loop		=	$E0

MTCC_VolumeInc		=	$F0+$00
MTCC_VolumeDec		=	$F0+$01
MTCC_VolumeBne		=	$F0+$02
MTCC_VolumeBeq		=	$F0+$03
MTCC_VolumeReset	=	$F0+$04
MTCC_VolumeClear	=	$F0+$05
MTCC_Flag2Beq		=	$F0+$06
MTCC_Flag2Bne		=	$F0+$07
MTCC_ToneAdd		=	$F0+$08
MTCC_StepIndexOut	=	$F0+$09
MTCC_Flag1Beq		=	$F0+$0A
MTCC_Flag1Bne		=	$F0+$0B
MTCC_LoopBeq		=	$F0+$0C
MTCC_Call		=	$F0+$0D
MTCC_Jump		=	$F0+$0E
MTCC_End		=	$F0+$0F

vPNT			=	$80
vPIN			=	$81			;用星星进入方式
vPAL			=	$90
vIRQ			=	$a0
xIRQ			=	$a1			;原有基础上追加IRQ
vSPR			=	$b0
vEND			=	$ff

.importzp	SystemControlTemp, VideoControlTemp, ScreenPositionX, ScreenPositionY
.importzp	ProgramBank0Temp, ProgramBank1Temp, ProgramBank2Temp
.importzp	IRQCount,IRQScanLineBank, ScanlineOffest, IRQScanLine
.importzp	NMIControl, NMITemp
.importzp	DMAScreenBank, DMASourceAddress, DMADestinationAddress, DMALength
.importzp	MultiDMABank,MultiDMATableAddr
.importzp	InitScreenPoint
.importzp	addr0, addr1, Temp0, Temp1, Temp2
