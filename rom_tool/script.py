#!/usr/bin/env python3
import os, sys
import argparse

def main():
    parser = argparse.ArgumentParser(description='Convert VTxx BIN format to NES 2.0 format')
    parser.add_argument('infile', metavar='infile', type=str, nargs=1,
                        help='Input .bin file')
    parser.add_argument('-m', '--mapper', action='store', default=256,
                        help='NES 2.0 mapper number (default: 256)')
    parser.add_argument('-s', '--submapper', action='store', default=0,
                        help='NES 2.0 submapper (default: 0)')
    parser.add_argument('-o', '--outfile', action='store', default="",
                        help='Output file name (default: converts .bin to .nes)')
    parser.add_argument('-p', dest='tvmode', action='store_const', default="ntsc", const="pal",
                        help='ROM is for PAL TV system (default: NTSC)')
                        
    args = parser.parse_args(sys.argv[1:])
    
    romsize = os.path.getsize(args.infile[0])
    rombanks = (romsize + 16383) // 16384
    
    outfile = os.path.splitext(args.infile[0])[0] + ".nes"
    if args.outfile != "":
        outfile = args.outfile
    
    ma = int(args.mapper)
    sm = int(args.submapper)
    
    header = [0x4E, 0x45, 0x53, 0x1A] #magic
    header.append(rombanks & 0xFF) #PRG rom banks
    header.append(0x00) #CHR rom banks
    header.append((ma & 0xF) << 4) #mapper number, flags
    header.append((ma & 0xF0) | 0x08) #mapper number, flags
    
    header.append(((sm & 0xF) << 4) | ((ma & 0xF00) >> 8)) #mapper MSB and variant
    header.append((rombanks & 0xF00) >> 8) # CHR, PRG size msb
    header.append(0x00) # RAM size
    header.append(0x00) # VRAM size
    
    header.append(0x01 if args.tvmode == "pal" else 0x00) # TV system
    header.append(0x00) # VS hardware
    header.append(0x00) # MISC roms
    header.append(0x00) # reserved

    with open(outfile, 'wb') as of:
        of.write(bytes(header))
        with open(args.infile[0], 'rb') as infi:
            of.write(infi.read())
if __name__ == '__main__':
    main()