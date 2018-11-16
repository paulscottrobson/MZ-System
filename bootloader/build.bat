@echo off
rem 
rem 	Tidy up
rem
del /Q bootloader.sna 
del /Q ..\files\bootloader.sna
rem 
rem 	Assemble file.
rem
..\bin\snasm -next bootloader.asm 
rem 
rem 	Copy if successful.
rem
if exist bootloader.sna copy bootloader.sna ..\files
