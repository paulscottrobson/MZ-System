; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		macros.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		10th November 2018
;		Purpose :	MZ Kernel
;
; ***************************************************************************************
; ***************************************************************************************

setMemoryPage: macro 								; set memory page direct.
			nextreg $56,\1
			nextreg $57,\1+1
			endm

setMemoryPageA: macro 								; set memory page to A register
			nextreg $56,a
			inc 	a
			nextreg $57,a
			dec 	a
			endm

resetMemoryPage: macro 								; set memory page to A' register, used
			db 		$08 							; when leaving routines that will change
			nextreg $56,a 							; the page. When running MZ code A' is always
			inc 	a 								; the page you are currently in. A' PC form a
			nextreg $57,a 							; 24 bit PC.
			dec 	a
			db 		$08
			endm

