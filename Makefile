TOOLCHAIN_PREFIX ?=
CC = $(TOOLCHAIN_PREFIX)gcc
AR = $(TOOLCHAIN_PREFIX)ar
OBJCOPY = $(TOOLCHAIN_PREFIX)objcopy

CFLAGS=-DKASLR -DNO_SYMTAB -DDO_NOT_REMAP_RWX
CFLAGS += -march=btver2 -masm=intel -std=gnu11 -ffreestanding -fno-common \
	-fPIE -pie -fno-stack-protector -fomit-frame-pointer -nostdlib -nostdinc \
	-fno-asynchronous-unwind-tables \
	-Os -Wall -Werror -Wl,--no-dynamic-linker,--build-id=none,-T,kexec.ld,--nmagic \
	-mcmodel=small -mno-red-zone -m64

SOURCES := kernel.c kexec.c linux_boot.c linux_thunk.S uart.c firmware.c \
	acpi.c crc32.c

PS4_VERSIONS := PS4_3_55 PS4_3_70 PS4_4_00 PS4_4_05 PS4_4_55 PS4_5_01 PS4_5_05 PS4_6_72 PS4_9_00 PS4_9_03 PS4_11_00

all:
	for version in $(PS4_VERSIONS); do \
		make $$version; \
	done

$(PS4_VERSIONS):
	mkdir -p $@
	$(MAKE) OBJ_DIR=$@ CFLAGS="$(CFLAGS) -D$@" clean build

build: OBJS
	$(AR) -rc $(OBJ_DIR)/libkexec.a $(OBJS)
	$(CC) $(CFLAGS) -o $(OBJ_DIR)/kexec.elf $(OBJ_DIR)/libkexec.a
	$(OBJCOPY) -O binary $(OBJ_DIR)/kexec.elf $(OBJ_DIR)/kexec.bin

OBJS: $(patsubst %.S,%.o,$(patsubst %.c,%.o,$(SOURCES)))

%.o: %.c *.h
	$(CC) -c $(CFLAGS) -o $(OBJ_DIR)/$@ $<

%.o: %.S
	$(CC) -c $(CFLAGS) -o $(OBJ_DIR)/$@ $<

clean:
	rm -f $(OBJ_DIR)/libkexec.a $(OBJ_DIR)/kexec.elf $(OBJ_DIR)/kexec.bin $(addprefix $(OBJ_DIR)/, $(OBJS))

.PHONY: all clean $(PS4_VERSIONS) build