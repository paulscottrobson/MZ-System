; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		process.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Word Processor
;		Date : 		15th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************

WORD_StdDefine = $82 						; standard define
WORD_Compile = $84 							; compile word - call macro if exists, otherwise compile
WORD_Execute = $86 							; execute if in FORTH (or number) only

; ********************************************************************************************************
;
;				HL points to type byte, word follows ending with any value $80-$FF	
;									Carry set on exit if error
;
; ********************************************************************************************************

PROCESSWord:
		push 	bc
		push 	de
		push 	hl
		push 	ix

		ld		a,(hl) 						; get type byte.
		cp 		WORD_Execute 				; is it execute ?
		jp 		z,HEXECProcess 				

PROCESSOkay:								; come here if okay
		xor 	a
		jr 		PROCESSReturn
PROCESSFail: 								; come here if fail
		scf
PROCESSReturn: 								; come here to return your own flag
		pop 	ix
		pop 	hl
		pop 	de
		pop 	bc
		ret

; ********************************************************************************************************
;
;		Update the context registers as if HL had been entered as a number
;
; ********************************************************************************************************

PROCESSPushHLOnExecuteStack:
		push 	de
		ld 		de,(ARegister)
		ld 		(BRegister),de
		ld 		(ARegister),hl
		pop 	de
		ret

; ********************************************************************************************************
;
;						Execute the word at E:HL in the register context.
;
; ********************************************************************************************************

PROCESSExecuteEHL:
		push 	af
		push 	bc
		push 	de
		push 	hl
		ld 		a,e  						; switch to the page the word to be executed is on.
		call 	PAGESwitch 

		ld 		de,__PROCEXECContinue
		push 	de
		push 	hl
		ld 		hl,(ARegister)
		ld 		de,(BRegister)
		ld 		bc,(CRegister)
		ret
		ld 		(ARegister),hl
		ld 		(BRegister),de
		ld 		(CRegister),bc
__PROCExecContinue:
		call 	PAGERestore 				; restore the page
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret
