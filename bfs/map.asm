;MAP class


MAP:
	DB	16, 16		  ;SIZE
	DB	"################"
	DB	"#      I       #"
	DB	"#              #"
	DB	"###### ## ######"
	DB	"#   ## ## ##   #"
	DB	"# # ## ## ## # #"
	DB	"# # ## ## ## # #"
	DB	"# # ## ## ## # #"
	DB	"# # ## ## ## # #"
	DB	"# # ## ## ## # #"
	DB	"# # ## ## ## # #"
	DB	"# # ## ##G## # #"
	DB	"# #    ##### # #"
	DB	"# ############ #"
	DB	"#              #"
	DB	"################"



; PRINTS THE MAP
; IN - IX Map address
MAP_RENDER:
	;INIT POSITION
	LD 	HL, #0001	; LINE 24, POSITION 1
	CALL	POSIT

	
	;LD	IX, MAP
	LD	A, (IX)		; WIDTH
	LD	D, A	
	INC	IX
	LD	C, (IX)		; HEIGHT
	LD	E, A		
	INC	IX		
	
	

	; TWO INC TO SET THEM TO THE STARTING POSITION.	
		
;Saving superior loop var.	
	LD	B, C
	;DEC	B
.LOOP_Y:
	PUSH 	BC	
	LD	B, D		; LD WIDTH	
	
.LOOP_X:
	LD	A, (IX)		;LOAD MAP POINT
	CALL	CHPUT		;PUT POINT	
	
	INC	IX		;NEXT!	
		
	DJNZ	.LOOP_X
	
;Loop part 2.
	;COMPARE WIDTH LIMIT
	POP 	BC
	
	INC 	L	;NEXT LINE
	LD	H, 0
	CALL	POSIT
	
	DJNZ	.LOOP_Y
	
	
	
	;COMPARE HEIGHT LIMIT
	
	;JP	NZ,	.LOOP_Y
.END:	
	RET
	
	
	
; COPIES ROM MAP TO RAM
MAP_COPY_ROM_TO_RAM:
	LD	BC, 258		;Change for the real size
	
	LD	HL, MAP
	LD	DE, V_MAP
	
	LDIR	
	RET
	