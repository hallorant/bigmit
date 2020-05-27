ifndef INCLUDE_M1_VBLANK
INCLUDE_M1_VBLANK equ 1

;           __        _     _             _
;          /  |      | |   | |           | |
; _ __ ___ `| |__   _| |__ | | __ _ _ __ | | __
;| '_ ` _ \ | |\ \ / / '_ \| |/ _` | '_ \| |/ /
;| | | | | || |_\ V /| |_) | | (_| | | | |   <
;|_| |_| |_\___/ \_/ |_.__/|_|\__,_|_| |_|_|\_\
;            ______
;           |______|
;
; Routines from the TRS8BIT article on the Model 1 VBLANK mod.

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

endif ; INCLUDE_M1_VBLANK
