Q       EQU     4200H
        ORG     100H+Q
;
BDOS    EQU     0005H+Q
TYPEF   EQU     2     ;TYPE FUNCTION
;
CR      EQU     0DH   ;CARRIAGE RETURN
LF      EQU     0AH   ;LINE FEED
; MAIN
        OUT     0E8H  ;E8 SERIAL MASTER RESET
        IN      0E9H  ;E9 GET SERIAL SWITCHS
        MOV     B,A
        ANI     0F0H  ;HIGH NIBBLE
        RRC
        RRC
        RRC
        RRC
        CALL    NIBBLE2ASCII
	CALL    PCHAR
        MOV     A,B
        ANI     0FH  ;LOW NIBBLE
        CALL    NIBBLE2ASCII
	CALL    PCHAR
	CALL    CRLF
        RET    ;TO THE CPP
; SUBROUTINES
PCHAR:  ;PRINT A CHARACTER
        PUSH H! PUSH D! PUSH B  ;SAVED
        MVI     C,TYPEF
        MOV     E,A
        CALL    BDOS
        POP B! POP D! POP H  ;RESTORED
        RET
CRLF:
        MVI     A,CR
        CALL    PCHAR
        MVI     A,LF
        CALL    PCHAR
        RET
NIBBLE2ASCII:
        CPI     10         ; Compare with 10 (decimal)
        JNC     ISALPHA    ; If 10 or greater, it's A-F
        ADI     '0'        ; If 0-9, add ASCII '0'
        RET
ISALPHA:
        ADI     'A' - 0AH  ; If A-F, add offset for 'A'
        RET
