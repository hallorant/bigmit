; Demo for TRS-80 model identification.
  org $4a00
import '../lib/barden_fill.asm'
import '../lib/barden_hexcv.asm'
import '../lib/barden_move.asm'

blank		equ	$80
screen		equ	$3c00
m4_txt		defb	'MODEL '
m4_len		equ	$-m4_txt

; Identifies the model number of the TRS-80 we are running on.
;
; Uses a,b
;
; Exit: a  1 = Model 1 (Level 1 or 2)
;          3 = Model 3
;          4 = Model 4 (4ga or 4p)
get_model_number:
  ; If we can write to $0000 ROM we are on a Model 4.
  ; (Memory map II, III, or I4)
  ld a,($0000)
  ; Save the value, then try to change it.
  ld b,a
  inc a
  ld ($0000),a
  ld a,($0000)
  cp b
  jr z,_get_model_number_m1_check
  ; We are on a Model 4 (Memory map II, III, or I4).
  ld a,4
  ret
_get_model_number_m1_check:
  ; If $3000 is $ff (unused) we are on a Model 1.
  ld a, ($3000)
  xor $ff
  jr nz,_get_model_number_m4_check
  ; We are on a Model 1 (Level 1 or Level 2).
  ld a,1
  ret
_get_model_number_m4_check: 
  ; If $37ff is $ff we are on a Model 4.
  ld a, ($37ff)
  xor $ff
  jr nz,_get_model_number_m4p_check
  ; We are on a Model 4 (not 4ga or 4p).
  ld a,4
  ret
_get_model_number_m4p_check:
  ; If $37ff is $00 we are on a Model 4p (portable).
  ld a, ($37ff)
  or 0
  jr nz,_get_model_number_m4ga_check
  ; We are on a Model 4p.
  ld a,4
  ret
_get_model_number_m4ga_check:
  ; If $37ff is $82 we are on a Model 4ga (gate array).
  ld a, ($37ff)
  xor $28
  jr nz,_get_model_number_m3
  ; We are on a Model 4ga.
  ld a,4
  ret
_get_model_number_m3:
  ; We are on a Model 3.
  ld a,3
  ret
; ---------- get_model_number
  
; A little demo program that just prints the model number to the screen.
main:
  ; Clear the screen.
  ld d,blank
  ld hl,screen
  ld bc,64*16
  call barden_fill

print_model:
  ld hl,m4_txt
  ld de,screen+64*3
  ld bc,m4_len
  call barden_move
  call get_model_number
  call barden_hexcv  ; hex is fine (1, 3, or 4).
  ld a,h
  ld (screen+64*3+m4_len),a

hcf:
  jr hcf

  end main
