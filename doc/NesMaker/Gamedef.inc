_GamesDefine:
	.word	Game001
	.word	$0000
Game001:
	.byte	$01
	.byte	$00
	.byte	$00
	.byte	$01
	.byte	$01
	.byte	$10
	.word	GameSub
	.byte	"Super Mario Bros. 3 (Europe)"
	.byte	$00
.include	"GameSub.inc"