/*****************************************************************************/
/*                                  Definitions                              */
/*****************************************************************************/
#define	SpriteColor16		0x0004	//%00000100
#define	SpriteColor4		0x0000
#define	SpriteSize16		0x0005	//%00000101
#define	BackgroudColor16	0x0002	//%00000010
#define	BackgroudColor4		0x0000	
#define	BackgroudExtMode	0x0010	//%00010000
#define	SpriteExtMode		0x0008	//%00001000
#define	NewColor		0x0080	//%10000000
#define	OldColor		0x0000	


#define LCDLine160		0x1000	//%0001000000000000
#define LCDLine120		0x2000	//%0010000000000000
#define LCDLine80		0x3000	//%0011000000000000
#define VideBWMode		0x0800	//%0000100000000000
#define VideDAEnable		0x0400	//%0000010000000000
#define EVA12Select		0x0200	//%0000001000000000
#define NoUseVRAM		0x0100	//%0000000100000000

#define JOY_A			0x80
#define	JOY_B			0x40
#define	JOY_SELECT		0x20
#define	JOY_START		0x10
#define	JOY_UP			0x08
#define	JOY_DOWN		0x04
#define	JOY_LEFT		0x02
#define	JOY_RIGHT		0x01
#define	JOY_LEFT_RIGHT		0x03
#define	JOY_LEFT_DOWN		0x06
#define	JOY_LEFT_UP		0x0A
#define	JOY_DOWN_UP		0x0C
#define	JOY_DOWN_RIGHT		0x05
#define	JOY_UP_RIGHT		0x09

/*****************************************************************************/
/* 	      	  		   Functions	     			     */
/*****************************************************************************/
void InstallVT03();
void InitVT03System(int SystemMode);
void WaitSync();
void ClearSprBuffer();
void InitScreen(void * Table);
void ClearPaletteBuffer();
void PatternUpdate();
void WaitPatternUpdate();
void PaletteUpdate();
void WaitPaletteUpdate();
void EnableNMI();
void DisableNMI();
void OpenScreenDisplay();
void CloseScreenDisplay();
void OpenSpriteDisplay();
void CloseSpriteDisplay();
void SetVectors(int NMI_address,int IRQ_address);
void StandardNMI();
void StandardIRQ();



void MusicInitial();
void MusicSetup(void * address);
void MusicPlay(void * address);
void MusicEffect(void * address);

extern Music_SquareEffect00[];
extern Music_SquareEffect01[];
extern Music_SquareEffect02[];
extern Music_SquareEffect03[];
extern Music_TriangleEffect00[];
extern Music_TriangleEffect01[];
extern Music_TriangleEffect02[];
extern Music_NoiseEffect00[];
extern Music_NoiseEffect01[];
extern Music_NoiseEffect02[];
extern Music_NoiseEffect03[];
extern Music_NoiseEffect04[];
extern Effect00[];
extern Effect01[];
extern Effect02[];
extern Effect03[];
extern Effect04[];
extern Effect05[];
extern Effect06[];
extern Effect07[];
extern Effect08[];
extern Effect09[];
extern Effect10[];
extern Effect11[];
extern Effect12[];
extern Effect13[];
extern Effect14[];
extern Effect15[];
extern Effect16[];
extern Effect17[];
extern Effect18[];
extern Effect19[];
extern Effect20[];
extern Effect21[];
extern Effect22[];
extern Effect23[];
extern Effect24[];
extern Effect25[];
extern Effect26[];
extern Effect27[];
extern Effect28[];
extern Effect29[];
extern Effect30[];
extern Effect31[];
extern Effect32[];
extern Effect33[];
extern Effect34[];
extern Effect35[];
extern Effect36[];
extern Effect37[];
extern Effect38[];
extern Effect39[];
extern Effect40[];
extern Effect41[];
extern Effect42[];
extern Effect43[];
extern Effect44[];
extern Effect45[];
extern Effect46[];
extern Effect47[];
extern Effect48[];
extern Effect49[];
extern Effect50[];