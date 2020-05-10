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
  jp $1a19
  end main
