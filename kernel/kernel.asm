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

EditBufferSize = $400 								; buffer for editing / importing bootstrap
EditBuffer = 	$7802								; edit buffer (option either side)
StackTop   = 	$7EF0 								; Top of stack

DictionaryPage = $20 								; dictionary page
BootstrapPage = $22 								; page containing bootstrapped text.
FirstCodePage = $24									; first code page

			include "macros.asm"

			opt 	zxnextreg
			org 	$8000
			jr 		Boot
			org 	$8004
			dw 		SystemInformation

Boot:		ld 		sp,(SIStack)					; reset Z80 Stack
			di										; enable interrupts
			nextreg	7,2								; set turbo port (7) to 2 (14Mhz)
			call 	SetMode48k 						; initialise and clear screen.
			db 		$DD,$01
			ld 		a,(SIBootCodePage) 				; get the page to start
			setMemoryPageA
			ex 		af,af' 							; set the current code page in A'
			ld 		hl,(SIBootCodeAddress)
			jp 		(hl)

AlternateFont:
			include "font.inc"
			include "support/multiply.asm"			; support functions
			include "support/divide.asm"
			include "support/keyboard.asm"
			include "__words.asm"					; generated file of words
			include "data.asm"						; data area

			org 	$C000
			db 		0 								; start of dictionary, which is empty.
