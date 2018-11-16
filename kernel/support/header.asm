; *********************************************************************************
; *********************************************************************************
;
;		File:		header.asm
;		Purpose:	Header file for kernel
;		Date : 		15th November 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

		org 	$8000
		jp 		Boot 								; $8000 Boot
		org 	$8004
		dw 		SystemInformationTable 				; $8004 System Information Table
		org 	$8010

__CALLMultiply:
		jp 		MULTMultiply16 						; $8010
__CALLDivide:
		jp 		DIVDivideMod16 						; $8013
__CALLMode48:
		jp 		GFXInitialise48k		 			; $8016
__CALLModeLow:
		jp 		GFXInitialiseLowRes 				; $8019
__CALLModeLayer2:
		jp 		GFXInitialiseLayer2 				; $801C
__CALLKeyboard:
		jp 		IOScanKeyboard 						; $801F
__CALLConfigure:
		jp 		GFXConfigure 						; $8022

		include 	"support\divide.asm"		
		include 	"support\keyboard.asm"		
		include 	"support\multiply.asm"		
		include 	"support\screen48k.asm"		
		include 	"support\screen_layer2.asm"		
		include 	"support\screen_lores.asm"	
		include 	"support\graphics.asm"
		include 	"support\debug.asm"
