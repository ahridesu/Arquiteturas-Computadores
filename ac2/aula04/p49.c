#include <detpic32.h>

unsigned char toBCD(unsigned char value) {
	return ((value / 10) << 4) + (value % 10);
}
void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

void blink(int s) {
	LATD = (LATD & 0xFF9F) | 0x0060;
	for(; s>0; s--) {
		LATB = LATB & 0x00FF;
		delay(500);
		LATB = LATB | 0x3F00;
		delay(500);
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
		if(value%2!=0) LATB = LATB | 0x8000;
		LATB = LATB | ((int) displays7Scodes[digit_high] << 8);
	} else {
		LATD = (LATD & 0xFF9F) | 0x0020;
		if(value%2==0) LATB = LATB | 0x8000;
		LATB = LATB | ((int) displays7Scodes[digit_low] << 8);
	}
	displayFlag = displayFlag ^ 0x01;
}
// contator com displays não merdosa
int main (void) {
	// set RB8-RB15 como saídas e set RB15
	LATB = (LATB & 0x00FF);
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0060;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	
	unsigned char val, counter = 0;
	int i;
	while(1) {
		i = 0;
		val = toBCD(counter);
		do { 	
			delay(10); // taxa refrescamento: 10ms = 100 Hz
			send2displays(val);
		} while(++i < 100); // taxa contagem: 200ms = 5 Hz
		if(++counter == 60) {
			counter = 0;
			blink(5);
		}
	}
	return 0;
}
