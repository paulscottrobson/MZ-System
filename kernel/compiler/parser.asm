; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		parser.asm
;		Author :	paul@robsons.org.uk
;		Date : 		12th November 2018
;		Purpose :	Text word parser.
;
; ***************************************************************************************
; ***************************************************************************************

; ********************************************************************************************************
;
;						Set the pointer to the data to be parsed.
;
; ********************************************************************************************************

PARSESetWordPointer:
		ld 		(PARSEPointer),hl
		ret

; ********************************************************************************************************
;
;			Get the next parsed element, return in HL, type in B CS if nothing to get. 
;
; ********************************************************************************************************

PARSEGetNextWord:
		ld 		hl,(PARSEPointer)					; get parse pointer
__PARSEGNWSkipSpaces:
		ld 		a,(hl) 								; skip over spaces 
		inc 	hl
		cp 		' '
		jr 		z,__PARSEGNWSkipSpaces
		or 		a 									; if reached the end return with carry set
		scf
		ret 	z
		dec 	hl 									; back to first character.
		push 	hl 									; save start of word on stack.
__PARSESkipOverWord:
		ld 		a,(hl) 								; skip over the word looking for null/space
		inc 	hl
		cp 		' '+1
		jr 		nc,__PARSESkipOverWord
		dec 	hl 									; go back to the null/space
		ld 		(PARSEPointer),hl 					; write the pointer back

		xor 	a 									; clear carry
		pop 	hl 									; HL points to the start of the word
		ld 		b,' '								; it is type $20 (ASCII ending in null/space)
		ret
