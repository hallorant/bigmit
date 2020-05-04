; Timer test ticking up a character on the screen.
;
; Expect a banner at the top and a single character that changes on the
; second line
;
; Only works on Model 3 or Model 4
  org     0x4a00

video   equ     $3c00
count   defb    11   ; init to 11 ticks
d_char  defb    $41  ; init to ascii A
msg     defb    'Timer Interrupt test on the TRS-80 Model III'
msg_len	equ	$-msg

main:
  jmp cls ; Skip interrupt handler; jump to setup code

tick:
  ; Only change the letter every 10 ticks.
  ld hl,count
  dec (hl)
  jr nz,tick_r
  ld (hl),11  ; reset to count down again

disp:
  ; Display a letter, A-Z, on the screen.
  ld hl,d_char
  ld a,(hl)
  ld (video+64+5),a
  ; Next time show the next letter.
  inc a
  ld d,a  ; dup the letter into reg d
  ; Did we just display ascii Z? if so reset to ascii A.
  sub a,$5a+1  ; (ascii Z) plus 1
  jr nz,save_l
  ld d,$41 ; ascii A
save_l:
  ld (hl),d ; next letter in the alphabet
  jmp tick_r

cls:
  ; Start by clearing the screen.
  ld hl,video
  ld bc,64*16
cls_c:
  ld (hl),0
  inc hl
  dec bc
  ld a,b
  or c
  jr nz,cls_c

bannner:
  ; Write a message about the program to line 1 of the screen.
  ld hl,msg
  ld de,video
  ld bc,msg_len
  ldir
  ; Setup timer interrupt Model 3 & 4.
  di
  ld hl,(0x4013)
  ld (tick_r+1),hl
  ld hl,tick
  ld (0x4013),hl
  ei

hcf:
  jr hcf

; Return back to ROM interrupt processing;
; the vector was set by init code above.
tick_r: jp 0 ; The 0 is self-modified into the original address.
  end main
