  org $7000
import '../z80unit.asm'

_zero	defw	0
_ten	defw	10

; Trys out z80unit 16-bit assertions.
main:
  z80unit_test 'Passing assertZero16'
  assertZero16 0
  assertZero16 (_zero)
  ld bc,$0000
  assertZero16 bc
  assertZero16 BC
  assertZero16 Bc
  assertZero16 bC
  ld de,$0000
  assertZero16 de
  assertZero16 DE
  assertZero16 De
  assertZero16 dE
  ld hl,$0000
  assertZero16 hl
  assertZero16 HL
  assertZero16 Hl
  assertZero16 hL
  ld ix,$0000
  assertZero16 ix
  assertZero16 IX
  assertZero16 Ix
  assertZero16 iX
  ld iy,$0000
  assertZero16 iy
  assertZero16 IY
  assertZero16 IY
  assertZero16 iy

  z80unit_test 'Failing assertZero16'
  assertZero16 $ffff, 'OK'
  ld hl,$0456
  assertZero16 hl
  ld a,50
  assertZero16 af
  assertZero16 AF
  assertZero16 Af
  assertZero16 aF

  z80unit_test 'Passing assertEquals16'
  ld hl,$0456
  assertEquals16 hl,$0456
  assertEquals16 10,(_ten)

  z80unit_test 'Failing assertEquals16'
  ld hl,$0450
  assertEquals16 hl,$0456, 'OK'
  assertEquals16 11,(_ten)

  z80unit_test 'Passing assertNotEquals16'
  ld hl,$0450
  assertNotEquals16 hl,$0456
  assertNotEquals16 11,(_ten)

  z80unit_test 'Failing assertNotEquals16'
  ld hl,$0456
  assertNotEquals16 hl,$0456, 'OK'
  assertNotEquals16 10,(_ten)

  z80unit_end_and_exit
  end main
