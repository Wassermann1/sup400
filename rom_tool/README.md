 - scrypt.py converts bin to nes, output nes can be rum on fceux emulator
 - games metadata - game table from console dump. 9 bytes for each game 
 left side values from dump - right side values from vt registers on game start
 register meaning:
  - 4100 semms to determine memory page from 00 to 77
  - 2018 201A - Video banks registers
  - 410B mapping logic 02 for 256 banks window rest need to find out
  - 4107-410A PRG banks
  - A000 - mirroring options, 0 horizontal, 1 vertical, 80 - ?