all: bfs.rom

bfs.rom: main.z80
	cp main.z80 bfs.rom
main.z80: *.asm
	asmsx -z main.asm
	rm *tmppre.*
clean:
	rm *.z80 *.rom *.sym

test: bfs.rom
	openmsx -cart bfs.rom
