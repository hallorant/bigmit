  org $7000
import '../z80unit.asm'

s1	defb	'a test'
s2	defb	'a test'
s2ln	equ	$-s2
s3	defb	'foo bar'
s4	defb	'foO bar'
s4ln	equ	$-s4

; Trys out z80unit block memory assertions.
; For each assert we do some passing and some failing calls.
main:
  z80unit_test 'Passing assertMemString'
  assertMemString s1,'a test'
  assertMemString s1+2,'test'

  z80unit_test 'Failing assertMemString'
  assertMemString s1,'a*test','expected'
  assertMemString s1+2,'tes*'

  z80unit_test 'Passing assertMemEquals8'
  assertMemEquals8 s1,s2,6
  assertMemEquals8 s1,s2,s2ln
  ld c,s2ln
  assertMemEquals8 s1,s2,d
  ld a,s2ln
  assertMemEquals8 s1,s2,a

  z80unit_test 'Failing assertMemEquals8'
  assertMemEquals16 s3,s4,s4ln,'expected'
  assertMemEquals16 s1,s2,150

  z80unit_test 'Passing assertMemEquals16'
  assertMemEquals16 s1,s2,6
  assertMemEquals16 s1,s2,s2ln
  ld l,6
  ld h,0
  assertMemEquals16 s1,s2,hl
  assertMemEquals16 s1,s2,s2ln

  z80unit_test 'Failing assertMemEquals16'
  assertMemEquals16 s3,s4,s4ln,'expected'
  assertMemEquals16 s1,s2,1024

  z80unit_end_and_exit
  end main
