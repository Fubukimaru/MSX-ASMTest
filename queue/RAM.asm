;RAM VARS
	ORG		#A000	;page 2
	
QUEUE:	
	DS	256	; 256 Bytes, intialized with 0 by default
Q_FIRST: 
	DW	QUEUE	; Initial address of the queue
Q_LAST:	
	DW	QUEUE	; Last add of queue


PILA0:
        DS      256
PILA:   DB		0 

