ifndef INCLUDE_Z80UNIT
INCLUDE_BZ80UNIT equ 1

;     _____ _____             _ _
;    |  _  |  _  |           (_) |
; ____\ V /| |/' |_   _ _ __  _| |_ 
;|_  // _ \|  /| | | | | '_ \| | __|
; / /| |_| \ |_/ / |_| | | | | | |_ 
;/___\_____/\___/ \__,_|_| |_|_|\__|
;                                   
; A unit testing library for the TRS-80
; Author: Tim Halloran
;
; assertZero8
; assertEquals8
; assertNotEquals8
; assertGreaterThan8
; assertLessThan8
; assertZero16
; assertEquals16
; assertNotEquals16
; assertGreaterThan16
; assertLessThan16
; assertContains mem*, value
; assertFilledWith8 mem*, reg/imm8, cnt
; assertFilledWith16 mem*, reg/imm16, cnt
                                   
; ---------------------------------------------------------------- ;
; / / / / / / / / / /  IMPLEMENTATION DETAILS  / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

_failed_count			defw	0
_passed_count			defw	0
_title_displayed		defb	0 ; 0=no, 1=yes
_running_test			defb	0 ; 0=no, 1=yes
_last_passed			defb	1 ; 0=no, 1=yes

_title_txt			defb	'z80unit (Bigmit Software 2020)',0
_passed_progress_txt		defb	'P',0
_failed_progress_txt		defb	'F',0
_diagnostic_expected_txt	defb	' expected ',0
_diagnostic_actual_txt		defb	' but was ',0
_complete_progress_bar_txt	defb	']',0
_report_success_txt		defb	'ALL TESTS PASSED (',0
_report_problems_txt		defb	'*** TESTS FAILED *** (',0
_report_passed_txt		defb	' passed, ',0
_report_failed_txt		defb	' failed)',0
_buffer				defs	16 ; buffer for ASCII conversions

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

; ---------------------------------------------------------------- ;
; / / / / / / / / /  OS SPECIFIC PRINT ROUTINES  / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; TRSDOS 6 / LDOS 6 (Model 4) implementation that prints a zero-terminated
; string to the screen. Output is truncated to 132 characters and
; no newline is printed.
;
; Tested running with 'trs80gp -m4' and 'trs80gp -m4 -ld'.
;
; Entry: hl  Points to a zero-terminated string.
_os_print:
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
  push hl     ; save location to restore the zero terminator.

  ; Print the string with no newline.
  ex de,hl    ; put buffer address into hl
  ld a,10 ; @DSPLY
  rst 40

  pop hl
  ld (hl),0 ; restore zero terminator
  z80unit_pop_reg
  ret

; ------------------------------------------------------------------
; TRSDOS 6 / LDOS 6 (Model 4) implementation that prints a newline to
; the screen.
;
; Tested running with 'trs80gp -m4' and 'trs80gp -m4 -ld'.
_os_newln:
  z80unit_push_reg
  jr _os_print_newln_skip
_os_newline	defb	$0d ; <ENTER>
_os_print_newln_skip:
  ld hl,_os_newline
  ld a,10 ; @DSPLY
  rst 40
  z80unit_pop_reg
  ret

; ---------------------------------------------------------------- ;
; / / / / / / / / / / / CONVERSION ROUTINES  / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; Subroutine to covert 1 byte into a hex value in ASCII. This has been
; modified from the book so that the output goes into a buffer.
;
; Author: William Barden, Jr.
;         'TRS-80 Assembly-Language Programming', 1979 pg 198.
;
; Uses:  a,c,hl
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
; 16-bit binary to ASCII decimal conversion.
;
; Author: William Barden, Jr.
;         'More TRS-80 Assembly-Language Programming', 1982 pg 156.
;
; Entry: hl  16-bit binary value
;        ix  Pointer to the start of the character buffer
; Exit:  buffer filled with five ASCII characters, leading zeros.
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
; Skip past leading zeros in an zero-terminated ASCII string.
;
; Uses:  hl,a
;
; Entry: hl   Point to start of the buffer.
; Exit:  hl   Points not first non '0' ASCII character in the
;             string or just the string '0'.
_skip_ascii_zeros:
  ld a,(hl)
  xor '0' ; a == '0'
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
; Write a 8-bit value as a number as hex and decimal into a buffer as ASCII.
; For example, for 55 the output is "<0x37/   55>"
; Uses:  a,c,hl,de
;
; Entry: a  The value to output.
;        hl  Points to a 14-byte buffer.
; Exit:  hl  Will point to end-of-buffer + 1.
z80unit_diagnostic_msg8:
  ld c,a ; save the value
  ld (hl),'<'
  inc hl
  ld (hl),'0'
  inc hl
  ld (hl),'x'
  inc hl
  ld a,c
  call _barden_hexcv
  ld (hl),'='
  inc hl
  ; Add decimal value.
  push hl
  pop ix
  ld a,c ; the value
  ld l,a
  ld h,0 ; hl = the value (but 16 bits)
  call _barden_bindec
  push ix
  pop hl
  ld (hl),'>'
  inc hl
  ret

; ------------------------------------------------------------------
; Shows the title and starts a unit test.
;
; Entry: hl  Points to the zero-terminated title of the test.
z80unit_show_title_and_start_test:
  push hl ; save the title of the test to print later

  ld a,(_title_displayed)
  or a ; set z flag
  jr nz,_start_test
  ld a,1
  ld (_title_displayed),a

  ld hl,_title_txt
  call _os_print
  call _os_newln

_start_test:
  ; Note we are running a test.
  ld a,1
  ld (_running_test),a

  ; Print a title for the test.
  pop hl
  call _os_print
  ret

; ------------------------------------------------------------------
; Shows progress upon a passed assertion.
z80unit_passed_progress:
  ld hl,_passed_progress_txt
  call _os_print

  ; Increment the assertion passed counter.
  ld hl,(_passed_count)
  inc hl
  ld (_passed_count),hl

  ; Note the assertion passed.
  ld a,1
  ld (_last_passed),a
  ret

; ------------------------------------------------------------------
; Shows progress upon a passed assertion.
z80unit_failed_progress:
  ld a,(_last_passed)
  or a ; set z flag
  jr z,_last_assertion_failed

  ; Previous assertion passed so we output a newline to separate
  ; the failure message from the progress bar.
  ld hl,_buffer
  inc hl
  ld (hl),0
  ld hl,_buffer
  call _os_print
  call _os_newln

_last_assertion_failed:
  ld hl,_failed_progress_txt
  call _os_print

  ; Increment the assertion failed counter.
  ld hl,(_failed_count)
  inc hl
  ld (_failed_count),hl

  ; Note the assertion failed (last passed is no longer true).
  ld a,0
  ld (_last_passed),a
  ret

; ------------------------------------------------------------------
; Entry: ix  points to the zero-terminated assertion text, e.g.,
;            'assertEquals8(a,0)' created by the macro.
;        iy  points to an optional zero-terminated diagnostic message.
;            (iy) will be 0 (empty but propertly zero-terminated) if no
;            diagnostic message was provided to the assertion.
;        b   expected value
;        c   actual value
z80unit_output_diagnostic_msg8:
  jr _skip_msg8
_saved_exp	defs	1
_saved_act	defs	1
_skip_msg8:
  ld a,b
  ld (_saved_exp),a
  ld a,c
  ld (_saved_act),a

  ld hl,_buffer
  ld (hl),' '
  call _os_print
  push ix
  pop hl
  call _os_print

  ld hl,_diagnostic_expected_txt
  call _os_print

  ld a,(_saved_exp)
  ld hl,_buffer ; reuse buffer
  call z80unit_diagnostic_msg8
  ld (hl),0
  ld hl,_buffer
  call _os_print
  call _os_newln

;  ld hl,?m1_txt
;  ld a,10 ; @DSPLY
;  rst 40

;  ld a,(?saved_act)
;  ld hl,?m0_txt ; reuse buffer
;  call z80unit_diagnostic_msg8
;  ld a,$03 ; ETX
;  ld (hl),a
;  ld hl,?m0_txt
;  ld a,10 ; @DSPLY
;  rst 40

;  ld hl,?m2_txt
;  ld a,10 ; @DSPLY
;  rst 40
;?end:
;  nop
  ret


; ------------------------------------------------------------------
; Ends the current test, if necessary.
z80unit_end_test:
  ld a,(_running_test)
  or a  ; set z flag
  ret z ; nothing to do -- no test running

  ; Complete the progress bar for this test.
  ld hl,_complete_progress_bar_txt
  call _os_print
  call _os_newln

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
  call _os_print

  ; Print test passed count.
  ld hl,(_passed_count)
  ld ix,_buffer
  call _barden_bindec
  ld (ix),0 ; zero-terminate the string
  ld hl,_buffer
  call _skip_ascii_zeros
  call _os_print
  ld hl,_report_passed_txt
  call _os_print

  ; Print test failed count.
  ld hl,(_failed_count)
  ld ix,_buffer
  call _barden_bindec
  ld (ix),0 ; zero-terminate the string
  ld hl,_buffer
  call _skip_ascii_zeros
  call _os_print
  ld hl,_report_failed_txt
  call _os_print
  call _os_newln
  ret

; ---------------------------------------------------------------- ;
; / / / / / / / / / / / / / PUBLIC  MACROS / / / / / / / / / / / / ;
; ---------------------------------------------------------------- ;

; ------------------------------------------------------------------
; Starts a new test.
;
; name - the name of the test
z80unit_test macro name,?test_title_txt,?skip
  jp ?skip ; Could be >127 characters of output below.
?test_title_txt	defb	' name [',0
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
z80unit_end macro ?passed_txt,?failed_txt,?skip
  z80unit_push_reg
  call z80unit_end_test
  call z80unit_report
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 8-bit registers or immediate values are equal.
; Any exp valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Example use:
;   assertEquals8 a,$03
;   assertEquals8 a,c
;   assertEquals8 05,$05
;
; expected - an 8-bit value
; actual   - an 8-bit value
; msg      - added to the diagnostic output if the assertion fails (optional)
assertEquals8 macro expected,actual,msg,?sexp,?sact,?txt,?dtxt,?skip,?fail,?end
  jp ?skip ; Could be >127 characters of output below.
?sexp	defs	1
?sact	defs	1
?txt	defb	'assertEquals8(expected,actual)',0
?dtxt	defb	'msg',0
?skip:
  z80unit_push_reg

  ; Save the comparison values: 'expected' and 'actual'.
  ; We have to be careful with the a register because it could be what
  ; was defined for 'expected' and/or 'actual', e.g., assertEquals a,a
  ; We use the stack to restore the "at start" a register value after
  ; saving 'expected' prior to saving 'actual'.
  push af
  ld a,expected
  ld (?sexp),a
  pop af
  ld a,actual
  ld (?sact),a

  ; Check the assertion
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
  ld ix,?txt
  ld iy,?dtxt
  ld a,(?sexp)
  ld b,a
  ld a,(?sact)
  ld c,a
  call z80unit_output_diagnostic_msg8

?end:
  z80unit_pop_reg
  endm

endif ; INCLUDE_Z80UNIT
