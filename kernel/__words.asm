; ---------------------------------------------------------
; Name : + Type : macro
; ---------------------------------------------------------

__mzdefine_2b:
    call COMHCopyFollowingCode
    db __mzdefine_2b_end-__mzdefine_2b-4
  add  hl,de
__mzdefine_2b_end:

; ---------------------------------------------------------
; Name : and Type : word
; ---------------------------------------------------------

__mzdefine_61_6e_64:
    call COMHCreateCallToCode
  ld   a,h
  and  d
  ld   h,a
  ld   a,l
  and  e
  ld   l,a
  ret

; ---------------------------------------------------------
; Name : / Type : word
; ---------------------------------------------------------

__mzdefine_2f:
    call COMHCreateCallToCode
  push  de
  call  DIVDivideMod16
  ex   de,hl
  pop  de
  ret

; ---------------------------------------------------------
; Name : = Type : word
; ---------------------------------------------------------

__mzdefine_3d:
    call COMHCreateCallToCode
 ld   a,h
 cp   d
 jr   nz,__COMFalse
 ld   a,l
 cp   e
 jr   nz,__COMFalse
__COMTrue:
 ld   hl,$FFFF
 ret
__COMFalse:
 ld   hl,$0000
 ret

; ---------------------------------------------------------
; Name : > Type : word
; ---------------------------------------------------------

__mzdefine_3e:
    call COMHCreateCallToCode
__COMP_GT:
 ld   a,h
    xor  d
    jp   m,__Greater
    sbc  hl,de
    jp   c,__COMTrue
    jp   __COMFalse
__Greater:
 bit  7,d
    jp   nz,__COMFalse
    jp     __COMTrue

; ---------------------------------------------------------
; Name : >= Type : word
; ---------------------------------------------------------

__mzdefine_3e_3d:
    call COMHCreateCallToCode
 dec  hl
 jp   __COMP_GT

; ---------------------------------------------------------
; Name : < Type : word
; ---------------------------------------------------------

__mzdefine_3c:
    call COMHCreateCallToCode
 dec  hl
 jp   __COMP_LE

; ---------------------------------------------------------
; Name : <= Type : word
; ---------------------------------------------------------

__mzdefine_3c_3d:
    call COMHCreateCallToCode
__COMP_LE:
 ld   a,h
    xor  d
    jp   m,__LessEqual
    sbc  hl,de
    jp   nc,__COMTrue
    jp   __COMFalse
__LessEqual:
 bit  7,d
    jp   z,__COMFalse
    jp   __COMTrue

; ---------------------------------------------------------
; Name : mod Type : word
; ---------------------------------------------------------

__mzdefine_6d_6f_64:
    call COMHCreateCallToCode
  push  de
  call  DIVDivideMod16
  pop  de
  ret

; ---------------------------------------------------------
; Name : * Type : word
; ---------------------------------------------------------

__mzdefine_2a:
    call COMHCreateCallToCode
  jp   MULTMultiply16

; ---------------------------------------------------------
; Name : <> Type : word
; ---------------------------------------------------------

__mzdefine_3c_3e:
    call COMHCreateCallToCode
 ld   a,h
 cp   d
 jp   nz,__COMTrue
 ld   a,l
 cp   e
 jp   nz,__COMTrue
 jp   __COMFalse

; ---------------------------------------------------------
; Name : or Type : word
; ---------------------------------------------------------

__mzdefine_6f_72:
    call COMHCreateCallToCode
  ld   a,h
  or   d
  ld   h,a
  ld   a,l
  or   e
  ld   l,a
  ret

; ---------------------------------------------------------
; Name : - Type : macro
; ---------------------------------------------------------

__mzdefine_2d:
    call COMHCopyFollowingCode
    db __mzdefine_2d_end-__mzdefine_2d-4
  push  de
  ex   de,hl
  xor  a
  sbc  hl,de
  pop  de
__mzdefine_2d_end:

; ---------------------------------------------------------
; Name : xor Type : word
; ---------------------------------------------------------

__mzdefine_78_6f_72:
    call COMHCreateCallToCode
  ld   a,h
  xor   d
  ld   h,a
  ld   a,l
  xor  e
  ld   l,a
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

GFXInitialise:
  push  de
  push  hl
  ld  (SIScreenDriver),de
  ld   a,l
  ld   (SIScreenWidth),a
  ld   a,h
  ld   (SIScreenHeight),a
  ld   hl,0
  ld   (IOScreenPosition),hl
  pop  hl
  pop  de
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

  ld   a,l
PrintCharacter:
  push  de
  push  hl
  ld   e,a
  ld   a,(IOColour)
  ld   d,a
  ld   hl,(IOScreenPosition)
  call  WriteCharacter
  inc  hl
  ld   (IOScreenPosition),hl
  pop  hl
  pop  de
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

PrintString:
  push  hl
__IOASCIIZ:
  ld   a,(hl)
  or   a
  jr   z,__IOASCIIExit
  call PrintCharacter
  inc  hl
  jr   __IOASCIIZ
__IOASCIIExit:
  pop  hl
  ret

; ---------------------------------------------------------
; Name : gfx.mode.48k Type : word
; ---------------------------------------------------------

__mzdefine_67_66_78_2e_6d_6f_64_65_2e_34_38_6b:
    call COMHCreateCallToCode
SetMode48k:
  call  GFXInitialise48k
  jp   GFXInitialise
; *********************************************************************************
; *********************************************************************************
;
;  File:  screen48k.asm
;  Purpose: Hardware interface to Spectrum display, standard but with
;     sprites enabled.
;  Date :   8th November 2018
;  Author:  paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************
; *********************************************************************************
;
;      Call the SetMode for the Spectrum 48k
;
; *********************************************************************************
GFXInitialise48k:
  push  af          ; save registers
  push  bc
  ld   bc,$123B        ; Layer 2 access port
  ld   a,0         ; disable Layer 2
  out  (c),a
  nextreg $15,$3        ; Disable LowRes but enable Sprites
  ld   hl,$4000        ; clear pixel memory
__cs1: ld   (hl),0
  inc  hl
  ld   a,h
  cp   $58
  jr   nz,__cs1
__cs2: ld   (hl),$47       ; clear attribute memory
  inc  hl
  ld   a,h
  cp   $5B
  jr   nz,__cs2
  xor  a          ; border off
  out  ($FE),a
  pop  bc
  pop  af
  ld   hl,$1820        ; H = 24,L = 32, screen extent
  ld   de,GFXPrintCharacter48k
  ret
; *********************************************************************************
;
;    Write a character E on the screen at HL, in colour D
;
; *********************************************************************************
GFXPrintCharacter48k:
  push  af          ; save registers
  push  bc
  push  de
  push  hl
  ld   b,e         ; character in B
  ld   a,h         ; check range.
  cp   3
  jr   nc,__ZXWCExit
;
;  work out attribute position
;
  push  hl          ; save position.
  ld   a,h
  add  $58
  ld   h,a
  ld   a,d         ; get current colour
  and  7           ; mask 0..2
  or   $40          ; make bright
  ld   (hl),a         ; store it.
  pop  hl
;
;  calculate screen position => HL
;
  push  de
  ex   de,hl
  ld   l,e         ; Y5 Y4 Y3 X4 X3 X2 X1 X0
  ld   a,d
  and  3
  add  a,a
  add  a,a
  add  a,a
  or   $40
  ld   h,a
  pop  de
;
;  char# 32-127 to font address => DE
;
  push  hl
  ld   a,b         ; get character
  and  $7F         ; bits 0-6 only.
  sub  32
  ld   l,a         ; put in HL
  ld   h,0
  add  hl,hl         ; x 8
  add  hl,hl
  add  hl,hl
  ld   de,(SIFontBase)      ; add the font base.
  add  hl,de
  ex   de,hl         ; put in DE (font address)
  pop  hl
;
;  copy font data to screen position.
;
  ld   a,b
  ld   b,8         ; copy 8 characters
  ld   c,0         ; XOR value 0
  bit  7,a         ; is the character reversed
  jr   z,__ZXWCCopy
  dec  c          ; C is the XOR mask now $FF
__ZXWCCopy:
  ld   a,(de)        ; get font data
  xor  c          ; xor with reverse
  ld   (hl),a         ; write back
  inc  h          ; bump pointers
  inc  de
  djnz  __ZXWCCopy        ; do B times.
__ZXWCExit:
  pop  hl          ; restore and exit
  pop  de
  pop  bc
  pop  af
  ret

; ---------------------------------------------------------
; Name : gfx.mode.layer2 Type : word
; ---------------------------------------------------------

__mzdefine_67_66_78_2e_6d_6f_64_65_2e_6c_61_79_65_72_32:
    call COMHCreateCallToCode
SetModeLayer2:
  call  GFXInitialiseLayer2
  jp   GFXInitialise
; *********************************************************************************
; *********************************************************************************
;
;  File:  screen_layer2.asm
;  Purpose: Layer 2 console interface, sprites enabled, no shadow.
;  Date :   8th November 2018
;  Author:  paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************
; *********************************************************************************
;
;        Clear Layer 2 Display.
;
; *********************************************************************************
GFXInitialiseLayer2:
  push  af
  push  bc
  push  de
  nextreg $15,$3        ; Disable LowRes but enable Sprites
  ld   e,2         ; 3 banks to erase
L2PClear:
  ld   a,e         ; put bank number in bits 6/7
  rrc  a
  rrc  a
  or   2+1         ; shadow on, visible, enable write paging
  ld   bc,$123B        ; out to layer 2 port
  out  (c),a
  ld   hl,$4000        ; erase the bank to $00
L2PClearBank:           ; assume default palette :)
  dec  hl
  ld   (hl),$00
  ld   a,h
  or   l
  jr  nz,L2PClearBank
  dec  e
  jp   p,L2PClear
  xor  a
  out  ($FE),a
  pop  de
  pop  bc
  pop  af
  ld   hl,$1820        ; still 32 x 24
  ld   de,GFXPrintCharacterLayer2
  ret
;
;  Print Character E, colour D, position HL
;
GFXPrintCharacterLayer2:
  push  af
  push  bc
  push  de
  push  hl
  push  ix
  ld   b,e         ; save A temporarily
  ld   a,b
  and  $7F
  cp   32
  jr   c,__L2Exit        ; check char in range
  ld   a,h
  cp   3
  jr   nc,__L2Exit       ; check position in range
  ld   a,b
  push  af
  xor  a          ; convert colour in C to palette index
  bit  0,d         ; (assumes standard palette)
  jr   z,__L2Not1
  or   $03
__L2Not1:
  bit  2,d
  jr   z,__L2Not2
  or   $1C
__L2Not2:
  bit  1,d
  jr   z,__L2Not3
  or   $C0
__L2Not3:
  ld   c,a         ; C is foreground
  ld   b,0         ; B is xor flipper, initially zero
  pop  af          ; restore char
  push  hl
  bit  7,a         ; adjust background bit on bit 7
  jr   z,__L2NotCursor
  ld   b,$FF         ; light grey is cursor
__L2NotCursor:
  and  $7F         ; offset from space
  sub  $20
  ld   l,a         ; put into HL
  ld   h,0
  add  hl,hl         ; x 8
  add  hl,hl
  add  hl,hl
  push  hl          ; transfer to IX
  pop  ix
  pop  hl
  push  bc          ; add the font base to it.
  ld   bc,(SIFontBase)
  add  ix,bc
  pop  bc
  ;
  ;  figure out the correct bank.
  ;
  push  bc
  ld   a,h         ; this is the page number.
  rrc  a
  rrc  a
  and  $C0         ; in bits 6 & 7
  or   $03         ; shadow on, visible, enable write pagin.
  ld   bc,$123B        ; out to layer 2 port
  out  (c),a
  pop  bc
  ;
  ;   now figure out position in bank
  ;
  ex   de,hl
  ld   l,e
  ld   h,0
  add  hl,hl
  add  hl,hl
  add  hl,hl
  sla  h
  sla  h
  sla  h
  ld   e,8         ; do 8 rows
__L2Outer:
  push  hl          ; save start
  ld   d,8         ; do 8 columns
  ld   a,(ix+0)        ; get the bit pattern
  xor  b          ; maybe flip it ?
  inc  ix
__L2Loop:
  ld   (hl),0         ; background
  add  a,a         ; shift pattern left
  jr   nc,__L2NotSet
  ld   (hl),c         ; if MSB was set, overwrite with fgr
__L2NotSet:
  inc  hl
  dec  d          ; do a row
  jr   nz, __L2Loop
  pop  hl          ; restore, go 256 bytes down.
  inc  h
  dec  e          ; do 8 rows
  jr   nz,__L2Outer
__L2Exit:
  pop  ix
  pop  hl
  pop  de
  pop  bc
  pop  af
  ret

; ---------------------------------------------------------
; Name : gfx.mode.lowres Type : word
; ---------------------------------------------------------

__mzdefine_67_66_78_2e_6d_6f_64_65_2e_6c_6f_77_72_65_73:
    call COMHCreateCallToCode
SetModeLowres:
  call  GFXInitialiseLowRes
  jp   GFXInitialise
; *********************************************************************************
; *********************************************************************************
;
;  File:  screen_lores.asm
;  Purpose: LowRes console interface, sprites enabled.
;  Date :   8th November 2018
;  Author:  paul@robsons.org.uk
;
; *********************************************************************************
; *********************************************************************************
; *********************************************************************************
;
;        Clear LowRes Display.
;
; *********************************************************************************
GFXInitialiseLowRes:
  push  af
  push  bc
  push  de
  nextreg $15,$83        ; Enable LowRes and enable Sprites
  xor  a          ; layer 2 off.
  ld   bc,$123B        ; out to layer 2 port
  out  (c),a
  ld   hl,$4000        ; erase the bank to $00
  ld   de,$6000
LowClearScreen:          ; assume default palette :)
  xor  a
  ld   (hl),a
  ld   (de),a
  inc  hl
  inc  de
  ld   a,h
  cp   $58
  jr  nz,LowClearScreen
  xor  a
  out  ($FE),a
  pop  de
  pop  bc
  pop  af
  ld   hl,$0C10        ; resolution is 16x12 chars
  ld   de,GFXPrintCharacterLowRes
  ret
;
;  Print Character E Colour D @ HL
;
GFXPrintCharacterLowRes:
  push  af
  push  bc
  push  de
  push  hl
  push  ix
  ld   b,e         ; save character in B
  ld   a,e
  and  $7F
  cp   32
  jr   c,__LPExit
  add  hl,hl
  add  hl,hl
  ld   a,h         ; check in range 192*4 = 768
  cp   3
  jr   nc,__LPExit
  ld   a,d         ; only lower 3 bits of colour
  and  7
  ld   c,a         ; C is foreground
  push  hl
  ld   a,b         ; get char back
  ld   b,0         ; B = no flip colour.
  bit  7,a
  jr   z,__LowNotReverse      ; but 7 set, flip is $FF
  dec  b
__LowNotReverse:
  and  $7F         ; offset from space
  sub  $20
  ld   l,a         ; put into HL
  ld   h,0
  add  hl,hl         ; x 8
  add  hl,hl
  add  hl,hl
  push  hl          ; transfer to IX
  pop  ix
  push  bc          ; add the font base to it.
  ld   bc,(SIFontBase)
  add  ix,bc
  pop  bc
  pop  hl
  ex   de,hl
  ld   a,e         ; put DE => HL
  and  192         ; these are part of Y
  ld   l,a          ; Y multiplied by 4 then 32 = 128
  ld   h,d
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
  set  6,h         ; put into $4000 range
  ld   a,15*4         ; mask for X, which has been premultiplied.
  and  e          ; and with E, gives X position
  add  a,a         ; now multiplied by 8.
  ld   e,a         ; DE is x offset.
  ld   d,0
  add  hl,de
  ld   a,h
  cp   $58         ; need to be shifted to 2nd chunk ?
  jr   c,__LowNotLower2
  ld   de,$0800
  add  hl,de
__LowNotLower2:
  ld   e,8         ; do 8 rows
__LowOuter:
  push  hl          ; save start
  ld   d,8         ; do 8 columns
  ld   a,(ix+0)        ; get the bit pattern
  xor  b
  inc  ix
__LowLoop:
  ld   (hl),0         ; background
  add  a,a         ; shift pattern left
  jr   nc,__LowNotSet
  ld   (hl),c         ; if MSB was set, overwrite with fgr
__LowNotSet:
  inc  l
  dec  d          ; do a row
  jr   nz, __LowLoop
  pop  hl          ; restore, go 256 bytes down.
  push  de
  ld   de,128
  add  hl,de
  pop  de
  dec  e          ; do 8 rows
  jr   nz,__LowOuter
__LPExit:
  pop  ix
  pop  hl
  pop  de
  pop  bc
  pop  af
  ret

; ---------------------------------------------------------
; Name : gfx.write.char Type : word
; ---------------------------------------------------------

__mzdefine_67_66_78_2e_77_72_69_74_65_2e_63_68_61_72:
    call COMHCreateCallToCode
WriteCharacter:
  push  bc
  push  de
  push  hl
  ld   bc,__WCContinue
  push  bc
  ld   bc,(SIScreenDriver)
  push  bc
  ret
__WCContinue:
  pop  hl
  pop  de
  pop  bc
  ret

; ---------------------------------------------------------
; Name : +! Type : word
; ---------------------------------------------------------

__mzdefine_2b_21:
    call COMHCreateCallToCode
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl
  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  dec  hl
  ret

; ---------------------------------------------------------
; Name : @ Type : macro
; ---------------------------------------------------------

__mzdefine_40:
    call COMHCopyFollowingCode
    db __mzdefine_40_end-__mzdefine_40-4
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
__mzdefine_40_end:

; ---------------------------------------------------------
; Name : c@ Type : macro
; ---------------------------------------------------------

__mzdefine_63_40:
    call COMHCopyFollowingCode
    db __mzdefine_63_40_end-__mzdefine_63_40-4
  ld   l,(hl)
  ld   h,0
__mzdefine_63_40_end:

; ---------------------------------------------------------
; Name : p@ Type : word
; ---------------------------------------------------------

__mzdefine_70_40:
    call COMHCreateCallToCode
  push  bc
  ld   c,l
  ld   b,h
  in   l,(c)
  ld   h,0
  pop  bc
  ret

; ---------------------------------------------------------
; Name : p! Type : word
; ---------------------------------------------------------

__mzdefine_70_21:
    call COMHCreateCallToCode
  push  bc
  ld   c,l
  ld   b,h
  out  (c),e
  pop  bc
  ret

; ---------------------------------------------------------
; Name : ! Type : macro
; ---------------------------------------------------------

__mzdefine_21:
    call COMHCopyFollowingCode
    db __mzdefine_21_end-__mzdefine_21-4
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
__mzdefine_21_end:

; ---------------------------------------------------------
; Name : c! Type : macro
; ---------------------------------------------------------

__mzdefine_63_21:
    call COMHCopyFollowingCode
    db __mzdefine_63_21_end-__mzdefine_63_21-4
  ld   (hl),e
__mzdefine_63_21_end:

; ---------------------------------------------------------
; Name : break protected Type : macro
; ---------------------------------------------------------

__mzdefine_62_72_65_61_6b:
    call COMHCopyFollowingCode
    db __mzdefine_62_72_65_61_6b_end-__mzdefine_62_72_65_61_6b-4+128
  db   $DD,$01
__mzdefine_62_72_65_61_6b_end:

; ---------------------------------------------------------
; Name : copy Type : word
; ---------------------------------------------------------

__mzdefine_63_6f_70_79:
    call COMHCreateCallToCode
  ld   a,b         ; nothing to do.
  or   c
  ret  z
  push  bc
  push  de
  push  hl
  xor  a          ; find direction.
  sbc  hl,de
  ld   a,h
  add  hl,de
  bit  7,a         ; if +ve use LDDR
  jr   z,__copy2
  ex   de,hl         ; LDIR etc do (DE) <- (HL)
  ldir
__copyExit:
  pop  hl
  pop  de
  pop  bc
  ret
__copy2:
  add  hl,bc         ; add length to HL,DE, swap as LDDR does (DE) <- (HL)
  ex   de,hl
  add  hl,bc
  dec  de          ; -1 to point to last byte
  dec  hl
  lddr
  jr   __copyExit

; ---------------------------------------------------------
; Name : debug Type : word
; ---------------------------------------------------------

__mzdefine_64_65_62_75_67:
    call COMHCreateCallToCode
DebugShow:
  push  bc
  push  de
  push  hl
  push  bc
  push  de
  push  hl
  ld   a,(SIScreenHeight)     ; on the bottom line
  dec  a
  ld  e,a
  ld  d,0
  ld   h,d
  ld   a,(SIScreenWidth)
  ld   l,a
  call  MULTMultiply16
  pop  de          ; display A
  ld   c,'A'
  call  __DisplayHexInteger
  pop  de          ; display B
  ld   c,'B'
  call  __DisplayHexInteger
  pop  de          ; display B
  ld   c,'C'
  call  __DisplayHexInteger
  pop  hl
  pop  de
  pop  bc
  ret
__DisplayHexInteger:
  push  de
  ld   d,6
  ld   e,c
  set  7,e
  call  WriteCharacter
  inc  hl
  pop  de
  ld   a,d
  call  __DisplayHexByte
  ld   a,e
__DisplayHexByte:
  push  af
  rrc  a
  rrc  a
  rrc  a
  rrc  a
  call  __DisplayHexNibble
  pop  af
__DisplayHexNibble:
  push  de
  ld   d,4
  and  15
  cp   10
  jr   c,__DHN2
  add  a,7
__DHN2: add  a,48
  ld   e,a
  call  WriteCharacter
  inc  hl
  pop  de
  ret

; ---------------------------------------------------------
; Name : .hex Type : word
; ---------------------------------------------------------

__mzdefine_2e_68_65_78:
    call COMHCreateCallToCode
PrintHexWord:
  ld   a,' '
  call  PrintCharacter
  ld   a,h
  call  PrintHexByte
  ld   a,l
  call  PrintHexByte
  ret
; *********************************************************************************
;
;        Print A in hexadecimal
;
; *********************************************************************************
PrintHexByte:
  push  af
  rrc  a
  rrc  a
  rrc  a
  rrc  a
  call  __PrintNibble
  pop  af
__PrintNibble:
  and  15
  cp   10
  jr   c,__PNIsDigit
  add  7
__PNIsDigit:
  add  48
  jp   PrintCharacter

; ---------------------------------------------------------
; Name : fill Type : word
; ---------------------------------------------------------

__mzdefine_66_69_6c_6c:
    call COMHCreateCallToCode
  ld   a,b         ; nothing to do.
  or   c
  ret  z
  push bc
  push  hl
__fill1:ld   (hl),e
  inc  hl
  dec  bc
  ld   a,b
  or   c
  jr   nz,__fill1
  pop  hl
  pop  bc
  ret

; ---------------------------------------------------------
; Name : halt Type : word
; ---------------------------------------------------------

__mzdefine_68_61_6c_74:
    call COMHCreateCallToCode
HaltZ80:
  di
  halt
  jr   HaltZ80

; ---------------------------------------------------------
; Name : inkey Type : word
; ---------------------------------------------------------

__mzdefine_69_6e_6b_65_79:
    call COMHCreateCallToCode
  ex   de,hl
  call  IOScanKeyboard
  ld   l,a
  ld   h,0
  ret

; ---------------------------------------------------------
; Name : ; protected Type : macro
; ---------------------------------------------------------

__mzdefine_3b:
    call COMHCopyFollowingCode
    db __mzdefine_3b_end-__mzdefine_3b-4+128
  ret
__mzdefine_3b_end:

; ---------------------------------------------------------
; Name : sys.info Type : word
; ---------------------------------------------------------

__mzdefine_73_79_73_2e_69_6e_66_6f:
    call COMHCreateCallToCode
  ex   de,hl
  ld   hl,SystemInformation
  ret

; ---------------------------------------------------------
; Name : abc>r protected Type : macro
; ---------------------------------------------------------

__mzdefine_61_62_63_3e_72:
    call COMHCopyFollowingCode
    db __mzdefine_61_62_63_3e_72_end-__mzdefine_61_62_63_3e_72-4+128
 push  bc
 push  de
 push  hl
__mzdefine_61_62_63_3e_72_end:

; ---------------------------------------------------------
; Name : ab>r protected Type : macro
; ---------------------------------------------------------

__mzdefine_61_62_3e_72:
    call COMHCopyFollowingCode
    db __mzdefine_61_62_3e_72_end-__mzdefine_61_62_3e_72-4+128
 push  de
 push  hl
__mzdefine_61_62_3e_72_end:

; ---------------------------------------------------------
; Name : a>b Type : macro
; ---------------------------------------------------------

__mzdefine_61_3e_62:
    call COMHCopyFollowingCode
    db __mzdefine_61_3e_62_end-__mzdefine_61_3e_62-4
 ld   d,h
 ld   e,l
__mzdefine_61_3e_62_end:

; ---------------------------------------------------------
; Name : a>c Type : macro
; ---------------------------------------------------------

__mzdefine_61_3e_63:
    call COMHCopyFollowingCode
    db __mzdefine_61_3e_63_end-__mzdefine_61_3e_63-4
 ld   b,h
 ld   c,l
__mzdefine_61_3e_63_end:

; ---------------------------------------------------------
; Name : a>r protected Type : macro
; ---------------------------------------------------------

__mzdefine_61_3e_72:
    call COMHCopyFollowingCode
    db __mzdefine_61_3e_72_end-__mzdefine_61_3e_72-4+128
 push  hl
__mzdefine_61_3e_72_end:

; ---------------------------------------------------------
; Name : b>a Type : macro
; ---------------------------------------------------------

__mzdefine_62_3e_61:
    call COMHCopyFollowingCode
    db __mzdefine_62_3e_61_end-__mzdefine_62_3e_61-4
 ld   h,d
 ld   l,e
__mzdefine_62_3e_61_end:

; ---------------------------------------------------------
; Name : b>c Type : macro
; ---------------------------------------------------------

__mzdefine_62_3e_63:
    call COMHCopyFollowingCode
    db __mzdefine_62_3e_63_end-__mzdefine_62_3e_63-4
 ld   b,d
 ld   c,e
__mzdefine_62_3e_63_end:

; ---------------------------------------------------------
; Name : b>r protected Type : macro
; ---------------------------------------------------------

__mzdefine_62_3e_72:
    call COMHCopyFollowingCode
    db __mzdefine_62_3e_72_end-__mzdefine_62_3e_72-4+128
 push  de
__mzdefine_62_3e_72_end:

; ---------------------------------------------------------
; Name : c>a Type : macro
; ---------------------------------------------------------

__mzdefine_63_3e_61:
    call COMHCopyFollowingCode
    db __mzdefine_63_3e_61_end-__mzdefine_63_3e_61-4
 ld   h,b
 ld   l,c
__mzdefine_63_3e_61_end:

; ---------------------------------------------------------
; Name : c>b Type : macro
; ---------------------------------------------------------

__mzdefine_63_3e_62:
    call COMHCopyFollowingCode
    db __mzdefine_63_3e_62_end-__mzdefine_63_3e_62-4
 ld   d,b
 ld   e,c
__mzdefine_63_3e_62_end:

; ---------------------------------------------------------
; Name : c>r protected Type : macro
; ---------------------------------------------------------

__mzdefine_63_3e_72:
    call COMHCopyFollowingCode
    db __mzdefine_63_3e_72_end-__mzdefine_63_3e_72-4+128
 push  bc
__mzdefine_63_3e_72_end:

; ---------------------------------------------------------
; Name : r>a protected Type : macro
; ---------------------------------------------------------

__mzdefine_72_3e_61:
    call COMHCopyFollowingCode
    db __mzdefine_72_3e_61_end-__mzdefine_72_3e_61-4+128
 pop  hl
__mzdefine_72_3e_61_end:

; ---------------------------------------------------------
; Name : r>ab protected Type : macro
; ---------------------------------------------------------

__mzdefine_72_3e_61_62:
    call COMHCopyFollowingCode
    db __mzdefine_72_3e_61_62_end-__mzdefine_72_3e_61_62-4+128
 pop  hl
 pop  de
__mzdefine_72_3e_61_62_end:

; ---------------------------------------------------------
; Name : r>abc protected Type : macro
; ---------------------------------------------------------

__mzdefine_72_3e_61_62_63:
    call COMHCopyFollowingCode
    db __mzdefine_72_3e_61_62_63_end-__mzdefine_72_3e_61_62_63-4+128
 pop  hl
 pop  de
 pop  bc
__mzdefine_72_3e_61_62_63_end:

; ---------------------------------------------------------
; Name : r>b protected Type : macro
; ---------------------------------------------------------

__mzdefine_72_3e_62:
    call COMHCopyFollowingCode
    db __mzdefine_72_3e_62_end-__mzdefine_72_3e_62-4+128
 pop  de
__mzdefine_72_3e_62_end:

; ---------------------------------------------------------
; Name : r>c protected Type : macro
; ---------------------------------------------------------

__mzdefine_72_3e_63:
    call COMHCopyFollowingCode
    db __mzdefine_72_3e_63_end-__mzdefine_72_3e_63-4+128
 pop  bc
__mzdefine_72_3e_63_end:

; ---------------------------------------------------------
; Name : swap Type : macro
; ---------------------------------------------------------

__mzdefine_73_77_61_70:
    call COMHCopyFollowingCode
    db __mzdefine_73_77_61_70_end-__mzdefine_73_77_61_70-4
 ex   de,hl
__mzdefine_73_77_61_70_end:

; ---------------------------------------------------------
; Name : 0= Type : word
; ---------------------------------------------------------

__mzdefine_30_3d:
    call COMHCreateCallToCode
  ld  a,h
  or  l
  ld  hl,$0000
  ret nz
  dec hl
  ret

; ---------------------------------------------------------
; Name : 0< Type : word
; ---------------------------------------------------------

__mzdefine_30_3c:
    call COMHCreateCallToCode
  bit 7,h
  ld  hl,$0000
  ret z
  dec hl
  ret

; ---------------------------------------------------------
; Name : 0- Type : word
; ---------------------------------------------------------

__mzdefine_30_2d:
    call COMHCreateCallToCode
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  inc hl
  ret

; ---------------------------------------------------------
; Name : 16/ Type : word
; ---------------------------------------------------------

__mzdefine_31_36_2f:
    call COMHCreateCallToCode
  sra  h
  rr   l
  sra  h
  rr   l
  sra  h
  rr   l
  sra  h
  rr   l
  ret

; ---------------------------------------------------------
; Name : 16* Type : macro
; ---------------------------------------------------------

__mzdefine_31_36_2a:
    call COMHCopyFollowingCode
    db __mzdefine_31_36_2a_end-__mzdefine_31_36_2a-4
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
__mzdefine_31_36_2a_end:

; ---------------------------------------------------------
; Name : 1- Type : macro
; ---------------------------------------------------------

__mzdefine_31_2d:
    call COMHCopyFollowingCode
    db __mzdefine_31_2d_end-__mzdefine_31_2d-4
  dec hl
__mzdefine_31_2d_end:

; ---------------------------------------------------------
; Name : 1+ Type : macro
; ---------------------------------------------------------

__mzdefine_31_2b:
    call COMHCopyFollowingCode
    db __mzdefine_31_2b_end-__mzdefine_31_2b-4
  inc hl
__mzdefine_31_2b_end:

; ---------------------------------------------------------
; Name : 256/ Type : word
; ---------------------------------------------------------

__mzdefine_32_35_36_2f:
    call COMHCreateCallToCode
  ld   l,h
  ld   h,0
  bit  7,l
  ret  z
  dec  h
  ret

; ---------------------------------------------------------
; Name : 256* Type : macro
; ---------------------------------------------------------

__mzdefine_32_35_36_2a:
    call COMHCopyFollowingCode
    db __mzdefine_32_35_36_2a_end-__mzdefine_32_35_36_2a-4
  ld   h,l
  ld   l,0
__mzdefine_32_35_36_2a_end:

; ---------------------------------------------------------
; Name : 2/ Type : macro
; ---------------------------------------------------------

__mzdefine_32_2f:
    call COMHCopyFollowingCode
    db __mzdefine_32_2f_end-__mzdefine_32_2f-4
  sra  h
  rr   l
__mzdefine_32_2f_end:

; ---------------------------------------------------------
; Name : 2- Type : macro
; ---------------------------------------------------------

__mzdefine_32_2d:
    call COMHCopyFollowingCode
    db __mzdefine_32_2d_end-__mzdefine_32_2d-4
  dec hl
  dec hl
__mzdefine_32_2d_end:

; ---------------------------------------------------------
; Name : 2+ Type : macro
; ---------------------------------------------------------

__mzdefine_32_2b:
    call COMHCopyFollowingCode
    db __mzdefine_32_2b_end-__mzdefine_32_2b-4
  inc hl
  inc hl
__mzdefine_32_2b_end:

; ---------------------------------------------------------
; Name : 2* Type : macro
; ---------------------------------------------------------

__mzdefine_32_2a:
    call COMHCopyFollowingCode
    db __mzdefine_32_2a_end-__mzdefine_32_2a-4
  add  hl,hl
__mzdefine_32_2a_end:

; ---------------------------------------------------------
; Name : 4/ Type : word
; ---------------------------------------------------------

__mzdefine_34_2f:
    call COMHCreateCallToCode
  sra  h
  rr   l
  sra  h
  rr   l
  ret

; ---------------------------------------------------------
; Name : 4* Type : macro
; ---------------------------------------------------------

__mzdefine_34_2a:
    call COMHCopyFollowingCode
    db __mzdefine_34_2a_end-__mzdefine_34_2a-4
  add  hl,hl
  add  hl,hl
__mzdefine_34_2a_end:

; ---------------------------------------------------------
; Name : 8* Type : macro
; ---------------------------------------------------------

__mzdefine_38_2a:
    call COMHCopyFollowingCode
    db __mzdefine_38_2a_end-__mzdefine_38_2a-4
  add  hl,hl
  add  hl,hl
  add  hl,hl
__mzdefine_38_2a_end:

; ---------------------------------------------------------
; Name : abs Type : word
; ---------------------------------------------------------

__mzdefine_61_62_73:
    call COMHCreateCallToCode
  bit 7,h
  ret z
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  inc hl
  ret

; ---------------------------------------------------------
; Name : bswap Type : macro
; ---------------------------------------------------------

__mzdefine_62_73_77_61_70:
    call COMHCopyFollowingCode
    db __mzdefine_62_73_77_61_70_end-__mzdefine_62_73_77_61_70-4
  ld   a,l
  ld   l,h
  ld   h,a
__mzdefine_62_73_77_61_70_end:

; ---------------------------------------------------------
; Name : max Type : word
; ---------------------------------------------------------

__mzdefine_6d_61_78:
    call COMHCreateCallToCode
 ld   a,h
    xor  d
    jp   m,__Max2
    push  hl
    sbc  hl,de
    pop  hl
    ret  nc
    ex   de,hl
    ret
__Max2:
 bit  7,h
 ret  z
 ex   de,hl
 ret

; ---------------------------------------------------------
; Name : min Type : word
; ---------------------------------------------------------

__mzdefine_6d_69_6e:
    call COMHCreateCallToCode
 ld   a,h
    xor  d
    jp   m,__Min2
    push  hl
    sbc  hl,de
    pop  hl
    ret  c
    ex   de,hl
    ret
__Min2:
 bit  7,h
 ret  nz
 ex   de,hl
 ret

; ---------------------------------------------------------
; Name : not Type : word
; ---------------------------------------------------------

__mzdefine_6e_6f_74:
    call COMHCreateCallToCode
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  ret

; ---------------------------------------------------------
; Name : c, Type : word
; ---------------------------------------------------------

__mzdefine_63_2c:
    call COMHCreateCallToCode
  ld   a,l
  jp    FARCompileByte

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ***********************************************************************************************
; ***********************************************************************************************
;
;         Compile word at HL
;
; ***********************************************************************************************
; ***********************************************************************************************
COMCompileWord:
  push  bc
  push  de
  push  hl
  push  hl        ; save word address
  call  DICTFindWord      ; try to find it
  pop  bc         ; restore word address to BC
  jr   nc,__COMCWWordFound
  ld   h,b        ; put back in HL
  ld   l,c
  call  CONSTConvert      ; convert it to a constant
  jr   nc,__COMCWConstant     ; write code to load that.
  scf
__COMCWExit:
  pop  hl
  pop  de
  pop  bc
  ret
;
;  Word found in dictionary
;
__COMCWWordFound:
  call  COMUTLExecuteEHL      ; execute the word.
  xor  a          ; exit happy
  jr   __COMCWExit
;
;  Decimal constant found.
;
__COMCWConstant:
  call  COMUTLConstantCode      ; compile as constant
  xor  a          ; exit happy
  jr   __COMCWExit

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ***********************************************************************************************
;
;   Convert ASCIIZ string at HL to constant in HL. DE 0, Carry Clear if true
;
; ***********************************************************************************************
CONSTConvert:
 push  bc
 ex   de,hl          ; string in DE.
 ld   hl,$0000        ; result in HL.
 ld   c,0          ; C is set if negative
 ld   a,(de)         ; check if -x
 cp   '-'
 jr   nz,__CONConvLoop
 inc  de           ; skip over - sign.
 inc  c           ; C is sign flag
__CONConvLoop:
 ld   a,(de)         ; get next character
 inc  de
 cp   '0'          ; must be 0-9 otherwise
 jr   c,__CONConFail
 cp   '9'+1
 jr   nc,__CONConFail
 push  bc
 push  hl           ; HL -> BC
 pop  bc
 add  hl,hl          ; HL := HL * 4 + BC
 add  hl,hl
 add  hl,bc
 add  hl,hl          ; HL := HL * 10
 ld   b,0          ; add the digit into HL
 and  15
 ld   c,a
 add  hl,bc
 pop  bc
 ld   a,(de)
 cp   ' '+1
 jr   nc,__CONConvLoop
 ld   a,c
 or   a
 jr   z,__CONConNotNegative
 ld   a,h          ; negate HL
 cpl
 ld   h,a
 ld   a,l
 cpl
 ld   l,a
 inc  hl
__CONConNotNegative:
 ld   de,$0000
 xor  a           ; clear carry
 pop  bc
 ret
__CONConFail:           ; didn't convert
 ld   hl,$FFFF
 ld   de,$FFFF
 scf
 pop  bc
 ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ***********************************************************************************************
;
;         Generate code for constant in HL
;
; ***********************************************************************************************
COMUTLConstantCode:
  ld   a,$EB         ; ex de,hl
  call  FARCompileByte
  ld   a,$21         ; ld hl,const
  call  FARCompileByte
  call  FARCompileWord       ; compile the constant
  ret
; ***********************************************************************************************
;
;    Compile code to call EHL from current compile position
;
; ***********************************************************************************************
COMUTLCodeCallEHL:
  ld   a,$CD         ; call <Address>
  call  FARCompileByte
  call  FARCompileWord       ; compile the constant
  ret
; ***********************************************************************************************
;
;         Execute code at EHL
;
; ***********************************************************************************************
COMUTLExecuteEHL:
  ld   a,e         ; switch to that page
  call  PAGESwitch
  ld   de,COMUTLExecuteExit     ; push after code address
  push  de
  push  hl          ; push call address
  ld   hl,(ARegister)       ; load registers
  ld   de,(BRegister)
  ld   bc,(CRegister)
  ret           ; execute the call
COMUTLExecuteExit:
  ld   (CRegister),bc       ; save registers
  ld   (BRegister),de
  ld   (ARegister),hl
  call  PAGERestore
  ret
; ***********************************************************************************************
;
;  Copy a macro. The return address points to ld a,<count> followed by the macro contents
;  Note only the lower 4 bits of the count are valid.
;
; ***********************************************************************************************
COMHCopyFollowingCode:
  pop  hl           ; get return address
  ld   a,(hl)          ; get count in bits 0..3
  and  15
  ld   b,a
__COMHCFCLoop:            ; copy bytes
  inc  hl
  ld   a,(hl)
  call  FARCompileByte
  djnz  __COMHCFCLoop
  ret
; ***********************************************************************************************
;
;   Create a call to the code following this caller. It is running in page A'
;
; ***********************************************************************************************
COMHCreateCallToCode:
  pop  hl           ; get the address of the code.
  call  COMUTLCodeCallEHL       ; compile a call to E:HL from here.
  ret

; ---------------------------------------------------------
; Name : , Type : word
; ---------------------------------------------------------

__mzdefine_2c:
    call COMHCreateCallToCode
  jp  FARCompileWord

; ---------------------------------------------------------
; Name : :: Type : immediate
; ---------------------------------------------------------

__mzdefine_3a_3a:
  call  DICTGetWordAddDictionary
  ret
DICTGetWordAddDictionary:
  push de
  push  hl
  call  PARSEGetNextWord      ; get the next word.
  jr   c,__GWADError       ; nothing to get.
  call  DICTAddWord       ; add it to the dictionary.
  pop  hl
  pop  de
  ret
__GWADError:           ; nothing to get.
  ld   hl,__GWADMessage
  jp   ErrorHandler
__GWADMessage:
  db   "No word available for definition",0

; ---------------------------------------------------------
; Name : : Type : immediate
; ---------------------------------------------------------

__mzdefine_3a:
  call  DICTGetWordAddDictionary
  ld   a,$CD
  call FARCompileByte
  ld   hl,COMHCreateCallToCode
  call  FARCompileWord
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ***********************************************************************************************
;
;   Find word in dictionary. HL points to name, on exit, HL is the address, D the
;   type ID and E the page number with CC if found, CS set and HL=DE=0 if not found.
;
; ***********************************************************************************************
DICTFindWord:
  push  bc         ; save registers - return in DEHL Carry
  push  ix
  ld   a,DictionaryPage     ; switch to dictionary page
  call  PAGESwitch
  ld   ix,$C000       ; dictionary start
__DICTFindMainLoop:
  ld   a,(ix+0)      ; examine offset, exit if zero.
  or   a
  jr   z,__DICTFindFail
  push  ix         ; save pointers on stack.
  push  hl
  ld   b,(ix+4)       ; characters to compare
__DICTCheckName:
  ld   a,(ix+5)       ; compare dictionary vs character.
  cp  (hl)         ; compare vs the matching character.
  jr   nz,__DICTFindNoMatch    ; no, not the same word.
  inc  hl         ; HL point to next character
  inc  ix
  djnz  __DICTCheckName
  ld   a,(hl)       ; if so, see if the next one is EOW
  cp   ' '+1
  jr   nc,__DICTFindNoMatch    ; if not , bad match.
  pop  hl         ; Found a match. restore HL and IX
  pop  ix
  ld   d,(ix+4)       ; D = type/length
  ld   e,(ix+1)      ; E = page
  ld   l,(ix+2)      ; HL = address
  ld   h,(ix+3)
  xor  a         ; clear the carry flag.
  jr   __DICTFindExit
__DICTFindNoMatch:        ; this one doesn't match.
  pop  hl         ; restore HL and IX
  pop  ix
__DICTFindNext:
  ld   e,(ix+0)      ; DE = offset
  ld   d,$00
  add  ix,de        ; next word.
  jr   __DICTFindMainLoop    ; and try the next one.
__DICTFindFail:
  ld   de,$0000       ; return all zeros.
  ld   hl,$0000
  scf          ; set carry flag
__DICTFindExit:
  push  af
  call  PAGERestore
  pop  af
  pop  ix         ; pop registers and return.
  pop  bc
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ***********************************************************************************************
;
;  Add Dictionary Word. Name is string at HL ends in <= ' ', uses the current page/pointer
;  values.
;
; ***********************************************************************************************
DICTAddWord:
  push  af          ; registers to stack.
  push  bc
  push  de
  push hl
  push  ix
  push  hl          ; put length of string in B
  ld   b,-1
__DICTAddGetLength:
  ld   a,(hl)
  inc  hl
  inc  b
  cp   ' '+1
  jr   nc,__DICTAddGetLength
  pop  hl
  ld   a,DictionaryPage     ; switch to dictionary page
  call  PAGESwitch
  ld   ix,$C000       ; IX = Start of dictionary
__DICTFindEndDictionary:
  ld   a,(ix+0)        ; follow down chain to the end
  or   a
  jr   z,__DICTCreateEntry
  ld   e,a
  ld   d,0
  add  ix,de
  jr   __DICTFindEndDictionary
__DICTCreateEntry:
  ld   a,b
  add  a,5
  ld   (ix+0),a        ; offset is length + 5
  ld   a,(SINextFreeCodePage)    ; code page
  ld   (ix+1),a
  ld   de,(SINextFreeCode)     ; code address
  ld   (ix+2),e
  ld   (ix+3),d
  ld   (ix+4),b        ; length
  ex   de,hl         ; put name in DE
__DICTAddCopy:
  ld   a,(de)         ; copy byte over as 7 bit ASCII.
  ld   (ix+5),a
  inc  de
  inc  ix
  djnz __DICTAddCopy       ; until string is copied over.
  ld   (ix+5),0        ; write end of dictionary zero.
  call  PAGERestore
  pop  ix          ; restore and exit
  pop  hl
  pop  de
  pop  bc
  pop  af
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ***********************************************************************************************
;
;        Byte compile far memory A
;
; ***********************************************************************************************
FARCompileByte:
  push  af          ; save byte and HL
  push  hl
  push  af          ; save byte
  ld  a,(SINextFreeCodePage)     ; switch to page
  call  PAGESwitch
  ld   hl,(SINextFreeCode)     ; write to memory location
  pop  af
  ld   (hl),a
  inc  hl          ; bump memory location
  ld   (SINextFreeCode),hl     ; write back
  call  PAGERestore
  pop  hl          ; restore and exit
  pop  af
  ret
; ***********************************************************************************************
;
;        Word compile far memory A/HL
;
; ***********************************************************************************************
FARCompileWord:
  push  af          ; save byte and HL
  push  de
  push  hl
  ex   de,hl         ; word into DE
  ld  a,(SINextFreeCodePage)     ; switch to page
  call  PAGESwitch
  ld   hl,(SINextFreeCode)     ; write to memory location
  ld   (hl),e
  inc  hl
  ld   (hl),d
  inc  hl
  ld   (SINextFreeCode),hl     ; write back
  call  PAGERestore
  pop  hl
  pop  de          ; restore and exit
  pop  af
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ********************************************************************************************************
; ********************************************************************************************************
;
;  Name :   loader.asm
;  Author :  Paul Robson (paul@robsons.org.uk)
;  Purpose :  Source loader
;  Date :   5th November 2018
;
; ********************************************************************************************************
; ********************************************************************************************************
; ********************************************************************************************************
;
;         Load the bootstrap page
;
; ********************************************************************************************************
LOADBootstrap:
  push  bc
  push  de
  push  hl
  push  ix
  ld   hl,__LOADBoot
  call  PrintString
  ld   a,BootstrapPage      ; set the current page to bootstrap page.
  call  PAGESwitch
  ld   ix,$C000        ; current section being loaded.
;
;  Once here for every 'chunk'. We copy the text to the editor buffer in
;  chunks (currently 1024 bytes) until we've done all 16k of the page.
;
__LOADBootLoop:
  push  ix          ; HL = Current Section
  pop  hl
  ld   de,EditBuffer        ; Copy to edit buffer 1k of code.
  ld   bc,EditBufferSize
  ldir
  ld   a,6         ; show progress by printing a '.'
  ld   (IOColour),a
  ld   a,'.'
  call  PrintCharacter
  ld   hl,EditBuffer       ; now scan the edit buffer
  call  LOADScanBuffer
  ld   de,EditBufferSize      ; add buffer size to IX
  add  ix,de
  push  ix         ; until wrapped round to $0000
  pop  hl
  ld   a,h
  or   l
  jr   nz,__LOADBootLoop
  pop  ix
  pop  hl
  pop  de
  pop  bc
  jp   HaltZ80
; ********************************************************************************************************
;
;         Process (compiling) the text at HL.
;
; ********************************************************************************************************
LOADScanBuffer:
  push  af
  push  bc
  push  de
  push  hl
  push  ix
  call  PARSESetWordPointer     ; set the word pointer.
__LOADScanLoop:
  call  PARSEGetNextWord     ; try to get next word text@HL type@B
  jr   c,__LOADScanExit
  call  COMCompileWord       ; compile the word at HL
  jr   c,__LOADErrorHandler     ; error ?
  jr   __LOADScanLoop
__LOADScanExit:
  pop  ix
  pop  hl
  pop  de
  pop  bc
  pop  af
  ret
; ********************************************************************************************************
;
;    Come here if an error has occurred (cannot find word, or it is protected)
;
; ********************************************************************************************************
__LOADErrorHandler:         ; unknown word @ HL
  ld   de,__LOADErrorMessage
  ld   bc,ErrorMessageBuffer
  push  bc
__LOADErrorCopyName:
  ld   a,(hl)
  ld   (bc),a
  inc  bc
  inc  hl
  cp   ' '+1
  jr   nc,__LOADErrorCopyName
  dec  bc
__LOADErrorCopyError:
  ld   a,(de)
  ld   (bc),a
  inc  bc
  inc  de
  or   a
  jr   nz,__LOADErrorCopyError
  pop  hl
  jp   ErrorHandler
__LOADErrorMessage:
  db   " : Unknown word",0
__LOADBoot:
  db   "MZ Bootstrap (10-11-18) ",0

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ********************************************************************************************************
;
;          Initialise Paging, set current to A
;
; ********************************************************************************************************
PAGEInitialise:
  nextreg $56,a         ; switch to page A
  inc  a
  nextreg $57,a
  dec  a
  ex   af,af'         ; put page in A'
  ld   hl,PAGEStackBase      ; reset the page stack
  ld   (PAGEStackPointer),hl
  ret
; ********************************************************************************************************
;
;          Switch to a new page A
;
; ********************************************************************************************************
PAGESwitch:
  push  af
  push  hl
  push  af          ; save A on stack
  ld   hl,(PAGEStackPointer)     ; put A' on the stack, the current page
  ex   af,af'
  ld   (hl),a
  inc  hl
  ld   (PAGEStackPointer),hl
  pop  af          ; restore new A
  nextreg $56,a         ; switch to page A
  inc  a
  nextreg $57,a
  dec  a
  ex   af,af'         ; put page in A'
  pop  hl
  pop  af
  ret
; ********************************************************************************************************
;
;          Return to the previous page
;
; ********************************************************************************************************
PAGERestore:
  push  af
  push  hl
  ld   hl,(PAGEStackPointer)     ; pop the old page off
  dec  hl
  ld   a,(hl)
  ld   (PAGEStackPointer),hl
  nextreg $56,a         ; switch to page A
  inc  a
  nextreg $57,a
  dec  a
  ex   af,af'         ; put page in A'
  pop  hl
  pop  af
  ret

; ---------------------------------------------------------
; Name :  Type : codeonly
; ---------------------------------------------------------

; ********************************************************************************************************
;
;      Set the pointer to the data to be parsed.
;
; ********************************************************************************************************
PARSESetWordPointer:
  ld   (PARSEPointer),hl
  ret
; ********************************************************************************************************
;
;   Get the next parsed element, return in HL, type in B CS if nothing to get.
;
; ********************************************************************************************************
PARSEGetNextWord:
  ld   hl,(PARSEPointer)     ; get parse pointer
__PARSEGNWSkipSpaces:
  ld   a,(hl)         ; skip over spaces
  inc  hl
  cp   ' '
  jr   z,__PARSEGNWSkipSpaces
  or   a          ; if reached the end return with carry set
  scf
  ret  z
  dec  hl          ; back to first character.
  push  hl          ; save start of word on stack.
__PARSESkipOverWord:
  ld   a,(hl)         ; skip over the word looking for null/space
  inc  hl
  cp   ' '+1
  jr   nc,__PARSESkipOverWord
  dec  hl          ; go back to the null/space
  ld   (PARSEPointer),hl      ; write the pointer back
  xor  a          ; clear carry
  pop  hl          ; HL points to the start of the word
  ld   b,' '        ; it is type $20 (ASCII ending in null/space)
  ret

