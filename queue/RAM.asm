;RAM VARS
	ORG		#C000	;page 2
	
QUEUE:	
	DS	256	; 256 Bytes, intialized with 0 by default
Q_FIRST: 
	DW	QUEUE	; Initial address of the queue (THIS DOES NOT WORK ON EMULATORS!)
Q_LAST:	
	DW	QUEUE	; Last add of queue


PILA0:
        DS      256
PILA:   DB	0 

