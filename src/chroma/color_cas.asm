; Robert French has permitted making the enclosed freely downloadable with the
; following copyright notice:
;
; This material is licensed under Attribution-ShareAlike 4.0 International
; (CC BY-SA 4.0) https://creativecommons.org/licenses/by-sa/4.0/

;
; [Sep 2020 Tim Halloran] Cassette version of the driver in 'color_cas.asm'
;   The INIDOS has been removed (was setting 'Mem Size?' in the code)
;   because this broke the BASIC checks in DEMO/BAS (14 bytes off).
;   JP 402DH (the DOS exit) has been replaced with JP 1A19H.
;

;	ORG	0B000H	;FOR 32K MACHINES
	ORG	0F000H	;FOR 48K MACHINES
;
GO	JP	CONT
;
INIT1	JP	MODE1	;INITIALIZE MODE 1 GRAPHICS
INIT2	JP	MODE2	;INITIALIZE MODE 2 GRAPHICS
CLS	JP	CLEAR	;CLEAR SCREEN, SET BACKROUND
SET	JP	PON	;TURN ON A POINT
RESET	JP	POFF	;TURN OFF A POINT
TEST	JP	PTEST	;IS POINT ON?
DEFPAT	JP	PATERN	;MOVE SPRITE PATTERN TO VRAM
DEFSPR	JP	SETSPR	;SET GIVEN SPRITE TO PATTERN
MOVSPR	JP	MOVESP	;MOVE SPRITE TO X,Y COORDINATE
INSPR	JP	INITSP	;SET ALL SPRITE PATTERNS TO ZEROS
;
LINE	JP	DRLINE	;DRAW LINE
FILL	JP	FILLER	;FILL AREA
WRSTR	JP	STRING	;WRITE STRING
WRINT	JP	INTGER	;WRITE	INTERGER
;
TONE	JP	SOUND	;OUTPUT TONE
RDPAD	JP	PADDL	;READ ATARI PADDLE
RDJOY	JP	FORJOY	;READ ATARI JOYSTICK
;
COLOR	DEFB	1FH	;FORGROUND/BACKROUND
BKDROP	DEFB	0CH	;BACKDROP COLOR
XCOR	DEFB	0
YCOR	DEFB	0
XLINE	DEFW	0
YLINE	DEFW	0
XPRIME	DEFB	0
YPRIME	DEFB	0
SCOLOR	DEFB	0
SPATRN	DEFS	32
SPNUM	DEFB	0
PNUM	DEFB	0
SPXCOR	DEFB	0
SPYCOR	DEFB	0
INTNUM	DEFW	0
STRADR	DEFW	0
STRLEN	DEFB	0
FREQ	DEFB	0
AMP	DEFB	0
DUR	DEFB	0
JOYSTK	DEFB	0
IFLAG	DEFB	0
;
STATUS	EQU	79H	;READ STATUS PORT
REG	EQU	79H	;WRITE REG PORT
ADDR	EQU	79H	;WRITE VRAM DATA ADDR
DATA	EQU	78H	;READ/WRITE VRAM DATA
;
CONT	CALL	MODE2
	CALL	CLS
	CALL	INSPR
	LD	HL,LINE1
	CALL	IMESG
	LD	HL,LINE2
	CALL	IMESG
	LD	HL,LINE3
	CALL	IMESG
	LD	HL,LINE4
	CALL	IMESG
	CALL	CBAR
	JP	1A19H
;
LINE1	DEFW	140AH	;X COR,Y COR,STR LEN,COLOR
	DEFW	6F25H
;	DEFM	'CHROMAtrs V 1.1 32k Cassette Software'
	DEFM	'CHROMAtrs V 1.1 48k Cassette Software'
LINE2	DEFW	1414H
	DEFW	5F27H
	DEFM	'(C) 1982, SOUTH SHORE COMPUTER CONCEPTS'
LINE3	DEFW	141EH
	DEFW	0DF21H
	DEFM	'1590 BROADWAY, HEWLETT, NY 11557 '
LINE4	DEFW	1428H
	DEFW	0CF23H
	DEFM	'ORDERS & INFO: Ian Mavric          '
LINE5	DEFW	64B4H
;
IMESG	LD	A,(HL)	;PLACE 4 PARAMETERS & STR ADDRESS
	LD	(YCOR),A	;INTO PROPER MEM LOC'S
	INC	HL
	LD	A,(HL)
	LD	(XCOR),A
	INC	HL
	LD	A,(HL)
	LD	(STRLEN),A
	INC	HL
	LD	A,(HL)
	LD	(COLOR),A
	INC	HL
	LD	(STRADR),HL
	CALL	WRSTR
	RET
;
CBAR	LD	HL,LINE6+4	;CREATE BARS
	LD	B,26	; # OF CHARECTERS
	LD	A,91	;CHAR VALUE (FULL BLOCK)
ICBLP	LD	(HL),A
	INC	HL
	DJNZ	ICBLP
CBARLP	LD	A,(LINE6)	;INC Y BY 8
	ADD	A,8
	LD	(LINE6),A
	LD	A,(LINE6+1)	;INC X BY 4
	ADD	A,4
	LD	(LINE6+1),A
	LD	A,(LINE6+3)	;CHANGE COLOR OF BAR
	ADD	A,10H
	CP	0FFH
	RET	Z
	LD	(LINE6+3),A
	LD	HL,LINE6
	CALL	IMESG
	JP	CBARLP
LINE6	DEFW	2430H
	DEFW	0F16H
	DEFM	'                            '
;
PORTON	PUSH	AF	;ENABLE SYSTEM I/O BUS
	LD	A,10H
	OUT	(0ECH),A
	IN	A,(REG)	;TMS9918A STATUS
	POP	AF
	RET
;
; ROUTINE TO WRITE AN ADDRESS IN VRAM
; ADDRESS IN HL, DATA IN A
RAMOUT	CALL	PORTON	;ENABLE I/O BUS
	LD	C,REG	;WRITE REG PORT
	SET	6,H	;SEE TABLE 2-1 OF TMS9918A MANUAL
	RES	7,H
	OUT	(C),L	;OUTPUT ADDRESS
	OUT	(C),H
	NOP
	OUT	(DATA),A	;SEND DATA TO VRAM
	RET
;
; ADDRESS IN HL, DATA RETURNED IN A
RAMIN	CALL	PORTON
	LD	C,REG	;WRITE REG PORT
	RES	6,H	;SEE TABLE 2-1 OF TMS9918A MANUAL
	RES	7,H
	OUT	(C),L
	OUT	(C),H
	NOP
	IN	A,(DATA)	;GET DATA
	RET
;
; ROUTINE TO WRITE DATA TO A REGISTER
; DATA IN A, REG # IN B
REGOUT	CALL	PORTON	;SEE TABLE 2-1 OF TMS9918A MANUAL
	OUT	(REG),A
	LD	A,B
	OR	80H
	OUT	(REG),A
	RET
;
; ROUTINE TO INITILIZE MODE 2 GRAPHICS
;
MODE2	LD	HL,M2TBL	;DATA
	LD	B,6		;REGISTER #
LP0	LD	A,(HL)
	CALL	REGOUT	;OUT DATA TO REGISTERS
	INC	HL
	DEC	B
	JP	P,LP0
	RET
;
M2TBL	DEFB	7	;SEE SECTIONS 2.2 TO 2.7 OF
	DEFB	56	;TMS9918A MANUAL
	DEFB	3
	DEFB	255
	DEFB	6
	DEFB	0C2H
	DEFB	2
;
; ROUTINE TO CLEAR THE SCREEN,
; SET BACKROUND & BACKDROP
; FIRST WRITE PATTERN NAME TABLE...
CLEAR	XOR	A
	LD	HL,1800H	;BASE OF NAME TABLE
	CALL	RAMOUT
	LD	B,3
LP1	INC	A	;SEQUENTIAL DATA TO VRAM SENT
	OUT	(DATA),A	;W/O UPDATING ADDRESS
	JP	NZ,LP1	;(SEE TABLE 2-1 AGAIN!)
	DJNZ	LP1
; CLEAR PATTERN TABLE TO ZEROS
	LD	HL,0
	XOR	A
	CALL	RAMOUT
	LD	HL,17FFH	;PATTERN TABLE -1
	LD	BC,1
LP2	OUT	(DATA),A	;ZAP PATTERN TABLE
	SBC	HL,BC
	JP	NZ,LP2
; CLEAR COLOR TABLE
	LD	HL,2000H
	XOR	A
	LD	A,(COLOR)	;OUT FIRST BYTE
	CALL	RAMOUT
	LD	HL,17FFH
	LD	BC,1
LP3	OUT	(DATA),A	;OUT REST OF BYTES
	SBC	HL,BC
	JP	NZ,LP3
	LD	A,(BKDROP)	;SEE TMS9918A MANUAL
	LD	B,7	;SECTION 2.2.8
	CALL	REGOUT
	RET
;
; ROUTINE TO TRANSLATE X,Y COORDINATE TO
; A VRAM LOCATION AND GET IT INTO THE A REGISTER
BIT	DEFB	0
BYTE	DEFB	0
XYCALC	LD	A,(XCOR)	;DETERMIN BIT SET
	CPL		;BY DIVIDING BY 8
	AND	7	;AND COMPLEMENTING THE REMAINDER
	LD	(BIT),A
	LD	A,(YCOR)	;DIV Y BY 8 & STORE
	AND	7
	LD	(BYTE),A
	LD	H,0
	LD	A,(YCOR)	;CALC # OF 8X8 ROWS ABOVE
	AND	0F8H
	LD	L,A
	ADD	HL,HL
	ADD	HL,HL
	LD	A,(XCOR)	;DIV X BY 8
	SRL	A
	SRL	A
	SRL	A
	ADD	A,L	;ADD # 8X8 ROWS ABOVE TO # LEFT
	LD	L,A	;OF THE POINT
	ADD	HL,HL	;MULTIPLY # 8X8 PATS BY 8 AND
	ADD	HL,HL
	ADD	HL,HL
	LD	B,0	;ADD Y/8 REMAINDER = ADDRESS
	LD	A,(BYTE)
	LD	C,A
	ADD	HL,BC
	CALL	RAMIN	;GET DATA FROM ADDRESS
	RET
;
MODE1	RET	;NOT AVAILABLE
PON	CALL	XYCALC	;CONVERT TO VRAM ADDRESS
	PUSH	AF	;SAVE DATA
	LD	A,(BIT)	;GET BIT TO SET
	SLA	A	;POSITION SO BIT SET IS IN POS
	SLA	A	;5, 4, & 3
	SLA	A
	OR	0C7H	;SET BITS 6,7,0,1,&2
	LD	(INS+1),A	;SEE Z80 MANUAL 'SET B,R
	POP	AF
INS	SET	0,A	;NOW SET WITH PROPER BIT
	CALL	RAMOUT	;SET POINT
	LD	BC,2000H	;OFFSET TO COLOR TABLE
	LD	A,(COLOR)	;& CHANGE PTS COLOR
	ADD	HL,BC
	CALL	RAMOUT
	RET
;
POFF	CALL XYCALC	;SEE PON
	PUSH	AF
	LD	A,(BIT)
	SLA	A
	SLA	A
	SLA	A
	OR	087H	;SEE PON & Z80 MANUAL 'RES B,R
	LD	(INS1+1),A
	POP	AF
INS1	RES	0,A
	CALL	RAMOUT
	RET
PTEST	CALL	XYCALC	;SEE PON
	PUSH	AF
	LD	A,(BIT)
	SLA	A
	SLA	A
	SLA	A
	OR	47H	;SEE PON & Z80 MANUAL 'BIT B,R
	LD	(INS2+1),A
	POP	AF
INS2	BIT	0,A	;TEST BIT
	JP	Z,CLR	;RETURN SET
	LD	A,0
	LD	(JOYSTK),A
	RET
CLR	LD	A,0FFH	;RETURN RESET
	LD	(JOYSTK),A
	RET
;
; ROUTINE TO CLEAR THE SPRITE ATTRIBUTE TABLE
INITSP	XOR	A	;SIMPLY ZAP THE 2K TABLE
	LD	HL,3800H	;TABLE ADDRESS
	CALL	RAMOUT
	LD	HL,2047		;LENGTH -1
	LD	BC,1
LP4	OUT	(DATA),A	;ZAP THE REST
	SBC	HL,BC
	JP	NZ,LP4
	RET
;
; ROUTINE TO MOVE A PATTERN IN RAM TO THE
; SPRITE # GIVEN.
PATERN	LD	H,0
	LD	A,(SPNUM)
	LD	L,A
	LD	B,5
LP5	ADD	HL,HL	;SPNUM*32
	DJNZ	LP5
	LD	BC,3800H
	ADD	HL,BC	;SPNUM*32+3800H -> VRAM ADDRESS
	LD	A,(SPATRN)	;OUTPUT FIRST BYTE
	CALL	RAMOUT
	LD	C,DATA	;SET CONDITIONS FOR OUTI
	LD	HL,SPATRN+1
	LD	B,31
LP6	OUTI	;OUTPUT 31 SUBSEQUENT BYTES
	JP	NZ,LP6
;
; ROUTINE TO SET A SPRITE TO A PATTERN
SETSPR	LD	H,0
	LD	A,(SPNUM)
	LD	L,A
	ADD	HL,HL
	ADD	HL,HL	;SPNUM*4
	LD	BC,7170	;BASE ADDRESS + 2 -> NAME POINTER
	ADD	HL,BC	;SPNUM*4 + BASE ADDRESS
	LD	A,(PNUM)	;PATTERN # SPRITE
	CALL	RAMOUT
	LD	A,(SCOLOR)	;COLOR FOR SPRITE
	OUT	(DATA),A ;SET SPRITE COLOR
	RET
;
; ROUTINE TO MOVE THE PSRITE TO AN X,Y LOCATION.
MOVESP	LD	H,0
	LD	A,(SPNUM)
	LD	L,A
	ADD	HL,HL	;SPRITE # X 4
	ADD	HL,HL
	LD	BC,7168		;BASE ADDRESS
	ADD	HL,BC	;GET ADDRESS FOR "Y"
	LD	A,(SPYCOR)	;OUTPUT y COORDINATE
	CALL	RAMOUT
	LD	A,(SPXCOR)	;OUTPUT X COORDINATE
	OUT	(DATA),A
	RET
;
; ROUTINE TO DRAW A LINE BETWEEN TWO POINTS
XSLOPE	DEFB	0
YSLOPE	DEFB	0
DRLINE	XOR	A
	LD	(YADD+1),A	;MAKE SURE ZERO
	LD	A,(XLINE)	;IF X > OR = X' NXTST
	LD	B,A
	LD	A,(XPRIME)
	CP	B
	JP	Z,NXTST
	JP	NC,NXTST
	LD	(XLINE),A	;EX X & X'
	LD	A,B
	LD	(XPRIME),A
	LD	A,(YLINE)	;EX Y & Y'
	LD	B,A
	LD	A,(YPRIME)
	LD	(YLINE),A
	LD	A,B
	LD	(YPRIME),A
NXTST	LD	A,(YLINE)	;IF Y > OR = Y' THEN DRAW
	LD	B,A
	LD	A,(YPRIME)
	CP	B
	JP	Z,DRAWLN
	JP	NC,DRAWLN
	LD	A,255	;MAKE Y OFFSET NEG 1
	LD	(YADD+1),A
DRAWLN	LD	A,(XLINE)	;COMPUTE DIFFERENCE
	LD	B,A	;IN X VALS & STORE
	LD	A,(XPRIME)	;COMP DIFF IN Y VALS
	SUB	B		;STORE
	LD	C,A
	LD	A,(YLINE)
	LD	B,A
	LD	A,(YPRIME)
	SUB	B
	LD	B,8
BEXIT	LD	(YSLOPE),A	;DIFF IN Y VALS=YSLOPE
	LD	A,C
	LD	(XSLOPE),A	;DIFF IN X VALS=XSLOPE
	LD	A,(XLINE)
	LD	(XLINE+1),A	;PUT STARTING X & Y IN
	LD	A,(YLINE)	;B03BH &B03DH
	LD	(YLINE+1),A
	XOR	A	;ZERO B03AH &B03CH
	LD	(XLINE),A
	LD	(YLINE),A
POINT	LD	A,(XLINE+1)	;XCOR=X & YCOR=Y
	LD	(XCOR),A
	LD	A,(YLINE+1)
	LD	(YCOR),A
	CALL	SET	;SET XCOR,YCOR
	LD	A,(XCOR)	;IF X <> X' ADD XOFFSET
	LD	B,A
	LD	A,(XPRIME)
	CP	B
	JP	NZ,ADD
	LD	A,(YCOR)	;IF Y <> Y' ADD YOFFSET
	LD	B,A
	LD	A,(YPRIME)
	CP	B
	JP	NZ,ADD
	RET		;IF X=X' & Y=Y' RETURN
ADD	LD	HL,(XLINE)	;ADD  X CORDINATE
	LD	A,(XSLOPE)	;TO X OFFSET
	LD	E,A	;& STORE
	LD	D,0
	ADD	HL,DE
	LD	(XLINE),HL
	LD	HL,(YLINE)	;ADD Y COORDINATE
	LD	A,(YSLOPE)	;TO Y OFFSET
	LD	E,A		;& STORE
YADD	LD	D,0
	ADD	HL,DE
	LD	(YLINE),HL
	JP	POINT	;NEXT POINT
;
;
;ROUTINE TO MAKE SOUNDS FROM SOUND PORT.
;VARIABLE AMPLITUDE, FREQ, AND DURATION.
SOUND	LD	A,(DUR)
	LD	B,A
	CALL	PORTON
	XOR	A
	LD	(IFLAG),A	;ZERO IFLAG
	LD	A,I	;GET INTERUPT STATUS
	JP	PO,DURLP	;IF STATUS = 0 (PARITY
	LD	A,1	;ODD) THEN GO
	LD	(IFLAG),A	;ELSE SAVE PARITY EVEN (1)
	DI
DURLP	LD	A,B
	LD	(CNTR),A	;SAVE DURATION
	LD	A,(AMP)
	OR	80H
	OUT	(7EH),A	;OUTPUT AMPLITUDE + 128
	CALL	DELAY	;DELAY FOR FREQUENCY
	LD	A,80H	;OUTPUT 128 (NULL)
	OUT	(7EH),A
	CALL	DELAY	;DELAY FOR FREQUENCY
	LD	A,(CNTR)	;GO UNLESS DURATION DONE
	LD	B,A
	DJNZ	DURLP
	LD	A,(IFLAG)	;REENABLE I/O STATUS
	CP	0
	RET	Z
	EI
	RET
DELAY	LD	A,(FREQ)
	LD	B,A
DELLP	PUSH	BC	;DELAY - HO  HUMMMMM
	POP	BC
	DJNZ	DELLP
	RET
;
CNTR	DEFB	0
;
;SCANS A STRING AND PRINTS IT ON THE SCREEN
;AT THE DESIRED LOCATION.
STRING	LD	HL,(STRADR)	;ADDRESS
	LD	A,(STRLEN)	;LENGTH
	LD	B,A
STRLP	LD	A,(HL)		;GET CHAR
	PUSH	BC		;SAVE REGISTERS
	PUSH	HL
	CALL	WRITE		;PUT ON SCREEN
	POP	HL		;RESTORE REGISTERS
	POP	BC
	INC	HL		;POINT NEXT
	DJNZ	STRLP		;PRINT NEXT ELSE DONE
	RET
;
INTGER	LD	A,5	;SETUP STRING ADDRESSES
	LD	(STRLEN),A	;5 DIGIT INTEGER #
	LD	HL,STRBUF	;BUFFER FOR INT STRING
	LD	(STRADR),HL	;STRADR PT TO STRBUF
	LD	IY,FTBL
	LD	IX,STRBUF
	LD	B,5	;SET BUFFER TO ZEROS
	LD	HL,STRBUF	;ZAP FOR REENTRIES
	LD	A,30H
TLP	LD	(HL),A
	INC	HL
	DJNZ	TLP
	LD	B,5	;5 DIGIT LENGTH
GETFTR	LD	E,(IY)	;CURRENT VAL TO BE TESTED
	INC	IY
	LD	D,(IY)	;PUT NEXT IN D
	INC	IY	;POINT NEXT
FTRLP	LD	HL,(INTNUM)	;INTEGER #
	SCF	;RESET CARRY FLAG
	CCF
	SBC	HL,DE	;IF DE>HL GET NEXT DE
	JP	C,NXFTR
	LD	(INTNUM),HL	;STORE NEW LOWER INTNUM
	INC	(IX)	;INCREMENT COUNTER
	JP	FTRLP	;CHECK IF DE>HL AGAIN
NXFTR	INC	IX
	DJNZ	GETFTR
	LD	B,4	;POINT NEXT COUNTER
	LD	HL,STRBUF
ZSLP	LD	A,(HL)	;IF LEFT$(INT STR,1)<>0 PRINT IT
	CP	30H	
	JP	NZ,STRING	;ELSE TRY NEXT
	LD	A,20H
	LD	(HL),A
	INC	HL
	DJNZ	ZSLP
	JP	STRING
STRBUF	DEFS	5
FTBL	DEFW	10000	;POWERS OF 10
	DEFW	1000
	DEFW	100
	DEFW	10
	DEFW	1
;
FORJOY	LD	A,(14400)	;MEM LOC FOR ARROW KEYS
	CP	0
	JP	Z,RDJOYS	;NO? CHECK JOYSTICKS
	LD	C,A	;PUT VAL IN C
	XOR	A
	BIT	3,C	;TEST WHICH KEY PRESSED AND
	JP	Z,JDOWN	;SIMULATE JOYSTICK DATA RETURN
	SET	3,A
JDOWN	BIT	4,C
	JP	Z,JRITE
	SET	2,A
JRITE	BIT	6,C
	JP	Z,JLEFT
	SET	0,A
JLEFT	BIT	5,C
	JP	Z,JFIRE
	SET	1,A
JFIRE	BIT	7,C
	JP	Z,JOVER
	SET	4,A
JOVER	LD	(JOYSTK),A	;RETURN DATA
	RET
RDJOYS	LD	A,(JOYSTK)	;JOYSTICK #
	LD	C,A	;PORT = 7D + JOYSTICK #
	LD	A,7DH
	ADD	A,C
	LD	C,A
	CALL	PORTON
	IN	A,(C)	;READ JOYSTICK
	CPL	;COMPLEMENT SO 1=SET & 0=NORMAL (READ SEC.4.4 & 4.5  OF CHROMATRS MANUAL)
	AND	1FH	;SEND ONLY BITS 0-4
	LD	(JOYSTK),A	;RETURN DATA
	RET
;
FILLER	RET	;NOT AVAILABLE.
;
PADDL	CALL	PORTON	;READ SEC. 4.6 & 4.7 OF CHROMATRS MANUAL
	XOR	A	;SEE TONE (SOUND)
	LD	(IFLAG),A
	LD	A,I
	JP	PO,PCONTU
	LD	A,1
	LD	(IFLAG),A
	DI	;DI FOR ACCURATE TIMING LOOPS
PCONTU	LD	HL,0
	LD	A,0
	OUT	(7EH),A	;TRIG ONESHOTS (READ SEC. 4.7 OF CHROMATRS MANUAL)
	CALL	BOTADJ
	CALL	CKPAD
ADJUST	LD	A,0	;IF PADDLE POS>255 RETURN 255
	CP	H
	JP	Z,NORMP
	LD	A,255
	LD	(JOYSTK),A
	JP	PEX
NORMP	LD	A,L	;RETURN CORRECT POSITION
	LD	(JOYSTK),A
PEX	LD	A,80H	;RESET ONESHOTS (SEE 4.6 AGAIN)
	OUT	(7EH),A
	LD	A,(IFLAG)
	CP	0
	RET	Z
	EI
	RET
BOTADJ	LD	B,180	;DELAY (READ SEC 4.7 OF CHROMATRS MANUAL)
BALP	DJNZ	BALP
	RET
CKPAD	LD	A,(JOYSTK)	;GET PADDLE # & CHECK
	CP	0
	JP	Z,CK0
	CP	1
	JP	Z,CK1
	CP	2
	JP	Z,CK2
CK3	IN	A,(7EH)	;COUNT UNTIL D7 OF 7EH GOES HI
	BIT	7,A
	RET	NZ
	INC	HL
	CALL	PDEL
	JP	CK3
CK2	IN	A,(7EH)	;COUNT UNTIL D6 OF 7EH GOES HI
	BIT	6,A
	RET	NZ
	INC	HL
	CALL	PDEL
	JP	CK2
CK1	IN	A,(7DH)	;COUNT UNTIL D7 OF 7DH GOES HI
	BIT	7,A
	RET	NZ
	INC	HL
	CALL	PDEL
	JP	CK1
CK0	IN	A,(7DH)	;COUNT UNTIL D6 OF 7DH GOES HI
	BIT	6,A
	RET	NZ
	INC	HL
	CALL	PDEL
	JP	CK0
PDEL	RET
;
WRITE	LD	H,0	;CHAR VAL*6+TABLE LOCATION
	LD	L,A
	LD	D,0
	LD	E,A
	LD	B,5
ATLP	ADD	HL,DE
	DJNZ	ATLP
	LD	DE,CTABLE
	ADD	HL,DE	;NOW HL POINTS TO CHAR TABLE
	LD	IX,XCOR
	LD	IY,YCOR
	LD	A,6
	EX	AF,AF'
GETBYT	LD	A,(HL)
	LD	B,8
SLP	SRL	A	;SHIFT LEFT NO CARRY RESET
	JP	NC,RESETP
	PUSH	BC
	PUSH	AF
	PUSH	HL
	CALL	SET
	POP	HL
	POP	AF
	POP	BC
INYCOR	INC	(IY)	;POINT NEXT LINE
	DJNZ	SLP
	INC	(IX)	;POINT NEXT X LOCATION
	LD	A,(IY)	;GET CURRENT Y LOCATION
	SUB	8	;RESTORE TO Y LOCATION
	LD	(IY),A	
	EX	AF,AF'	;CHECK IF ALL 6 X'S DONE 
	DEC	A
	RET	Z	;YES RETURN ELSE NEXT
	EX	AF,AF'
	INC	HL
	JP	GETBYT
RESETP	PUSH	BC	;SAVE REGISTERS
	PUSH	AF
	PUSH	HL
	CALL	RESET	;RESET POINT
	POP	HL	;RESTORE
	POP	AF
	POP	BC
	JP	INYCOR	;INC Y COORDINATE
CTABLE	DEFS	0C0H
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0	;!
	DEFB	0
	DEFB	5FH
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	8H	;"
	DEFB	7H
	DEFB	0
	DEFB	8H
	DEFB	7H
	DEFB	0
	DEFB	14H	;#
	DEFB	7FH
	DEFB	14H
	DEFB	7FH
	DEFB	14H
	DEFB	0
	DEFB	0	;$
	DEFB	24H
	DEFB	6BH
	DEFB	6BH
	DEFB	12H
	DEFB	0
	DEFB	63H	;%
	DEFB	13H
	DEFB	8H
	DEFB	64H
	DEFB	63H
	DEFB	0
	DEFB	36H	;&
	DEFB	49H
	DEFB	49H
	DEFB	36H
	DEFB	50H
	DEFB	0
	DEFB	0	;'
	DEFB	8H
	DEFB	7H
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	1CH	;(
	DEFB	22H
	DEFB	41H
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0	;)	
	DEFB	0
	DEFB	0
	DEFB	41H
	DEFB	22H
	DEFB	1CH
	DEFB	2AH	;*
	DEFB	1CH
	DEFB	7FH
	DEFB	1CH
	DEFB	2AH
	DEFB	0
	DEFB	8H	;+
	DEFB	8H
	DEFB	7FH
	DEFB	8H
	DEFB	8H
	DEFB	0
	DEFB	0	;,
	DEFB	80H
	DEFB	70H
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	8H	;-
	DEFB	8H
	DEFB	8H
	DEFB	8H
	DEFB	8H
	DEFB	0
	DEFB	0	;.
	DEFB	0
	DEFB	40H
	DEFB	40H
	DEFB	0H
	DEFB	0
	DEFB	60H	;/
	DEFB	10H
	DEFB	8H
	DEFB	4H
	DEFB	3H
	DEFB	0
	DEFB	3EH	;0
	DEFB	41H
	DEFB	41H
	DEFB	41H
	DEFB	3EH
	DEFB	0
	DEFB	0	;1
	DEFB	42H
	DEFB	7FH
	DEFB	40H
	DEFB	0
	DEFB	0
	DEFB	62H	;2
	DEFB	51H
	DEFB	49H
	DEFB	49H
	DEFB	46H
	DEFB	0
	DEFB	21H	;3
	DEFB	41H
	DEFB	49H
	DEFB	4DH
	DEFB	33H
	DEFB	0
	DEFB	18H	;4
	DEFB	14H
	DEFB	12H
	DEFB	7FH
	DEFB	10H
	DEFB	0
	DEFB	4FH	;5
	DEFB	49H
	DEFB	49H
	DEFB	49H
	DEFB	31H
	DEFB	0
	DEFB	3EH	;6
	DEFB	59H
	DEFB	49H
	DEFB	49H
	DEFB	30H
	DEFB	0
	DEFB	1H	;7
	DEFB	71H
	DEFB	9
	DEFB	5
	DEFB	3
	DEFB	0
	DEFB	36H	;8
	DEFB	49H
	DEFB	49H
	DEFB	49H
	DEFB	36H
	DEFB	0
	DEFB	06H	;9
	DEFB	49H
	DEFB	49H
	DEFB	49H
	DEFB	3EH
	DEFB	0
	DEFB	0	;:
	DEFB	0
	DEFB	14H
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0	;;
	DEFB	40H
	DEFB	34H
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0	;<
	DEFB	08H
	DEFB	14H
	DEFB	22H
	DEFB	41H
	DEFB	0
	DEFB	0	;=
	DEFB	14H
	DEFB	14H
	DEFB	14H	
	DEFB	14H
	DEFB	0
	DEFB	0	;>
	DEFB	41H
	DEFB	22H
	DEFB	14H
	DEFB	08H
	DEFB	0
	DEFB	0	;?
	DEFB	02H
	DEFB	51H
	DEFB	09H
	DEFB	06H
	DEFB	0
	DEFB	3EH	;@
	DEFB	4BH
	DEFB	55H
	DEFB	59H
	DEFB	0EH	
	DEFB	0
	DEFB	7CH	;A
	DEFB	12H	
	DEFB	11H
	DEFB	12H
	DEFB	7CH
	DEFB	0
	DEFB	7FH	;B
	DEFB	49H
	DEFB	49H
	DEFB	49H
	DEFB	36H
	DEFB	0
	DEFB	3EH	;C
	DEFB	41H
	DEFB	41H
	DEFB	41H
	DEFB	22H	
	DEFB	0
	DEFB	7FH	;D
	DEFB	41H
	DEFB	41H
	DEFB	41H
	DEFB	3EH
	DEFB	0
	DEFB	7FH	;E
	DEFB	49H
	DEFB	49H
	DEFB	41H
	DEFB	41H
	DEFB	0
	DEFB	7FH	;F
	DEFB	09H
	DEFB	09H
	DEFB	01H	
	DEFB	01H
	DEFB	0
	DEFB	3EH	;G
	DEFB	41H
	DEFB	41H
	DEFB	51H
	DEFB	72H
	DEFB	0
	DEFB	7FH	;H
	DEFB	08H
	DEFB	08H
	DEFB	08H
	DEFB	7FH
	DEFB	0
	DEFB	41H	;I
	DEFB	41H
	DEFB	7FH
	DEFB	41H	
	DEFB	41H
	DEFB	0
	DEFB	30H	;J
	DEFB	40H
	DEFB	40H
	DEFB	40H
	DEFB	3FH
	DEFB	0
	DEFB	7FH	;K
	DEFB	08H
	DEFB	14H
	DEFB	22H
	DEFB	41H
	DEFB	0
	DEFB	7FH	;L
	DEFB	40H
	DEFB	40H
	DEFB	40H
	DEFB	40H
	DEFB	0
	DEFB	7FH	;M
	DEFB	02H
	DEFB	0CH
	DEFB	02H
	DEFB	7FH
	DEFB	0
	DEFB	7FH	;N
	DEFB	06H
	DEFB	08H
	DEFB	30H
	DEFB	7FH
	DEFB	0
	DEFB	3EH	;O
	DEFB	41H
	DEFB	41H
	DEFB	41H
	DEFB	3EH
	DEFB	0
	DEFB	7FH	;P
	DEFB	9H
	DEFB	9H
	DEFB	9H
	DEFB	6H
	DEFB	0
	DEFB	3EH	;Q
	DEFB	41H
	DEFB	51H
	DEFB	61H
	DEFB	3EH
	DEFB	0
	DEFB	7FH	;R
	DEFB	9H
	DEFB	19H
	DEFB	29H
	DEFB	46H
	DEFB	0
	DEFB	26H	;S
	DEFB	49H
	DEFB	49H
	DEFB	49H
	DEFB	32H
	DEFB	0
	DEFB	1H	;T
	DEFB	1H
	DEFB	7FH
	DEFB	1H
	DEFB	1H
	DEFB	0
	DEFB	3FH	;U
	DEFB	40H
	DEFB	40H
	DEFB	40H
	DEFB	3FH
	DEFB	0
	DEFB	1FH	;V
	DEFB	20H
	DEFB	40H
	DEFB	20H
	DEFB	1FH
	DEFB	0
	DEFB	7FH	;W
	DEFB	20H
	DEFB	10H
	DEFB	20H
	DEFB	7FH
	DEFB	0
	DEFB	63H	;X
	DEFB	14H
	DEFB	8H
	DEFB	14H
	DEFB	63H
	DEFB	0
	DEFB	3H	;Y
	DEFB	4H
	DEFB	78H
	DEFB	4H
	DEFB	3H
	DEFB	0
	DEFB	61H	;Z
	DEFB	51H
	DEFB	49H
	DEFB	45H
	DEFB	43H
	DEFB	0
	DEFB	255	;SOLID BLOCK
	DEFB	255
	DEFB	255
	DEFB	255
	DEFB	255
	DEFB	255
	DEFS	30	;GAP TO LOWER CASE
	DEFB	0	;SM A
	DEFB	24H
	DEFB	54H
	DEFB	54H
	DEFB	38H
	DEFB	40H
	DEFB	0	;SM B
	DEFB	7EH
	DEFB	44H
	DEFB	44H
	DEFB	38H
	DEFB	0
	DEFB	0	;SM C
	DEFB	38H
	DEFB	44H
	DEFB	44H
	DEFB	48H
	DEFB	0
	DEFB	0	;SM D
	DEFB	38H
	DEFB	44H
	DEFB	44H
	DEFB	7EH
	DEFB	0
	DEFB	0	;SM E
	DEFB	38H
	DEFB	54H
	DEFB	54H
	DEFB	58H
	DEFB	0
	DEFB	0	;SM F
	DEFB	10H
	DEFB	7EH
	DEFB	12H
	DEFB	4H
	DEFB	0
	DEFB	0	;SM G
	DEFB	98H
	DEFB	0A4H
	DEFB	0A4H
	DEFB	78H
	DEFB	0
	DEFB	0	;SM H
	DEFB 	7EH
	DEFB	8H
	DEFB	4H
	DEFB	78H
	DEFB	0
	DEFB	0	;SM I
	DEFB	0
	DEFB	7AH
	DEFB	0
	DEFB	0
	DEFB	0
	DEFB	0	;SM J
	DEFB	80H
	DEFB	80H
	DEFB	80H
	DEFB	7AH
	DEFB	0
	DEFB	0	;SM K
	DEFB	7EH
	DEFB	10H
	DEFB	18H
	DEFB	66H
	DEFB	0
	DEFB	0	;SM L
	DEFB	0
	DEFB	3EH
	DEFB	40H
	DEFB	0
	DEFB	0
	DEFB	78H	;SM M
	DEFB	4H
	DEFB	78H
	DEFB	4H
	DEFB	78H
	DEFB	0
	DEFB	0	;SM N
	DEFB	78H
	DEFB	4H
	DEFB	4H
	DEFB	78H
	DEFB	0
	DEFB	0	;SM O
	DEFB	38H
	DEFB	44H
	DEFB	44H
	DEFB	38H
	DEFB	0
	DEFB	0	;SM P
	DEFB	0F8H
	DEFB	24H
	DEFB	24H
	DEFB	18H
	DEFB	0
	DEFB	18H	;SM Q
	DEFB	24H
	DEFB	24H
	DEFB	0F8H
	DEFB	80H
	DEFB	0
	DEFB	0	;SM R
	DEFB	78H
	DEFB	4H
	DEFB	4H
	DEFB	8H
	DEFB	0
	DEFB	0	;SM S
	DEFB	48H
	DEFB	54H
	DEFB	54H
	DEFB	24H
	DEFB	0
	DEFB	0	;SM T
	DEFB	8H
	DEFB	3EH
	DEFB	48H
	DEFB	0
	DEFB	0
	DEFB	0	;SM U
	DEFB	3CH
	DEFB	40H
	DEFB	40H
	DEFB	3CH
	DEFB	40H
	DEFB	1CH	;SM V
	DEFB	20H
	DEFB	40H
	DEFB	20H
	DEFB	1CH
	DEFB	0
	DEFB	3CH	;SM W
	DEFB	40H
	DEFB	30H
	DEFB	40H
	DEFB	3CH
	DEFB	0
	DEFB	0	;SM X
	DEFB	6CH
	DEFB	10H
	DEFB	10H
	DEFB	6CH
	DEFB	0
	DEFB	0	;SM Y
	DEFB	9CH
	DEFB	0A0H
	DEFB	0A0H
	DEFB	7CH
	DEFB	0
	DEFB	0	;SM Z
	DEFB	64H
	DEFB	54H
	DEFB	4CH
	DEFB	44H
	DEFB	0
;
	END	GO
