			
;SYMBOL				DIRECTIVE			VALUE			COMMENT			
GPIO_PORTB_DATA 	EQU 				0x400053FC ; data address to all pins
GPIO_PORTB_DIR 		EQU 				0x40005400
GPIO_PORTB_AFSEL 	EQU 				0x40005420
GPIO_PORTB_DEN 		EQU 				0x4000551C
GPIO_PORTB_PUR 		EQU 				0x40005510
PUB					EQU 				0xF0
IOB 				EQU 				0x0F
GPIO_PORTE_DATA 	EQU 				0x400243FC ; data address to all pins
GPIO_PORTE_DIR 		EQU 				0x40024400
GPIO_PORTE_AFSEL 	EQU 				0x40024420
GPIO_PORTE_DEN 		EQU 				0x4002451C
IOE 				EQU 				0x00
SYSCTL_RCGCGPIO 	EQU 				0x400FE608

ADDR			 	EQU 				0x20000400
STR_ADDRESS			EQU 				0x20000500
	
					AREA 				main, READONLY, CODE, ALIGN=2
					THUMB
					EXTERN 				DELAY
					EXTERN 				SEARCH
					EXTERN 				OutChar
					EXPORT 				__main

__main 		LDR 	R1,=SYSCTL_RCGCGPIO		; Run Clock Gate Control Register
			LDR 	R0,[R1]					; Load the value
			ORR 	R0,R0,#0x12				; ORR with 010010 for (E and B ports)
			STR		R0,[R1]					; Store the value at the address
			NOP								; Wait for it to stabilize
			NOP
			NOP 

			LDR		R1,=GPIO_PORTB_DIR 		; Direction register
			LDR  	R0,[R1]
			BIC 	R0,#0xFF
			ORR		R0,#IOB
			STR 	R0,[R1]					; Store the value
			
			LDR 	R1,=GPIO_PORTB_AFSEL	; Alternate Function SELect register 
			LDR 	R0,[R1]
			BIC 	R0,#0xFF
			STR 	R0,[R1]					; Store the value
			
			LDR 	R1,=GPIO_PORTB_DEN		; Digital ENable register
			LDR 	R0,[R1]
			ORR 	R0,#0xFF
			STR 	R0,[R1] 				; Store the value
			
			LDR 	R0,=GPIO_PORTB_PUR		; Pull-up register
			MOV		R1,#PUB					; Determines whether there is pull-up register or not
			STR 	R1,[R0]					; Store the value
			
			LDR 	R11, =STR_ADDRESS
						

row			LDR 	R0,=0xF0
			LDR 	R1,=GPIO_PORTB_DATA		; Load the address to where the data will be written to the memory
			STR 	R0,[R1]					; Store "0xF0" to this address
			
			MOV 	R0,#0					; Initialize the registers
			MOV 	R1,#0					; 		|
			MOV 	R2,#0					; 		|
			MOV		R3,#0					; 		|
			MOV 	R4,#0					; 		|
			MOV 	R5,#0					; 		|
			MOV 	R6,#0					; 		V		
			
			LDR 	R1,=GPIO_PORTB_DATA		; Load the data register address to R1
			LDRB 	R3,[R1]					; Load the byte (input) to R4
			LSR		R4,R3,#4            	; Logical Right Shift 4 times (to shift one HEX digit)
											
			BL 		DELAY					; Wait for some time to check the input again
											; Comparing the current reading with the initial reading
											; makes the results more robust and reliable 
			
			LDR 	R1,=GPIO_PORTB_DATA		; Load the address where the inputs are stored to R1 
			LDRB 	R3,[R1]					; Load the input byte to R4, again
			LSR		R5,R3,#4 				; Logical Right Shift 4 times (to shift one HEX digit)
											
											; R3 has the initial reading and R5 has the final reading 
			CMP 	R4, R5					; Compare the initial and the final reading
			BNE 	row					; If "Not Equal", then it is NOT an ideal input
											; Check for input, again 
			
			CMP 	R4,#0xF 				; If the values are the same but it is equal to F
			BEQ 	row					; Then, the input is not valid as well (means no input)
											; Check for input, again 
			
			; "0" represents the button pressed

; firstrow = rowE
; Check if the button pressed is in the first row
firstrow	LDR     R2,=0xFE				; R2 <-- 0xFE
			STR		R2,[R1]					
			LDR 	R1,=GPIO_PORTB_DATA		; Load the address
			LDRB	R3,[R1]
			CMP 	R2,R3
			BEQ 	secondrow
			B 		continue				; R3 is one of these: 0xEE, 0xDE, 0xBE, 0x7E
			
; secondrow = rowD
; Check if the button pressed is in the second row
secondrow	LDR 	R2,=0xFD				; R2 <-- 0xFD
			STR		R2,[R1]					
			LDR 	R1,=GPIO_PORTB_DATA		; Load the address
			LDRB	R3,[R1]
			CMP 	R2,R3
			BEQ 	thirdrow
			B 		continue				; R3 is one of these: 0xED, 0xDD, 0xBD, 0x7D

; thirdrow = rowB
; Check if the button pressed is in the third row
thirdrow	LDR 	R2,=0xFB				; R2 <-- 0xFB
			STR		R2,[R1]					
			LDR 	R1,=GPIO_PORTB_DATA		; Load the address
			LDRB	R3,[R1]
			CMP 	R2,R3
			BEQ 	fourthrow
			B 		continue				; R3 is one of these: 0xEB, 0xDB, 0xBB, 0x7B

; fourthrow = rowE
; Check if the button pressed is in the fourth row
fourthrow	LDR 	R2,=0xF7				; R2 <-- 0xF7
			STR		R2,[R1]					
			LDR 	R1,=GPIO_PORTB_DATA		; Load the address
			LDRB 	R3,[R1]					; R3 is one of these: 0xE7, 0xD7, 0xB7, 0x77

; Check if there is debouncing as the key is released
; As stated in the experiment manual,
; Checking the consistenct of the readings at two different time instances
; and comparing these two values is the simplest way of checking debouncing
continue	LDR 	R1,=GPIO_PORTB_DATA
			LDRB 	R6,[R1]
			ASR		R6,R6,#4 				; Asynchronous Right Shift 4 bits

			BL 		DELAY
			
			LDR 	R1,=GPIO_PORTB_DATA
			LDRB 	R7,[R1]
			ASR		R7,R7,#4 
			CMP 	R6,R7
			BNE 	continue
			
			CMP 	R6,#0xF					
			BEQ 	exit					
			B 		continue
			
exit		BL		SEARCH
			LDR  	R9,=ADDR
			BL 		OutChar
			SUB		R0,#48
			CMP		R0,#9
			BGT		over9
			
			STR     R0,[R11],#1				; Store the outputs at an address		
			B 		row

over9		SUB		R0,#1
			STR     R0,[R11],#1				; Store the outputs at an address		
			B 		row

			ALIGN
			END