#
# makefile for DEMO1 runtime library
#
CC=cc65 
CFLAGS=-t none -I../include 
AS=ca65
AFLAGS=-t none -I../include
LD=ld65
LFLAGS=-C demo1.cfg -m demo1.map -o menu.bin

.SUFFIXES: .o .s .c
#--------------------------------------------------------------------------
# Rules

%.o:   	%.c
	@$(CC) $(CFLAGS) $<
	@$(AS) -o $@ $(AFLAGS) $(*).s
	
%.o:	%.s
	@$(AS) -g -o $@ $(AFLAGS) $<
#--------------------------------------------------------------------------
# Object files

C_OBJS  =	demo1.o

S_OBJS  =      	proc.o
#--------------------------------------------------------------------------
# Targets
.PHONY:	all clean zap

all:   	$(C_OBJS) $(S_OBJS)
	@$(LD) $(LFLAGS) vt03.o $(C_OBJS) $(S_OBJS) vt03.lib

clean:
	@$(RM) $(C_OBJS:.c=.s) $(C_OBJS) $(S_OBJS) $(LIB)

zap:	clean

