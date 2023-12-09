;SYMBOL		DIRECTIVE	VALUE			COMMENT
            AREA        main, READONLY, CODE
            THUMB
            EXPORT      SEARCH				; Make available

;		    colE  colD  colB  col7
;			----  ----  ----  ----
;	rowE |   K1    K2    K3    K4
;	rowD |   K5    K6    K7    K8
;	rowB |   K9    K10   K11  K12
;	row7 |   K13   K14   K15  K16


;		    colE  colD  colB  col7
;			----  ----  ----  ----
;	rowE |  [EE]  [DE]  [BE]  [7E]
;	rowD |  [ED]  [DD]  [BD]  [7D]
;	rowB |  [EB]  [DB]  [BB]  [7B]
;	row7 |  [E7]  [D7]  [B7]  [77]
;			
;	"SEARCH" subroutine prepares R0 for the final stage		
;	After determining which button is pressed, 
;	R0 is loaded with the ASCII version of the ID
;	ex. If K2 is pressed, R4 has 0xDE, the ID is "1"
;	ASCII (char) equivalent of "1" corresponds to 49 in decimal
;	ex. If K13 is pressed, R4 has 0xE7, the ID is "C"
;	ASCII (char) equivalent of "C" corresponds to 67 in decimal


SEARCH		PROC
start		CMP 	R3,#0xEE 		; K1 is pressed
			MOVEQ	R0,#48			; ASCII (char) equivalent of "0" corresponds to 48 in decimal
			BEQ 	return

			CMP 	R3,#0xDE		; K2 is pressed
			MOVEQ	R0,#49			; ASCII (char) equivalent of "1" corresponds to 49 in decimal
			BEQ 	return

			CMP 	R3,#0xBE		; K3 is pressed
			MOVEQ	R0,#50			; ASCII (char) equivalent of "2" corresponds to 50 in decimal
			BEQ 	return

			CMP 	R3,#0x7E		; K4 is pressed
			MOVEQ	R0,#51			; ASCII (char) equivalent of "3" corresponds to 51 in decimal
			BEQ 	return

			CMP 	R3,#0xED		; K5 is pressed
			MOVEQ	R0,#52			; ASCII (char) equivalent of "4" corresponds to 52 in decimal
			BEQ 	return

			CMP 	R3,#0xDD		; K6 is pressed
			MOVEQ	R0,#53			; ASCII (char) equivalent of "5" corresponds to 53 in decimal
			BEQ 	return

			CMP 	R3,#0xBD		; K7 is pressed
			MOVEQ	R0,#54			; ASCII (char) equivalent of "6" corresponds to 54 in decimal
			BEQ 	return

			CMP 	R3,#0x7D		; K8 is pressed
			MOVEQ	R0,#55			; ASCII (char) equivalent of "7" corresponds to 55 in decimal
			BEQ 	return

			CMP 	R3,#0xEB		; K9 is pressed
			MOVEQ	R0,#56			; ASCII (char) equivalent of "8" corresponds to 56 in decimal
			BEQ 	return

			CMP 	R3,#0xDB		; K10 is pressed
			MOVEQ	R0,#57			; ASCII (char) equivalent of "9" corresponds to 57 in decimal
			BEQ 	return

			CMP 	R3,#0xBB		; K11 is pressed
			MOVEQ	R0,#65			; ASCII (char) equivalent of "A" corresponds to 65 in decimal
			BEQ 	return

			CMP 	R3,#0x7B		; K12 is pressed
			MOVEQ	R0,#66			; ASCII (char) equivalent of "B" corresponds to 66 in decimal
			BEQ 	return

			CMP 	R3,#0xE7		; K13 is pressed
			MOVEQ	R0,#67			; ASCII (char) equivalent of "C" corresponds to 67 in decimal
			BEQ 	return

			CMP 	R3,#0xD7		; K14 is pressed
			MOVEQ	R0,#68			; ASCII (char) equivalent of "D" corresponds to 68 in decimal
			BEQ 	return

			CMP 	R3,#0xB7		; K15 is pressed
			MOVEQ	R0,#69			; ASCII (char) equivalent of "E" corresponds to 69 in decimal
			BEQ 	return
			
			CMP 	R3,#0x77		; K16 is pressed
			MOVEQ	R0,#70			; ASCII (char) equivalent of "F" corresponds to 70 in decimal
			
return		ENDP
			BX		LR