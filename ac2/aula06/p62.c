#include <detpic32.h>

volatile unsigned char voltage = 0;

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
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
		LATB = LATB | ((int) displays7Scodes[digit_high] << 8);
	} else {
		LATD = (LATD & 0xFF9F) | 0x0020;
		LATB = LATB | ((int) displays7Scodes[digit_low] << 8);
	}
	displayFlag = displayFlag ^ 0x01;
}

//Interrupt Handler (VECTOR = ADC1 Convert Done = 27)
void _int_(27) isr_adc(void) {
	int *p = (int *) (&ADC1BUF0);
	int i, v, media = 0;
	for(i=0; i<8; i++) {	//Calculate buffer average(8 samples)
		media += p[i*4];
	}
	media = media / 8;
	v = (media*33+511) / 1023;	//Calculate voltage amplitude
	//Convert voltage amplitude to decimal
	int inteira = v / 10; 
	int decimal = v % 10;
	voltage = (inteira & 0x000F) << 4 | (decimal & 0x000F);
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
	AD1CON2bits.SMPI = 8-1;//Interrupt is generated after XX samples
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
	// configuração do Display
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0060;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	// final configuração do Display
	EnableInterrupts();		//Global Interrupt Enable
	
	unsigned int cnt = 0;
	while(1) {
		if(cnt == 25) { //250 ms (4 samples/segundo)
			AD1CON1bits.ASAM = 1;	//start conversion
			cnt = 0;
		}
		send2displays(voltage);
		cnt++;
		delay(10);			//100 Hz
	} 		
	return 0;
}
