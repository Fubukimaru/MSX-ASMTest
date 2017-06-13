all: queue.rom

queue.rom: main.z80
	cp main.z80 queue.rom
main.z80: *.asm
	asmsx -z main.asm
	rm *tmppre.*
clean:
	rm *.z80 *.rom *.sym

test: queue.rom
	openmsx -cart queue.rom
