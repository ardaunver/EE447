;SYMBOL		DIRECTIVE	VALUE			COMMENT
NUMBER 		EQU 		0x00000000		
ADDR		EQU 		0x20000400		; Address to store HEALTH and SWORD
ADDR2		EQU			0x20000424		; Address to store health values after the fight is over
ADDR3		EQU			0x20000466		; Address to where CONVRT take place
OFFSET      EQU         0x22 			; OFFSET is used in CONVRT
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB		
CTR1        DCB         0x0B ;
NEWLINE		DCB			0xA
			DCB         0x0D
            DCB         0x04
MSG1        DCB         "Enter Monster Health:"
			DCB         0x0D
            DCB         0x04
MSG2        DCB         "Enter Sword Strength:"
            DCB         0x0D
            DCB         0x04
MSG3        DCB         "FIGHT!"
            DCB         0x0D
            DCB         0x04
			EXTERN		CONVRT			
			EXTERN		InChar
			EXTERN		OutStr
            EXPORT 		__main

			; HEALTH represents the health of the monster
			; Max HEALTH value = 999 (3E7 in HEX) 
			; SWORD	represents the damage of the sword
			; Max SWORD damage  =  99 (63 in HEX) 

__main 		PROC	
start		MOV			R0,#0
			LDR			R0,=MSG1	
			LDR			R1,=ADDR	; Address to store HEALTH and SWORD
			LDR			R10,=0xA	; Load 10 for Base-10
			LDR			R11,=0x64	; Load 100 for Base-100
			
			
			BL			OutStr		; Print "Enter Monster Health:"
			MOV			R6,#3		; Counter for the "health" loop	

			
			; "health" loop gets the monster health input from the user

health		CMP			R6,#0		; Check the counter
			BEQ			hex1		; Branch if Z is set
			BL			InChar		; Get input (HEALTH) from the user
			SUB 		R0,#0x30  	; Convert the ASCII value to HEX
			MUL			R0,R11		; Multiply regarding the digit (hundreds, tens, ones)
			UDIV		R11,R10		; Change the divisor for the next loop
			STR			R0,[R1],#4	; Store the value in ADDR
			SUB			R6,#1		; Decrement the counter
			MOV 		R0,#0		; Clear the register
			ADD			R4,#1		; Count the digits (counter for "hex1" loop)
			B 			health		; Loop again

			; "hex1" loop sums the stored values 
			; R3 holds the HEALTH value in HEX after the loop

hex1		CMP			R4,#0		; Check the counter
			BEQ			prep1		; Branch if Z is set
			SUB			R1,#4		; Pointer decremented
			LDR			R2,[R1]		; Digit is loaded 
			ADD			R3,R2		; Digit is added to the sum
			SUB			R4,#1		; Decrement counter
			B 			hex1		; Loop again

			; "prep1" loop prepares the registers for the "sword" loop

prep1 		MOV			R11,#100	; Load 100 for Base-100
			ADD			R1,#OFFSET	; Pointer = ADDR + OFFSET
			MOV			R2,R3		; Store the HEALTH value in R2
			MOV 		R3,#0		; Clear R3
			MOV			R6,#2		; Set the counter (SWORD is 2 digits)
			LDR			R0,=NEWLINE	
			BL			OutStr		; Print newline
			MOV			R0,#0
			LDR			R0,=MSG2
			BL			OutStr		; Print "Enter Sword Strength:"
			MOV			R0,#0		; Clear R0

			; "sword" loop gets the sword power input from the user

sword		CMP			R6,#0		; Check the counter
			BEQ			hex2		; Branch if Z is set
			BL			InChar		; Get input (SWORD) from the user
			SUB 		R0,#0x30  	; Convert the ASCII value to HEX
			MUL			R0,R10		; Multiply regarding the digit (hundreds, tens, ones)
			UDIV		R10,R10		; Change the divisor for the next loop
			STR			R0,[R1],#4	; Store the value in ADDR + OFFSET and increment pointer
			SUB			R6,#1		; Decrement counter
			MOV 		R0,#0		; Clear R0
			ADD			R4,#1		; Count the digits for the "hex2" loop
			B 			sword		; Loop again
			
			; "hex2" loop sums the stored values 
			; R3 holds the SWORD value in HEX after the loop

hex2		CMP			R4,#0		; Check the counter
			BEQ			prep2		; Branch if Z is set
			SUB			R1,#4		; Pointer decremented
			LDR			R7,[R1]		; Digit is loaded 
			ADD			R3,R7		; Digit is added to the sum
			SUB			R4,#1		; Decrement counter
			B 			hex2		; Loop again

prep2		LDR			R0,=NEWLINE	
			BL			OutStr		; Print newline
			MOV			R0,#0
			LDR			R0,=MSG3	; Print "FIGHT!"
			BL			OutStr	
			CMP			R12,#1		; If the flag is set, the fight is over
			BEQ			prep3		; Branch to prep3
			MOV			R0,#0		; Clear R0
			MOV			R7,#0		; Clear R7
			MOV			R4,R2		; Current HEALTH
			MOV			R5,R3		; Current SWORD
			MOV			R12,#1		; Set the flag so that you only fight the monster once
			MOV			R6,#2		; R6 will be used for division
			
			; R1 points to ADDR + OFFSET
			; R2 holds HEALTH, R3 holds SWORD
			; R4 holds Current HEALTH, R5 Current holds SWORD
			; R6 holds 2 for division
			; R10 and R11 hold 1 and 100, respectively
			; R12 is used as flag

			; "fight" is the recursive subroutine, where you fight the monster
			; Purpose is to bring the monster's health to zero
			; You keep attacking the monster, until it has zero or negative health
			; If its health is zero, monster is slaughtered 
			; If its health is negative, monster is healed by the half of its initial health 
fight 		CMP			R4, #0				; If monster has 0 health
			BEQ			return				; Return
			STMDB 		SP!, {R4,LR}		; PUSH monster's health and LR to the stack
attack		SUB			R4,R5				; Hit the monster with your sword
			CMP			R4,#0				; If its health is above 0
			BGT			attack				; Keep attacking
			CMP			R4, #0				; If its health is zero
			BEQ			return				; Return 
			ADD			R4,R2, LSR #1		; Monster is healed
			UDIV		R5,R6				; Damage of the sword is halved
			ADD			R7,#1				; Count the times monster healed
			BL 			fight				; Recursive call
			LDMIA		SP!, {R4,LR}		; POP from the stack

			; Recursive functions return
return 		STR			R4,[R1],#2			; Store the health values of the monster
			MOV 		PC, LR				; PC <-- LR 
			
prep3		ADD			R8, R7,#1			; R8 holds the amount of the health values (count)
			LDR			R0,=NEWLINE			; Load the ascii value of newline
			BL			OutStr				; Print newline
			MOV			R0,#0				; Clear R0
			LDR			R1,=ADDR2			; Load the address where the health values are stored
			MOV			R12,#0				; Clear R12
			
print		CMP			R8,#0				; Check if count is zero (no more health values)
			BEQ			done				; Branch to the end
			LDR			R1,=ADDR2			; Load the address where the health values are stored
			ADD			R1,R12				; Increment the pointer by 0,2,4,6,8...
			LDRB		R4,[R1]				; Load the health value
			LDRB		R9,[R1,#1]			; If health is below 255 (0xFF), this byte will be zero
											; If health is over 255, 
			LSL			R9,#8				; this byte will be shifted left 8 times (or mult. by 256)
			ADD			R4,R9				; and added to the previous byte 
			LDR			R5,=ADDR3			; Load the address where "CONVRT" will take place
			BL			CONVRT				; Convert the digits of the value in R4 to ASCII
			LDR			R0,=ADDR3			; Load the address of the converted digits
			BL			OutStr				; OutStr prints from the address stored in R0 until 0x0D and 0x04 bytes
			SUB			R8,#1				; Decrement the counter
			ADD			R12,#2				; Increment of the pointer depends on R12
			B			print				; Loop again
			
done 		B 			done				; End the code
			ALIGN
			ENDP
			END