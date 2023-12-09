;SYMBOL		DIRECTIVE	VALUE			COMMENT
D_AMOUNT	EQU			1250			; Delay Amount
	
            AREA        main, READONLY, CODE
            THUMB
            EXPORT      DELAY				; Make available

DELAY
			LDR		R10,=D_AMOUNT
loop		PROC
			NOP
			NOP
			SUB		R10,R10,#1
			CMP		R10,#0
			BEQ		return
			B 		loop

return		
			BX LR

            ALIGN
			ENDP
            END
