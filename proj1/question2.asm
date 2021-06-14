         ORG 40H  ;;Set the starting address
         MOV A,#0 ;;initialize accumulator
         MOV R0,#0 ;;Set R0 to be X2 (0-7 bits)
         MOV R1,#0 ;;Set R1 to be X2 (8-15 bits)
	     MOV R2,#1 ;;Set R2 to be X3 (0-7 bits)
         MOV R3,#0 ;;Set R3 to be X3 (8-15 bits)
	     MOV R4,#0 ;;Set R4 to be X4 (0-7 bits)
         MOV R5,#0 ;;Set R5 to be X4 (8-15 bits)
         MOV R7,#2 ;;R7 = N, N = 2 initially 

START1:  MOV A,R1  ;;A = R1
         ADD A,R3  ;;A := A + R3
	     MOV R5,A  ;;R5 = A 
         MOV A,R0  ;;A = R0
         ADD A,R2  ;;A := A + R2
	     MOV R4,A  ;;R4 = A
	     MOV A,R2  ;;A = R2
         MOV R0,A  ;;R0 = A, We need the new R1 value = old R2 value
         MOV A,R4  ;;A = R4
         MOV R2,A  ;;R2 = A, We need the new R2 value = old R3 value
         
         JNC NOCARRY ;;skip when CY == 0
         INC R5      ;;increment R5 if CY == 1
         CLR C       ;;clear CY
NOCARRY: MOV A,R3  ;;A = R3
         MOV R1,A  ;;R1 = A, We need the new R1 value = old R2 value      
         MOV A,R5  ;;A = R5
         MOV R3,A  ;;R3 = A, We need the new R2 value = old R3 value    
         INC R7    ;;increment R7    
         CJNE R7,#25, START1 ;;loop when N != 25
         END   ;

        
