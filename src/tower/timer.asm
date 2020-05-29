ifndef INCLUDE_TIMER
INCLUDE_TIMER equ 1

; Public interface is
;  timer_setup
;  timer_await

import '../lib/gp_get_trs80_model.asm'
import '../lib/m1_vblank.asm'

save_sp		defs	2
trs80_model	defb	0 ; TRS80 Model? 1 = Model 1, 3 = Model 3, 4 = Model 4
m1_vblank	defb	0 ; Has the Model 1 VBLANK mod? 1 = yes, 0 = no.
ticks		defb	0 ; Counts ticks of the timer (30 times per second)

timer_interrupt_handler:
  push af
  ld a,(ticks)
  inc a
  ld (ticks),a
  pop af
tick_jp:
  jp 0 ; The 0 is self-modified into the original handler address.

setup_timer_interrupt_handler macro
  di
  ld hl,($4013)
  ld (tick_jp+1),hl
  ld hl,timer_interrupt_handler
  ld ($4013),hl
  ei
  endm

timer_setup macro ?use_interrupt,?done
  ; Save TRS80 Model and, if a Model 1 check if the VBLANK mod is installed.
  call gp_get_trs80_model
  ld (trs80_model),a
  xor 1
  jr nz,?use_interrupt
  call detect_m1_vblank
  ld (m1_vblank),a
  jr prep_screen
?use_interrupt:
  setup_timer_interrupt_handler
?done:
  endm

timer_await macro ?m34_wait,?m34_wait_loop,?done_waiting
  ld a,(trs80_model)
  xor 1 ; is a == 1 (Model 1)?
  jr nz,?m34_wait
  ; Check if we are suppose to use the VBLANK hardware.
  ld a,(m1_vblank)
  or a ; is a == 0 (no)?
  jr z,?done_waiting
  wait_for_vblank_start
  jr ?done_waiting
?m34_wait:
  ld a,(ticks)
  ld b,a
?m34_wait_loop:
  ld a,(ticks)
  xor b ; is a == b?
  jr z,?m34_wait_loop
?done_waiting:
  endm

endif ; INCLUDE_TIMER
