; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compiler.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		12th November 2018
;		Purpose :	Main Compiler (yes, this is it !)
;
; ***************************************************************************************
; ***************************************************************************************

; ***********************************************************************************************
; ***********************************************************************************************
;
;									Compile word at HL
;
; ***********************************************************************************************
; ***********************************************************************************************

COMCompileWord:
		push 	bc
		push 	de
		push 	hl
		push 	hl								; save word address
		call 	DICTFindWord 					; try to find it
		pop 	bc 								; restore word address to BC
		jr 		nc,__COMCWWordFound
		ld 		h,b 							; put back in HL
		ld 		l,c
		call 	CONSTConvert 					; convert it to a constant
		jr 		nc,__COMCWConstant 				; write code to load that.
		scf
__COMCWExit:
		pop 	hl
		pop 	de
		pop 	bc
		ret
;
;		Word found in dictionary
;
__COMCWWordFound:
		call 	COMUTLExecuteEHL 					; execute the word.
		xor 	a 									; exit happy
		jr 		__COMCWExit
;
;		Decimal constant found.
;
__COMCWConstant:
		call 	COMUTLConstantCode 					; compile as constant
		xor 	a 									; exit happy
		jr 		__COMCWExit
		