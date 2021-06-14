	ORG 00H
      E EQU P3.2 ;;define E
     RS EQU P3.3 ;;define RS
		CLR P3.1
		SETB P3.0
		MOV TMOD,#50H
BACK:		
	;	MOV TL1, #0 ;;
	;	MOV TH1, #0 ;; 
     ;   CALL START

	;	CALL TENMS
	;	MOV R1, TL1
	;	MOV R2, TH1
	;	CALL CONVERT
		JMP BACK

START:
	;    SETB TR1 ;;start the timer
	;	RET

CONVERT:
	;	MOV   A,R1      
 	;	MOV   B,#10        ;
 	;	DIV   AB           ; 
 	;	MOV   R5,B         ;
	;	MOV   B,#10
	;	DIV   AB
 	;	MOV   R4,B         ;
 	;	MOV   R3,A         ;

	;	MOV A, R2
	;	SUBB A, #1
	;	JC ZERO
	;	CLR C
	;	MOV A, R2
	;	SUBB A, #2
	;	JC ONE
	;	CLR C
	;	MOV A, R2		
	;	SUBB A, #3
	;	JC TWO
	;	CLR C
ZERO:
	;	RET

TENMS:
	;	MOV R6, #20
;outer:  MOV R7, #250
;inner:	DJNZ R7, inner ;; do {}while(--R5);
	;	DJNZ R6, outer ;;}while(--R4)
	 ;   RET

ONE:
	;	CLR C
	;	MOV A, R5
	;	ADD A,#6 
	;	SUBB A,#10
	;	JNC NOCARRY1
	;	MOV A, R5
	;	ADD A, #6 
RETURN1:
	;	MOV R5, A
	;	CLR C
	;	MOV A, R4
	;	ADD A, #5
	;	SUBB A,#10
	;	JNC NOCARRY2
	;	MOV A, R4
	;	ADD A, #5
RETURN2:
	;	MOV R4, A
	;	CLR C
	;	MOV A, R3
	;	ADD A, #2
	;	MOV R3, A
	;	RET

TWO:
	;	CLR C
	;	MOV A, R5
	;	ADD A,#2 
	;	SUBB A,#10
	;	JNC NOCARRY3
	;	MOV A, R5
	;	ADD A, #2 
RETURN3:
	;	MOV R5, A
	;	CLR C
	;	MOV A, R4
	;	ADD A, #1
	;	SUBB A,#10
	;	JNC NOCARRY4
	;	MOV A, R4
	;	ADD A, #1
RETURN4:		
	;	MOV R4, A
	;	CLR C
	;	MOV A, R3
	;	ADD A, #5
	;	MOV R3, A
	;	RET

NOCARRY1:
	;	INC R4
	;	MOV A, R5
	;	SUBB A,#4
	;	JMP RETURN1
				
NOCARRY2:
	;	INC R3
	;	MOV A, R4
	;	SUBB A,#5
	;	JMP RETURN2	

NOCARRY3:
	;	INC R4
	;	MOV A, R5
	;	SUBB A,#8
	;	JMP RETURN3
				
NOCARRY4:
	;	INC R3
	;	MOV A, R4
	;	SUBB A,#9
	;	JMP RETURN4	
