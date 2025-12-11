_GamesDefine:
	.word	Game001
	.word	Game002
	.word	$0000
Game001:
	.byte	$01
	.byte	$00
	.byte	$00
	.byte	$02
	.byte	$01
	.byte	$10
	.word	GameSub
	.byte	"Darkwing Duck (U) MMC3"
	.byte	$00
Game002:
	.byte	$00
	.byte	$00
	.byte	$10
	.byte	$02
	.byte	$86
	.byte	$10
	.word	GameSub
	.byte	"Prince of Persia (Europe)"
	.byte	$00
.include	"GameSub.inc"