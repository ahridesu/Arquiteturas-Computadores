#include <detpic32.h>

int main (void) {
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	// bit a bit
	LATDbits.LATD5 = 1;
	LATDbits.LATD6 = 0;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	char c;
	int disp;
	while(1) {
		c = getChar();
		LATB = LATB & 0x00FF;
		if (c == '\n')
			break;
		if(c >= 'a' && c <= 'g') c = c - ' ';
		if(c >= 'A' && c <= 'G') {
			disp = 0x0100;
			// teste
			// putChar(c);
			c = c - 'A';
			disp = disp << c;
			LATB = LATB | disp;
		} else if(c == '.') {
			// teste
			// putChar(c);
			LATB = LATB | 0x8000;
		}
	}
	return 0;
}
