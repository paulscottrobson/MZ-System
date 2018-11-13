; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		kernel.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th November 2018
;		Purpose :	MZ Kernel
;
; ***************************************************************************************
; ***************************************************************************************

EditBuffer = 	$7808								; edit buffer (option either side)
EditBufferSize = $400 								; buffer for editing / importing bootstrap
ErrorMessageBuffer = $7C10 							; buffer for error messages
StackTop   = 	$7EF0 								; Top of stack

DictionaryPage = $20 								; dictionary page
BootstrapPage = $22 								; page containing bootstrapped text.
FirstCodePage = $24									; first code page

			org 	$8000
			jr 		Boot
			org 	$8004
			dw 		SystemInformation

Boot:		ld 		sp,(SIStack)					; reset Z80 Stack
			di										; enable interrupts
			db 		$ED,$91,7,2						; set turbo port (7) to 2 (14Mhz)
			call 	SetMode48k 						; initialise and clear screen.
			ld 		a,(SIBootCodePage) 				; get the page to start
			call 	PAGEInitialise 
			ld 		hl,(SIBootCodeAddress)
			jp 		(hl)

ErrorHandler:
			ld 		a,2
			ld 		(IOColour),a
			call 	PrintString
			jp 		HaltZ80

AlternateFont:
			include "font.inc"
			include "support/multiply.asm"			; support functions
			include "support/divide.asm"
			include "support/keyboard.asm"

			include "compiler/utilities.asm"		; compiler functions
			include "compiler/farmemory.asm"
			include "compiler/paging.asm"
			include "compiler/loader.asm"
			include "compiler/parser.asm"
			include "compiler/constant.asm"
			include "compiler/dictionary.asm"
			include "compiler/compiler.asm"
						
			include "__words.asm"					; generated file of words

			include "data.asm"						; data area

			org 	$C000
			db 		0 								; start of dictionary, which is empty.
