; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		loader.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Source loader
;		Date : 		15th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************

; ********************************************************************************************************
;
;									Load the bootstrap page
;
; ********************************************************************************************************

LOADBootstrap:

		ld 		a,BootstrapPage 					; set the current page to bootstrap page.
		call 	PAGESwitch
		ld 		ix,$C000 							; current section being loaded.
		ld 		c,0
;
;		Once here for every 'chunk'. We copy the text to the editor buffer in 
;		chunks (currently 1024 bytes) until we've done all 16k of the page.
;
__LOADBootLoop:

		push 	ix 									; HL = Current Section
		pop 	hl
		push 	bc
		ld 		de,EditBuffer  						; Copy to edit buffer 1k of code.
		ld 		bc,EditBufferSize			
		ldir 	
		pop 	bc

		ld 		h,0 								; Progress prompt.
		ld 		l,c
		ld 		de,$052A
		call 	GFXWriteCharacter
		inc 	c

		ld 		hl,EditBuffer 						; now scan the edit buffer
		call 	LOADScanBuffer 

		ld 		de,EditBufferSize 					; add buffer size to IX
		add 	ix,de
		push 	ix									; until wrapped round to $0000
		pop 	hl
		ld 		a,h
		or 		l		
		jr 		nz,__LOADBootLoop

__LOADEnds:
		di
		halt
		jr 		__LOADEnds

; ********************************************************************************************************
;
;									Process (compiling) the text at HL. 
; 
; ********************************************************************************************************

LOADScanBuffer:
		push 	af
		push 	bc
		push 	de
		push 	hl
		push 	ix

__LOADSkipSpaces:									; skip over spaces (now $A0)
		ld 		a,(hl)
		inc 	hl
		cp 		$A0
		jr 		z,__LOADSkipSpaces
		dec 	hl 									; first non space character
		cp 		$FF 								; was it $FF ?
		jr 		z,__LOADScanExit 					; if so, we are done.

		call	PROCESSWord
		jr 		c,__LOADErrorHandler

__LOADNextWord: 									; look for the next bit 7 high.
		inc 	hl
		bit 	7,(hl)
		jr 		z,__LOADNextWord
		jr 		__LOADSkipSpaces
		jr 		__LOADErrorHandler

__LOADScanExit:
		pop 	ix
		pop 	hl
		pop 	de
		pop 	bc
		pop 	af
		ret

; ********************************************************************************************************
;
;				Come here if an error has occurred (cannot find word, or it is protected)
;
; ********************************************************************************************************

__LOADErrorHandler:									; unknown word @ HL
		ld 		de,__LOADErrorMessage
		ld 		bc,ErrorMessageBuffer
		push 	bc
		inc 	hl 									; skip over tag
__LOADErrorCopyName: 								; copy name
		ld 		a,(hl)
		ld 		(bc),a
		inc 	bc
		inc 	hl
		bit 	7,(hl)
		jr 		z,__LOADErrorCopyName
__LOADErrorCopyError: 								; copy error text.
		ld 		a,(de)
		ld 		(bc),a
		inc 	bc
		inc 	de
		or 		a
		jr 		nz,__LOADErrorCopyError
		pop 	hl
		jp 		ErrorHandler

__LOADErrorMessage:	
		db 		" : Unknown word",0
