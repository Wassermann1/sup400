_GamesDefine:
	.word	Game001
	.word	Game002
	.word	$0000
Game001:
	.byte	$01
	.byte	$00
	.byte	$00
	.byte	$02
	.byte	$06
	.byte	$10
	.word	GameSub
	.byte	"Legend of Zelda, The (Europe)"
	.byte	$00
Game002:
	.byte	$00
	.byte	$00
	.byte	$10
	.byte	$02
	.byte	$06
	.byte	$10
	.word	GameSub
	.byte	"DuckTales 2 (Europe)"
	.byte	$00
.include	"GameSub.inc"