;---------------------
;	QUEUE
;---------------------

INIT_Q:
	PUSH HL
	LD HL, QUEUE
	LD (Q_FIRST), HL
	LD (Q_LAST), HL
	POP HL
	ret

;STORES A VALUE IN THE QUEUE
; USES:	A,HL	
; A:	VALUE TO STORE 
ENQUEUE8:
	;Input: A, byte to store
	LD HL, (Q_LAST)		;Get the pointer to the last

	;ToDO: Check queue size (overflow)
	
	LD (HL), A		;Store data
	
	INC HL			;Increase pointer
	LD (Q_LAST), HL
	
	ret

;RETRIEVES A VALUE FROM THE QUEUE
; USES:	A,HL	
; A:	VALUE TO RETRIEVE
DEQUEUE8:		
	LD HL, (Q_FIRST) 	;Get pointer to data
	;ToDo: Check if there is data. (Q_FIRST != Q_LAST)

	LD A, (HL)		;Load what is in memory
	
	INC HL			;Increase pointer
	LD (Q_FIRST), HL
	
	RET			;Data is in A


;STORES A VALUE IN THE QUEUE
; USES:	DE,HL	
; DE:	VALUE TO STORE 
ENQUEUE16:				;TODO: USE IX
	;Input: A, byte to store
	LD HL, (Q_LAST)		;Get the pointer to the last

	;ToDO: Check queue size (overflow)
	
	LD 		(HL), D		;Store data
	INC		HL			;INCREASE POINTER
	LD 		(HL), E		;Store data
	INC		HL			;INCREASE POINTER
	
	LD 		(Q_LAST), HL
	
	ret

;RETRIEVES A VALUE FROM THE QUEUE
; USES:	DE,HL	
; DE:	VALUE TO RETRIEVE
DEQUEUE16:				;TODO: USE IX
	LD		HL, (Q_FIRST) 	;Get pointer to data
	;ToDo: Check if there is data. (Q_FIRST != Q_LAST)

	LD		D, (HL)		;Load what is in memory
	INC		HL
	LD		E, (HL)		;Load what is in memory
	INC		HL			;Increase pointer
	LD		(Q_FIRST), HL
	
	RET			;Data is in DE



IS_QUEUE_EMPTY:
	;ALWAYS HL <= DE GIVEN THE MEMORY LAYOUT
	LD 	HL, (Q_FIRST)
	LD 	DE, (Q_LAST)

	OR	A		;JUST IN CASE SET CARRY 0
	
	SBC	HL, DE
	; IF NZ, QUEUE NOT EMPTY
	LD	A, 0
	JP	NZ, .END	
	LD	A, 1
.END:
	RET

TEST_QUEUE:
	CALL	INIT_Q

	;NOT EMPTY CHECK
	;LD	A, 'H'
	;CALL	ENQUEUE

	;CHECK IF QUEUE IS EMPTY
	CALL IS_QUEUE_EMPTY
	LD 	B, A	
	DJNZ	.NOT_EMPTY	;Zero if queue was empty, as it had a 1 (TRUE)

.EMPTY:
	;TEST QUEUE
	LD	A, 't'
	CALL	CHPUT

	;ENQUEUE HOLA
	LD	A, 'H'
	CALL	ENQUEUE
	LD	A, 'O'
	CALL	ENQUEUE
	LD	A, 'L'
	CALL	ENQUEUE
	LD	A, 'A'
	CALL	ENQUEUE

	;DEQUEUE AND PRINT HOLA
	CALL 	DEQUEUE
	CALL 	CHPUT
	CALL 	DEQUEUE
	CALL 	CHPUT
	CALL 	DEQUEUE
	CALL 	CHPUT
	CALL 	DEQUEUE
	CALL 	CHPUT

	;PRINT FINAL
	LD 	A, 'f'
	CALL 	CHPUT
	JP	.END
	
	;QUEUE IS NOT EMPTY. ERROR
.NOT_EMPTY:	
	LD	A, 'N'
	CALL	CHPUT
	LD	A, 'O'
	CALL	CHPUT
	LD	A, 'T'
	CALL	CHPUT
.END:
	RET
	



;.include "RAM.asm"
