; *********************************************************************************
; *********************************************************************************
;
;		File:		generate.asm
;		Purpose:	Fake build of kernel words for bootstrap generation.
;		Date : 		15th November 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

	opt 		zxNextReg
	include 	"support\header.asm"	

	

;
;		Hacks to make things compile.
;
Boot:
SystemInformationTable:
SIFontBase:
SIScreenWidth:
SIScreenHeight:
SIScreenDriver:
SIScreenSize:
DBStackTemp:
SIExecStackTop:

	org 		$A000
	include 	"__words.asm"

