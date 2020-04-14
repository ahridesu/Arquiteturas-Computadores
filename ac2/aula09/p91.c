#include <detpic32.h>

// funções ativação e desativação interrupções
#define DisableUart1RxInterrupt() IEC0bits.U1RXIE = 0;
#define EnableUart1RxInterrupt() IEC0bits.U1RXIE = 1;
#define DisableUart1TxInterrupt() IEC0bits.U1TXIE = 0;
#define EnableUart1TxInterrupt() IEC0bits.U1TXIE = 1;

// constantes
#define BUF_SIZE	8
#define INDEX_MASK	(BUF_SIZE - 1)

// estrutura buffer circular 
typedef struct 
{
	unsigned char data[BUF_SIZE];
	unsigned int head;
	unsigned int tail;
	unsigned int count;
} circularBuffer;

// instanciar 2 buffers
volatile circularBuffer txb;
volatile circularBuffer rxb;

// funções para instanciar buffers circulares 
void comDrv_flushRx(void) {
	rxb.head = 0;
	rxb.tail = 0;
	rxb.count = 0;
}
void comDrv_flushTx(void) {
	txb.head = 0;
	txb.tail = 0;
	txb.count = 0;
}

// escreve char no buffer de transmissão
void comDrv_putc(char ch) {
	while(txb.count == BUF_SIZE) {} // wait while buffer is full
	txb.data[txb.tail] = ch;
	txb.tail = (txb.tail + 1) & INDEX_MASK; //incremento e aplicar mask
	DisableUart1TxInterrupt();		// begin of critical section
	if(txb.count<BUF_SIZE) txb.count++;
	EnableUart1TxInterrupt();		// end critical section
}
// envia para o buffer de transmissão uma string
void comDrv_puts(char *s) {
	for(; *s!='\0'; s++) comDrv_putc(*s);
	comDrv_putc('\0');
	while(txb.count>0) {} //só sai da função quando todos os caracteres tiverem sido consumidos
}
// lê um caracter do buffer de receção
char comDrv_getc(char *pchar) {
	if(rxb.count==0) return 0;
	DisableUart1RxInterrupt();
	*pchar = rxb.data[rxb.head];
	rxb.head = (rxb.head + 1) & INDEX_MASK;
	//if(rxb.count<BUF_SIZE) rxb.count++;
	rxb.count--;
	EnableUart1RxInterrupt();
	return 1;
}
// rotina de interrupção de transmissão da UART1
void _int_(24) isr_uart1(void) {
	// caso receção
	if(IFS0bits.U1RXIF) {
		rxb.data[rxb.tail] = U1RXREG;
		rxb.tail = (rxb.tail + 1) & INDEX_MASK;
		if(rxb.count<BUF_SIZE) rxb.count++;
		 // se receber mais que consegue lidar discarda mais antigo
		else rxb.head = (rxb.head + 1) & INDEX_MASK;
		IFS0bits.U1RXIF = 0;
	}
	// caso transmissão
	if(IFS0bits.U1TXIF) {
		if(txb.count > 0) {
			U1TXREG = txb.data[txb.head];
			txb.head = (txb.head + 1) & INDEX_MASK;
			txb.count--;
		} 
		if(txb.count == 0) DisableUart1TxInterrupt();
		IFS0bits.U1TXIF = 0; //Clear Flag Recepção
	}
}
int comDrv_config(unsigned int baudrate, char parity, int databits, unsigned int stopbits) {
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
	//Configurar interrupções Transmissão
	IFS0bits.U1TXIF = 0;	//Clear Flag Recepção
	IEC0bits.U1TXIE = 1; 	//Enable Recepção
	//Configurar interrupções Erros
	//IFS0bits.U1EIF  = 0;	//Clear Flag Erro
	//IEC0bits.U1EIE = 1;		//Enable Erros
	//Ativar modúlos de transmissão e receção
	U1STAbits.UTXEN = 1;	//Transmit enable
	U1STAbits.URXEN = 1;	//Receiver enable
	//Enable UART1
	U1MODEbits.ON = 1;
	return 0;	
}
int main(void) {
	comDrv_config(115200, 'N', 8, 1);
	comDrv_flushRx();
	comDrv_flushTx();
	EnableInterrupts();
	//comDrv_puts("Teste do bloco de transmissao do device driver!...");
	comDrv_puts("PIC32 UART Device-driver\n");
	char c;
	while(1) {
		if(comDrv_getc(&c)) {
			//putChar(c)
			if(c=='S') 
				comDrv_puts("\nString de pelo menos 30 caracteres\n");
			comDrv_putc(c);
		}
	}
	return 0;
}
