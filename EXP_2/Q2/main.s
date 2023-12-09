GPIO_PORTB_DATA 	EQU 0x400053FC ; data addr e s s to a l l pins
GPIO_PORTB_DIR 		EQU 0x40005400
GPIO_PORTB_AFSEL 	EQU 0x40005420
GPIO_PORTB_DEN 		EQU 0x4000551C
GPIO_PORTB_PUR 		EQU 0x40005510
PUB					EQU 0x0F
IOB 				EQU 0xF0
GPIO_PORTE_DATA 	EQU 0x400243FC ; data addr e s s to a l l pins
GPIO_PORTE_DIR 		EQU 0x40024400
GPIO_PORTE_AFSEL 	EQU 0x40024420
GPIO_PORTE_DEN 		EQU 0x4002451C
IOE 				EQU 0x00
SYSCTL_RCGCGPIO 	EQU 0x400FE608
	
					AREA main, READONLY, CODE, ALIGN=2
					THUMB
					EXTERN DELAY
					EXPORT __main


; Delay degismeli
; 3 saniyede degil 4 saniyede bir almali
; Registerlarin adi degismeli

__main 	    LDR 	R1,=SYSCTL_RCGCGPIO
			LDR 	R0,[R1]
			ORR 	R0,R0,#0x12 	;0001.0010
									; Enable clock for PortB = 0x02 and for PortE = 0x10
			STR 	R0,[R1]
			NOP
			NOP
			NOP 

			LDR 	R1,=GPIO_PORTB_DIR 
			LDR 	R0,[R1]
			BIC 	R0,#0xFF
			ORR 	R0,#IOB
			STR 	R0,[R1]
			
			LDR 	R1,=GPIO_PORTB_AFSEL
			LDR 	R0,[R1]
			BIC 	R0,#0xFF
			STR 	R0,[R1]
			
			LDR 	R1,=GPIO_PORTB_DEN 
			LDR 	R0,[R1]
			ORR 	R0,#0xFF			; Enable Port as digital port
			STR 	R0,[R1] 
			
			LDR 	R0,=GPIO_PORTB_PUR
			MOV		R1,#PUB
			STR 	R1,[R0]
			
			MOV32 	R11,#8000000

loop	    MOV32 	R11,#8000000

			MOV 	R2,#0
			MOV 	R3,#0
			MOV 	R4,#0
			MOV 	R5,#0
			
			LDR 	R1,=GPIO_PORTB_DATA ; Load the address that the input will be written to  (load for input)
			LDRB 	R5,[R1] 			; Load the input to R5
			LSL		R5,R5,#4 			; Shift the input one byte
			CMP 	R5,#0xFF 			; If it is other than 0xF0 give the output
			BEQ 	loop
			
			MOV 	R4,R1 				; Move the data register to R2
			LDRB	R4,[R4] 			; Load the data from the data register
			LSL		R3,R4,#4 			; Shift the bits 4 times and load to R3
			STR		R3,[R1] 			; Store R3 at the data register address (store for output)
			BL 		DELAY
			B loop
			ALIGN
			END