#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

void main(void) {
	LATEbits.LATE0 = 0;		// set valor inicial
	TRISEbits.TRISE0 = 0;
	while(1) {
		delay(1000);		// 1Hz
		LATEbits.LATE0 = !LATEbits.LATE0;
	}
}

