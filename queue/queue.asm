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

	
	CALL INIT_MEMORY	;
	
	
	CALL QUEUE		;
	CALL QUEUE		;
	CALL QUEUE		;

	CALL DEQUEUE
	CALL PRINT
	



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


QUEUE:
	;Input: A, byte to store
	PUSH	BC
	PUSH	HL
	LD BC, (BUFF_I)
	LD HL, BUFF
	ADD HL, BC
	
	LD (HL), A
	INC HL
	LD (HL), 61
	INC HL
	LD (HL), 62
	;INC (BUFF_I) ; Increment the pointer
	
	POP	HL
	POP	BC	
	ret
