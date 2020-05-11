ifndef INCLUDE_Z80UNIT
INCLUDE_BZ80UNIT equ 1

;     _____ _____             _ _
;    |  _  |  _  |           (_) |
; ____\ V /| |/' |_   _ _ __  _| |_ 
;|_  // _ \|  /| | | | | '_ \| | __|
; / /| |_| \ |_/ / |_| | | | | | |_ 
;/___\_____/\___/ \__,_|_| |_|_|\__|
;                                   
; A programmer-friendly unit testing library for TRS-80 assembly.
; Author: Tim Halloran
;         (with mentoring by George Phillips, e.g., z80unit_is_reg16)
;
; 8-bit assertions, where e, an expected value, and a, an actual
; value, are any <exp> valid in "ld a,<exp>". All magnitude comparisons
; are unsigned.
;   assertZero8 a                     ; a == 0
;   assertEquals8 e,a                 ; e == a
;   assertNotEquals8 e,a              ; e != a
;   assertGreaterThan8 e,a            ; e >  a (unsigned)
;   assertGreaterThanOrEquals8 e,a    ; e >= a (unsigned)
;   assertLessThan8 e,a;              ; e <  a (unsigned)
;   assertLessThanOrEquals8 e,a       ; e <= a (unsigned)
;
; 16-bit assertions, where e, an expected value, and a, an actual
; value, are either a 16-bit register or any <exp> valid in "ld hl,<exp>".
;   assertZero16 a                    ; a == 0
;   assertEquals16 e,a                ; e == a
;   assertNotEquals16 e,a             ; e != a
; A notable limitation of the 16-bit assertions is that any indirect
; register value, such as (hl) or (ix), is not supported. Of course,
; you can use hl or ix -- but not as pointers to memory.
;
; Memory block assertions check memory against an expected vector of bytes.
; 'ptr' values are either a 16-bit register or any <exp> valid in "ld hl,<exp>".
;   assertMemString ptr,string        ; memory at 'ptr' contains 'string'
;   assertMemEquals8 ptr1,ptr2,count  ; 'ptr1' and 'ptr2' equal for 'count':8-bits bytes.
;   assertMemEquals16 ptr1,ptr2,count ; 'ptr1' and 'ptr2' equal for 'count':16-bits bytes.

; ---------------------------------------------------------------- ;
; / / / / / / / / / /  IMPLEMENTATION DETAILS  / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

_failed_count			defw	0
_passed_count			defw	0
_title_displayed		defb	0 ; 0=no, 1=yes
_running_test			defb	0 ; 0=no, 1=yes
_last_passed			defb	1 ; 0=no, 1=yes

_title_txt			defb	'z80unit : Programmer-friendly unit testing for TRS-80 assembly',0
_pause_txt			defb	'Examine the diagnostics above & press <ENTER> to continue...',0
_passed_progress_txt		defb	'P',0
_failed_progress_txt		defb	'F',0
_complete_progress_bar_txt	defb	')',0
_report_success_txt		defb	'ALL TESTS PASSED (',0
_report_problems_txt		defb	'*** TESTS FAILED *** (',0
_report_passed_txt		defb	' passed, ',0
_report_failed_txt		defb	' failed)',0
_buffer				defs	32 ; a small scratch buffer

z80unit_push_reg macro
  push af
  push bc
  push de
  push hl
  push ix
  push iy
  endm

z80unit_pop_reg macro
  pop iy
  pop ix
  pop hl
  pop de
  pop bc
  pop af
  endm

; Checks if 'value' is the name of a 16-bit register.
;
; Big thanks to George Phillips for suggesting this approach.
;
; value - the text
; match - this symbol is updated to indicate if value was a
;         16-bit register name: zero is no, non-zero is yes.
z80unit_is_reg16 macro value,?fp
?fp	defl	0
  irpc letter,value
    ?fp *= 256 ; ?fp is zero for the first letter
    ?fp += '&letter'
  endm
z80unit_reg16	defl	0
; af
z80unit_reg16 |= ?fp == 256 * 'a' + 'f'
z80unit_reg16 |= ?fp == 256 * 'A' + 'F'
z80unit_reg16 |= ?fp == 256 * 'a' + 'F'
z80unit_reg16 |= ?fp == 256 * 'A' + 'f'
; bc
z80unit_reg16 |= ?fp == 256 * 'b' + 'c'
z80unit_reg16 |= ?fp == 256 * 'B' + 'C'
z80unit_reg16 |= ?fp == 256 * 'b' + 'C'
z80unit_reg16 |= ?fp == 256 * 'B' + 'c'
; de
z80unit_reg16 |= ?fp == 256 * 'd' + 'e'
z80unit_reg16 |= ?fp == 256 * 'D' + 'E'
z80unit_reg16 |= ?fp == 256 * 'd' + 'E'
z80unit_reg16 |= ?fp == 256 * 'D' + 'e'
; hl
z80unit_reg16 |= ?fp == 256 * 'h' + 'l'
z80unit_reg16 |= ?fp == 256 * 'H' + 'L'
z80unit_reg16 |= ?fp == 256 * 'h' + 'L'
z80unit_reg16 |= ?fp == 256 * 'H' + 'l'
; ix
z80unit_reg16 |= ?fp == 256 * 'i' + 'x'
z80unit_reg16 |= ?fp == 256 * 'I' + 'X'
z80unit_reg16 |= ?fp == 256 * 'i' + 'X'
z80unit_reg16 |= ?fp == 256 * 'I' + 'x'
; iy
z80unit_reg16 |= ?fp == 256 * 'i' + 'y'
z80unit_reg16 |= ?fp == 256 * 'I' + 'Y'
z80unit_reg16 |= ?fp == 256 * 'i' + 'Y'
z80unit_reg16 |= ?fp == 256 * 'I' + 'y'
  endm

; ---------------------------------------------------------------- ;
; / / / / / / / / /  OS SPECIFIC PRINT ROUTINES  / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; We define a simple interface to the console for test diagnostic output.
;
;  z80unit_print prints a zero-terminated string pointed to by hl to the
;                console. The output is truncated to 132 characters if
;                longer or the string is not terminated properly.
;
;  z80unit_newln prints a newline to the console.
;
;  z80unit_pause pauses testing, prompts user, and waits for ENTER.
;
;  z80unit_exit  exits the program.
;
; Each supported OS needs these two console output interfaces.

; ------------------------------------------------------------------

; Tested: trs80gp -m1 mytest.cas
;         trs80gp -m3 mytest.cas
;         trs80gp -m4 mytest.cas
z80unit_m1_m3_m4_CASSETTE = 1

; Tested: trs80gp -m2 mytest.cmd
;     See "TRS-80 Model II Disk Operating System Reference Manual"
z80unit_m2_TRSDOS2.0a = 0
; Tested: trs80gp -m2 -ld mytest.cmd
;     See "The Programmer's Guide to TRSDOS Version 6" / LDOS Version 6 too!
z80unit_m2_LDOS06.03.01 = 0

; Tested: trs80gp -m1 mytest.cmd
;         trs80gp -m1 -ld mytest.cmd
;         trs80gp -m3 -ld mytest.cmd
;     See "LDOS Version 5.1: The TRS-80 Operating System Model I and III"
z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1 = 0
; Tested: trs80gp -m3 mytest.cmd
;     See "TRS-80 MODEL III Operation and BASIC Language Reference Manual"
z80unit_m3_TRSDOS1.3 = 0

; Tested: trs80gp -m4 mytest.cmd
;         trs80gp -m4 -ld mytest.cmd
;     See "The Programmer's Guide to TRSDOS Version 6" / LDOS Version 6 too!
z80unit_m4_TRSDOS06.02.01_LDOS06.03.01 = 0

if z80unit_m1_m3_m4_CASSETTE

_screen_start	equ	$3c00
_screen_end	equ	_screen_start+64*16
_screen_size	equ	_screen_end-_screen_start
_scroll_start	equ	_screen_start+64*1
_scroll_end	equ	_screen_start+64*15
_first_call	defb	1
; Points to the current cursor position on the screen.
_cursor		defw	_screen_start

_cls_if_first_call:
  ; Check if this is the first call.
  ld a,(_first_call)
  or a
  ret z
  ld a,0
  ld (_first_call),a
  ; Clear the screen
  ld d,$20
  ld hl,_screen_start
  ld bc,_screen_size
_cls_loop:
  ld (hl),d
  inc hl
  dec bc
  ld a,b
  or c
  jr nz,_cls_loop
  ret

z80unit_print:
  z80unit_push_reg
  call _cls_if_first_call
_print_loop:  
  ld a,(hl)
  or a ; a == 0
  jr z,_print_done
  inc hl
  push hl ; Increment the cursor ptr
  ld hl,(_cursor)
  ld (hl),a
  inc hl
  ld (_cursor),hl
  pop hl
  jr _print_loop
_print_done:
  z80unit_pop_reg
  ret

z80unit_newln:
  z80unit_push_reg
  call _cls_if_first_call
  ; Our approach is to shift to the start of the next line in video memory by
  ; adding 1 after dumping column position on the current line, via LSB >>> 6,
  ; putting empty column position back via LSB << 6. Adding one to MSB if carry.
  ld a,(_cursor) ; LSB
  rept 6
  srl a ; LSB >>> 6 (dump column position)
  endm
  add 1
  jr nc,_newln_lsb_restore
  ; We need to incremenct the MSB due to carry.
  push af
  ld a,(_cursor+1) ; MSB
  add 1
  ld (_cursor+1),a
  pop af
_newln_lsb_restore:
  rept 6
  sla a ; LSB << 6 (restore empty column position)
  endm
  ld (_cursor),a
  z80unit_pop_reg
  ret

z80unit_pause:
  z80unit_push_reg
  z80unit_pop_reg
  ret

z80unit_exit:
 jr z80unit_exit

endif ; z80unit_m1_m3_m4_CASSETTE

; ------------------------------------------------------------------
; TRS80 Model II - TRSDOS version 2.0a
if z80unit_m2_TRSDOS2.0a

; Gets the size of a zero-terminated string and puts it in b (8-bits).
;
; Entry: hl  Points to a zero-terminated string.
; Exit:  b   Length of the string.
;        hl  Is unchanged.
_strln:
  push af
  push hl  ; save start of buffer
  ld b,0
_strln_loop:
  ld a,(hl)
  or 0
  jr z,_strln_restore
  inc b
  inc hl
  jr _strln_loop
_strln_restore:
  pop hl   ; restore start of buffer
  pop af
  ret

z80unit_print:
  z80unit_push_reg
  call _strln ; into b
  ld c,$03    ; end of line character: ETX
  ld a,9      ; VDLINE (pg 236)
  rst 8
  z80unit_pop_reg
  ret

z80unit_newln:
  z80unit_push_reg
  ld hl,0
  ld b,0   ; length
  ld c,$0d ; end of line character: <ENTER>
  ld a,9   ; VDLINE (pg 236)
  rst 8
  z80unit_pop_reg
  ret

z80unit_pause:
  z80unit_push_reg
  ld hl,_pause_txt
  call z80unit_print
  ld b,1
  ld hl,_buffer
  ld a,5   ; KBLINE (pg 230)
  rst 8
  z80unit_pop_reg
  ret

z80unit_exit:
  rst 0
endif ; z80unit_m2_TRSDOS2.0a

; ------------------------------------------------------------------
; TRS80 Model 1 - TRSDOS version 2.3 & LDOS version 5.3.1
; TRS80 Model 2 - LDOS version 06.03.01
; TRS80 Model 3 - TRSDOS version 1.3 & LDOS version 5.3.1
; TRS80 Model 4 - TRSDOS version 06.0201 & LDOS version 06.03.01
if z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1 || z80unit_m2_LDOS06.03.01 || z80unit_m3_TRSDOS1.3 || z80unit_m4_TRSDOS06.02.01_LDOS06.03.01

z80unit_print:
  z80unit_push_reg
  push hl  ; save start of buffer

  ; Change string terminator from zero to ETX.
  ld bc,132  ; search only 132 characters, truncate if needed
  ld a,0     ; search for zero
  cpir
  jr nz,_change_zero_to_etx
  dec hl     ; zero that was found is one address back

_change_zero_to_etx:
  ; We either found zero terminator or will truncate.
  ld (hl),$03 ; change string terminator to ETX (restored later)
  pop de      ; restore start of buffer
  push hl     ; save location to restore the zero terminator

  ; Print the string with no newline.
  ex de,hl ; put buffer address into hl
  if z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1
  call $4467 ; @DSPLY
  endif
  if z80unit_m3_TRSDOS1.3
  call $021b ; $VDLINE
  endif
  if z80unit_m2_LDOS06.03.01 || z80unit_m4_TRSDOS06.02.01_LDOS06.03.01
  ld a,10    ; @DSPLY (pg 7-19)
  rst 40
  endif

  pop hl
  ld (hl),0 ; restore zero terminator
  z80unit_pop_reg
  ret

z80unit_newln:
  z80unit_push_reg
  jr _newln_skip
_enter  defb  $0d ; <ENTER>
_newln_skip:
  ld hl,_enter
  if z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1
  call $4467 ; @DSPLY
  endif
  if z80unit_m3_TRSDOS1.3
  call $021b ; $VDLINE
  endif
  if z80unit_m2_LDOS06.03.01 || z80unit_m4_TRSDOS06.02.01_LDOS06.03.01
  ld a,10    ; @DSPLY (pg 7-19)
  rst 40
  endif
  z80unit_pop_reg
  ret

z80unit_pause:
  z80unit_push_reg
  ld hl,_pause_txt
  call z80unit_print
  ld b,1
  ld hl,_buffer
  if z80unit_m3_TRSDOS1.3 || z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1
  call $0040 ; $KBLINE / @KEYIN (pg 6-55)
  endif
  if z80unit_m2_LDOS06.03.01 || z80unit_m4_TRSDOS06.02.01_LDOS06.03.01
  ld c,0    ; should contain zero
  ld a,9    ; @DSPLY (pg 7-19)
  rst 40
  endif
  z80unit_pop_reg
  ret

z80unit_exit:
  if z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1 || z80unit_m3_TRSDOS1.3
  ; This works for TRSDOS 1.3 but page 12/15 of the "TRS-80 MODEL III
  ; Operation and BASIC Language Reference Manual" says to use $READY:
  ; which is a jp to $1a19. This doesn't work.
  call $402d ; @EXIT (pg 6-51)
  endif
  if z80unit_m2_LDOS06.03.01 || z80unit_m4_TRSDOS06.02.01_LDOS06.03.01 
  ld hl,0  ; Normal termination
  ld a,22  ; @EXIT (pg 7-19)
  rst 40
  endif

endif ; z80unit_m1_TRSDOS2.3_and_m3_LDOS5.3.1 || z80unit_m2_LDOS06.03.01 || z80unit_m3_TRSDOS1.3 || z80unit_m4_TRSDOS06.02.01_LDOS06.03.01

; ---------------------------------------------------------------- ;
; / / / / / / / / / / / / SUPPORT ROUTINES / / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; We want this include file to be self-contained. So many support
; routines dealing with format conversions and string manipulation
; are included below.

; ------------------------------------------------------------------
; Copies zero-termianted data to a buffer. The copy includes the terminator.
;
; Start: ix  Points to zero-terminated source buffer.
;        iy  Points to destination buffer.
; Exit:  ix  Points to the source buffer's terminating zero.
;        iy  Points to the destination buffer's terminating zero.
_strcpy:
  ld a,(ix)
  ld (iy),a
  or a ; is a == 0?
  ret z
  inc ix
  inc iy
  jr _strcpy

; ------------------------------------------------------------------
; Subroutine to covert 1 byte into a hex value in ASCII. This has been
; modified from the book so that the output goes into a buffer.
;
; Author: William Barden, Jr.
;         'TRS-80 Assembly-Language Programming', 1979 pg 198.
;
; Entry: a   Byte to be converted.
;        hl  Pointer to the start of a two-byte buffer.
; Exit:  hl  hl+2
_barden_hexcv:
  ld c,a     ; Save two hex digits
  srl a      ; Align high digit
  srl a
  srl a
  srl a
  call _cvt  ; Convert to ASCII
  ld (hl),a
  inc hl
  ld a,c     ; Restore original
  and $0f    ; Get low digit
  call _cvt  ; Convert to ASCII
  ld (hl),a
  inc hl
  ret
_cvt:
  add a,$30  ; Conversion factor
  cp $3a
  jr c,_cvt_is_done
  add a,7
_cvt_is_done:
  ret

; ------------------------------------------------------------------
; 16-bit binary to ASCII decimal conversion into a fixed 5-byte buffer.
; Results below 5 digits will have leading zeros, e.g., 00046.
;
; Author: William Barden, Jr.
;         'More TRS-80 Assembly-Language Programming', 1982 pg 156.
;
; Entry: hl  16-bit binary value.
;        ix  Pointer to the start of the character buffer.
; Exit:  buffer filled with five ASCII characters, possibly with leading zeros.
;        ix  buffer+5
_barden_bindec:
  jr _skip_bindec
_ptable	defw	10000
	defw	1000
	defw	100
	defw	10
	defw	1
_skip_bindec:
  ld iy,_ptable
_bin010:
  xor a
  ld d,(iy+1)
  ld e,(iy)
_bin020:
  or a
  sbc hl,de
  jr c,_bin030
  inc a
  jr _bin020
_bin030:
  add hl,de
  add a,$30
  ld (ix),a
  inc ix
  inc iy
  inc iy
  ld a,e
  cp 1
  jr nz,_bin010
  ret

; ------------------------------------------------------------------
; Skip past leading ASCII '0's in an zero-terminated string and return
; a pointer to the first non-'0'. The result will be the last '0' if the
; string is entirly composed of '0's.
;
; Entry: hl   Point to start of the buffer.
; Exit:  hl   Points not first non-'0' ASCII character in the
;             string or the last '0' if composed of all '0's.
_skip_ascii_zeros:
  ld a,(hl)
  xor '0' ; is a == (ASCII) '0'?
  jr nz,_check_for_zero_value
  inc hl
  jr _skip_ascii_zeros
_check_for_zero_value:
  ; Move back one if we are at the string terminator (show '0').
  ld a,(hl)
  or a ; is a == 0?
  ret nz
  dec hl
  ret

; ------------------------------------------------------------------
; 16-bit binary to ASCII decimal conversion. The result will be from
; one to five ASCII characters.
;
; Entry: de  A 16-bit binary value.
;        hl  Pointer to the start of destination buffer.
; 
; Exit:  buffer filled with up to five ASCII characters.
;        hl  Points to the last character + 1.
_bindec16:
  push hl ; save start of result buffer
  jr _bindec16_skip
_bindec16_buffer	defs	5
			defb	0
_bindec16_skip:
  ld ix,_bindec16_buffer
  ex de,hl ; get the value into hl
  call _barden_bindec 
  ld hl,_bindec16_buffer
  call _skip_ascii_zeros
  push hl
  pop ix ; points to start of result in the scratch buffer
  pop iy ; points to the result buffer
  call _strcpy
  push iy
  pop hl
  ret

; ---------------------------------------------------------------- ;
; / / / / / / / / / / / / X80UNIT ROUTINES / / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; Prints the ASCII decimal value of a 16-bit counter to the console.
;
; Entry: de  A 16-bit binary value.
z80unit_print_counter:
  ld hl,_buffer
  call _bindec16
  ld (hl),0
  ld hl,_buffer
  call z80unit_print
  ret

; ------------------------------------------------------------------
; Shows the title and starts a unit test.
;
; Entry: hl  Points to the zero-terminated title of the test.
z80unit_show_title_and_start_test:
  push hl ; save the title of the test to print later

  ld a,(_title_displayed)
  or a ; is a == 0?
  jr nz,_start_test
  ld a,1
  ld (_title_displayed),a

  call z80unit_newln ; skip by "...." line if TRSDOS on trs80gp.
  ld hl,_title_txt
  call z80unit_print
  call z80unit_newln

_start_test:
  ; Note we are running a test.
  ld a,1
  ld (_running_test),a

  ; Print the name of the test.
  pop hl
  call z80unit_print
  ret

; ------------------------------------------------------------------
; Show progress upon a passed assertion and update flags & counters.
z80unit_passed_progress:
  ld hl,_passed_progress_txt
  call z80unit_print

  ; Increment the assertion passed counter.
  ld hl,(_passed_count)
  inc hl
  ld (_passed_count),hl

  ; Note the assertion passed.
  ld a,1
  ld (_last_passed),a
  ret

; ------------------------------------------------------------------
; Show progress upon a failed assertion and update flags & counters.
z80unit_failed_progress:
  ld a,(_last_passed)
  or a ; set z flag
  jr z,_last_assertion_failed

  ; Previous assertion passed so we output a newline to separate
  ; the failure message from the progress bar.
  call z80unit_newln

_last_assertion_failed:
  ld hl,_failed_progress_txt
  call z80unit_print

  ; Increment the assertion failed counter.
  ld hl,(_failed_count)
  inc hl
  ld (_failed_count),hl

  ; Note the assertion failed (last passed is no longer true).
  ld a,0
  ld (_last_passed),a
  ret

; ------------------------------------------------------------------
; Prints a 8-bit value as hex and decimal ASCII to the console.
; For example, for 55 the output is "<0x37=55>".
;
; Entry: a   An 8-bit value.
z80unit_print_value8:
  ld hl,_buffer

  push af
  push af
  push af ; save the value for uses below

  ; Output as hex ASCII.
  ld (hl),'0'
  inc hl
  ld (hl),'x'
  inc hl

  pop af ; restore the value
  call _barden_hexcv

  ld (hl),'='
  inc hl

  ; Output as decimal ASCII.
  pop af ; restore the value
  ld e,a
  ld d,0 ; de = the value (but 16 bits)
  call _bindec16

  ; Output as ASCII (ensure printable).
  pop af ; restore the value
  cp ' '
  jr c,_value8_skip_char
  ld (hl),'='
  inc hl
  ld (hl),$27
  inc hl
  ld (hl),a
  inc hl
  ld (hl),$27
  inc hl
_value8_skip_char

  ld (hl),0 ; terminate the string

  ld hl,_buffer
  call z80unit_print
  ret

; ------------------------------------------------------------------
; Prints a 16-bit value as hex and decimal ASCII to the console.
; For example, for 55 the output is "<0x0037=55>"
;
; Entry: hl  A 16-bit value.
z80unit_print_value16:
  ld b,h
  ld c,l ; bc <- hl
  ld hl,_buffer

  push bc
  push bc
  push bc ; save the value for three uses below

  ld (hl),'0'
  inc hl
  ld (hl),'x'
  inc hl

  pop bc ; restore the value
  ld a,b
  call _barden_hexcv
  pop bc ; restore the value
  ld a,c
  call _barden_hexcv

  ld (hl),'='
  inc hl

  pop de ; restore the value
  call _bindec16
  ld (hl),0

  ld hl,_buffer
  call z80unit_print
  ret

; ------------------------------------------------------------------
; Ends the current test, if necessary.
z80unit_end_test:
  ld a,(_running_test)
  or a  ; set z flag
  ret z ; nothing to do -- no test running

  ; Complete the progress bar for this test.
  ld hl,_complete_progress_bar_txt
  call z80unit_print
  call z80unit_newln

  ; Note we are no longer running a test.
  ld a,0
  ld (_running_test),a
  ret

; ------------------------------------------------------------------
; Report results on the overall unit test.
z80unit_report:
  call z80unit_end_test

  ld hl,(_failed_count)
  ld a,h
  or l ; is hl == 0?
  jr nz,_report_problems
  ld hl,_report_success_txt
  jr _print_result
_report_problems:
  ld hl,_report_problems_txt
_print_result:
  call z80unit_print

  ; Print test passed count.
  ld hl,_buffer
  ld de,(_passed_count)
  call _bindec16
  ld (hl),0
  ld hl,_buffer
  call z80unit_print
  ld hl,_report_passed_txt
  call z80unit_print

  ; Print test failed count.
  ld hl,_buffer
  ld de,(_failed_count)
  call _bindec16
  ld (hl),0
  ld hl,_buffer
  call z80unit_print
  ld hl,_report_failed_txt
  call z80unit_print
  call z80unit_newln
  ret

; ---------------------------------------------------------------- ;
; / / / / / / / / / / / / / PUBLIC  MACROS / / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; Starts a new test.
;
; Examples:
;   z80unit_test 'barden_fill'
;
; name - the name of the test
z80unit_test macro name,?test_title_txt,?skip
  jp ?skip ; Could be >127 characters of output below.
?test_title_txt	defb	' name (',0
?skip:
  z80unit_push_reg
  call z80unit_end_test ; if one is running

  ld hl,?test_title_txt
  call z80unit_show_title_and_start_test
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Ends the unit test. Should be called after the last test to report
; passed/failed counts for the unit test.
; See also z80unit_end_and_exit if you want to exit the program.
;
; Examples:
;   z80unit_end
z80unit_end macro ?passed_txt,?failed_txt,?skip
  z80unit_push_reg
  call z80unit_end_test
  call z80unit_report
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Ends the unit test and exits to the OS. Should be called after the
; last test to report passed/failed counts for the unit test.
;
; Examples:
;   z80unit_end_and_exit
z80unit_end_and_exit macro ?passed_txt,?failed_txt,?skip
  z80unit_end
  call z80unit_exit
  endm

; ---------------------------------------------------------------- ;
; / / / / / / / / / / / / 8-BIT ASSERTIONS / / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; Asserts that an 8-bit value is zero.
;
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertZero8 a
;   assertZero8 0
;   assertZero8 ($3a00)
;
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertZero8 macro actual,msg,?sact,?txt0,?txt1,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sact	defs	1
?txt0	defb	' assertZero8 actual : value was ',0
?txt1	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed value.
  ld a,actual
  ld (?sact),a

  ; Check the assertion.
  ld a,(?sact)
  or a
  jr nz,?fail

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?sact)
  call z80unit_print_value8

  ld a,(?txt1+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt1
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 8-bit values are equal.
;
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertEquals8 a,$03
;   assertEquals8 a,c
;   assertEquals8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertEquals8 macro expected,actual,msg,?sexp,?sact,?txt0,?txt1,?txt2,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sexp	defs	1
?sact	defs	1
?txt0	defb	' assertEquals8 expected,actual : ex`pected ',0
?txt1	defb	' but was ',0
?txt2	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push af
  ld a,expected
  ld (?sexp),a
  pop af
  ld a,actual
  ld (?sact),a

  ; Check the assertion.
  ld a,(?sact)
  ld c,a
  ld a,(?sexp)
  xor c ; exp == act
  jr nz,?fail

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?sexp)
  call z80unit_print_value8

  ld hl,?txt1
  call z80unit_print

  ld a,(?sact)
  call z80unit_print_value8

  ld a,(?txt2+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt2
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 8-bit values are not equal.
;
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertNotEquals8 a,$03
;   assertNotEquals8 a,c
;   assertNotEquals8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertNotEquals8 macro expected,actual,msg,?sexp,?sact,?txt0,?txt1,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sexp	defs	1
?sact	defs	1
?txt0	defb	' assertNotEquals8 expected,actual : both were ',0
?txt1	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push af
  ld a,expected
  ld (?sexp),a
  pop af
  ld a,actual
  ld (?sact),a

  ; Check the assertion.
  ld a,(?sact)
  ld c,a
  ld a,(?sexp)
  xor c ; exp == act
  jr z,?fail

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?sexp)
  call z80unit_print_value8

  ld a,(?txt1+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt1
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that a first 8-bit value is greater than a second 8-bit value.
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
;
; The registers are saved and restored.
;
; Examples:
;   assertGreaterThan8 a,$03
;   assertGreaterThan8 a,c
;   assertGreaterThan8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertGreaterThan8 macro val1,val2,msg,?s1,?s2,?txt0,?txt1,?txt2,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?s1	defs	1
?s2	defs	1
?txt0	defb	' assertGreaterThan8 val1,val2 : ',0
?txt1	defb	' <= ',0
?txt2	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push af
  ld a,val1
  ld (?s1),a
  pop af
  ld a,val2
  ld (?s2),a

  ; Check the assertion.
  ld a,(?s2)
  ld c,a
  ld a,(?s1)
  cp c
  jr c,?fail  ; s1 < s2
  jr z,?fail  ; s1 == s2

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?s1)
  call z80unit_print_value8

  ld hl,?txt1
  call z80unit_print

  ld a,(?s2)
  call z80unit_print_value8

  ld a,(?txt2+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt2
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that a first 8-bit value is greater than or equal to a
; second 8-bit value.
;
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertGreaterThanOrEquals8 a,$03
;   assertGreaterThanOrEquals8 a,c
;   assertGreaterThanOrEquals8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertGreaterThanOrEquals8 macro val1,val2,msg,?s1,?s2,?txt0,?txt1,?txt2,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?s1	defs	1
?s2	defs	1
?txt0	defb	' assertGreaterThanEquals8 val1,val2 : ',0
?txt1	defb	' < ',0
?txt2	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push af
  ld a,val1
  ld (?s1),a
  pop af
  ld a,val2
  ld (?s2),a

  ; Check the assertion.
  ld a,(?s2)
  ld c,a
  ld a,(?s1)
  cp c
  jr c,?fail  ; s1 < s2

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?s1)
  call z80unit_print_value8

  ld hl,?txt1
  call z80unit_print

  ld a,(?s2)
  call z80unit_print_value8

  ld a,(?txt2+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt2
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that a first 8-bit value is less than a second 8-bit value.
;
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertLessThan8 a,$03
;   assertLessThan8 a,c
;   assertLessThan8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertLessThan8 macro val1,val2,msg,?s1,?s2,?txt0,?txt1,?txt2,?skip,?pass,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?s1	defs	1
?s2	defs	1
?txt0	defb	' assertLessThan8 val1,val2 : ',0
?txt1	defb	' >= ',0
?txt2	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push af
  ld a,val1
  ld (?s1),a
  pop af
  ld a,val2
  ld (?s2),a

  ; Check the assertion.
  ld a,(?s2)
  ld c,a
  ld a,(?s1)
  cp c
  jr c,?pass  ; s1 < s2
  jr ?fail

?pass:
  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?s1)
  call z80unit_print_value8

  ld hl,?txt1
  call z80unit_print

  ld a,(?s2)
  call z80unit_print_value8

  ld a,(?txt2+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt2
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that a first 8-bit value is less than or equal to a
; second 8-bit value.
;
; Any <exp> valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertLessThanOrEquals8 a,$03
;   assertLessThanOrEquals8 a,c
;   assertLessThanOrEquals8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertLessThanOrEquals8 macro val1,val2,msg,?s1,?s2,?txt0,?txt1,?txt2,?skip,?pass,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?s1	defs	1
?s2	defs	1
?txt0	defb	' assertLessThanOrEquals8 val1,val2 : ',0
?txt1	defb	' > ',0
?txt2	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push af
  ld a,val1
  ld (?s1),a
  pop af
  ld a,val2
  ld (?s2),a

  ; Check the assertion.
  ld a,(?s2)
  ld c,a
  ld a,(?s1)
  cp c
  jr c,?pass  ; s1 < s2
  jr z,?pass  ; s1 == s2
  jr ?fail

?pass:
  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld a,(?s1)
  call z80unit_print_value8

  ld hl,?txt1
  call z80unit_print

  ld a,(?s2)
  call z80unit_print_value8

  ld a,(?txt2+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt2
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ---------------------------------------------------------------- ;
; / / / / / / / / / / /  16-BIT ASSERTIONS   / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; Asserts that a 16-bit value is zero.
;
; Any 16-bit register or any <exp> valid within "ld hl,<exp>" may be
; used for the argument.
; The registers are saved and restored.
;
; Examples:
;   assertZero16 bc
;   assertZero16 $34a4
;   assertZero16 ($3a00)
;
; Note: Any indirect register value, such as (hl) or (ix), is not supported.
;
; actual   - A 16-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertZero16 macro actual,msg,?sact,?txt0,?txt1,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sact	defs	2
?txt0	defb	' assertZero16 actual : value was ',0
?txt1	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed value.
  z80unit_is_reg16 actual
  if z80unit_reg16
    push actual
    pop hl
  else
    ld hl,actual
  endif
  ld (?sact),hl

  ; Check the assertion.
  ld hl,(?sact)
  ld a,h
  or l
  jr nz,?fail

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld hl,(?sact)
  ld b,h
  ld c,l
  call z80unit_print_value16

  ld a,(?txt1+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt1
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 16-bit values are equal.
;
; Any 16-bit register or any <exp> valid within "ld hl,<exp>" may be
; used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertEquals16 hl,$03
;   assertEquals16 de,ix
;   assertEquals16 5,($3a00)
;
; Note: Any indirect register value, such as (hl) or (ix), is not supported.
;
; expected - An 16-bit value.
; actual   - An 16-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertEquals16 macro expected,actual,msg,?sexp,?sact,?txt0,?txt1,?txt2,?skip,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sexp	defs	2
?sact	defs	2
?txt0	defb	' assertEquals16 expected,actual : ex`pected ',0
?txt1	defb	' but was ',0
?txt2	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push hl
  z80unit_is_reg16 expected
  if z80unit_reg16
    push expected
    pop hl
  else
    ld hl,expected
  endif
  ld (?sexp),hl
  pop hl
  z80unit_is_reg16 actual
  if z80unit_reg16
    push actual
    pop hl
  else
    ld hl,actual
  endif
  ld (?sact),hl

  ; Check the assertion.
  ld hl,(?sact)
  ld de,(?sexp)
  ld a,h
  xor d ; hl msb == de msb
  jr nz,?fail
  ld a,l
  xor e ; hl lsb == de lsb
  jr nz,?fail

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld hl,(?sexp)
  ld b,h
  ld c,l
  call z80unit_print_value16

  ld hl,?txt1
  call z80unit_print

  ld hl,(?sact)
  ld b,h
  ld c,l
  call z80unit_print_value16

  ld a,(?txt2+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt2
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 16-bit values are not equal.
;
; Any 16-bit register or any <exp> valid within "ld hl,<exp>" may be
; used for the two arguments.
; The registers are saved and restored.
;
; Examples:
;   assertNotEquals16 hl,$03
;   assertNotEquals16 de,ix
;   assertNotEquals16 5,($3a00)
;
; Note: Any indirect register value, such as (hl) or (ix), is not supported.
;
; expected - An 16-bit value.
; actual   - An 16-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertNotEquals16 macro expected,actual,msg,?sexp,?sact,?txt0,?txt1,?skip,?pass,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sexp	defs	2
?sact	defs	2
?txt0	defb	' assertNotEquals16 expected,actual : both were ',0
?txt1	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed values.
  push hl
  z80unit_is_reg16 expected
  if z80unit_reg16
    push expected
    pop hl
  else
    ld hl,expected
  endif
  ld (?sexp),hl
  pop hl
  z80unit_is_reg16 actual
  if z80unit_reg16
    push actual
    pop hl
  else
    ld hl,actual
  endif
  ld (?sact),hl

  ; Check the assertion.
  ld hl,(?sact)
  ld de,(?sexp)
  ld a,h
  xor d ; hl msb == de msb
  jr nz,?pass
  ld a,l
  xor e ; hl lsb == de lsb
  jr nz,?pass
  jr ?fail

?pass:
  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ld hl,(?sexp)
  ld b,h
  ld c,l
  call z80unit_print_value16

  ld a,(?txt1+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt1
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ---------------------------------------------------------------- ;
; / / / / / / / / / /  MEMORY BLOCK ASSERTIONS / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; Asserts that the memory pointed by ptr contains the passed string.
;
; Any 16-bit register or any <exp> valid within "ld hl,<exp>" may be
; used for the first argument.
; The registers are saved and restored.
;
; Examples:
;   assertMemString $3a00,'video'
;   assertMemString hl,'abc'
; s1  defb 'test'
;   assertMemString s1,'test'
;   assertMemString s1+2,'t'
;
; ptr      - A pointer to memory.
; string   - A immediate string of bytes.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertMemString macro ptr,string,msg,?sptr,?sstr,?slen,?txt0,?txt1,?txt2,?txt3,?skip,?loop,?loop_entry,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sptr	defs	2
?sstr	defb	'string'
?slen	equ	$-?sstr
?txt0	defb	' assertMemString ptr,',$27,'string',$27,' : at +',0
?txt1	defb	' ',0
?txt2	defb	' was not ',0
?txt3	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the passed pointer to memory.
  z80unit_is_reg16 ptr
  if z80unit_reg16
    push ptr
    pop hl
  else
    ld hl,ptr
  endif
  ld (?sptr),hl

  ; Check the assertion.
  ld ix,(?sptr)
  ld iy,?sstr
  ld hl,?slen   ; number of bytes to compare
  ld bc,0       ; index in the string
  jr ?loop_entry
?loop
  inc ix
  inc iy
  inc bc
?loop_entry
  ld d,(ix)
  ld a,(iy)
  xor d ; (ix) == (iy)
  jr nz,?fail

  dec hl
  ld d,h
  ld a,l
  or d ; hl == 0
  jr nz,?loop
  
  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  push iy
  push ix
  push bc ; index in the string

  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ; print the index of problem.
  pop de
  call z80unit_print_counter

  ld hl,?txt1
  call z80unit_print

  ; print the actual byte.
  pop iy
  ld a,(iy)
  call z80unit_print_value8

  ld hl,?txt2
  call z80unit_print

  ; print the expected byte.
  pop ix
  ld a,(ix)
  call z80unit_print_value8

  ld a,(?txt3+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt3
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the memory pointed to by 'ptr1' and 'ptr2' are the same
; for 'count bytes. In this version 'count' is a 8-bit value.
;
; Any 16-bit register or any <exp> valid within "ld hl,<exp>" may be
; used for the 'ptr' arguments.
; The 'count' must be an <exp> valid within "ld a,<exp>".
; The registers are saved and restored.
;
; Examples:
; s1  defb 'test'
; s2  defb 'test'
; s2l equ  $-s2
;   assertMemEquals8 s1,s2,s2l
;   ld a,4
;   assertMemEquals8 s1,s2,a
;
; ptr1     - A pointer to memory.
; ptr2     - A pointer to memory.
; count    - Count of bytes to examine, must be < 256 (fit in 8-bits).
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertMemEquals8 macro ptr1,ptr2,count,msg,?sp1,?sp2,?sct,?txt0,?txt1,?txt2,?txt3,?skip,?loop,?loop_entry,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sp1	defs	2
?sp2	defs	2
?sct	defs	1
?txt0	defb	' assertMemEquals8 ptr1,ptr2,count : at +',0
?txt1	defb	' ',0
?txt2	defb	' was not ',0
?txt3	defb	' : msg',0
?skip:
  z80unit_push_reg

  ; Save the count.
  ld a,count
  ld (?sct),a

  ; Save the first pointer.
  push hl ; save hl, other ptr might use it
  z80unit_is_reg16 ptr1
  if z80unit_reg16
    push ptr1
    pop hl
  else
    ld hl,ptr1
  endif
  ld (?sp1),hl
  pop hl

  ; Save the second pointer.
  z80unit_is_reg16 ptr2
  if z80unit_reg16
    push ptr2
    pop hl
  else
    ld hl,ptr2
  endif
  ld (?sp2),hl

  ; Check the assertion.
  ld ix,(?sp1)
  ld iy,(?sp2)
  ld a,(?sct) ; number of bytes to compare
  ld h,a
  ld bc,0     ; index in the string
  jr ?loop_entry
?loop
  inc ix
  inc iy
  inc bc
?loop_entry
  ld d,(ix)
  ld a,(iy)
  xor d ; (ix) == (iy)
  jr nz,?fail

  dec h
  ld a,h
  or a ; count == 0
  jr nz,?loop
  
  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  push iy
  push ix
  push bc ; index in the string

  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ; print the index of problem.
  pop de
  call z80unit_print_counter

  ld hl,?txt1
  call z80unit_print

  ; print the actual byte.
  pop iy
  ld a,(iy)
  call z80unit_print_value8

  ld hl,?txt2
  call z80unit_print

  ; print the expected byte.
  pop ix
  ld a,(ix)
  call z80unit_print_value8

  ld a,(?txt3+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt3
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the memory pointed to by 'ptr1' and 'ptr2' are the same
; for 'count bytes. In this version 'count' is a 16-bit value.
;
; Any 16-bit register or any <exp> valid within "ld hl,<exp>" may be
; used for the 'ptr' and 'count' arguments.
; The registers are saved and restored.
;
; Examples:
; s1  defb 'test'
; s2  defb 'test'
; s2l equ  $-s2
;   assertMemEquals16 s1,s2,s2l
;   ld hl,4
;   assertMemEquals16 s1,s2,hl
;
; ptr1     - A pointer to memory.
; ptr2     - A pointer to memory.
; count    - Count of bytes to examine, must be < 65535 (fit in 16-bits).
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertMemEquals16 macro ptr1,ptr2,count,msg,?sp1,?sp2,?sct,?txt0,?txt1,?txt2,?txt3,?skip,?loop,?loop_entry,?fail,?nl,?end
  jp ?skip ; could be >127 characters of output below
?sp1	defs	2
?sp2	defs	2
?sct	defs	2
?txt0	defb	' assertMemEquals16 ptr1,ptr2,count : at +',0
?txt1	defb	' ',0
?txt2	defb	' was not ',0
?txt3	defb	' : msg',0
?skip:
  z80unit_push_reg

  push hl ; save hl, ptrs might use it
  ; Save the count.
  z80unit_is_reg16 count
  if z80unit_reg16
    push count
    pop hl
  else
    ld hl,count
  endif
  ld (?sct),hl
  pop hl

  ; Save the first pointer.
  push hl ; save hl, other ptr might use it
  z80unit_is_reg16 ptr1
  if z80unit_reg16
    push ptr1
    pop hl
  else
    ld hl,ptr1
  endif
  ld (?sp1),hl
  pop hl

  ; Save the second pointer.
  z80unit_is_reg16 ptr2
  if z80unit_reg16
    push ptr2
    pop hl
  else
    ld hl,ptr2
  endif
  ld (?sp2),hl

  ; Check the assertion.
  ld ix,(?sp1)
  ld iy,(?sp2)
  ld hl,(?sct) ; number of bytes to compare
  ld bc,0      ; index in the string
  jr ?loop_entry
?loop
  inc ix
  inc iy
  inc bc
?loop_entry
  ld d,(ix)
  ld a,(iy)
  xor d ; (ix) == (iy)
  jr nz,?fail

  dec hl
  ld d,h
  ld a,l
  or d ; count == 0
  jr nz,?loop
  
  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?fail:
  ; The assertion failed.
  push iy
  push ix
  push bc ; index in the string

  call z80unit_failed_progress

  ld hl,?txt0
  call z80unit_print

  ; print the index of problem.
  pop de
  call z80unit_print_counter

  ld hl,?txt1
  call z80unit_print

  ; print the actual byte.
  pop iy
  ld a,(iy)
  call z80unit_print_value8

  ld hl,?txt2
  call z80unit_print

  ; print the expected byte.
  pop ix
  ld a,(ix)
  call z80unit_print_value8

  ld a,(?txt3+3)
  or a
  jr z,?nl ; no msg to display
  ld hl,?txt3
  call z80unit_print
?nl:
  call z80unit_newln
  call z80unit_pause
?end:
  z80unit_pop_reg
  endm

endif ; INCLUDE_Z80UNIT
