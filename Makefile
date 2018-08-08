CC = avr-gcc
LD = avr-objcopy
DU = avrdude
TARGET = main
UART = uart/uart
SPI = sdcard/mmc
PF = sdcard/pff
ASM = sdcard/asmfunc

MU = atmega328p
CPU_CK=16000000
PORT = /dev/ttyACM0
BAUD = 115200


all:
	$(CC) -Os -DF_CPU=$(CPU_CK)UL -mmcu=$(MU) -c -o $(TARGET).o $(TARGET).c
	$(CC) -Os -DF_CPU=$(CPU_CK)UL -mmcu=$(MU) -c -o $(UART).o $(UART).c
	$(CC) -Os -DF_CPU=$(CPU_CK)UL -mmcu=$(MU) -c -o $(SPI).o $(SPI).c
	$(CC) -Os -DF_CPU=$(CPU_CK)UL -mmcu=$(MU) -c -o $(PF).o $(PF).c
	$(CC)  -Os -DF_CPU=$(CPU_CK)UL -mmcu=$(MU) -c -o $(ASM).o $(ASM).S
	$(CC) -mmcu=$(MU) $(TARGET).o $(UART).o $(SPI).o $(PF).o $(ASM).o -o $(TARGET)
	$(LD) -O ihex -R .eeprom $(TARGET) $(TARGET).hex

flash:
	$(DU) -F -V -c arduino -p ATMEGA328P -P $(PORT) -b $(BAUD) -U flash:w:$(TARGET).hex
