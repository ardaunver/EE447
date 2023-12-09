;SYMBOL		DIRECTIVE	VALUE			COMMENT
D_AMOUNT	EQU			1250			; Delay Amount
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			DCB 		0X0D
			DCB 		0X04
			EXTERN 		DELAY
            EXPORT 		__main

__main 		PROC	
			; Number is stored in memory location NUM as a key is pressed
start	 	MOV			R1,#3
			BL			DELAY
			ADD			R1,#1
			ALIGN
			ENDP
			END