;SYMBOL		DIRECTIVE	VALUE			COMMENT
NUMBER 		EQU 		0x00000000		
NUM		 	EQU 		0x20000400

			AREA 		upbound, READONLY, CODE
            THUMB
			EXPORT 		UPBND				
UPBND		PROC
			
			CMP			R0,#85		; Check if the feedback is (U)p
			BNE			down

; Lower and upper bound are represented with R7 and R8, respectively

; If the number is greater than the "Guess" Number (R9)
; Lower bound must be updated
			ADD			R7,R9,#1	; New Lower Bound = 1 + Old Guess
			ADD			R9,R8,R7	; New Guess =
			LSR			R9,#1		; (New Lower Bound + Old Upper Bound)//2
			B fin
	
down		CMP			R0,#68 		; Check if the feedback is (D)own
			SUB			R8,R9,#1	; New Upper Bound = Old Guess - 1
			ADD			R9,R8,R7	; New Guess =
			LSR			R9,#1		; (Old Lower Bound + New Upper Bound)//2
			
fin			BX          LR 			
			ALIGN
			ENDP
			END