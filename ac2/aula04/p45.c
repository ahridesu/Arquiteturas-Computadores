#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}
// usar os displays para imprimir os characteres
int main (void) {
	static const char displays7Scodes[] = {0x3F, 0x06, 0x5B, 0x4F, 0x66, 0x6D, 0x7D, 0x07, 
						0x7F, 0x6F, 0x77, 0x7C, 0x39, 0x5E, 0x79, 0x71};
	// set RB0.RB3 como entradas
	TRISB =  TRISB | 0x0004;
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0020;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	int val;
	while(1) {
		// display vai a 0
		LATB = LATB & 0x00FF;
		// ler valor do dsw
		val = (PORTB & 0x000F);
		// enviar valor para displays 
		LATB = LATB | (((int) displays7Scodes[val]) << 8);
	}
	return 0;
}
