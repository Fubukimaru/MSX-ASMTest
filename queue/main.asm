;SIZE OF ROM
	SIZE 32;*1024
	
	ORG	#8000 ; Code will be at position #8000 (Page 2)

;HEADER
	DB	"AB" ;ROM header
	DW	INICIO ; Code initial address
	DEFS	12
	
; Constants
FORCLR 	EQU #F3E9 ; FOREGROUND COLOUR

;BIOS routine addresses
INITXT 	EQU #006C
POSIT	EQU #00C6
CHPUT	EQU #00A2
CHGET	EQU #009F	

;LIBS
	INCLUDE "queue.asm"

;---------------------------------------------------------
INICIO:

	;Init stack
	di
	LD	SP,PILA
	ei
	
	CALL INIT_MODE_SC0	; INICIAR EL MODE DE PANTALLA
	CALL INIT_CURSOR

	LD A, 'a'

	CALL CHPUT
	CALL CHPUT
	CALL CHPUT
	CALL CHPUT
	
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


INIT_CURSOR:
	LD HL, #0118	; LINE 24, POSITION 1
	CALL POSIT
	RET




	
	
	INCLUDE "RAM.asm"	
