extern unsigned char Game_Pic0[];

void	irq();
void	nmi();
void 	InitSystem();
void	InitPalette();
void 	ClearScreen();
void 	Outputxy(int x,int y, char * Text);