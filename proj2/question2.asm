		 ORG 40H
	 N1: DB "14" ;40H=0x32H,41H=0x33H
  	 	 DB 0
	 N2: DB "17" ;43H=0x35H,44H=0x38H
         DB 0
		 MOV R0, #0    ;;initialized R0
	   	 MOV DPTR, #N1 ;;move DPTR to label M1
	     MOVC A, @A+DPTR ;;take the content of N1 and store to A
		 SUBB A, #30H ;;subtract A to convert it to decimal value
		 MOV R1, A    ;;store the value to R1
	     MOV A, #0    ;;clear A
		 INC DPTR     ;;increment A by 1, move to the next address
	     MOVC A, @A+DPTR ;;take the content of (N1+1) and store to A
		 SUBB A, #30H ;;subtract A to convert it to decimal value
		 MOV R2, A    ;;move the value to R2
		 
         INC DPTR     ;;increment A by 1, move to the next address
         MOV A,#0 ;;clear A
	     MOVC A, @A+DPTR ;;take the content of (N1+1) and store to A
		 JZ NEXT1     ;;jump if A == 0
		 SUBB A, #30H ;;subtract A to convert it to decimal value
		 MOV R3, A    ;;move the value to R2
		 MOV R0, #1   ;;R0=1

NEXT1:	 MOV DPTR, #N2;;move DPTR to label N2
		 MOV A, #0    ;;clear A
		 MOVC A, @A+DPTR ;;take the content of N2 and store to A
		 SUBB A, #30H ;;subtract A to convert it to decimal value
		 MOV R4, A    ;;move the value to R3
		 INC DPTR     ;;move DPTR to label (N2+1)
	     MOV A, #0    ;;clear A
		 MOVC A, @A+DPTR ;;take the content of (N2+1) and store to A
		 SUBB A, #30H ;;subtract A to convert it to decimal value
		 MOV R5, A    ;;move theb value to R4
		 
		 INC DPTR     ;;increment A by 1, move to the next address
	     MOV A, #0 ;;clear A 
         MOVC A, @A+DPTR ;;take the content of (N1+1) and store to A
         JZ NEXT2     ;;Jump if A = 0 
		 SUBB A, #30H ;;subtract A to convert it to decimal value
		 MOV R6, A    ;;move the value to R2 

NEXT2:	 CJNE R0, #1, SKIP1
         MOV A, R2    ;;move R1 to A
		 MOV B, #10   ;;move 10 to B
		 MUL AB       
	;;mutiplied them, casue tens digit needs to be mutiplied by 10
		 ADD A, R3    ;;add R2
		 MOV R2, A    ;;move A to R2
		 MOV A, R1    ;;move R1 to A
	     MOV B, #100  ;;mutiply B by 100 becase it's a hundred digit
		 MUL AB       ;;mutiply AB
		 ADD A, R2    ;;add R2 tO A
         MOV R3, A    ;;store the value to R6
         JMP NEXT3    ;;we don't need the next loop   
SKIP1:   MOV A, R1    ;;if the number is less than 100
	     MOV B, #10   ;;mutiply B by 10 becasue R1 is the ten digit
		 MUL AB       ;;multiply them
	     ADD A, R2    ;;add R2 to A
		 MOV R3, A    ;;store the result to R3
		
NEXT3:   CJNE R0, #1, SKIP2
         MOV A, R5    ;;move R1 to A
		 MOV B, #10   ;;move 10 to B
		 MUL AB       ;;mutiplied them, casue tens digit needs to be mutiplied by 10
		 ADD A, R6    ;;add R2
		 MOV R5, A    ;;move A to R5
		 MOV A, R4    ;;move R4 to A
	     MOV B, #100  ;;mutiply B by 100 becase it's a hundred digit
		 MUL AB       ;;multiply them
		 ADD A, R5    ;;add R5 tO A
         MOV R4, A    ;;store the value to R6
	     JMP NEXT4    ;;we don't need the following loop
SKIP2:   MOV A, R4    ;;move R4 to A
	     MOV B, #10   ;;move 10 to B
		 MUL AB       ;;mutiplied them, casue tens digit needs to be mutiplied by 10
	     ADD A, R5    ;;add R5 to A
		 MOV R4, A    ;;store the result to R4

NEXT4:   MOV A,#0 ;;initialize accumulator
		 MOV R0,#0 ;;clear R0
	     MOV R1,#0 ;;Set R1 to be the result (0-7 bits)
         MOV R2,#0 ;;Set R2 to be the result (8-15 bits)
		 MOV R5,#0 ;;clear R5
		 MOV R6,#0 ;;clear R6
         MOV R7,#0 ;;clear R7

    	 MOV A, R3 ;;move R3 to A
		 MOV B, R4 ;;move R4 to B
		 MUL AB    ;;multiply them
		 MOV R2, B ;;the 8-15 bit is stored in B, so move it to R2
		 MOV R1, A ;;move 0-7 bit to R1

		 MOV R4, #0 ;;clear R4
		 MOV R3, #0 ;;clear R3

		 MOV A, R1  ;;move R1 to A
     	 MOV B, #100;;move 100 to B				
		 DIV AB     ;;divide A by 100 to get the hundreds 
		 MOV R2, A  ;;store the result to R2

		 MOV A, R1  ;;move R1 to A
		 MOV B, #10 ;;move 10 to B		
		 DIV AB     ;;divide A by 10 
         MOV R7, A  ;;store the result to R7
		 MOV A, R2  ;;move R2 to A
		 MOV B, #10 ;;move 10 to B
		 MUL AB     ;;multiply AB
		 MOV R0, A  ;;store the result to R0
		 MOV A, R7  ;;move the result to A 
		 SUBB A, R0 ;;subtract 10*R2 to get the tens
		 MOV R3, A  ;;store the result to R3
         
		 MOV A, R2  ;;move R2 to A
		 MOV B, #100;;move 100 to B
		 MUL AB     ;;multiply them
		 MOV R6, A  ;;store the result to R6
		 MOV A, R3  ;;move R3 to A
		 MOV B, #10 ;;move 10 to B
		 MUL AB     ;;multiply them
		 ADD A, R6  ;;A := A + R6
         MOV R5, A  ;;store the result to R5
		 MOV A, R1  ;;move R1 to A
		 SUBB A, R5 ;;A = R1 - (R2*100 + R3*10), so we got the unit digits
		 MOV R4, A  ;;store the result to R4
		 
		 ;ADD 30H, convert decimal to hex
		 MOV A, R2  ;;move R2 to A
		 ADD A, #30H;;A := A +30H
		 MOV 40H, A ;;save to result to address 40H

		 MOV A, R3  ;;move R3 to A
		 ADD A, #30H;;A := A +30H
		 MOV 41H, A ;;save to result to address 41H
		 
         MOV A, R4  ;;move R4 to A
		 ADD A, #30H;;A := A +30H
		 MOV 42H, A ;;save to result to address 42H

		 END