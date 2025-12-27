_GamesDefine:
	.word	Game001
	.word	$0000
Game001:
	.byte	$01
	.byte	$00
	.byte	$00
	.byte	$02
	.byte	$81
	.byte	$00
	.word	GameSub
	.byte	"Ninja Gaiden (U) MMC3"
	.byte	$00
.include	"GameSub.inc"