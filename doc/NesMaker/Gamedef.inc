_GamesDefine:
	.word	Game001
	.word	Game002
	.word	$0000
Game001:
	.byte	$00
	.byte	$00
	.byte	$10
	.byte	$04
	.byte	$a6
	.byte	$00
	.word	GameSub
	.byte	"Super Mario Bros. (Europe)"
	.byte	$00
Game002:
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$02
	.byte	$ae
	.byte	$00
	.word	GameSub
	.byte	"Contra (USA)"
	.byte	$00
.include	"GameSub.inc"