#include <detpic32.h>

int config_T1(void) {
	//configuração do timer
	T1CONbits.TCKPS = 3;//1:256 prescaler
	PR1 = 39062;		//Fout = 20MHz / (256 * (39062 + 1)) = 2Hz
	TMR1 = 0;			//Reset timer count register
	T1CONbits.TON = 1;	//Enable Timer
	//configuração da interrupção
	IPC1bits.T1IP = 3;	//Prioridade
	IEC0bits.T1IE = 1;	//Enable Timer Interrupts
	IFS0bits.T1IF = 0;	//Reset timer interrupt flag
	return 0;
	//configuração do timer
}
int config_T3(void) {
	T3CONbits.TCKPS =4;//1:16 prescaler
	PR3 = 62499;		//Fout = 20MHz / (16 * (62499 + 1)) = 20Hz
	TMR3 = 0;			//Reset timer count register
	T3CONbits.TON = 1;	//Enable Timer
	//configuração da interrupção
	IPC3bits.T3IP = 2;	//Prioridade
	IEC0bits.T3IE = 1;	//Enable Timer Interrupts
	IFS0bits.T3IF = 0;	//Reset timer interrupt flag
	return 0;
}

void _int_(4) isr_T1(void) {
	putChar('1');
	IFS0bits.T1IF = 0;
}

void _int_(12) isr_T3(void) {
	putChar('3');
	IFS0bits.T3IF = 0;
}

int main(void) {
	config_T1();
	config_T3();
	EnableInterrupts();
	while(1) {}
	return 0;
}
