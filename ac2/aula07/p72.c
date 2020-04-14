#include <detpic32.h>

int config(void) {
	//configuração do timer
	T3CONbits.TCKPS = 7;//1:256 prescaler
	PR3 = 39062;		//Fout = 20MHz / (256 * (39062 + 1)) = 2Hz
	TMR3 = 0;			//Reset timer count register
	T3CONbits.TON = 1;	//Enable Timer
	//configuração da interrupção
	IPC3bits.T3IP = 2;	//Prioridade
	IEC0bits.T3IE = 1;	//Enable Timer Interrupts
	IFS0bits.T3IF = 0;	//Reset timer interrupt flag
	return 0;
}

void _int_(12) isr_T3(void) {
	static int i=0;	
	if(i) putChar('.');
	IFS0bits.T3IF = 0;
	i=!i;
}

int main(void) {
	config();
	EnableInterrupts();
	while(1) {}
	return 0;
}
