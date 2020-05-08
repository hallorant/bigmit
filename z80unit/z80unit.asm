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
_space				defb	' ',0
_passed_progress_txt		defb	'P',0
_failed_progress_txt		defb	'F',0
_diagnostic_expected_txt	defb	' expected ',0
_diagnostic_actual_txt		defb	' but was ',0
_complete_progress_bar_txt	defb	']',0
_report_success_txt		defb	'ALL TESTS PASSED (',0
_report_problems_txt		defb	'*** TESTS FAILED *** (',0
_report_passed_txt		defb	' passed, ',0
_report_failed_txt		defb	' failed)',0
_buffer				defs	32 ; buffer for ASCII conversions

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

; We define a simple interface to the console for test diagnostic output.
;
;  z80unit_print prints a zero-terminated string pointed to by hl to the
;                console. The output is truncated to 132 characters if
;                longer or the string is not terminated properly.
;
;  z80unit_newln prints a newline to the console.
;
; Each supported OS needs these two console output interfaces.

; -------------------------------------------------- ;
; TRSDOS 6 / LDOS 6 (Model 4) console implementation ;
; -------------------------------------------------- ;
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
  ld a,10  ; @DSPLY
  rst 40

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
  ld a,10 ; @DSPLY
  rst 40
  z80unit_pop_reg
  ret

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
; Write a 8-bit value as a number as hex and decimal into a buffer as ASCII.
; For example, for 55 the output is "<0x37=55>". The output is zero terminated.
;
; Entry: a   An 8-bit value.
;        hl  Points to the destination buffer.
; Exit:  hl  unchanged
z80unit_diagnostic_value8:
  push hl ; save the buffer start

  push af
  push af ; save the value for two uses below

  ld (hl),'<'
  inc hl
  ld (hl),'0'
  inc hl
  ld (hl),'x'
  inc hl

  pop af ; restore the value
  call _barden_hexcv

  ld (hl),'='
  inc hl

  pop af ; restore the value
  ld e,a
  ld d,0 ; de = the value (but 16 bits)
  call _bindec16
  ld (hl),'>'
  inc hl
  ld (hl),0 ; terminate the string

  pop hl ; restore the buffer start
  ret

; ------------------------------------------------------------------
; Write a 6-bit value as a number as hex and decimal into a buffer as ASCII.
; For example, for 55 the output is "<0x0037=55>"
;
; Entry: bc  A 16-bit value.
;        hl  Points to the output buffer.
; Exit:  hl  Points to the last character + 1.
z80unit_diagnostic_value16:
  push hl ; save the buffer start

  push bc
  push bc
  push bc ; save the value for three uses below

  ld (hl),'<'
  inc hl
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
  ld (hl),'>'
  inc hl
  ld (hl),0

  pop hl ; restore the buffer start
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
  ld hl,(_passed_count)
  ld ix,_buffer
  call _barden_bindec
  ld (ix),0 ; zero-terminate the string
  ld hl,_buffer
  call _skip_ascii_zeros
  call z80unit_print
  ld hl,_report_passed_txt
  call z80unit_print

  ; Print test failed count.
  ld hl,(_failed_count)
  ld ix,_buffer
  call _barden_bindec
  ld (ix),0 ; zero-terminate the string
  ld hl,_buffer
  call _skip_ascii_zeros
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
; Example use:
;   z80unit_test 'barden_fill'
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
;
; Example use:
;   z80unit_end
z80unit_end macro ?passed_txt,?failed_txt,?skip
  z80unit_push_reg
  call z80unit_end_test
  call z80unit_report
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that an 8-bit value is zero.
; Any exp valid within "ld a,<exp>" may be used for the argument.
; The registers are saved and restored.
;
; Example use:
;   assertZero8 a
;   assertZero8 0
;   assertZero8 ($3a00)
;
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertZero8 macro actual,msg,?sact,?buf,?txt0,?txt1,?skip,?fail,?end
  jp ?skip ; could be >127 characters of output below
?sact	defs	1
?buf	defs	15
?txt0	defb	' assertZero8 actual : expected 0 but was ',0
?txt1	defb	' msg',0
?skip:
  z80unit_push_reg

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
  ld hl,?buf
  call z80unit_diagnostic_value8
  call z80unit_print

  ld hl,?txt1
  call z80unit_print
  call z80unit_newln
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that a 16-bit value is zero.
; Any exp valid within "ld hl,<exp>" may be used for the argument.
; The registers are saved and restored.
;
; Example use:
;   assertZero16 bc
;   assertZero8 0
;   assertZero8 ($3a00)
;
; actual   - A 16-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertZero16 macro actual,msg,?sact,?buf,?txt0,?txt1,?skip,?fail,?end
  jp ?skip ; could be >127 characters of output below
?sact	defs	2
?buf	defs	15
?txt0	defb	' assertZero15 actual : expected 0 but was ',0
?txt1	defb	' msg',0
?skip:
  z80unit_push_reg

  ld hl,actual
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
  ld hl,?buf
  call z80unit_diagnostic_value16
  call z80unit_print

  ld hl,?txt1
  call z80unit_print
  call z80unit_newln
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 8-bit values are equal.
; Any exp valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Example use:
;   assertEquals8 a,$03
;   assertEquals8 a,c
;   assertEquals8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertEquals8 macro expected,actual,msg,?sexp,?sact,?buf,?txt0,?txt1,?txt2,?skip,?fail,?end
  jp ?skip ; could be >127 characters of output below
?sexp	defs	1
?sact	defs	1
?buf	defs	15
?txt0	defb	' assertEquals8(expected,actual) ex`pected ',0
?txt1	defb	' but was ',0
?txt2	defb	' msg',0
?skip:
  z80unit_push_reg

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
  ld hl,?buf
  call z80unit_diagnostic_value8
  call z80unit_print

  ld hl,?txt1
  call z80unit_print

  ld a,(?sact)
  ld hl,?buf
  call z80unit_diagnostic_value8
  call z80unit_print

  ld hl,?txt2
  call z80unit_print
  call z80unit_newln
?end:
  z80unit_pop_reg
  endm

; ------------------------------------------------------------------
; Asserts that the two 8-bit values are not equal.
; Any exp valid within "ld a,<exp>" may be used for the two arguments.
; The registers are saved and restored.
;
; Example use:
;   assertNotEquals8 a,$03
;   assertNotEquals8 a,c
;   assertNotEquals8 05,(ix)
;
; expected - An 8-bit value.
; actual   - An 8-bit value.
; msg      - Added to the diagnostic output if the assertion fails (optional).
assertNotEquals8 macro expected,actual,msg,?sexp,?sact,?buf,?txt0,?txt1,?skip,?fail,?end
  jp ?skip ; could be >127 characters of output below
?sexp	defs	1
?sact	defs	1
?buf	defs	15
?txt0	defb	' assertNotEquals8(expected,actual) both were ',0
?txt1	defb	' msg',0
?skip:
  z80unit_push_reg

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
  ld hl,?buf
  call z80unit_diagnostic_value8
  call z80unit_print

  ld hl,?txt1
  call z80unit_print
  call z80unit_newln
?end:
  z80unit_pop_reg
  endm

endif ; INCLUDE_Z80UNIT
