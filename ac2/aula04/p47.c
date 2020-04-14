#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

void send2displays(unsigned char value) {
	static const char displays7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
						0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
	static char displayFlag = 0; //static variable: doesn`t lose its value between calls to function
	int digit_low = value & 0x0F;
	int digit_high = value >> 4;
	LATB = LATB & 0x00FF;
	if(displayFlag) {
		LATD = (LATD & 0xFF9F) | 0x0040;
		LATB = LATB | ((int) displays7Scodes[digit_high] << 8);
	} else {
		LATD = (LATD & 0xFF9F) | 0x0020;
		LATB = LATB | ((int) displays7Scodes[digit_low] << 8);
	}
	displayFlag = displayFlag ^ 0x01;
}
// contator com displays menos merdosos (uso de flags e taxa de refrescamento)
int main (void) {
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0060;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	
	unsigned char counter = 0;
	int i;
	while(1) {
		i = 0;
		do {
			delay(50); // taxa refrescamento: 50ms = 20 Hz
			send2displays(counter);
		} while(++i < 4); // taxa contagem: 200ms = 5 Hz
		counter++;
	}
	return 0;
}
