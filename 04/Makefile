# Flags for NASM and LD
NASMFLAGS = -f elf64 -g -F dwarf
LDFLAGS = -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

# Default target: build both part1 and part2
all: part1 part2

# Build part1 executable
part1: part1.o printnumber.o
	ld -o part1 part1.o printnumber.o $(LDFLAGS)

# Build part2 executable
part2: part2.o printnumber.o
	ld -o part2 part2.o printnumber.o $(LDFLAGS)

# Assemble part1.asm
part1.o: part1.asm
	nasm $(NASMFLAGS) part1.asm -o part1.o

# Assemble part2.asm
part2.o: part2.asm
	nasm $(NASMFLAGS) part2.asm -o part2.o

# Assemble printnumber.asm
printnumber.o: printnumber.asm
	nasm $(NASMFLAGS) printnumber.asm -o printnumber.o

# Clean up object files and executables
clean:
	rm -f part1.o part2.o printnumber.o part1 part2

