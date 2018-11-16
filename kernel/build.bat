@echo off
pushd ..\bootloader
call build.bat
popd
pushd ..\words
call build.bat
popd
rem
rem	Tidy up
rem
del /Q boot.img
del /Q ..\files\boot.img
rem
rem	Assemble the kernel file.
rem
..\bin\snasm -next -vice kernel.asm boot.img
rem
rem Insert required words in dictionary
rem
if exist boot.img   python ..\scripts\loaddictionary.py
rem
rem Copy to files area.	
rem
if exist boot.img 	copy boot.img ..\files\boot.img
