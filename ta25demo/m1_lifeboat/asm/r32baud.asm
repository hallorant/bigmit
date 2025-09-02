Q       EQU     4200H
        ORG     100H+Q
BDOS    EQU     5H+Q
CLBUF   EQU     80H+Q
PSTRING EQU     9       ;PRINT STRING CP/M FUNCTION
H110    EQU     '1'+'1'+'0'
H300    EQU     '3'+'0'+'0'
H600    EQU     '6'+'0'+'0'
H1200   EQU     '1'+'2'+'0'+'0'
H2400   EQU     '2'+'4'+'0'+'0'
;
; SETS THE BAUD ON MODEL 1 SERIAL FOR LIFEBOAT CP/M v1.41.
;
SETUP:  LXI     H,0
        DAD     SP
        SHLD    OLDSP
        LXI     SP,STKTOP
START:  LXI     H,CLBUF ;LOAD ADDR OF COMMAND LINE BUFFER
        MOV     A,M     ;LOAD THE NUMBER OF CHARACTERS
        ORA     A       ;CHECK IF ZERO
        JZ      USAGE
        LXI     D,BUF   ;COPY INTO BUF
        INX     H       ;HL POINTS TO THE FIRST CHAR
MORE:   PUSH    A       ;SAVE LENGTH LEFT
        MOV     A,M     ;GET A CHAR
        CPI     ' '     ;IGNORE SPACES(ZERO IF SPACE)
        JZ      NEXT
        CALL    HASH    ;HASH THE STRING AS IT IS STORED
        STAX    D       ;STORE CHAR IN BUF
        INX     D       ;MOVE TO NEXT POSITION IN BUF
NEXT:   INX     H       ;MOVE TO NEXT CHAR IN CL
        POP     A
        DCR     A       ;DECREMENT LENGTH
        JNZ     MORE    ;LOOP IF MORE CHARS
        MVI     A,'$'   ;ADD THE '$' TERMINATOR
        STAX    D       ;STORE TERMINATOR IN BUF
SETB:   LDA     HASHV
        CPI     H110    ;110 BAUD
        JZ      B110
        CPI     H300    ;300 BAUD
        JZ      B300
        CPI     H600    ;600 BAUD
        JZ      B600
        CPI     H1200   ;1200 BAUD
        JZ      B1200
        CPI     H2400   ;2400 BAUD
        JZ      B2400
        LXI     D,BUF   ;PRINT ERROR MSG THEN USAGE
        MVI     C,PSTRING
        CALL    BDOS
        LXI     D,WHAT
        MVI     C,PSTRING
        CALL    BDOS
        JMP     USAGE     
B110:   MVI     A,22H
        JMP     SERIAL
B300:   MVI     A,55H
        JMP     SERIAL
B600:   MVI     A,66H
        JMP     SERIAL
B1200:  MVI     A,77H
        JMP     SERIAL
B2400:  MVI     A,0AAH
        JMP     SERIAL
; FUNCTIONS
HASH:   PUSH    B
        PUSH    A
        MOV     B,A
        LDA     HASHV
        ADD     B
        STA     HASHV
        POP     A
        POP     B
        RET
SERIAL: PUSH    A       ;A HOLDS M1 SERIAL BAUD RATE(HIGH AND LOW NIBBLE)
        OUT     0E8H    ;M1 SERIAL BOARD MASTER RESET
        MVI     A,0ECH  ;8 BITS;NO PARITY;1 STOP BIT
        OUT     0EAH    ;M1 SERIAL BOARD SET URT CONTROL REG
        POP     A       ;BAUD RATE
        OUT     0E9H    ;M1 SERIAL BOARD SET BAUD RATE
        LXI     D,PREFIX
        MVI     C,PSTRING
        CALL    BDOS
        LXI     D,BUF
        MVI     C,PSTRING
        CALL    BDOS
        LXI     D,AFTER
        MVI     C,PSTRING
        CALL    BDOS
        JMP     EXIT
USAGE:  LXI     D,USESTR
        MVI     C,PSTRING
        CALL    BDOS
EXIT:   LHLD    OLDSP   ;RESTORE ORIGINAL CPP STACK LOCATION
        SPHL
        RET             ;TO CPP
HASHV:  DB      0
WHAT:   DB      '? UNKNOWN BAUD RATE',13,10,'$'
USESTR: DB      'USAGE: R32BAUD 110, 300, 600, 1200, OR 2400',13,10,'$'
PREFIX: DB      'R32: DEVICE SET TO ','$'
AFTER:  DB      ' BAUD',13,10,'     (8 DATA BITS, 1 STOP BIT, NO PARITY)',13,10,'$'
BUF:    DS      128
OLDSP:  DS      2
        DS      64 ;32 LEVEL STACK
STKTOP:
        END
