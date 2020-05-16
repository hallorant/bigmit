  org $B000

msg1	defb	'Hello Model III TRSDOS 1.3',$0d
msg2	defb	'Press <ENTER> to continue...',$03
buffer	defs	5

main:
  ld hl,msg1
  call $021b
  ld hl,msg2
  call $021b
  ld b,5
  ld hl,buffer
  call $0040 ; $KBLINE
  ; This works for TRSDOS 1.3 but page 12/15 of the "TRS-80 MODEL III
  ; Operation and BASIC Language Reference Manual" says to use $READY:
  ; which is a jp to $1a19. This doesn't work.
  ; NOT jp $1a19
  call $402d ; @EXIT (pg 6-51)
  end main
