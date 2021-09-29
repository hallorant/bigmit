; add.asm
;   Adds a few numbers (no screen output)
;
; zmac add.asm
; trs80gp -b main zout/add.bds
  org $5200

num	defb	2
main:
  ; 8-bit math
  ld a,5     ; a = 5
  inc a      ; a = 6
  dec a      ; a = 5

  ld a,(num) ; load 2 from num into a
  inc a      ; a = 3
  dec a      ; a = 2
  ld c,10    ; c = 10
  add c      ; a = 12, c = 10
  ld (num),a ; store 12 into num

  ; We can do 16-bit math too
  ld hl,512  ; hl = 512
  ld bc,512  ; bc = 512
  add hl,bc  ; hl = 1024

  ; reset "num" to repeat
  ld a,2     ; a = 2
  ld (num),a ; store 2 into num (via a)

  jr main    ; jump back up to main and repeat until reboot
  end main
