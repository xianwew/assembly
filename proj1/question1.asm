       ORG 40H  ;;Set the starting address
       MOV A,#0 ;;initialize accumulator
       MOV R1,#0 ;;Set R1 to be X(n-2), R1 = X2 initially
	   MOV R2,#1 ;;Set R2 to be X(n-1), R2 = X3 initially
	   MOV R3,#0 ;;R3 is the result we want, Set R3 to be X(n), R3 = X4 initially 
       MOV R4,#10 ;;R4 indicates loop times
       MOV R7,#2 ;;R7 = N, N = 1 initially 
START: MOV A,R1  ;;A = R1
       ADD A,R2  ;;A := A + R2
	   MOV R3,A  ;;R3 = A
	   MOV A,R2  ;;A = R2
       MOV R1,A  ;;R1 = A, We need the new R1 value = old R2 value
       MOV A,R3  ;;A = R3
       MOV R2,A  ;;R2 = A, We need the new R2 value = old R3 value
       INC R7    ;;increment R7 
       DJNZ R4,START ;;loop and decrement R4 by 1, when R4 == 0, skip the loop
       END
  
