#include <detpic32.h>

#define WRITE 		 0x02
#define RDSR 		 0x05
#define READ 		 0x03
#define WRSR 		 0x01
#define WRDI 		 0x04
#define WREN 		 0x06
#define EEPROM_CLOCK 500000

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

void spi2_setClock(unsigned int clock_freq) {
	// Write SPI2BRG register
	SPI2BRG = (PBCLK + clock_freq) / (2 * clock_freq) - 1;
}

void spi2_init(void) {
	volatile char trash;
	// Disable SPI2 module
	SPI2CONbits.ON = 0;
	// Configure clock idle state as logic level 0
	SPI2CONbits.CKP = 0;
	// Configure the clock active transition: from active 
	// 	state to idle state (1 > 0)
	SPI2CONbits.CKE = 1;
	// Configure SPI data input sample phase bit (middle of data output time)
	SPI2CONbits.SMP = 0;
	// Configure word length (8 bits)
	SPI2CONbits.MODE32 = 0;
	SPI2CONbits.MODE16 = 0;
	// Enable Enhanced buffer mode (this allows the usage of FIFOs RX, TX)
	SPI2CONbits.ENHBUF = 1;
	// Enable slave select support (Master Mode Slave Select)
	SPI2CONbits.MSSEN = 1;
	// Enable master mode
	SPI2CONbits.MSTEN = 1;
	// Clear RX FIFO:
	while(SPI2STATbits.SPIRBE == 0) // while RX FIFO not empty read
		trash = SPI2BUF;			// FIFO (discard data)
	// Clear overflow error flag
	SPI2STATbits.SPIROV = 0;
	// Enable SPI2 module
	SPI2CONbits.ON = 1;
}

char eeprom_readStatus(void) {
	volatile char trash;
	// Clear RX FIFO (discard all data in the reception FIFO)
	while(SPI2STATbits.SPIRBE == 0) // while RX FIFO not empty read
		trash = SPI2BUF;			// FIFO (discard data)
	// Clear overflow error flag bit
	SPI2STATbits.SPIROV = 0;
	SPI2BUF = RDSR;	// Send RDSR command
	SPI2BUF = 0;	// Send anything so that EEPROM clocks data int SO
	while(SPI2STATbits.SPIBUSY);	// wait while SPI module is working
	trash = SPI2BUF;// First char received is garbage (receive while sending command)
	return SPI2BUF;	// Second received character is the STATUS value
}

void eeprom_writeStatusCommand(char command) {
	while( eeprom_readStatus() & 0x01 );	// wait while WIP is true
											// (write in process)
	// Copy "command" value to SPI2BUF (TX FIFO)
	SPI2BUF = command;
	// Wait while SPI module is working (SPIBUSY set)
	while(SPI2STATbits.SPIBUSY);
}

void eeprom_writeData(int address, char value) {
	// Apply a mask to limit address to 9 bits
	address = address & 0x1FF;
	// Read STATUS and wait while WIP is true (write in process)
	while( eeprom_readStatus() & 0x01 );
	// Enable write operations (activate WEL bit in STATUS register, 
	// using eeprom_writeStatusCommand() function )
	eeprom_writeStatusCommand(WREN);
	// Copy WRITE Command and A8 address bit to the TX FIFO:
	SPI2BUF = WRITE | ((address & 0x100) >> 5);
	// Copy address (8 LSbits) to the TX FIFO
	SPI2BUF = address & 0x0FF;
	// Copy "value" to the TX FIFO
	SPI2BUF = value;
	// Wait while SPI module is working (SPIBUSY)
	while(SPI2STATbits.SPIBUSY);
}

char eeprom_readData(int address) {
	volatile char trash;
	// Clear RX FIFO
	while(SPI2STATbits.SPIRBE == 0)
		trash = SPI2BUF;
	// Clear overflow error flag bit
	SPI2STATbits.SPIROV = 0;
	// Apply a mask to limit address to 9 bits
	address = address & 0x1FF;
	// Read STATUS and wait while WIP is true (write is progress)
	while( eeprom_readStatus() & 0x01 );
	// Copy READ command and A8 address bit to the TX FIFO
	SPI2BUF = READ | ((address & 0x100) >> 5);
	// Copy address (8 LSbits) to the TX FIFO
	SPI2BUF = address & 0x0FF;
	// Copy any value (e.g. 0x00) to the TX FIFO
	SPI2BUF = 0x00;
	// Wait while SPI module is working (SPIBUSY)
	while(SPI2STATbits.SPIBUSY);
	// Read and discard 2 characters from RX FIFO
	trash = SPI2BUF; trash = SPI2BUF;
	// Read RX FIFO and return the corresponding value
	return SPI2BUF;
}

int main(void) {
	spi2_init();
	spi2_setClock(EEPROM_CLOCK);
	//eeprom_writeStatusCommand(WREN);	// Activate write operations
	char value, addr, command;
	int i;
	for(;;) {
		//command = getChar();
		printStr("S - Read Status\n");
		printStr("W - Write Address\n");
		printStr("R - Read  Address\n");
		command = getChar();
		putChar(command);
		putChar('\n');
		switch(command) {
			case 'S': 	
						printInt(eeprom_readStatus(), 2 | 4 << 16);
						putChar('\n');
						break;
			case 'W':
						printStr("Address: ");
						addr = readInt10();
						putChar('\n');
						printStr("Value: ");
						value = readInt10();
						for(i=0; i<=16; i++)
							eeprom_writeData(addr+i, value);
						putChar('\n');
						break;
			case 'R':	
						printStr("Address: ");
						addr = readInt10();
						putChar('\n');
						printStr("Value: ");
						for(i=0; i<16; i++) {
							printInt10(eeprom_readData(addr+i));
							printStr(", ");
						}
						printInt10(eeprom_readData(addr+16));
						putChar('\n');
						break;
		}
		delay(250);
		putChar('\n');
	}
	return 0;
}
