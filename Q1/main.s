;SYMBOL		DIRECTIVE	VALUE			COMMENT
NUMBER 		EQU 		0x00000081		
NUM		 	EQU 		0x20000400
OFFSET      EQU         0x22 
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			DCB 		0X0D
			DCB 		0X04
			EXTERN		InChar
			EXTERN		CONVRT
			EXTERN 		OutStr
            EXPORT 		__main

__main 		
			; Number is stored in memory location NUM as a key is pressed
start		LDR			R0,=0x0
			LDR			R2,=0x0 
			LDR			R4,=NUMBER
			LDR			R5,=NUM		; initialize a pointer
			BL 			InChar
			STR			R4,[R5]
			MOV 		R10,#0xA 		; Base-10
			
			BL 			CONVRT

			BL 			OutStr

done 		B 			start		; infinite loop 		   
			
			ALIGN
            END