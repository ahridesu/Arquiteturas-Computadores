#include <detpic32.h>

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
	// final da configuração das entradas analógicas
	// configuração do Display
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0060;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	// final configuração do Display
	while(1) {
		AD1CON1bits.ASAM = 1;	// start conversion
		while(IFS1bits.AD1IF == 0) {} // espera interrupção	
		int *p = (int *) (&ADC1BUF0);
		int i, v, media = 0;
		for(i=0; i<4; i++) {
			media += p[i*4];
		}
		media = media / 4;
		v = (media*33) / 1023;
		i = 0;
		do{
			delay(10); // taxa refrescamento: 10ms = 100 Hz
			send2displays(v);
		} while(++i < 25); // 4 medições por segundo
		printInt(v, 10 | 3 << 16);
		putChar(' ');
		IFS1bits.AD1IF = 0; // desativa interrupção
	}
	return 0;
}
