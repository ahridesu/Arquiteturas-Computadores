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
	// reset LATB
	LATB = LATB & 0x00FF;
	LATD = (LATD & 0xFF9F) | 0x0040;
	LATB = LATB | (((int) displays7Scodes[(value >> 4)]) << 8);
	delay(60);
	delay(1);
	LATD = LATD ^ 0x0060;
	LATB = (LATB & 0x00FF) | (((int) displays7Scodes[(value & 0x0F)]) << 8);
	delay(1);
}
// contator com displays merdosos (thanks guião)
int main (void) {
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0060;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	
	unsigned char c = 0;
	while(1) {
		send2displays(c++);
		delay(100); // 10 Hz
		//delay(200); // 5 Hz
	}
	return 0;
}
