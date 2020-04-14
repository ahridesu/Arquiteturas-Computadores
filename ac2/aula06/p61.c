#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}

//Interrupt Handler (VECTOR = ADC1 Convert Done = 27)
void _int_(27) isr_adc(void) {
	printInt(ADC1BUF0, 16 | 3 << 16);
	putChar('\n');
	delay(1500);
	AD1CON1bits.ASAM = 1;	//start conversion
	IFS1bits.AD1IF = 0;		//Reset AD1IF flag
}

int main(void) {
	// configuração das entradas analógicas
	TRISBbits.TRISB4 = 1;	// RBx digital output disconnected
	AD1PCFGbits.PCFG4 = 0;	// RBx configured as analog input (AN4) 
	// configurações adicionais
	AD1CON1bits.SSRC = 7;	// Conversion trigger selection bits: in this mode an internal counter ends sampling and starts conversion
	AD1CON1bits.CLRASAM = 1;//Stop conversions when the 1st A/D converter interrupt is generated. At the same time, hardware clears the ASAM bit
	AD1CON3bits.SAMC = 16;	//Sample time is 16 TAD (TAD = 100ns)
	// configuração do número de conversões consecutivas
	AD1CON2bits.SMPI = 1-1;//Interrupt is generated after XX samples
	// selecção do canal de entrada
	AD1CHSbits.CH0SA = 4; 	//Select input for A/D converter
	// configurações adicionais
	AD1CON1bits.ON = 1;		//Enable A/D converter (last command in configuration)
	// final da configuração A/D
	// configuração sistema de interrupções
	IPC6bits.AD1IP = 2;		//Configurar prioridade das interrupções A/D
	IFS1bits.AD1IF = 0;		//"limpar" alguma interrupção pendente
	IEC1bits.AD1IE = 1;		//Enable A/D interrupts
	// final da configuração das interrupções
	EnableInterrupts();		//Global Interrupt Enable
	AD1CON1bits.ASAM = 1;	//start conversion
	while(1) {} 			//toda a actividade feita pelo ISR
	return 0;
}
