@echo off
rem 
rem 	Tidy up
rem
del /Q bootloader.sna 
del /Q bootsave.img
rem
rem		Create a dummy boot.img file large enough
rem
python makerandomimage.py
rem
rem		Assemble with testing on
rem
..\bin\snasm -next -d TESTRW bootloader.asm 
rem
rem		Run it - note bootsave.img as a zero length file is required due to CSpect bug.
rem
if not exist bootloader.sna goto exit
..\bin\CSpect.exe -zxnext -cur -brk -exit -w3 bootloader.sna
rem sh ..\bin\zrun.sh .\ bootloader.sna
rem
rem		Check it was copied in and out successfully.
rem
echo Comparing the input and output boot images now.
fc   /b boot.img bootsave.img
:exit