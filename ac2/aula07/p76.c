#include <detpic32.h>

void setPWM(unsigned int dutyCycle) {
	if(dutyCycle>=0 && dutyCycle<=100)
	OC1RS = ((PR3 + 1) * dutyCycle) / 100;
}

/*
int config_T3(void) {
	T3CONbits.TCKPS = 2;	//1:4 prescaler
	PR3 = 49999;			//Fout = 20MHz / (4 * (49999 + 1)) = 100Hz
	TMR3 = 0;				//Reset timer count register
	T3CONbits.TON = 1;		//Enable Timer
	//configuração do PWM
	OC1CONbits.OCM = 6; 	//PWM mode on OCx; fault pin disabled
	OC1CONbits.OCTSEL = 1;	//USE timer T3 as the time base for PWM generation
	OC1RS = 12500;			//TON constant; duty-cycle = 25%
	OC1CONbits.ON = 1;		//Enable OC1 module
	return 0;
}
*/
// teste "visível para 2 Hz
int config_T3(void) {
	T3CONbits.TCKPS = 7;//1:256 prescaler
	PR3 = 39062;		//Fout = 20MHz / (256 * (39062 + 1)) = 2Hz
	TMR3 = 0;			//Reset timer count register
	T3CONbits.TON = 1;	//Enable Timer
	//configuração do PWM
	OC1CONbits.OCM = 6; 	//PWM mode on OCx; fault pin disabled
	OC1CONbits.OCTSEL = 1;	//USE timer T3 as the time base for PWM generation
	OC1RS = 12500;			//TON constant; duty-cycle = 25%
	OC1CONbits.ON = 1;		//Enable OC1 module
	return 0;
}

int config_LED(void) {
	LATEbits.LATE0 = 1;
	TRISEbits.TRISE0 = 0;
	return 0;
}

//altera brilho do led para dutyCycle pretendido
int main(void) {
	config_T3();
	config_LED();
	setPWM(80);
	while(1){
		LATEbits.LATE0 = PORTDbits.RD0;	//Saida OC1 multiplexada com LATDbits.LATD0, usar PORTD
	}
	return 0;
}
