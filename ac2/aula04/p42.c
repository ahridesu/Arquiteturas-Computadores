#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

void main(void) {
	LATE = LATE & 0xFFF0;	// set valor inicial
	TRISE = TRISE & 0xFFF0;
	while(1) {
		delay(1000);		// 1Hz
		//delay(250);		// 4Hz
		if((LATE & 0x000F) < 15) {
			LATE = LATE + 1;
		} else {
			LATE = LATE & 0xFFF0;
		}
	}
}