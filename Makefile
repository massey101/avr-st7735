AVRMCU ?= atmega8
F_CPU ?= 16000000
ISPPORT ?= /dev/kaboard

VERSION = 0.1

HEADERS = spi.h st7735.h st7735initcmds.h
SRC = main.c spi.c st7735.c
TARGET = st7735_test
OBJDIR = bin

CC = avr-gcc
OBJCOPY = avr-objcopy
OBJDUMP = avr-objdump
SIZE = avr-size

SRC_TMP = $(subst ../,,$(SRC))
OBJ = $(SRC_TMP:%.c=$(OBJDIR)/$(AVRMCU)/%.o)

CFLAGS = -I ../sss7core/ -Os -Wall -Wstrict-prototypes
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -fshort-enums -fpack-struct -funsigned-char -funsigned-bitfields
CFLAGS += -mmcu=$(AVRMCU) -DF_CPU=$(F_CPU)UL -DVERSION=$(VERSION)

LDFLAGS = -mmcu=$(AVRMCU) -Wl,--gc-sections

all: start $(OBJDIR)/$(AVRMCU)/$(TARGET).hex size
	@echo ":: Done !"

start:
	@echo "ST7735 for AVR $(VERSION)"
	@echo "=========================="
	@echo ":: Building for $(AVRMCU)"
	@echo ":: MCU operating frequency is $(F_CPU)Hz"

$(OBJDIR)/$(AVRMCU)/%.o : %.c $(HEADERS) Makefile
	@mkdir -p $$(dirname $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJDIR)/$(AVRMCU)/$(TARGET).elf : $(OBJ)
	$(CC) $(LDFLAGS) $+ -o $@

$(OBJDIR)/$(AVRMCU)/$(TARGET).hex : $(OBJDIR)/$(AVRMCU)/$(TARGET).elf
	$(OBJCOPY) -O ihex $< $@

size : $(OBJDIR)/$(AVRMCU)/$(TARGET).elf
	@echo
	@$(SIZE) --mcu=$(AVRMCU) -C $(OBJDIR)/$(AVRMCU)/$(TARGET).elf
	@echo

clean :
	@rm -rf $(OBJDIR)

flash : all
	avrdude -c arduino \
		-p $(AVRMCU) -P $(ISPPORT) \
        -U flash:w:$(OBJDIR)/$(AVRMCU)/$(TARGET).hex

test : flash
	screen $(ISPPORT) 38400
