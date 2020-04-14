#include <detpic32.h>

int config(void) {
	T3CONbits.TCKPS = 7;//1:256 prescaler
	PR3 = 39062;		//Fout = 20MHz / (256 * (39062 + 1)) = 2Hz
	TMR3 = 0;			//Reset timer count register
	T3CONbits.TON = 1;	//Enable Timer
	return 0;
}

int main(void) {
	config();
	IFS0bits.T3IF = 0;
	while(1) {
		while(IFS0bits.T3IF == 0);
		IFS0bits.T3IF = 0;
		putChar('.');
	}
	return 0;
}
