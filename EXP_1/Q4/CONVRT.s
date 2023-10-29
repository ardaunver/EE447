;SYMBOL		DIRECTIVE	VALUE			COMMENT
NUMBER 		EQU 		0x00000081	
NUM		 	EQU 		0x20000466
OFFSET      EQU         0x22 
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		CONVRT
				
			; Try 0x0000000A, 0x0000001A,, 0x00000ABC 0x00000081, 0x7FFFFFFF

			
CONVRT		PROC
			CMP			R4,#0 			; Check if number is equal to 0
			BEQ			zerocase
			MOV			R2,#1			; Number of digits
			MOV			R10,#10	 		;Load 10 for Base-10

; "loop" converts the HEX number to decimal 
; and stores the number digit by digit
loop		CMP			R4,#10
			BMI			lastdigit
			SDIV		R0,R4,R10 		; Signed divison (R0 = R4(number)/10)
										; EX: 2 = 26 / 10 stored in R0
			MUL 		R3,R0,R10 		; EX: 20 = 2 * 10 stored in R3
			SUB 		R6,R4,R3		; EX: 6 = 26 - 20 stored in R3
			STRB		R6,[R5], #1		; digit (6) stored in memory and increment the pointer
			SDIV		R4,R3,R10 		; Signed divison (R0 = R4(number)/10)
			ADD			R2,#1			; Increment the number of digits
			B			loop
			
zerocase	MOV			R3,R4
			ADD			R3,#48
			STRB		R3,[R5]
			ADD 		R11,#1
			B 			fin


lastdigit	STRB 		R4,[R5]			; Store the last digit 		
			LDR			R10,=NUM
			ADD			R10,#OFFSET
			MOV			R11,R2			; Preserve the number of digits

; "reverse" reverses the digits so that it is in the correct order
reverse		CMP			R2,#0
			BEQ			prep
			LDR			R3,[R5]			; Convert the table to ASCI values
			STRB 		R3,[R10], #1		; Store the ASCII values and increment the pointer
			MOV			R3,#0
			SUB			R5,#1
			SUB			R2,#1
			B 			reverse

; "prep" prepares the register for the "ascii" loop
prep 		ADD 		R5,#1
			MOV			R2, R11
			
; "ascii" adds 48 to each digit so that the digits are in ASCII form
; and stores the digits in the correct memory address
ascii		CMP			R2,#0
			BEQ			fin
			LDRB		R3, [R5,#OFFSET]
			ADD			R3,#48
			STRB		R3,[R5], #1 		 ; Store the digit in the correct address
			SUB			R2,#1
			B			ascii
			
fin			LDR			R5,=NUM		; R5 points to the address which stores the digits of the number in ASCII form
			ADD			R6, R5, R11
			LDR			R11,=0x0D
			STRB		R11,[R6], #1
			LDR			R11,=0x04
			STRB		R11,[R6]
			LDR			R5,=NUM
			LDR 		R0,=NUM

			BX          LR 

			ENDP

			ALIGN
            END