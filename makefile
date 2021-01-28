.DEFAULT_GOAL = run

CC=gcc
LD=ld
TARGETFLAGS=-fno-stack-protector -mgeneral-regs-only -mno-red-zone -ffreestanding -fno-pie -m32 -nostdinc -nostdlib
CFLAGS=$(TARGETFLAGS) -Wall -Wextra -Os -std=c99
LDFLAGS=-T linker.ld  -melf_i386
SOURCES=$(shell find kernel -name *.c)
OBJECTS=$(SOURCES:.c=.o)
ASM=nasm

%.o: %.asm
	@mkdir -p bin
	@echo $@
	@$(ASM) -f elf32 $< -o bin/$(notdir $@)

%.o: %.c
	@mkdir -p bin
	@echo $@
	@$(CC) -c $(CFLAGS) $< -o bin/$(notdir $@)

bin/boot.bin: boot-sector/bootsect.asm
	@mkdir -p bin
	@echo "compile bootloader"
	@nasm -f bin boot-sector/bootsect.asm -o bin/boot.bin

bin/kernel.bin: $(OBJECTS) kernel/entry.o
	@echo "link kernel"
	@$(LD) $(addprefix bin/, $(notdir $(OBJECTS))) bin/entry.o $(LDFLAGS) -o bin/kernel.bin

clean:
	@rm bin/*.o bin/boot.bin bin/kernel.bin bin/os-image.bin

bin/os-image.bin: bin/boot.bin bin/kernel.bin
	@cat $^ > bin/os-image.bin

run: bin/os-image.bin
	qemu-system-i386 -fda bin/os-image.bin
