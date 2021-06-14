	ORG 00H
      E EQU P3.2 ;;define E
     RS EQU P3.3 ;;define RS
		;;start the motor
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

		;;select different branch accouding to the value in R2
		;;if R2 == 0, nothing's gonna change
		MOV A, R2    
		SUBB A, #1
		JC ZERO
		CLR C
		;;if R2 == 1, we need to plus 256
		MOV A, R2
		SUBB A, #2
		JC ONE
		CLR C
		;;if R2 == 2, we need to plus 512
		MOV A, R2		
		SUBB A, #3
		JC TWO
		CLR C
ZERO:
		RET

		;;This function create a 10ms delay by using one inner loop and one outer loop. Each DJNZ takes 2usso we need 5000 of DJNZs.
TENMS:
		MOV R6, #20  ;;move 20 to R6
outer:  MOV R7, #250 ;;move 250 to R7
inner:	DJNZ R7, inner ;; do {}while(--R7);
		DJNZ R6, outer ;;}while(--R6)
	    RET

ONE:
		CLR C		;;clear the carry
		MOV A, R5	;;move R5 to A
		ADD A,#6 	;;plus 6
		SUBB A,#10	;;substract 10 to see if there is C
		JNC NOCARRY1
		;;plus 6 directly if there is C
		MOV A, R5	
		ADD A, #6 
RETURN1:
		MOV R5, A  ;;move A to R5
		CLR C		;;clear C
		MOV A, R4	;;move R4 to A
		ADD A, #5	;;plus 5 to A
		SUBB A,#10  ;;substract 10
		JNC NOCARRY2
		;;plus 5 directly if there is C
		MOV A, R4
		ADD A, #5
RETURN2:
		MOV R4, A  ;;move A to R4
		CLR C		;;clear C
		MOV A, R3  ;;move R3 to A
		ADD A, #2	;;plus 2 to A
		MOV R3, A	;;move A to R3
		RET

TWO:
		CLR C		;;clear the carry
		MOV A, R5	;;move R5 to A
		ADD A,#2 	;;plus 2
		SUBB A,#10	;;substract 10 to see if there is 	C
		JNC NOCARRY3
		;;plus 2 directly if there is C
		MOV A, R5
		ADD A, #2 
RETURN3:
		MOV R5, A  ;;move A to R5
		CLR C		;;clear C
		MOV A, R4	;;move R4 to A
		ADD A, #1	;;plus 1 to A
		SUBB A,#10	;;substract 10
		JNC NOCARRY4
		;;plus 1 directly if there is C
		MOV A, R4
		ADD A, #1
RETURN4:		
		MOV R4, A	;;move A to R4
		CLR C		;;clear C
		MOV A, R3	;;move R3 to A
		ADD A, #5	;;plus 5 to A
		MOV R3, A	;;move A to R3
		RET

NOCARRY1:
		INC R4		;;increment R4
		MOV A, R5	;;move R5 to A
		SUBB A,#4	;;subtract 4
		JMP RETURN1	;;jump back
				
NOCARRY2:
		INC R3		;;increment R3
		MOV A, R4	;;move R4 to A
		SUBB A,#5	;;subtract 5
		JMP RETURN2	;;jump back

NOCARRY3:
		INC R4		;;increment R4
		MOV A, R5	;;move R5 to A
		SUBB A,#8	;;subtract 8
		JMP RETURN3 ;jump back
				
NOCARRY4:
		INC R3		;;increment R3
		MOV A, R4	;;move R4 to A
		SUBB A,#9	;;subtract 9
		JMP RETURN4	;;jump back
