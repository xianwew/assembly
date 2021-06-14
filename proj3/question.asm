		ORG 00H
      E EQU P3.2 ;;define E
     RS EQU P3.3 ;;define RS
		
		CLR P3.1
		SETB P3.0
	 	MOV TMOD,#50H
BACK:
	;	CLR RS  ;;send instruction to the display
	;	MOV P1,#38H ;;Set Interface data length to 8 bits, 2 line, 5x7 font
	;	CALL PulseE 
	;	MOV P1,#06H;;set the entry mode to increment with no shift
	;	CALL PulseE
	;	MOV P1,#0FH ;;display on, the cursor on and blinking on
	;	Call PulseE

HERE:   
		MOV TL1, #0 ;;
		MOV TH1, #0 ;; 
        CALL START

		CALL TENMS
		MOV R1, TL1
		MOV R2, TH1
    ;	CALL CONVERT		
		

	;	SETB RS ;;send data
	;	CALL sendRevol
		CALL BACK

sendRevol:
	;	MOV P1,R2
	;	Call PulseE
	;	MOV P1,R1
	;	Call PulseE
	;	RET

PulseE:
	;	SETB E ; negative edge on E
	;	CLR E
	;	CALL delay
	;	RET

delay:
	;	MOV R0, #50
	;	DJNZ R0, $
	;	RET

CONVERT:
;		MOV A, TL1
	;	SUBB A,#30H
;		MOV B, #100
	;	MUL AB
	;	MOV R1, A
	;	MOV R2, B
	;	RET

START:
	    SETB TR1 ;;start the timer
		RET

TENMS:
		MOV R5, #20
outer:  MOV R6, #250
inner:	DJNZ R6, inner ;; do {}while(--R5);
		DJNZ R5, outer ;;}while(--R4)
	    RET