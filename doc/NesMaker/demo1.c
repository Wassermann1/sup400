#include	"vt03.h"
#include	"demo1.h"
#include	"ctype.h"

#define PageLines	17
#define LineWidth		24	

char const BlackLine[] ="                     ";

char ReadJoystick1();
void RunGame(int Par,int address);
void InitSprite();
void DisplayPage(int PNo,int Count);
void InitLCD();	
void InitSystemTestSprite();
int CheckGameCount();
int ReadJoystick2();

void InitMenuSprite();

#define	SpriteBuff	0x0200

int sprintf (char* buf, const char* Format, ...);

char TempBuffer[32];
extern void midi02[];
extern void GamesDefine[];

void * const Mus_SquareIndexTable[] =
{
	Music_SquareEffect00,
	Music_SquareEffect01,
	Music_SquareEffect02,
	Music_SquareEffect03,
};

void * const Mus_TriangleIndexTable[] =
{
	Music_TriangleEffect00,
	Music_TriangleEffect01,
	Music_TriangleEffect02,
};

void * const Mus_NoiseIndexTable[] =
{
	Music_NoiseEffect00,
	Music_NoiseEffect01,
	Music_NoiseEffect02,
	Music_NoiseEffect03,
	Music_NoiseEffect04
};

void * const Mus_DPCMIndexTable[] =
{
	0
};

void * const Music_IndexTable[] =
{
	Mus_SquareIndexTable,
	Mus_SquareIndexTable,
	Mus_TriangleIndexTable,
	Mus_NoiseIndexTable,
	Mus_DPCMIndexTable,
};

extern const long PICTable[];
int MusicLoop();
void TestSystem();

int main (void)
{	
	unsigned char key;
	int PageNo,SelectNo;
	int GameCount;		
	
	InitLCD();
	InstallVT03();
	InitVT03System(OldColor+BackgroudColor4+SpriteColor4);
	SetVectors((int)StandardNMI,(int)StandardIRQ);
	MusicInitial();				//初始化音乐播放程序
	MusicSetup(Music_IndexTable);		//设置音色数据
	
	ClearSprBuffer();			//初始化清除卡通缓存
	ClearPaletteBuffer();			//初始化清除颜色缓存
	EnableNMI();				//打开NMI中断
	GameCount = CheckGameCount();		//计算游戏表的游戏个数
	
	
	CloseScreenDisplay();
	InitScreen(&PICTable[3]);
	PatternUpdate();
	WaitPatternUpdate();
	DisableNMI();
//===============================================
	InitVT03System(OldColor+BackgroudColor4+SpriteColor4);
	SetVectors((int)nmi,(int)irq);	
	InitSystem();
	InitPalette();
	EnableNMI();	
	InitMenuSprite();
	OpenScreenDisplay();	
	
	
	SelectNo = 0;
	PageNo = 0;
	WaitSync();
	key = ReadJoystick1();
	if(key == (JOY_A|JOY_B))
	{
		TestSystem();
	}
	DisplayPage(PageNo,GameCount);

	//MusicPlay(midi02);	//播放背景音乐
	for(;;)
	{
		if(MusicLoop())
			MusicPlay(midi02);
					
		key = ReadJoystick1();
		switch(key)
		{
		case JOY_UP:
			if(SelectNo>0)
			{
				SelectNo--;
				MusicEffect(Effect43);
			}
			else
			{
				if(PageNo)
				{
					PageNo-=PageLines;
					MusicEffect(Effect47);
					DisplayPage(PageNo,GameCount);
					SelectNo = PageLines-1;	
				}
			}
			*((char *)SpriteBuff) = (SelectNo<<3) + 0x38;
			break;
			
			
		case JOY_DOWN:
			if(SelectNo<PageLines-1)
			{
				if((PageNo + SelectNo + 1) < GameCount)
					SelectNo++;
				MusicEffect(Effect43);
			}
			else
			{
				if((PageNo + PageLines) < GameCount)
				{
					PageNo += PageLines;
					MusicEffect(Effect47);
					DisplayPage(PageNo,GameCount);
					SelectNo=0;
				}
			}
			*((char *)SpriteBuff) = (SelectNo<<3) + 0x38;
			break;
		case JOY_LEFT:
			if(PageNo)
			{
				PageNo-=PageLines;
				MusicEffect(Effect47);
				DisplayPage(PageNo,GameCount);
			}
			break;
		case JOY_RIGHT:
			if((PageNo + PageLines) < GameCount)
			{
				PageNo += PageLines;
				while((PageNo + SelectNo) > (GameCount-1))
				{
					SelectNo--;
					*((char *)SpriteBuff) = (SelectNo<<3) + 0x38;	
				}
				MusicEffect(Effect47);
				DisplayPage(PageNo,GameCount);
			}
			break;	
		case JOY_A:
			MusicInitial();
			RunGame(0,*(int *)((int)GamesDefine + (PageNo+SelectNo)*2));
			//RunGame(0,*(int *)((int)GamesDefine + GameCount*2);
			break;
		}
	}
	return 1;
}

int CheckGameCount()
{
	int i;
	
	i = 0;
	
	while(*(int *)((int)GamesDefine + i*2))
	{
		i++;
	}
	return i;
}

void TestSystem()
{
	unsigned char key;
	int i;
	
	MusicInitial();
	InitSystemTestSprite();
	Outputxy(8,8,"N99 TEST PROGRAM");
	
	for(i=0;i<0x2000;i+=17)
	{
		*(unsigned char *)(0x6000+i) = 0x55;
		if(*(unsigned char *)(0x6000+i) != 0x55)
			break;
		*(unsigned char *)(0x6000+i) = 0xAA;
		if(*(unsigned char *)(0x6000+i) != 0xAA)
			break;
	}
	
	if(i>=0x2000)
	{
		Outputxy(8,11,"N99 TEST SRAM OK");
	}
	else
	{
		Outputxy(8,11,"N99 TEST SRAM ERROR");
	}
	
	do{
		WaitSync();
		
		key = ReadJoystick2();
		InitSystemTestSprite();
		if(key&JOY_UP)
			*(unsigned char *)(0x0200+0x01) = 0x5F;	
		if(key&JOY_DOWN)
			*(unsigned char *)(0x0200+0x05) = 0x5F;
		if(key&JOY_LEFT)
			*(unsigned char *)(0x0200+0x09) = 0x5F;
		if(key&JOY_RIGHT)
			*(unsigned char *)(0x0200+0x0D) = 0x5F;
		if(key&JOY_SELECT)
			*(unsigned char *)(0x0200+0x11) = 0x5F;
		if(key&JOY_START)
			*(unsigned char *)(0x0200+0x15) = 0x5F;
		if(key&JOY_A)
			*(unsigned char *)(0x0200+0x19) = 0x5F;
		if(key&JOY_B)
			*(unsigned char *)(0x0200+0x1D) = 0x5F;
			
		key = ReadJoystick1();
		switch(key)
		{
			case JOY_UP:
				MusicEffect(Effect41);
				break;
			case JOY_DOWN:
				MusicEffect(Effect42);
				break;
			case JOY_LEFT:
				MusicEffect(Effect43);
				break;
			case JOY_RIGHT:
				MusicEffect(Effect45);
				break;
			case JOY_SELECT:
				MusicEffect(Effect46);
				break;
			case JOY_START:
				MusicEffect(Effect44);
				break;
			case JOY_A:
				MusicEffect(Effect49);
				break;
			case JOY_B:
				MusicEffect(Effect48);
				break;
				
		}
	}while(1);
}

void DisplayPage(int PNo,int Count)
{
	int i,k;
	char Temp[48];
	char * GameName;
	int GameDefineAddress;	
	int GameTableAddress;	
	
	 
	
	for(i=0;i<PageLines;i++)
	{
		if((PNo+i) < Count)
		{
			GameDefineAddress = (int)GamesDefine + (PNo+i)*2;
			GameTableAddress = *(int *)(GameDefineAddress);
			GameName = (char *)(GameTableAddress + 8);
			if(*(int *)GameDefineAddress > 1)
				sprintf(Temp,"%d.%s(%d)",PNo+i+1,GameName,*(int *)GameDefineAddress);
			else
				sprintf(Temp,"%d.%s",PNo+i+1,GameName);
			for(k=0;k<LineWidth;k++)
			{
				if( Temp[k] == 0)
					break;
			}		 
			for(;k<LineWidth;k++)
			{
				Temp[k] = 0x20;
			}
			Temp[k] = 0;
			Outputxy(5,7+i,Temp);
		}
		else
			break;
	}	
	
	while(i!=PageLines)
	{
		Outputxy(4,7+i,(char *)BlackLine);
		i++;
	}
}
