; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		data.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th November 2018
;		Purpose :	Data area
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									System Information
;
; ***************************************************************************************

SystemInformation:

SINextFreeCode: 									; +0 	Next Free Code Byte
		dw 		FreeMemory,0
SINextFreeCodePage: 								; +4 	Next Free Code Byte Page
		dw 		FirstCodePage,0
SIBootCodeAddress:									; +8	Run from here
		dw 		LOADBootstrap,0
SIBootCodePage: 									; +12   Run page.
		db		FirstCodePage,0,0,0
SIPageUsage:										; +16 	Page Usage Table
		dw 		PageUsage,0 				
SIStack:											; +xx 	Initial stack value
		dw 		StackTop,0							
SIScreenWidth:										; +xx 	Screen Width
		dw 		0,0
SIScreenHeight:										; +xx 	Screen Height
		dw 		0,0
SIScreenDriver:										; +xx 	Screen Driver
		dw 		0,0 								
SIFontBase:											; +xx 	768 byte font, begins with space
		dw 		AlternateFont,0 							
		
; ***************************************************************************************
;
;								 Other data and buffers
;
; ***************************************************************************************

IOScreenPosition:									; Position on screen
		dw 		0
IOColour: 											; writing colour
		db 		7
PARSEPointer:										; Parsing position
		dw 		0
DICTLastDefinedWord: 								; Address of last defined word.
		dw 		0		

IsCompilerMode: 									; if 0 execute words, <> 0 compile them.
		db 		0 

ARegister: 											; Register for doing commands in context.
		dw 		0
BRegister:
		dw 		0
CRegister:
		dw 		0

PageUsage:
		db 		1									; $20 (dictionary) [1 = system]
		db 		1 									; $22 (bootstrap code)
		db 		2 									; $24 (first code) [2 = code]
		db 		0,0,0,0,0 							; $26-$2E 		   [0 = unused]
		db 		0,0,0,0,0,0,0,0 					; $30-$3E
		db 		0,0,0,0,0,0,0,0 					; $40-$4E
		db 		0,0,0,0,0,0,0,0 					; $50-$5E
		db 		$FF 								; end of page table.
		
		org 	$A000
FreeMemory:		