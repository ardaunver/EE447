;SYMBOL		DIRECTIVE	VALUE			COMMENT
            AREA        main, READONLY, CODE
            THUMB
            EXPORT      DELAY				; Make available

DELAY
loop		
			NOP
			NOP
			SUB		R11,R11,#1
			CMP		R11,#0
			BEQ		return
			B 		loop

return		
			BX LR

            ALIGN
            END
