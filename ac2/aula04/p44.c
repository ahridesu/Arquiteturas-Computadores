#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

void main (void) {
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x80FF;
	TRISB =  TRISB & 0x80FF;
	// set RD5 e RD6 como saídas
	// bit a bit
	//LATDbits.LATD5 = 0;
	//LATDbits.LATD6 = 1;
	LATD = (LATD & 0xFF9F) | 0x0040; // igual ao comentado em cima
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	
	unsigned int segment;
	int i;
	while(1) {
		// displays em alternado
		LATB = LATB & 0x80FF;
		// LATDbits.LATD6 = !LATDbits.LATD6;
		// LATDbits.LATD5 = !LATDbits.LATD5;
		LATD = LATD ^ 0x0060; // tb igual ao comentado em cima
		segment = 0x0100;
		for(i = 0; i<7; i++) {
			LATB = LATB | segment;
			//delay(1000); // 1 Hz
			//delay(100); // 10 Hz
			//delay(20); // 50 Hz
			delay(10); // 100 Hz
			segment = segment << 1;
		}
	}
}
