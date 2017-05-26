;HEADER
	DB "AB" ;ROM header
	DW INICIO ; Code initial address

INICIO:
	XOR A
	XOR A
	XOR A
	RET
