; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		dictionary.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th November 2018
;		Purpose :	Dictionary handler.
;
; ***************************************************************************************
; ***************************************************************************************

; ***********************************************************************************************
;
;		Add Dictionary Word. Name is string at HL ends in <= ' ', uses the current page/pointer
;		values.
;
; ***********************************************************************************************

DICTAddWord:
		push 	af 									; registers to stack.
		push 	bc
		push 	de
		push	hl
		push 	ix
		push 	hl 									; put length of string in B
		ld 		b,-1
__DICTAddGetLength:
		ld 		a,(hl)
		inc 	hl
		inc 	b
		cp 		' '+1
		jr 		nc,__DICTAddGetLength
		pop 	hl

		ld 		a,DictionaryPage					; switch to dictionary page
		call 	PAGESwitch

		ld 		ix,$C000							; IX = Start of dictionary
__DICTFindEndDictionary:
		ld 		a,(ix+0) 							; follow down chain to the end
		or 		a
		jr 		z,__DICTCreateEntry
		ld 		e,a
		ld 		d,0
		add 	ix,de
		jr 		__DICTFindEndDictionary

__DICTCreateEntry:
		ld 		a,b
		add 	a,5
		ld 		(ix+0),a 							; offset is length + 5

		ld 		a,(SINextFreeCodePage)				; code page
		ld 		(ix+1),a
		ld 		de,(SINextFreeCode)					; code address
		ld 		(ix+2),e
		ld 		(ix+3),d 
		ld 		(ix+4),b 							; length

		ex 		de,hl 								; put name in DE
__DICTAddCopy:
		ld 		a,(de) 								; copy byte over as 7 bit ASCII.
		ld 		(ix+5),a
		inc 	de
		inc 	ix 									
		djnz	__DICTAddCopy 						; until string is copied over.

		ld 		(ix+5),0 							; write end of dictionary zero.

		call 	PAGERestore
		pop 	ix 									; restore and exit
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret
; @codeonly

; ***********************************************************************************************
;
;			Find word in dictionary. HL points to name, on exit, HL is the address, D the
;			type ID and E the page number with CC if found, CS set and HL=DE=0 if not found.
;
; ***********************************************************************************************

DICTFindWord:
		push 	bc 								; save registers - return in DEHL Carry
		push 	ix

		ld 		a,DictionaryPage 				; switch to dictionary page
		call 	PAGESwitch

		ld 		ix,$C000 						; dictionary start			
__DICTFindMainLoop:
		ld 		a,(ix+0)						; examine offset, exit if zero.
		or 		a
		jr 		z,__DICTFindFail

		push 	ix 								; save pointers on stack.
		push 	hl 

		ld 		b,(ix+4) 						; characters to compare
__DICTCheckName:
		ld 		a,(ix+5) 						; compare dictionary vs character.
		cp 		(hl) 							; compare vs the matching character.
		jr 		nz,__DICTFindNoMatch 			; no, not the same word.
		inc 	hl 								; HL point to next character
		inc 	ix
		djnz 	__DICTCheckName

		ld 		a,(hl)							; if so, see if the next one is EOW
		cp 		' '+1
		jr 		nc,__DICTFindNoMatch 			; if not , bad match.

		pop 	hl 								; Found a match. restore HL and IX
		pop 	ix
		ld 		d,(ix+4) 						; D = type/length
		ld 		e,(ix+1)						; E = page
		ld 		l,(ix+2)						; HL = address
		ld 		h,(ix+3)		
		xor 	a 								; clear the carry flag.
		jr 		__DICTFindExit

__DICTFindNoMatch:								; this one doesn't match.
		pop 	hl 								; restore HL and IX
		pop 	ix
__DICTFindNext:
		ld 		e,(ix+0)						; DE = offset
		ld 		d,$00
		add 	ix,de 							; next word.
		jr 		__DICTFindMainLoop				; and try the next one.

__DICTFindFail:
		ld 		de,$0000 						; return all zeros.
		ld 		hl,$0000
		scf 									; set carry flag
__DICTFindExit:
		push 	af
		call 	PAGERestore
		pop 	af
		pop 	ix 								; pop registers and return.
		pop 	bc
		ret

