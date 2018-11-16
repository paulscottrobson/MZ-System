; *********************************************************************************
; *********************************************************************************
;
;		File:		debug.asm
;		Purpose:	Debug routines
;		Date : 		15th November 2018
;		Author:		paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************

DEBUGShowBottomLine:
		push 	af
		push 	bc
		push 	de
		push 	hl

		push 	bc
		push 	de
		push 	hl

		ld 		hl,(SIScreenSize) 					; calculate start position
		ld 		de,(SIScreenWidth)
		xor		a
		sbc 	hl,de
		push 	hl
		ld 		c,e
		ld 		b,c 								; clear the bottom line.
__DSSSBLClear:
		ld 		de,$0220
		call 	GFXWriteCharacter
		inc 	hl
		djnz 	__DSSSBLClear
		pop 	hl 									; restore current position.

		pop 	de
		call 	__DSSPrintDecimal
		inc 	hl
		pop 	de
		call 	__DSSPrintDecimal	
		inc 	hl
		pop 	de
		call 	__DSSPrintDecimal	
		inc 	hl

		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

__DSSPrintDecimal:	
		bit 	7,d
		jr 		z,__DSSPrintDecimalRec
		ld 		a,d
		cpl 	
		ld 		d,a
		ld 		a,e
		cpl
		ld 		e,a
		inc 	de
		ld 		a,'-'
		call 	GFXWriteCharacter
		inc 	hl
		dec 	c
__DSSPrintDecimalRec:
		push 	hl
		ld 		hl,10
		call 	DIVDivideMod16
		ld 		a,d
		or 		e
		ex 		(sp),hl
		call 	nz,__DSSPrintDecimalRec
		pop 	de
		ld 		a,e
		add 	a,48
		ld 		e,a
		ld 		d,6
		call 	GFXWriteCharacter
		inc		hl
		dec 	c
		ret

