; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		utilities.asm
;		Author :	paul@robsons.org.uk
;		Date : 		12th November 2018
;		Purpose :	Utility function.
;
; ***************************************************************************************
; ***************************************************************************************

; ***********************************************************************************************
;
;									Generate code for constant in HL
;
; ***********************************************************************************************

COMUTLConstantCode:
		ld 		a,$EB 								; ex de,hl
		call 	FARCompileByte 
		ld 		a,$21 								; ld hl,const
		call 	FARCompileByte
		call 	FARCompileWord 						; compile the constant
		ret

; ***********************************************************************************************
;
;				Compile code to call EHL from current compile position
;							(Does not handle cross page code)
;
; ***********************************************************************************************

COMUTLCodeCallEHL:
		ld 		a,$CD 								; call <Address>
		call 	FARCompileByte
		call 	FARCompileWord 						; compile the constant
		ret

; ***********************************************************************************************
;
;									Execute code at EHL 
;
; ***********************************************************************************************

COMUTLExecuteEHL:
		ld 		a,e 								; switch to that page
		call 	PAGESwitch
		ld 		de,COMUTLExecuteExit 				; push after code address
		push 	de
		push 	hl 									; push call address
		ld 		hl,(ARegister) 						; load registers
		ld 		de,(BRegister)
		ld 		bc,(CRegister)
		ret 										; execute the call
COMUTLExecuteExit:
		ld 		(CRegister),bc 						; save registers
		ld 		(BRegister),de
		ld 		(ARegister),hl
		call 	PAGERestore
		ret
		
; ***********************************************************************************************
;
;		Copy a macro. The return address points to ld a,<count> followed by the macro contents
;		Note only the lower 4 bits of the count are valid.
;
; ***********************************************************************************************

COMHCopyFollowingCode:
		pop 	hl 										; get return address
		and		15 										; mask any protection
		ld 		b,a 									; put count in B
__COMHCFCLoop: 											; copy bytes
		ld 		a,(hl)
		inc 	hl
		call 	FARCompileByte
		djnz 	__COMHCFCLoop
		ret

; ***********************************************************************************************
;
;			Create a call to the code following this caller. It is running in page A'
;
; ***********************************************************************************************

COMHCreateCallToCode:
		pop 	hl 										; get the address of the code.
		ex 		af,af'
		ld 		e,a 									; put the page number in E.
		ex 		af,af'
		call 	COMUTLCodeCallEHL 						; compile a call to E:HL from here. 	
		ret

