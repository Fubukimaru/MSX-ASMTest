;---------------------------------------------------------
; Nombre de nuestro programa
; Hola Mundo
;
---------------------------------------------------------
; DEFINIR CONTANTES
;
---------------------------------------------------------
; no definimos ninguna constante
;
; Variables de sistema
	FORCLR equ 0F3E9h;
; Foreground colour
;
---------------------------------------------------------
; DIRECTIVAS PARA EL ENSAMBLADOR ( asMSX )
;
---------------------------------------------------------
.bios
; Definir Nombres de las llamadas a la BIOS
.page 2
; Definir la dirección del código irá en 8000h
.rom
; esto es para indicar que crearemos una ROM
.start  INICIO 
; Inicio del Código de nuestro Programa
;---------------------------------------------------------
; INICIO DEL PROGRAMA
;
---------------------------------------------------------
INICIO:
	call INIT_MODE_SC0	; iniciar el mode de pantalla
	call P_INTRO		; imprimir el mensaje en pantalla


LLOOP:
	call GET_LINE		;
	;call DO_SCROLL
	jp LLOOP		; ToDo: introduce break
FIN:
	ret

---------------------------------------------------------
; INICIALIZA EL MODO DE PANTALLA
---------------------------------------------------------
; BASIC: COLOR 15,0,0
; Establecer el fondo de color Negro
INIT_MODE_SC0:
	ld hl, FORCLR
	ld[hl],15	; Color del primer plano
	inc hl		; blanco
	ld[hl],1	; Color de fondo
	inc hl		; negro
	ld[hl],1	; Color del borde
			; negro
	call INITXT	; set SCREEN 0
	;call INIT32	; set SCREEN 1
	;call INIGRP	; set SCREEN 2
	;call INIMLT	; set SCREEN 3
	; SCREEN 0 : texto de 40 x 24 con 2 colores 
	; SCREEN 1 : texto de 32 x 24 con 16 colores 
	; SCREEN 2 : gráficos de 256 x 192 con 16 colores 
	; SCREEN 3 : gráficosde 64 x 48 con 16 colores 
ret

;---------------------------------------------------------
;---------------------------------------------------------
; RUTINA QUE IMPRIME EL TEXTO EN PANTALLA
;---------------------------------------------------------
P_INTRO:
	ld hl,0101h
	call POSIT
	ld hl, texto
	call IMPRI_MENSAJE
	ret

DO_SCROLL: 		;Basically we remove the first line.
	ld hl,0101h 
	call POSIT
	ld hl, scrolltext
	call IMPRI_MENSAJE
	ret

INIT_CURSOR:
	ld hl,0118h	; Line 24, Position 1
	call POSIT
	ret
	

IMPRI_MENSAJE:
	;ld h,01	; situamos la Columna
	;ld l,01	; y la fila para
	;ld hl,0101h	; también podemos hacerlo de esta manera
	;call POSIT 	; fijar el cursor donde empezara a escribir
	;ld hl,texto	; ponemos hl apuntando al texto del mensaje

 @@bucle:
	ld a,[hl]	; cogemos el primer  carácter y lo metemos en a
	or a		; comprobamos si hemos llegado al final del texto
	ret z		; y salimos de la rutina en el caso que el compare sea Zero
	call CHPUT	; escribimos ese carácter en la posición del cursor
	inc hl		; incrementamos hl para que apunte a la siguiente letra
	jr @@bucle	; si no hemos llegado al final continuamosescribiendo

	ret
;---------------------------------------------------------
texto:
	db 27, "E"		;Borra pantalla
	db 27, "Y", 5+32, 10+32	;Situa cursor en 5,10
	db "Esto es un ejemplo"	;Text
	db 27, "H"		;Situa cursor al principio
	db 0			;Fin de cadena 


scrolltext:
	;db 27, 'L', 0	;Insert line in cursor
	db 27, 'M', 0	;Delete line in cursor


GET_LINE:
	push af			;Save a value
	push bc
	call CHGET		;Read char

	LD b,a			;Copy into b

	;-------Case ENTER	
@@ENTER:
	XOR	0Dh		; Check if it is an enter
	JP NZ, @@TEXT
	
	call DO_SCROLL	
	call INIT_CURSOR

	JP @@END_GET_LINE	; Go to the final

	

	;-------Case Text
@@TEXT: 
	ld a,b
	call CHPUT		;Write char
	
@@END_GET_LINE:
	pop bc
	pop af		;Restore a value
	ret
