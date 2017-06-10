;---------------------
;	QUEUE
;---------------------


ENQUEUE:
	PUSH HL			;Save state

	;Input: A, byte to store
	LD HL, (Q_LAST)		;Get the pointer to the last

	;ToDO: Check queue size (overflow)
	
	LD (HL), A		;Store data
	
	INC HL			;Increase pointer
	LD (Q_LAST), HL
	
	POP HL			;Restoring state
	ret


DEQUEUE:
	PUSH HL			;Save state
	
	LD HL, (Q_FIRST) 	;Get pointer to data
	;ToDo: Check if there is data. (Q_FIRST != Q_LAST)

	LD A, (HL)		;Load what is in memory
	
	INC HL			;Increase pointer
	LD (Q_FIRST), HL

	POP HL
	RET			;Data is in A
	

TEST_QUEUE:
	LD A, 'H'
	CALL ENQUEUE
	LD A, 'O'
	CALL ENQUEUE
	LD A, 'L'
	CALL ENQUEUE
	LD A, 'A'
	CALL ENQUEUE

	CALL DEQUEUE
	CALL CHPUT
	CALL DEQUEUE
	CALL CHPUT
	CALL DEQUEUE
	CALL CHPUT
	CALL DEQUEUE
	CALL CHPUT

	RET
	



;.include "RAM.asm"
