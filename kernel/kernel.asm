; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		kernel.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		15th November 2018
;		Purpose :	ColorForth Kernel
;
; ***************************************************************************************
; ***************************************************************************************

StackTop   = 	$7EF0 								; Top of stack

ErrorMessageBuffer = $7B00 							; Buffer for creating error messages.
EditBuffer = 	$7B40 								; Editor buffer
EditBufferSize = 512 								; Editor buffer size

DictionaryPage = $20 								; dictionary page
BootstrapPage = $22									; bootstrap code page
FirstCodePage = $24 								; first actual code page

			opt 	zxnextreg
			include "support/header.asm"			; header and support words.

Boot:		ld 		sp,(SIStack)					; reset Z80 Stack
			di										; enable interrupts

			nextreg	7,2								; set turbo port (7) to 2 (14Mhz)

			call 	GFXInitialise48k 				; initialise and clear screen.
			call 	GFXConfigure

			ld 		a,(SIBootCodePage) 				; get the page to start
			call 	PAGEInitialise

			ld 		hl,(SIBootCodeAddress)
			jp 		(hl)

ErrorHandler: 										; really bad error handler.
			ld 		c,l
			ld 		b,h
			ld 		hl,0
__ErrorPrint:
			ld 		a,(bc)
			or 		a
			jr 		z,__EndErrorHandler
			ld 		e,a
			ld 		d,2
			call 	GFXWriteCharacter
			inc 	bc
			inc 	hl
			jr 		__ErrorPrint

__EndErrorHandler:
			jr 		__EndErrorHandler

			include "compiler/constant.asm"			; ASCII -> Integer.
			include "compiler/farmemory.asm"		; Far memory read/write/compile functions.
			include "compiler/paging.asm"			; Page switching assembler
			include "compiler/loader.asm" 			; Bootstrap loader.
			include "compiler/dictionary.asm"		; Dictionary code.
			include "compiler/process.asm"			; word processor/execute/etc.
			include "compiler/handlers/execute.asm"	; handle execute words.

AlternateFont:
			include "font.inc"

			include "data.asm"		

			org 	$C000
			db 		0 								; start of dictionary, which is empty.

