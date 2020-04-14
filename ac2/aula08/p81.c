#include <detpic32.h>

void delay(int ms) {
	int k = FREQ / 2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}
int config_LED(void) {
	LATEbits.LATE0 = 0;
	TRISEbits.TRISE0 = 0;
	return 0;
}
int config_UART1(unsigned int baudrate, char parity, int databits, unsigned int stopbits) {
	//configurar gerador baudrate
	U1MODEbits.BRGH = 0;	//fator divisão 16
	if(baudrate >= 600 && baudrate <= 115200) U1BRG =  ((PBCLK + 8 * baudrate) / (16 * baudrate)) - 1;	//Registo 16 bits do gerador de baudrate
	else U1BRG =  ((PBCLK + 8 * 115200) / (16 * 115200)) - 1;
	//configurar parâmetros de trama
	if(databits == 9)      U1MODEbits.PDSEL = 3;	//9 bits data, sem paridade
	else if(parity == 'E') U1MODEbits.PDSEL = 1;	//8 bits data, paridade par
	else if(parity == 'O') U1MODEbits.PDSEL = 2;	//8 bits data, paridade impar
	else 				   U1MODEbits.PDSEL = 0;	//8 bits data, sem paridade
	
	if(stopbits>0 && stopbits<3) U1MODEbits.STSEL = stopbits-1;
	else U1MODEbits.STSEL = 0;

	//Ativar modúlos de transmissão e receção
	U1STAbits.UTXEN = 1;	//Transmit enable
	U1STAbits.URXEN = 1;	//Receiver enable
	//Enable UART1
	U1MODEbits.ON = 1;	
	return 0;	
}
void putc(char *str) {
	for(; *str!='\0'; str++) {
		while(U1STAbits.UTXBF){}
		U1TXREG = *str;
	}
}
//envia string, led aceso durante envio string
int main(void){
	config_LED();
	config_UART1(115200, 'N', 8, 1);
	//config_UART1(600, 'N', 8, 1);
	//config_UART1(1200, 'O', 8, 2);
	//config_UART1(9600, 'E', 8, 1);
	//config_UART1(19200, 'N', 8, 2);
	//config_UART1(115200, 'E', 8, 1);
	while(1) {
		while(!U1STAbits.TRMT) {}	//garante FILO e transmit shift vazio
		LATEbits.LATE0 = 1;
		putc("String de teste\n");
		LATEbits.LATE0 = 0;
		delay(1000);
	}
	return 0;
}
