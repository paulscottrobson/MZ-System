@echo off
echo Building ColorForth bootstrap code.
rem	
rem		This script generates the bootstrap.cf file from assembler source
rem
rem		This takes the files in the source subdirectory tree, which consist of marked up
rem 	relocatable ColorForth words. These are either macro (@generator) or forth (@word)
rem 	words. 
rem
rem		These are bodge assembled. This resultant code is then converted into FORTH that
rem 	generates the direct code itself, or MACRO that generates code to compile that code.
rem
rem		In the MACRO form it can optionally generate a FORTH word with the same functionality
rem
python ..\scripts\buildwords.py
..\bin\snasm -vice generate.asm generate.bin
python ..\scripts\buildbootstrap.py
copy support\*.* ..\kernel\support >NUL
copy bootstrap.mz ..\files >NUL

