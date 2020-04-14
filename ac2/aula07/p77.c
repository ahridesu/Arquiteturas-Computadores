#include <detpic32.h>

volatile unsigned char voltage = 0, voltageDecimal = 0;

void setPWM(unsigned int dutyCycle) {
	if(dutyCycle>=0 && dutyCycle<=100)
	OC1RS = ((PR2 + 1) * dutyCycle) / 100;
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

int config_T1(void) {
	//configuração do timer
	T1CONbits.TCKPS = 2;//1:256 prescaler
	PR1 = 19530;		//Fout = 20MHz / (256 * (19530 + 1)) = 4Hz
	TMR1 = 0;			//Reset timer count register
	T1CONbits.TON = 1;	//Enable Timer
	//configuração da interrupção
	IPC1bits.T1IP = 3;	//Prioridade
	IEC0bits.T1IE = 1;	//Enable Timer Interrupts
	IFS0bits.T1IF = 0;	//Reset timer interrupt flag
	return 0;
	//configuração do timer
}
// teste "visível para 2 Hz
int config_T2(void) {
	T2CONbits.TCKPS = 7;	//1:256 prescaler
	PR2 = 39062;			//Fout = 20MHz / (256 * (39062 + 1)) = 2Hz
	TMR2 = 0;				//Reset timer count register
	T2CONbits.TON = 1;		//Enable Timer
	//configuração do PWM
	OC1CONbits.OCM = 6; 	//PWM mode on OCx; fault pin disabled
	OC1CONbits.OCTSEL = 0;	//USE timer T2 as the time base for PWM generation
	OC1RS = 12500;			//TON constant; duty-cycle = 25%
	OC1CONbits.ON = 1;		//Enable OC1 module
	return 0;
}
int config_T3(void) {
	T3CONbits.TCKPS =2;//1:4 prescaler
	PR3 = 49999;		//Fout = 20MHz / (4 * (49999 + 1)) = 20Hz
	TMR3 = 0;			//Reset timer count register
	T3CONbits.TON = 1;	//Enable Timer
	//configuração da interrupção
	IPC3bits.T3IP = 2;	//Prioridade
	IEC0bits.T3IE = 1;	//Enable Timer Interrupts
	IFS0bits.T3IF = 0;	//Reset timer interrupt flag
	return 0;
}
int config_ADC(void) {
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
	return 0;
}
int config_Displays() {
	// configuração do Display
	// set RB8-RB15 como saídas 
	LATB = LATB & 0x00FF;
	TRISB =  TRISB & 0x00FF;
	// set RD5 e RD6 como saídas
	LATD = (LATD & 0xFF9F) | 0x0060;
	TRISDbits.TRISD5 = 0;
	TRISDbits.TRISD6 = 0;
	return 0;
}
int config_DS() {
	TRISB = (TRISB & 0xFFFC) | 0x0003;	//set RB0 e RB1 como entradas
	return 0;
}
int config_LED(void) {
	LATEbits.LATE0 = 1;
	TRISEbits.TRISE0 = 0;
	return 0; 
}
void _int_(4) isr_T1(void) {
	AD1CON1bits.ASAM = 1;	//start conversion
	IFS0bits.T1IF = 0;
}

void _int_(12) isr_T3(void) {
	send2displays(voltageDecimal);
	IFS0bits.T3IF = 0;
}

void _int_(27) isr_adc(void) {
	int *p = (int *) (&ADC1BUF0);
	int i, v, media = 0;
	for(i=0; i<8; i++) {	//Calculate buffer average(8 samples)
		media += p[i*4];
	}
	media = media / 8;
	v = (media*33+511) / 1023;	//Calculate voltage amplitude (aproximação)
	//Convert voltage amplitude to decimal
	int inteira = v / 10; 
	int decimal = v % 10;
	voltageDecimal = (inteira & 0x000F) << 4 | (decimal & 0x000F);
	voltage = v;
	IFS1bits.AD1IF = 0;		//Reset AD1IF flag
}

// Envia valores de acd para displays por interrupção
// Usa Timers, para conversão com combinação "10" do DS
int main(void) {
	config_T1();
	config_T2();
	config_T3();
	config_ADC();
	config_DS();
	config_LED();
	config_Displays();
	EnableInterrupts();
	int portVal, dutyCycle;
	while(1) {
		LATEbits.LATE0 = PORTDbits.RD0;
		portVal = PORTB & 0x0003;
		switch(portVal) {
			case 0:
				IEC0bits.T1IE = 1;
				setPWM(0);
				break;
			case 1:
				IEC0bits.T1IE = 0;
				setPWM(100);
				break;
			default:
				IEC0bits.T1IE = 1;
				dutyCycle = voltage * 3;
				setPWM(dutyCycle);
				break;
		}
	}
	return 0;
}
