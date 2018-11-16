; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		execute.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Word Processor
;		Date : 		15th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************


; ********************************************************************************************************
;
;				HL points to type byte, word follows ending with any value $80-$FF	
;									Carry set on exit if error
;
; ********************************************************************************************************

HEXECProcess:
		push 	hl
		xor 	a 									; search in FORTH
		call 	DICTFindWord
		pop 	bc
		jr 		nc,__HEXECWord
		ld 		h,b 								; check if number ?
		ld 		l,c
		call 	CONSTConvert
		jp 		c,PROCESSFail
;
;		Push HL on the stack
;
		call 	PROCESSPushHLOnExecuteStack
		jp 		PROCESSOkay
;
;		Execute a word in EHL 
;
__HEXECWord:
		call 	PROCESSExecuteEHL
		jp 		PROCESSOkay
		

