	ORG 00H
      E EQU P3.2 ;;define E
     RS EQU P3.3 ;;define RS
		;;start the moto
		CLR P3.1 
		SETB P3.0
		;;set the mode for timer1
		MOV TMOD,#50H 
		
		CLR RS  ;;send instruction to the display
		MOV P1,#38H ;;Set Interface data length to 8 bits, 2 line, 5x7 font
		CALL PulseE 
		MOV P1,#06H;;set the entry mode to increment with no shift
		CALL PulseE
		MOV P1,#0FH ;;display on, the cursor on and blinking on
		Call PulseE
BACK:
		
		MOV TL1, #0 ;;initalize TL1
		MOV TH1, #0 ;;initalize TH1
        CALL START ;;start the timer
		CALL TENMS ;;delay for 10ms
		MOV R1, TL1;;store the value of TL1 to R1
		MOV R2, TH1;;store the value of TH1 to R2
		CALL CONVERT ;;call the convertion function to convert hex to deciaml

		SETB RS ;;send data
		CALL sendRevol ;;call sendRevol to send the data to the lcd
		CLR RS  ;;indicate instruction is gonna be sent
		MOV P1,#80H ;;display on, the cursor on and blinking on
		Call PulseE
		JMP BACK ;;loop again

sendRevol:
		;;convert R3 to ascii code
		MOV A, R3  
		ADD A,#30H
		MOV R3, A
		;;convert R4 to ascii code
		MOV A, R4
		ADD A,#30H
		MOV R4, A
		;;convert R5 to ascii code
		MOV A, R5
		ADD A,#30H
		MOV R5, A
		MOV R0,#0 ;;termination 0

		MOV P1,R3 ;;move the data in R3 to P1
		Call PulseE
		MOV P1,R4 ;;move the data in R5 to P1
		Call PulseE
		MOV P1,R5 ;;move the data in R5 to P1
		Call PulseE
		MOV P1,#'0';;display the first '0'
		Call PulseE
		MOV P1,#'0';;display the second '0'
		Call PulseE
		MOV P1,R0 ;;termination 0
		Call PulseE

		RET

PulseE:
		SETB E ; negative edge on E
		CLR E  ;clear E
		CALL delay ;;call delay function, let lcd have enough time to implement
		RET

delay:
		MOV R0, #50 ;;move 50 to R0
		DJNZ R0, $  ;;run DJNZ for 50 times, each time takes 2us
		RET

START:
	    SETB TR1 ;;start the timer
		RET

CONVERT:
		MOV   A,R1   ;;move R1 to A   
 		MOV   B,#10  ;;move 10 to B
 		DIV   AB     ;;divide A by B
 		MOV   R5,B   ;;get the units digit
		MOV   B,#10  ;;move 10 to B
		DIV   AB	 ;;divide A by B
 		MOV   R4,B   ;;get the tens digit
 		MOV   R3,A   ;;get the hundredth unit

		MOV A, R2    
		SUBB A, #1
		JC ZERO
		CLR C
		MOV A, R2
		SUBB A, #2
		JC ONE
		CLR C
		MOV A, R2		
		SUBB A, #3
		JC TWO
		CLR C
ZERO:
		RET

TENMS:
		MOV R6, #20
outer:  MOV R7, #250
inner:	DJNZ R7, inner ;; do {}while(--R5);
		DJNZ R6, outer ;;}while(--R4)
	    RET

ONE:
		CLR C
		MOV A, R5
		ADD A,#6 
		SUBB A,#10
		JNC NOCARRY1
		MOV A, R5
		ADD A, #6 
RETURN1:
		MOV R5, A
		CLR C
		MOV A, R4
		ADD A, #5
		SUBB A,#10
		JNC NOCARRY2
		MOV A, R4
		ADD A, #5
RETURN2:
		MOV R4, A
		CLR C
		MOV A, R3
		ADD A, #2
		MOV R3, A
		RET

TWO:
		CLR C
		MOV A, R5
		ADD A,#2 
		SUBB A,#10
		JNC NOCARRY3
		MOV A, R5
		ADD A, #2 
RETURN3:
		MOV R5, A
		CLR C
		MOV A, R4
		ADD A, #1
		SUBB A,#10
		JNC NOCARRY4
		MOV A, R4
		ADD A, #1
RETURN4:		
		MOV R4, A
		CLR C
		MOV A, R3
		ADD A, #5
		MOV R3, A
		RET

NOCARRY1:
		INC R4
		MOV A, R5
		SUBB A,#4
		JMP RETURN1
				
NOCARRY2:
		INC R3
		MOV A, R4
		SUBB A,#5
		JMP RETURN2	

NOCARRY3:
		INC R4
		MOV A, R5
		SUBB A,#8
		JMP RETURN3
				
NOCARRY4:
		INC R3
		MOV A, R4
		SUBB A,#9
		JMP RETURN4	
