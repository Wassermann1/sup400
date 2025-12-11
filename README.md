An attempt to dassasemble a dump from handheld RetroFC (sup 400in1 game console)

Main goal: Isolate data and logic, responsible for build-in LCD and APU to integrate it in commonly used nes multicatridge builders

Platform info:
- Based on VTR One-Bus system
- Supports mappers 000 and 004 (MMC3)
- Operates by VT3xx (vt386\vt389)
- Storage from 8 to 32mb NoR Falsh
- Dump from console can be converted to .nes with python scrypt to run with FCEMU (mapper 256)
https://gist.github.com/daveshah1/39faa3f85d492cba38ecf45e272f72de
- Code examples from manufacturer contains 2 LCD initialization methods, that don't work on model retroFC\SUP devices
- Official website provide vt03.lib with .inc and .h files but LCD initialization not included in standard lib
- Different consoles have differnt LCD initialization logic, but LCD itself can be swapped between  different consoles with no issues
- vt3xx should be backwards comparable with vt03 dumps uploaded from other consoles work with TV out but without LCD and APU


project root contains current disassembled code from dump.BIN
