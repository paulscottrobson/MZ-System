@echo off
call build.bat
copy ..\files\bootloader.sna .
..\bin\CSpect.exe -zxnext -cur -brk -exit -w3 bootloader.sna 