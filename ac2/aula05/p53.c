#include <detpic32.h>

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
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
	AD1CON2bits.SMPI = 4-1;//Interrupt is generated after XX samples
	// selecção do canal de entrada
	AD1CHSbits.CH0SA = 4; 	//Select input for A/D converter
	// configurações adicionais
	AD1CON1bits.ON = 1;		//Enable A/D converter (last command in configuration)
	// final da configuração
	while(1) {
		AD1CON1bits.ASAM = 1;	// start conversion
		while(IFS1bits.AD1IF == 0) {} // espera interrupção	
		int *p = (int *) (&ADC1BUF0);
		int i;
		for(i=0; i<16; i++) {
			printInt(p[i*4], 10 | 4 << 16);
			putChar(' ');
		}
		IFS1bits.AD1IF = 0; // desativa interrupção
		delay(1500);
	}
	return 0;
}
