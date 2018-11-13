; ********************************************************************************************************
; ********************************************************************************************************
;
;		Name : 		loader.asm
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Purpose : 	Source loader
;		Date : 		5th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************

; ********************************************************************************************************
;
;									Load the bootstrap page
;
; ********************************************************************************************************

LOADBootstrap:
		push 	bc
		push 	de
		push 	hl
		push 	ix
		ld 		hl,__LOADBoot
		call 	PrintString
		ld 		a,BootstrapPage 					; set the current page to bootstrap page.
		call 	PAGESwitch
		ld 		ix,$C000 							; current section being loaded.
;
;		Once here for every 'chunk'. We copy the text to the editor buffer in 
;		chunks (currently 1024 bytes) until we've done all 16k of the page.
;
__LOADBootLoop:

		push 	ix 									; HL = Current Section
		pop 	hl
		ld 		de,EditBuffer  						; Copy to edit buffer 1k of code.
		ld 		bc,EditBufferSize			
		ldir 	

		ld 		a,6 								; show progress by printing a '.'
		ld 		(IOColour),a
		ld 		a,'.'
		call 	PrintCharacter

		ld 		hl,EditBuffer 						; now scan the edit buffer
		call 	LOADScanBuffer 

		ld 		de,EditBufferSize 					; add buffer size to IX
		add 	ix,de
		push 	ix									; until wrapped round to $0000
		pop 	hl
		ld 		a,h
		or 		l		
		jr 		nz,__LOADBootLoop

		pop 	ix
		pop 	hl
		pop 	de
		pop 	bc
		jp 		HaltZ80

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

		call 	PARSESetWordPointer 				; set the word pointer.
__LOADScanLoop:
		call 	PARSEGetNextWord					; try to get next word text@HL type@B
		jr 		c,__LOADScanExit 

		call 	COMCompileWord 						; compile the word at HL
		jr 		c,__LOADErrorHandler 				; error ?

		jr 		__LOADScanLoop

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
__LOADErrorCopyName:
		ld 		a,(hl)
		ld 		(bc),a
		inc 	bc
		inc 	hl
		cp 		' '+1
		jr 		nc,__LOADErrorCopyName
		dec 	bc
__LOADErrorCopyError:
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

__LOADBoot:
		db 		"MZ Bootstrap (10-11-18) ",0