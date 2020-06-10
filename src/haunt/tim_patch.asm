  org $685a

; Two loads on the cassette: "HAUNT" and "SNDFLR"

; Haunted House game load
haunt_load	equ	$42e9
haunt_end	equ	$4fff
; Size 3,350 bytes ($d16)
haunt_size	equ	haunt_end-haunt_load

; Second Floor data load (not sure how to deal with this yet)
sndflr_load	equ	$435e
sndflr_end	equ	$4ea0
; Size 2,882 bytes ($b42)
sndflr_size	equ	sndflr_end-sndflr_load

sndflr_copy	equ	$5000
haunt_copy	equ	$5b43

patch		equ	$4a49
patch_copy	equ	haunt_copy+(patch-haunt_load)

restart_the_game: ; $685a
  ld hl,haunt_copy
  ld de,haunt_load
  ld bc,haunt_size
  ldir
  jp haunt_load

main:
  ; We have to patch $4a49 -> 5a and $4a4a -> 68 (the address
  ; of restart_the_game) and the same relative location in the copy.
  ; This is where the game loops when you die at least in the
  ; floating knife room. Might be other places I have to patch.
  ld a,$5a
  ld (patch),a
  ld (haunt_copy+(patch-haunt_load)),a
  ld a,$68
  ld (patch+1),a
  ld (haunt_copy+1+(patch-haunt_load)),a
  ;; TODO we need to use "SNDFLR"
  jp haunt_load
  end main
