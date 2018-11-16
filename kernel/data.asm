; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		data.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th November 2018
;		Purpose :	Data area
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									System Information
;
; ***************************************************************************************

SystemInformationTable:

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
SIBuffer:											; +20 	Buffer
		dw		EditBuffer
SIBufferSize: 										; +24 	Buffer Size
		dw 		EditBufferSize 
SIStack:											; +28 	Initial Z80 stack value
		dw 		StackTop,0							
SIScreenWidth:										; +32 	Screen Width
		dw 		0,0
SIScreenHeight:										; +36 	Screen Height
		dw 		0,0
SIScreenDriver:										; +40 	Screen Driver
		dw 		0,0 								
SIScreenSize: 										; +44  	Screen Size
		dw 		0,0 
SIFontBase:											; +48 	768 byte font, begins with space
		dw 		AlternateFont,0 							

; ***************************************************************************************
;
;								 Other data and buffers
;
; ***************************************************************************************

DICTCurrentDictionary: 								; $00 Forth $40 Macro
		db 		0

PAGEStackPointer:									; page (non-call) stack pointer
		dw 		0
PAGEStackBase:										; space for the page switch stack
		ds 		16

ARegister:											; registers when out of execution.
		dw 		0
BRegister:
		dw 		0
CRegister:
		dw 		0

PageUsage:
		db 		1									; $20 (dictionary) [1 = system]
		db 		1 									; $22 (bootstrap)  
		db 		2 									; $24 (first code) [2 = code]
		db 		0,0,0,0,0,0 						; $24-$2E 		   [0 = unused]
		db 		0,0,0,0,0,0,0,0 					; $30-$3E
		db 		0,0,0,0,0,0,0,0 					; $40-$4E
		db 		0,0,0,0,0,0,0,0 					; $50-$5E
		db 		$FF 								; end of page.

		org 	$A000
FreeMemory:		


