ifndef INCLUDE_Z80UNIT
INCLUDE_BZ80UNIT equ 1

;     _____ _____             _ _
;    |  _  |  _  |           (_) |
; ____\ V /| |/' |_   _ _ __  _| |_ 
;|_  // _ \|  /| | | | | '_ \| | __|
; / /| |_| \ |_/ / |_| | | | | | |_ 
;/___\_____/\___/ \__,_|_| |_|_|\__|
;                                   
; Author: Tim Halloran
                                   
; ---------- IMPLEMENTATION DETAILS ---------- ;

z80unit_passed_count	defw	0
z80unit_failed_count	defw	0
z80unit_title_displayed	defb	0 ; 0=no, 1=yes
z80unit_running_test	defb	0 ; 0=no, 1=yes
z80unit_last_passed	defb	1 ; 0=no, 1=yes

_title_txt		defb	'z80unit (Bigmit Software 2020)',$0d ; <RETURN>
_passed_progress_txt	defb	'P',$03 ; ETX
_failed_progress_txt	defb	'F',$03 ; ETX
_newline_txt		defb	$0d ; <RETURN>
_complete_progress_bar	defb	']',$0d ; <ENTER>
_report_passed_txt	defb	'PASSED = ',$03 ; ETX
_report_failed_txt	defb	'  FAILED = ',$03 ; ETX
_buffer			defs	16 ; buffer for ASCII conversions

; Remove leading spaces from @HEXDEC output, if needed.
; '    5' -> '5'
;
; Uses:  de,hl,bc
;
; Entry: de     Point to end-of-buffer + 1, i.e., post @HEXDEC call.
; Exit:  de,hl  Will point to end-of-buffer + 1.
z80unit_trim_hexdec:
  ; de back to start of the buffer
  dec de
  dec de
  dec de
  dec de
  dec de
  ld h,d  ; hl <- de
  ld l,e
  ld bc,5 ; ASCII length, assume 5
  jr _first_loop_increment
_find_number:
  inc hl
  dec bc
_first_loop_increment:
  ld a,(hl)
  xor ' ' ; a == ' '
  jr z,_find_number
  ; hl @ first non-space, de @ buffer start, bc is ASCII length.
  ldir
  ld h,d ; hl <- de
  ld l,e
  ret

; Write a 8-bit value as a number as hex and decimal into a buffer as ASCII.
; For example, for 55 the output is "<0x37/   55>"
; Uses:  a,c,hl,de
;
; Entry: a  The value to output.
;        hl  Points to a 14-byte buffer.
; Exit:  hl  Will point to end-of-buffer + 1.
z80unit_reg8_out:
  ld c,a ; save the value
  ld (hl),'<'
  inc hl
  ld (hl),'0'
  inc hl
  ld (hl),'x'
  inc hl
  ld a,98 ; @HEX8
  rst 40
  ld (hl),'='
  inc hl
  ld d,h
  ld e,l
  ld a,c ; the value
  ld l,a
  ld h,0 ; hl = the value (but 16 bits)
  ld a,97 ; @HEXDEC
  rst 40
  call z80unit_trim_hexdec
  ld (hl),'>'
  inc hl
  ret

; Shows the title
z80unit_show_title:
  ld a,(z80unit_title_displayed)
  or a ; set z flag
  jr nz,_end_show_title
  ld a,1
  ld (z80unit_title_displayed),a

  ld hl,_title_txt
  ld a,10 ; @DSPLY
  rst 40
_end_show_title:
  ret

; Shows progress upon a passed assertion.
z80unit_passed_progress:
  ld hl,_passed_progress_txt
  ld a,10 ; @DSPLY
  rst 40

  ; Increment the assertion passed counter.
  ld hl,(z80unit_passed_count)
  inc hl
  ld (z80unit_passed_count),hl

  ; Note the assertion passed.
  ld a,1
  ld (z80unit_last_passed),a
  ret

; Shows progress upon a passed assertion.
z80unit_failed_progress:
  ld a,(z80unit_last_passed)
  or a ; set z flag
  jr z,_last_assertion_failed

  ; Previous assertion passed so we output a newline to separate
  ; the failure message from the progress bar.
  ld hl,_newline_txt
  ld a,10 ; @DSPLY
  rst 40

_last_assertion_failed:
  ld hl,_failed_progress_txt
  ld a,10 ; @DSPLY
  rst 40

  ; Increment the assertion failed counter.
  ld hl,(z80unit_failed_count)
  inc hl
  ld (z80unit_failed_count),hl

  ; Note the assertion failed
  ld a,0
  ld (z80unit_last_passed),a
  ret

; Ends the current test, if necessary.
z80unit_end_test:
  ld a,(z80unit_running_test)
  or a ; set z flag
  jr z,_no_test_running

  ; Complete the progress bar for this test.
  ld hl,_complete_progress_bar
  ld a,10 ; @DSPLY
  rst 40

  ; Note we are no longer running a test
  ld a,0
  ld (z80unit_running_test),a
_no_test_running:
  ret

; Report results on the overall unit test.
z80unit_report:
  call z80unit_end_test

  ; Report on passed tests.
  ld hl,_report_passed_txt
  ld a,10 ; @DSPLY
  rst 40

  ld de,_buffer
  ld a,(z80unit_passed_count)
  ld l,a
  ld h,0 ; hl = the count (but 16 bits)
  ld a,97 ; @HEXDEC
  rst 40
  call z80unit_trim_hexdec
  ld a,$03 ; ETX
  ld (hl),a
  ld hl,_buffer
  ld a,10 ; @DSPLY
  rst 40

  ; Report on failed tests.
  ld hl,_report_failed_txt
  ld a,10 ; @DSPLY
  rst 40

  ld de,_buffer
  ld a,(z80unit_failed_count)
  ld l,a
  ld h,0 ; hl = the count (but 16 bits)
  ld a,97 ; @HEXDEC
  rst 40
  call z80unit_trim_hexdec
  ld a,$0d ; <ENTER>
  ld (hl),a
  ld hl,_buffer
  ld a,10 ; @DSPLY
  rst 40
  ret

; ---------- PUBLIC MACROS ---------- ;

; Starts a new test.
;
; name - the name of the test
z80unit_test macro name,?test_title_txt,?skip
  jp ?skip ; Could be >127 characters of output below.
?test_title_txt	defb	'`name` [',$03 ; ETX
?skip:
  call z80unit_end_test
  call z80unit_show_title

  ; Note we are running a test.
  ld a,1
  ld (z80unit_running_test),a

  ; Print a title for the test.
  ld hl,?test_title_txt
  ld a,10 ; @DSPLY
  rst 40
  endm

; Ends the unit test. Should be called after the last test to report
; passed/failed counts for the unit test.
z80unit_end macro ?passed_txt,?failed_txt,?skip
  call z80unit_end_test
  call z80unit_report
  endm

; ---------- ASSERT MACROS ---------- ;

; assertEquals8
; assertNotEquals8
; assertGreaterThan8
; assertLessThan8

; Asserts that the two 8-bit registers or immediate values are equal.
;
; expected - 8-bit register or immediate value.
; actual   - 8-bit register or immediate value.
; msg      - to include in the diagnostic output message
;            if the assertion fails. (optional)
assertEquals8 macro expected,actual,msg,?expected,?actual,?m0_txt,?m1_txt,?m2_txt,?failed,?skip,?end
  jp ?skip ; Could be >127 characters of output below.
?expected	defb	0
?actual		defb	0
?m0_txt		defb	' assertEquals8(`expected`,`actual`) ','e','xpected ',$03 ; ETX
?m1_txt		defb	' but was ',$03 ; ETX
?m2_txt		defb	' `msg`',$0d ; <ENTER>
?skip:
  ld a,expected
  ld (?expected),a
  ld a,actual
  ld (?actual),a

  ; Check the assertion
  ld a,(?expected)
  ld c,a
  ld a,(?actual)
  xor c ; expected == actual
  jr nz,?failed

  ; The assertion passed.
  call z80unit_passed_progress
  jp ?end

?failed:
  ; The assertion failed so we ouput a diagnostic message.
  call z80unit_failed_progress

  ld hl,?m0_txt
  ld a,10 ; @DSPLY
  rst 40

  ld a,(?expected)
  ld hl,?m0_txt ; reuse buffer
  call z80unit_reg8_out
  ld a,$03 ; ETX
  ld (hl),a
  ld hl,?m0_txt
  ld a,10 ; @DSPLY
  rst 40

  ld hl,?m1_txt
  ld a,10 ; @DSPLY
  rst 40

  ld a,(?actual)
  ld hl,?m0_txt ; reuse buffer
  call z80unit_reg8_out
  ld a,$03 ; ETX
  ld (hl),a
  ld hl,?m0_txt
  ld a,10 ; @DSPLY
  rst 40

  ld hl,?m2_txt
  ld a,10 ; @DSPLY
  rst 40
?end:
  nop
  endm

endif ; INCLUDE_Z80UNIT
