;SYMBOL		DIRECTIVE	VALUE			COMMENT
NUMBER 		EQU 		0x00000000		
NUM		 	EQU 		0x20000400
OFFSET      EQU         0x22 
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			DCB 		0X04
			DCB 		0X0D
			EXTERN		CONVRT			
			EXTERN		UPBND
			EXTERN		InChar
			EXTERN		OutStr
            EXPORT 		__main
__main 		PROC	
start		LDR			R10,=0xA	; Load 10 for Base-10
			BL			InChar		; Get the first element of input (N) from the user
			SUB 		R0,#0x30  	; Convert the ASCII value to HEX
			MOV			R11,R0		; Store the value in R11
			
			BL			InChar		; Get the second element of input (N) from the user
			SUB 		R0,#0x30	; Convert the ASCII value to HEX
			MOV			R12,R0		; Store the value in R12 
			
			MUL			R1,R11,R10	; Multiply the "Tens" digit by 10
			ADD			R1,R12		; Add the "Ones" digit
									; R1 holds the value N (input from the user)
			
			
			SUB			R1,#1		; If N = 8, 0x1 must be shifted left 7 times
			MOV			R9,#1
			LSL			R9,R1		; First "Guess" Number
			MOV			R1,R9
			
			CMP			R1,#0		; If N is zero increment the first guess
			ADDEQ		R9,#1
			
initbounds	MOV			R7,#0		; First Lower Bound
			LSL			R8,R9,#1	; First Upper Bound
			B 			output		

			
			
feedback	BL			InChar		; Get input from the user (C or U or D)
			CMP			R0,#0x43	; Check if the input is (C)orrect
			BEQ			done		; Break out the loop
			
			BL			UPBND		; Else if the input is either (U)p or (D)own, enter UPBND 
									; subroutine to change the "Guess" number 
			B 			output		; "Guess" number will be printed as output
			
output		MOV			R4,R9		; "Guess" number must be stored in R4 before CONVRT
			LDR			R5,=NUM		; An address must be stored in R5 before UPBND
			BL 			CONVRT		; Convert the HEX number to decimal
			
			BL 			OutStr
			B 			feedback
			
done 		B 			done		; End the code
			ALIGN
			ENDP
			END