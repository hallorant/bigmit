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

; The addresses where our in-memory copies start.
sndflr_copy	equ	$5000
haunt_copy	equ	$5b43

; Addresses we need to patch to restart the game.
knife_patch	equ	$4a49
hole_patch	equ	$4a98

; Address we need to patch to skip cassette load of sndflr.
cassette_patch	equ	$42f5
sndflr_entry	equ	$435e

restart_the_game:
  ld hl,haunt_copy
  ld de,haunt_load
  ld bc,haunt_size
  ldir
  jp haunt_load

load_sndflr:
  ld hl,sndflr_copy
  ld de,sndflr_load
  ld bc,sndflr_size
  ldir
  jp sndflr_entry

main:
  ; Restart the game when you die from the floating knife in the
  ; living room. We have to patch two bytes at $4a49 with the
  ; address of restart_the_game to jp to that code and not stop the game.
  ; We also need to patch the same relative location in haunt_copy.
  ld a,low restart_the_game
  ld (knife_patch),a
  ld (haunt_copy+(knife_patch-haunt_load)),a
  ld a,high restart_the_game
  ld (knife_patch+1),a
  ld (haunt_copy+1+(knife_patch-haunt_load)),a

  ; Restart the game when you die from falling into the hole (climb) in the
  ; first dimly lit room on the second floor. We have to patch two bytes
  ; at $4a98 with the address of restart_the_game to jp to that code and
  ; not stop the game. We need to do the patch only at the relative location
  ; in sndflr_copy because sndflr is not loaded when the game starts up.
  ld a,low restart_the_game
  ld (sndflr_copy+(hole_patch-sndflr_load)),a
  ld a,high restart_the_game
  ld (sndflr_copy+1+(hole_patch-sndflr_load)),a

  ; Instead of loading the second cassette file use our second floor load.
  ; We have to include the jp op byte in this case.
  ld a,$c3 ; jp op
  ld (cassette_patch),a
  ld (haunt_copy+(cassette_patch-haunt_load)),a
  ld a,low load_sndflr
  ld (cassette_patch+1),a
  ld (haunt_copy+1+(cassette_patch-haunt_load)),a
  ld a,high load_sndflr
  ld (cassette_patch+2),a
  ld (haunt_copy+2+(cassette_patch-haunt_load)),a

  jp haunt_load
  end main
