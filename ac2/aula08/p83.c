#include <detpic32.h>

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
	//Configurar interrupções Gerais (Mesmo vetor para as 3 fontes)
	U1STAbits.URXISEL = 0;	//Modo de interrupção (interrupção quando FILO tiver pelo menos 1 char)
	IPC6bits.U1IP   = 2;	//Prioridade
	//Configurar interrupções Recepção
	IFS0bits.U1RXIF = 0;	//Clear Flag Recepção
	IEC0bits.U1RXIE = 1; 	//Enable Recepção
	//Configurar interrupções Erros
	IFS0bits.U1EIF  = 0;	//Clear Flag Erro
	IEC0bits.U1EIE = 1;		//Enable Erros
	//Ativar modúlos de transmissão e receção
	U1STAbits.UTXEN = 1;	//Transmit enable
	U1STAbits.URXEN = 1;	//Receiver enable
	//Enable UART1
	U1MODEbits.ON = 1;

	return 0;	
}
void putc(char c) {	//só aceita chars, leitura por inteiro de FILO causa erro
	while(U1STAbits.UTXBF);
	U1TXREG = c;
}
void _int_(24) isr_uart1(void) {
	if(IFS0bits.U1EIF) {	//Erro na Recepção
		if(U1STAbits.OERR) U1STAbits.OERR = 0; //Erro Overrun
		else {
			char c = U1RXREG;	//Erro Paridade ou framing
		}
		IFS0bits.U1EIF = 0;	//Clear Flag Erro
	} else {	//Receção de 1 char
		putc( U1RXREG );
		IFS0bits.U1RXIF = 0; //Clear Flag Receção
	}
}
//recebe(por interrupção) e retorna caracter
int main(void){
	config_UART1(115200, 'N', 8, 1);
	EnableInterrupts();
	while(1);
	return 0;
}
