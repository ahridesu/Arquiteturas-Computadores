// i2c.h
#ifndef _EEPROM_H
#define _EEPROM_H

#define WRITE 		 0x02
#define RDSR 		 0x05
#define READ 		 0x03
#define WRSR 		 0x01
#define WRDI 		 0x04
#define WREN 		 0x06
#define EEPROM_CLOCK 500000

void spi2_init(void);
void spi2_setClock(unsigned int clock_freq);
char eeprom_readStatus(void);
void eeprom_writeStatusCommand(char command);
void eeprom_writeData(int address, char value);
char eeprom_readData(int address);

#endif
