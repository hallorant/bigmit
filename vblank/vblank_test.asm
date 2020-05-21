; Model 1 VBLANK mod demonstration/test program.
; Dynamically detects the mod and animates a line with or without it.
  org $4a00
screen         equ  $3c00
blank_line     dc   64,$80
top_line       dc   64,$83
middle_line    dc   64,$8c
bottom_line    dc   64,$b0
has_vblank     defs 1 ; has VBLANK mod? 1 = yes, 0 = no.
no_vblank_txt  defb 'MODEL I VBLANK MOD *NOT* DETECTED'
no_vblank_len  equ  $-no_vblank_txt
vblank_txt     defb 'MODEL I VBLANK MOD DETECTED'
vblank_len     equ  $-vblank_txt

; Runtime check if this Model 1 has the VBLANK mod installed.
;
; On Exit: a - Is the VBLANK mod detected? 1=yes, 0=no
detect_m1_vblank:
  ld hl,1350
  ld bc,-1
  ; A Model 1 will not have a 0 in bit 0 of in $ff without the VBLANK
  ; mod. We want to observe for no less than 1/60th of a second, or
  ; 29566 t-states. The loop below is 44 t-states * 1350 = 59400
  ; or ~1/30th of a second which should be long enough.
_vblank_search_loop:
  in a,($ff)
  bit 0,a
  jr z,_vblank_found
  add hl,bc
  jr c,_vblank_search_loop
  ld a,0
  ret
_vblank_found:
  ld a,1
  ret

; Waits for the start of the next VBLANK, even if one is going on.
wait_for_vblank_start macro ?wait_in_vblank,?wait_not_in_vblank
?wait_in_vblank:
  in a,($ff)
  bit 0,a
  jr nz,?wait_in_vblank
?wait_not_in_vblank:
  in a,($ff)
  bit 0,a
  jr z,?wait_not_in_vblank
  endm

; Waits a bit to draw the next animation frame.
;
; If the VBLANK mod is installed we wait for the next VBLANK,
; otherwise a loop delay is used.
wait_a_bit macro ?no_vblank_mod,?delay,?done
  ld a,(has_vblank)
  or a ; is a == 0?
  jr z,?no_vblank_mod
  wait_for_vblank_start
  jr ?done
?no_vblank_mod
  ld hl,1200
  ld bc,-1
?delay
  add hl,bc
  jr c,?delay
?done
  endm

ldir_row macro line,row
  ld hl,line
  ld de,screen+64*row
  ld bc,64
  ldir
  endm

animate_row_down macro row
  ldir_row top_line,row
  wait_a_bit
  ldir_row middle_line,row
  wait_a_bit
  ldir_row bottom_line,row
  wait_a_bit
  ldir_row blank_line,row
  endm

animate_row_up macro row
  ldir_row bottom_line,row
  wait_a_bit
  ldir_row middle_line,row
  wait_a_bit
  ldir_row top_line,row
  wait_a_bit
  ldir_row blank_line,row
  endm

main:
  call detect_m1_vblank
  ld (has_vblank),a
  or a ; is a == 0?
  jr nz,vblank_detected

vblank_not_detected:
  ld hl,no_vblank_txt
  ld de,screen+64*11
  ld bc,no_vblank_len
  ldir
  jr start_animation

vblank_detected:
  ld hl,vblank_txt
  ld de,screen+64*11
  ld bc,vblank_len
  ldir

start_animation:
  wait_a_bit
animation_loop:
  irpc row,0123456789
  animate_row_down &row
  endm
  irpc row,9876543210
  animate_row_up &row
  endm
  jp animation_loop
  end main
