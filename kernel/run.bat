@echo off
call build.bat
if not exist boot.img goto exit
copy ..\files\bootloader.sna .
python ..\scripts\encode.py test.mz
..\bin\CSpect.exe -zxnext -cur -brk -exit -w3 bootloader.sna 
:exit