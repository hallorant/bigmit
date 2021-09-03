;
; space_invaders.asm
;
; zmac --zmac space_invaders.asm
; trs80gp -m1 zout/space_invaders.bds
screen	equ	$3c00

; Clears the screen at startup
  org screen
  dc 64*16,$20

; Our program
  org $5200

; Frame 1 of the ship animation: 3 characters X 2 lines

		; 0 1     1 1       1 0
		; 0 1     0 0       1 0
		; 1 1     1 1       1 1
frame1	defb	10111010b,10110011b,10110101b
		; 0 1     0 0       1 0
		; 1 0     0 1       0 0
		; 0 1     0 0       1 0
	defb	10100110b,10001000b,10010001b

; Frame 2 of the ship animation: 3 characters X 2 lines

		; 0 1     1 1       1 0
		; 0 1     1 1       1 0
		; 1 1     1 1       1 1
frame2	defb	10111010b,10111111b,10110101b
		; 0 1     0 0       1 0
		; 0 0     1 0       0 1
		; 0 1     0 0       1 0
	defb	10100010b,10000100b,10011001b

; Draws a frame of 3 characters X 2 lines on the screen at the passed address.
;
; hl - screen address
; ix - frame address
; uses: a, bc, hl, ix
draw_frame:
  ; Draw the top 3 characters on the screen.
  ld a,(ix)
  ld (hl),a
  inc hl
  ld a,(ix+1)
  ld (hl),a
  inc hl
  ld a,(ix+2)
  ld (hl),a
  ; Drop to the next line.
  ld bc,62
  add hl,bc
  ; Draw the bottom 3 characters on the screen.
  ld a,(ix+3)
  ld (hl),a
  inc hl
  ld a,(ix+4)
  ld (hl),a
  inc hl
  ld a,(ix+5)
  ld (hl),a
  ret

; Draws a row of invaders on the screen using the passed animation frame.
;
; ix - frame address
; uses: a, bc, hl, ix
draw_screen:
  ld hl,screen+(64*5)+15
  call draw_frame
  ld hl,screen+(64*5)+20
  call draw_frame
  ld hl,screen+(64*5)+25
  call draw_frame
  ld hl,screen+(64*5)+30
  call draw_frame
  ld hl,screen+(64*5)+35
  call draw_frame
  ld hl,screen+(64*5)+40
  call draw_frame
  ld hl,screen+(64*5)+45
  call draw_frame
  ret

; Pauses for a short period.
wait:
  ld bc,$ffff
wait_loop: djnz wait_loop
  dec c
  jr nz,wait_loop
  ret

main:
  ld ix,frame1
  call draw_screen
  call wait
  ld ix,frame2
  call draw_screen
  call wait
  jr main
  end main
