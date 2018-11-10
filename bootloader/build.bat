@echo off
rem 
rem 	Tidy up
rem
del /Q bootloader.sna 
del /Q ..\files\bootloader.sna
del /Q bootsave.img
del /Q boot.img
rem 
rem 	Assemble file.
rem
..\bin\snasm -next bootloader.asm 
rem 
rem 	Copy if successful.
rem
if exist bootloader.sna copy bootloader.sna ..\files
