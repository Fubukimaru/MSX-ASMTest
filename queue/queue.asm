;SIZE OF ROM
	SIZE 32

;Vars
	ORG		#E000
	
QUEUE:	
	DS	256	; 256 Bytes, intialized with 0 by default
Q_FIRST: 
	DW	QUEUE	; Initial address of the queue
Q_LAST:	
	DW	QUEUE	; Last add of queue


ORG		#8000 ; Code will be at position #8000 (Page 2)
;HEADER
	DB	"AB" ;ROM header
	DW	INICIO ; Code initial address
	DEFS	12

	
; Constants
FORCLR EQU #F3E9 ; FOREGROUND COLOUR

;BIOS routine addresses
INITXT 	EQU #006C
POSIT	EQU #00C6
CHPUT	EQU #00A2
CHGET	EQU #009F

;---------------------------------------------------------
INICIO:
	CALL INIT_MODE_SC0	; INICIAR EL MODE DE PANTALLA

	CALL TEST_QUEUE


@@LLOOP:
	XOR A
	JP @@LLOOP		; TODO: INTRODUCE BREAK
@@FIN:
	RET

;---------------------------------------------------------
; Init screen
;---------------------------------------------------------
INIT_MODE_SC0:
	LD HL, FORCLR
	LD (HL),15	; COLOR DEL PRIMER PLANO
	INC HL		; BLANCO
	LD (HL),1	; COLOR DE FONDO
	INC HL		; NEGRO
	LD (HL),1	; COLOR DEL BORDE
				; NEGRO
	CALL INITXT	; SET SCREEN 0
	RET


INIT_CURSOR:
	LD HL, #0118	; LINE 24, POSITION 1
	CALL POSIT
	RET



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

	RET
	



; JAMQUE COSAS
JOC:
        nop
        di
        .search
        ld      SP,PILA
        .SELECT 1 AT 06000h
        .SELECT 17 AT 08000h
        .SELECT 18 AT 0A000h


   .page   3       ; RAM DADES
        ;.ORG   0E000h ; Si es para 8ks, no empieza en $
____PAGE_3_RAM:
PILA0:
        ds      256
PILA:   .byte

