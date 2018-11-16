;
; Generated.
;
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   binary.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   16th November 2018
;  Purpose : Binary operators
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_2b_3a_3a_6d_61_63_72_6f:
; @macro +
  add  hl,de
__mzword_e_2b_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_2d_3a_3a_6d_61_63_72_6f:
; @macro -
  push  de
  ex   de,hl
  xor  a
  sbc  hl,de
  pop  de
__mzword_e_2d_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_2a_3a_3a_77_6f_72_64:
; @word *
  jp   __CALLMultiply
__mzword_e_2a_3a_3a_77_6f_72_64:
; @end

__mzword_s_2f_3a_3a_77_6f_72_64:
; @word /
  push  de
  call  __CALLDivide
  ex   de,hl
  pop  de
  ret
__mzword_e_2f_3a_3a_77_6f_72_64:
; @end

__mzword_s_6d_6f_64_3a_3a_77_6f_72_64:
; @word mod
  push  de
  call  __CALLDivide
  pop  de
  ret
__mzword_e_6d_6f_64_3a_3a_77_6f_72_64:
; @end

__mzword_s_61_6e_64_3a_3a_77_6f_72_64:
; @word and
  ld   a,h
  and  d
  ld   h,a
  ld   a,l
  and  e
  ld   l,a
  ret
__mzword_e_61_6e_64_3a_3a_77_6f_72_64:
; @end

__mzword_s_78_6f_72_3a_3a_77_6f_72_64:
; @word xor
  ld   a,h
  xor   d
  ld   h,a
  ld   a,l
  xor  e
  ld   l,a
  ret
__mzword_e_78_6f_72_3a_3a_77_6f_72_64:
; @end

__mzword_s_6f_72_3a_3a_77_6f_72_64:
; @word or
  ld   a,h
  or   d
  ld   h,a
  ld   a,l
  or   e
  ld   l,a
  ret
__mzword_e_6f_72_3a_3a_77_6f_72_64:
; @end


__mzword_s_6d_61_78_3a_3a_77_6f_72_64:
; @word max
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__Max2
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
__mzword_e_6d_61_78_3a_3a_77_6f_72_64:
; @end

__mzword_s_6d_69_6e_3a_3a_77_6f_72_64:
; @word min
    ld      a,h
    xor     d
    bit  7,a
    jr      nz,__Min2
    push    hl
    sbc     hl,de
    pop     hl
    ret     c
    ex      de,hl
    ret

__Min2:
    bit     7,h
    ret     nz
    ex      de,hl
    ret
__mzword_e_6d_69_6e_3a_3a_77_6f_72_64:
; @end
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   compare.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Comparison words, min and max.
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_3d_3a_3a_77_6f_72_64:
; @word =
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
__mzword_e_3d_3a_3a_77_6f_72_64:
; @end

__mzword_s_3c_3e_3a_3a_77_6f_72_64:
; @word <>
 ld   a,h
 cp   d
 jr   nz,__COM2True
 ld   a,l
 cp   e
 jr   z,__COM2False
__COM2True:
 ld   hl,$FFFF
 ret
__COM2False:
 ld   hl,$0000
 ret
__mzword_e_3c_3e_3a_3a_77_6f_72_64:
; @end


__mzword_s_3e_3a_3a_77_6f_72_64:
; @word >
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__Greater
    sbc  hl,de
    jr   c,__COM3True
    jr   __COM3False
__Greater:
 bit  7,d
    jr   nz,__COM3False
__COM3True:
 ld   hl,$FFFF
 ret
__COM3False:
 ld   hl,$0000
 ret
__mzword_e_3e_3a_3a_77_6f_72_64:
; @end

__mzword_s_3c_3d_3a_3a_77_6f_72_64:
; @word <=
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__LessEqual
    sbc  hl,de
    jr   nc,__COM4True
    jr   __COM4False
__LessEqual:
 bit  7,d
    jr   z,__COM4False
__COM4True:
 ld   hl,$FFFF
 ret
__COM4False:
 ld   hl,$0000
 ret
__mzword_e_3c_3d_3a_3a_77_6f_72_64:
; @end

__mzword_s_3e_3d_3a_3a_77_6f_72_64:
; @word >=
 dec  hl
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__Greater2
    sbc  hl,de
    jr   c,__COM6True
    jr   __COM6False
__Greater2:
 bit  7,d
    jr   nz,__COM6False
__COM6True:
 ld   hl,$FFFF
 ret
__COM6False:
 ld   hl,$0000
 ret
__mzword_e_3e_3d_3a_3a_77_6f_72_64:
; @end

__mzword_s_3c_3a_3a_77_6f_72_64:
; @word <
 dec  hl
 ld   a,h
    xor  d
    bit  7,a
    jr   nz,__LessEqual2
    sbc  hl,de
    jr   nc,__COM5True
    jr   __COM5False
__LessEqual2:
 bit  7,d
    jr   z,__COM5False
__COM5True:
 ld   hl,$FFFF
 ret
__COM5False:
 ld   hl,$0000
 ret
__mzword_e_3c_3a_3a_77_6f_72_64:
; @end
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   graphic.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Graphic System words
;
; ***************************************************************************************
; ***************************************************************************************

; *********************************************************************************

__mzword_s_6d_6f_64_65_2e_34_38_3a_3a_77_6f_72_64:
; @word   mode.48
  push  de
  call  __CALLMode48
  call  __CALLConfigure
  pop  de
  ret
__mzword_e_6d_6f_64_65_2e_34_38_3a_3a_77_6f_72_64:
; @end

; *********************************************************************************

__mzword_s_6d_6f_64_65_2e_6c_6f_77_72_65_73_3a_3a_77_6f_72_64:
; @word   mode.lowres
  push  de
  call  __CALLModeLow
  call  __CALLConfigure
  pop  de
  ret
__mzword_e_6d_6f_64_65_2e_6c_6f_77_72_65_73_3a_3a_77_6f_72_64:
; @end

; *********************************************************************************

__mzword_s_6d_6f_64_65_2e_6c_61_79_65_72_32_3a_3a_77_6f_72_64:
; @word   mode.layer2
  push  de
  call  __CALLModeLayer2
  call  __CALLConfigure
  pop  de
  ret
__mzword_e_6d_6f_64_65_2e_6c_61_79_65_72_32_3a_3a_77_6f_72_64:
; @end

; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   memory.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Memory and Hardware access
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_63_40_3a_3a_6d_61_63_72_6f:
; @macro c@
  ld   l,(hl)
  ld   h,0
__mzword_e_63_40_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_40_3a_3a_6d_61_63_72_6f:
; @macro @
  ld   a,(hl)
  inc  hl
  ld   h,(hl)
  ld   l,a
__mzword_e_40_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_63_21_3a_3a_6d_61_63_72_6f:
; @macro c!
  ld   (hl),e
__mzword_e_63_21_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_21_3a_3a_6d_61_63_72_6f:
; @macro !
  ld   (hl),e
  inc  hl
  ld   (hl),d
  dec  hl
__mzword_e_21_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_2b_21_3a_3a_77_6f_72_64:
; @word +!
  ld   a,(hl)
  add  a,e
  ld   (hl),a
  inc  hl

  ld   a,(hl)
  adc  a,d
  ld   (hl),a
  dec  hl
  ret
__mzword_e_2b_21_3a_3a_77_6f_72_64:
; @end

__mzword_s_70_21_3a_3a_77_6f_72_64:
; @word p!
  push  bc
  ld   c,l
  ld   b,h
  out  (c),e
  pop  bc
  ret
__mzword_e_70_21_3a_3a_77_6f_72_64:
; @end

__mzword_s_70_40_3a_3a_77_6f_72_64:
; @word p@
  push  bc
  ld   c,l
  ld   b,h
  in   l,(c)
  ld   h,0
  pop  bc
  ret
__mzword_e_70_40_3a_3a_77_6f_72_64:
; @end
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   register.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Register operators
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_73_77_61_70_3a_3a_6d_61_63_72_6f:
; @macro swap
 ex   de,hl
__mzword_e_73_77_61_70_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_61_3e_62_3a_3a_6d_61_63_72_6f:
; @macro a>b
 ld   d,h
 ld   e,l
__mzword_e_61_3e_62_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_62_3e_61_3a_3a_6d_61_63_72_6f:
; @macro b>a
 ld   h,d
 ld   l,e
__mzword_e_62_3e_61_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_61_3e_63_3a_3a_6d_61_63_72_6f:
; @macro a>c
 ld   b,h
 ld   c,l
__mzword_e_61_3e_63_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_63_3e_61_3a_3a_6d_61_63_72_6f:
; @macro c>a
 ld   h,b
 ld   l,c
__mzword_e_63_3e_61_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_62_3e_63_3a_3a_6d_61_63_72_6f:
; @macro b>c
 ld   b,d
 ld   c,e
__mzword_e_62_3e_63_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_63_3e_62_3a_3a_6d_61_63_72_6f:
; @macro c>b
 ld   d,b
 ld   e,c
__mzword_e_63_3e_62_3a_3a_6d_61_63_72_6f:
; @end
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   stack.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Stack operators
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_61_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @macro a>r protected
 push  hl
__mzword_e_61_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_62_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @macro b>r protected
 push  de
__mzword_e_62_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_63_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @macro c>r protected
 push  bc
__mzword_e_63_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_61_62_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @macro ab>r protected
 push  de
 push  hl
__mzword_e_61_62_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_61_62_63_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @macro abc>r protected
 push  bc
 push  de
 push  hl
__mzword_e_61_62_63_3e_72_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_72_3e_61_3a_3a_6d_61_63_72_6f_2f_70:
; @macro r>a protected
 pop  hl
__mzword_e_72_3e_61_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_72_3e_62_3a_3a_6d_61_63_72_6f_2f_70:
; @macro r>b protected
 pop  de
__mzword_e_72_3e_62_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_72_3e_63_3a_3a_6d_61_63_72_6f_2f_70:
; @macro r>c protected
 pop  bc
__mzword_e_72_3e_63_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_72_3e_61_62_3a_3a_6d_61_63_72_6f_2f_70:
; @macro r>ab protected
 pop  hl
 pop  de
__mzword_e_72_3e_61_62_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_72_3e_61_62_63_3a_3a_6d_61_63_72_6f_2f_70:
; @macro r>abc protected
 pop  hl
 pop  de
 pop  bc
__mzword_e_72_3e_61_62_63_3a_3a_6d_61_63_72_6f_2f_70:
; @end
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   unary.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Unary operators
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_30_3d_3a_3a_77_6f_72_64:
; @word 0=
  ld  a,h
  or  l
  ld  hl,$0000
  ret nz
  dec hl
  ret
__mzword_e_30_3d_3a_3a_77_6f_72_64:
; @end

__mzword_s_30_3c_3a_3a_77_6f_72_64:
; @word 0<
  bit 7,h
  ld  hl,$0000
  ret z
  dec hl
  ret
__mzword_e_30_3c_3a_3a_77_6f_72_64:
; @end

__mzword_s_30_2d_3a_3a_77_6f_72_64:
; @word 0-
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  inc hl
  ret
__mzword_e_30_2d_3a_3a_77_6f_72_64:
; @end

__mzword_s_6e_6f_74_3a_3a_77_6f_72_64:
; @word not
  ld  a,h
  cpl
  ld  h,a
  ld  a,l
  cpl
  ld  l,a
  ret
__mzword_e_6e_6f_74_3a_3a_77_6f_72_64:
; @end

__mzword_s_61_62_73_3a_3a_77_6f_72_64:
; @word abs
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
__mzword_e_61_62_73_3a_3a_77_6f_72_64:
; @end


__mzword_s_31_2b_3a_3a_6d_61_63_72_6f:
; @macro 1+
  inc hl
__mzword_e_31_2b_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_31_2d_3a_3a_6d_61_63_72_6f:
; @macro 1-
  dec hl
__mzword_e_31_2d_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_32_2b_3a_3a_6d_61_63_72_6f:
; @macro 2+
  inc hl
  inc hl
__mzword_e_32_2b_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_32_2d_3a_3a_6d_61_63_72_6f:
; @macro 2-
  dec hl
  dec hl
__mzword_e_32_2d_3a_3a_6d_61_63_72_6f:
; @end


__mzword_s_32_2a_3a_3a_6d_61_63_72_6f:
; @macro 2*
  add  hl,hl
__mzword_e_32_2a_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_32_2f_3a_3a_6d_61_63_72_6f:
; @macro 2/
  sra  h
  rr   l
__mzword_e_32_2f_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_34_2a_3a_3a_6d_61_63_72_6f:
; @macro 4*
  add  hl,hl
  add  hl,hl
__mzword_e_34_2a_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_34_2f_3a_3a_77_6f_72_64:
; @word 4/
  sra  h
  rr   l
  sra  h
  rr   l
  ret
__mzword_e_34_2f_3a_3a_77_6f_72_64:
; @end

__mzword_s_38_2a_3a_3a_6d_61_63_72_6f:
; @macro 8*
  add  hl,hl
  add  hl,hl
  add  hl,hl
__mzword_e_38_2a_3a_3a_6d_61_63_72_6f:
; @end


__mzword_s_31_36_2a_3a_3a_6d_61_63_72_6f:
; @macro 16*
  add  hl,hl
  add  hl,hl
  add  hl,hl
  add  hl,hl
__mzword_e_31_36_2a_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_31_36_2f_3a_3a_77_6f_72_64:
; @word 16/
  sra  h
  rr   l
  sra  h
  rr   l
  sra  h
  rr   l
  sra  h
  rr   l
  ret
__mzword_e_31_36_2f_3a_3a_77_6f_72_64:
; @end

__mzword_s_32_35_36_2a_3a_3a_6d_61_63_72_6f:
; @macro 256*
  ld   h,l
  ld   l,0
__mzword_e_32_35_36_2a_3a_3a_6d_61_63_72_6f:
; @end

__mzword_s_32_35_36_2f_3a_3a_77_6f_72_64:
; @word 256/
  ld   l,h
  ld   h,0
  bit  7,l
  ret  z
  dec  h
  ret
__mzword_e_32_35_36_2f_3a_3a_77_6f_72_64:
; @end

__mzword_s_62_73_77_61_70_3a_3a_6d_61_63_72_6f:
; @macro bswap
  ld   a,l
  ld   l,h
  ld   h,a
__mzword_e_62_73_77_61_70_3a_3a_6d_61_63_72_6f:
; @end
; ***************************************************************************************
; ***************************************************************************************
;
;  Name :   utility.words
;  Author : Paul Robson (paul@robsons.org.uk)
;  Date :   15th November 2018
;  Purpose : Miscellaneous words.
;
; ***************************************************************************************
; ***************************************************************************************

__mzword_s_62_72_65_61_6b_3a_3a_6d_61_63_72_6f_2f_70:
; @macro break protected
  db   $DD,$01
__mzword_e_62_72_65_61_6b_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_73_79_73_2e_69_6e_66_6f_3a_3a_77_6f_72_64:
; @word sys.info
  ex   de,hl
  ld   hl,SystemInformationTable
  ret
__mzword_e_73_79_73_2e_69_6e_66_6f_3a_3a_77_6f_72_64:
; @end

__mzword_s_3b_3a_3a_6d_61_63_72_6f_2f_70:
; @macro ; protected
  ret
__mzword_e_3b_3a_3a_6d_61_63_72_6f_2f_70:
; @end

__mzword_s_69_6e_6b_65_79_3a_3a_77_6f_72_64:
; @word inkey
  ex   de,hl
  call  __CALLKeyboard
  ld   l,a
  ld   h,0
  ret
__mzword_e_69_6e_6b_65_79_3a_3a_77_6f_72_64:
; @end

__mzword_s_68_61_6c_74_3a_3a_77_6f_72_64:
; @word halt
HaltZ80:
  di
  halt
  jr   HaltZ80
__mzword_e_68_61_6c_74_3a_3a_77_6f_72_64:
; @end

__mzword_s_63_6f_70_79_3a_3a_77_6f_72_64:
; @word copy
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
__mzword_e_63_6f_70_79_3a_3a_77_6f_72_64:
; @end

__mzword_s_66_69_6c_6c_3a_3a_77_6f_72_64:
; @word fill
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
__mzword_e_66_69_6c_6c_3a_3a_77_6f_72_64:
; @end
