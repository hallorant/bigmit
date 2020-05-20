; Model 1 VBLANK mod demonstration/test program.
; Dynamically detects the mod and, if found, animates a line.
  org $4200
screen         equ  $3c00
blank_line     dc   64,$80
top_line       dc   64,$83
middle_line    dc   64,$8c
bottom_line    dc   64,$b0
no_vblank_txt  defb 'MODEL I VBLANK MOD *NOT* DETECTED'
no_vblank_len  equ  $-no_vblank_txt
vblank_txt     defb 'MODEL I VBLANK MOD DETECTED'
vblank_len     equ  $-vblank_txt

; Runtime check if this Model 1 has the VBLANK mod installed.
;
; On Exit: a -  VBLANK mod detected? 1=yes, 0=no
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

ldir_row macro line,row
  ld hl,line
  ld de,screen+64*row
  ld bc,64
  ldir
  endm

animate_row_down macro row
  ldir_row top_line,row
  wait_for_vblank_start
  ldir_row middle_line,row
  wait_for_vblank_start
  ldir_row bottom_line,row
  wait_for_vblank_start
  ldir_row blank_line,row
  endm

animate_row_up macro row
  ldir_row bottom_line,row
  wait_for_vblank_start
  ldir_row middle_line,row
  wait_for_vblank_start
  ldir_row top_line,row
  wait_for_vblank_start
  ldir_row blank_line,row
  endm

main:
  call detect_m1_vblank
  or a ; is a == 0?
  jr nz,vblank_found

  ; No VBLANK mod detected, display a message and stop.
  ld hl,no_vblank_txt
  ld de,screen+64*11
  ld bc,no_vblank_len
  ldir
stop:
  jr stop

vblank_found:
  ld hl,vblank_txt
  ld de,screen+64*11
  ld bc,vblank_len
  ldir

  wait_for_vblank_start ;
smooth_animation:
  irpc row,0123456789
  animate_row_down &row
  endm
  irpc row,9876543210
  animate_row_up &row
  endm
  jp smooth_animation
  end main
