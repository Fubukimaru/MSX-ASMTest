;SIZE OF ROM
	SIZE 32

;Vars
	ORG		#E000
	
QUEUE:	DS	256	; 256 Bytes, intialized with 0 by default
Q_FIRST:DW	QUEUE	; Initial address of the queue
Q_LAST:	DW	QUEUE	; Last add of queue


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

	



.LLOOP:
	JP .LLOOP		; TODO: INTRODUCE BREAK
.FIN:
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


PRINT_A:
	;IN A,(#99) ; The interruption does this.
	;XOR A
	LD A,10
	OUT (#99),A	;BYTE BAJO DIR
	LD A, 64
	OUT (#99),A	;BYTE ALTO DIR
			;VRAM DIRECCION 0H		

	LD A, 65 	;ASCII A MAYUS
	OUT (#98),A
	RET

INIT_CURSOR:
	LD HL, #0118	; LINE 24, POSITION 1
	CALL POSIT
	RET



IMPRI_MENSAJE:
.BUCLE:
	LD A,(HL)	; COGEMOS EL PRIMER  CARACTER Y LO METEMOS EN A
	OR A		; COMPROBAMOS SI HEMOS LLEGADO AL FINAL DEL TEXTO
	RET Z		; Y SALIMOS DE LA RUTINA EN EL CASO QUE EL COMPARE SEA ZERO
	CALL CHPUT	; ESCRIBIMOS ESE CARACTER EN LA POSICION DEL CURSOR
	INC HL		; INCREMENTAMOS HL PARA QUE APUNTE A LA SIGUIENTE LETRA
	JR .BUCLE	; SI NO HEMOS LLEGADO AL FINAL CONTINUAMOSESCRIBIENDO

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
	
