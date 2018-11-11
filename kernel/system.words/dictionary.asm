; ***********************************************************************************************
; ***********************************************************************************************
;
;		Name : 		dictionary.asm
;		Purpose : 	Dictionary code.
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		5th November 2018
;
; ***********************************************************************************************
; ***********************************************************************************************

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
		nextmema

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
		ld 		(DICTLastDefinedWord),ix 			; save last defined address.
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

		pop 	ix 									; restore and exit
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

; @noheader dict.find
		ret


