#include <detpic32.h>
#include "i2c.h"

void delay(int ms) {
	int k = FREQ/2000;
	for(; ms>0; ms--) {
		resetCoreTimer();
		while(readCoreTimer() < k);
	}
}
int getTemperature(int *temperature) {
	int ack;
	// Send Start event
	i2c1_start();
	// Send Address + WR (ADDR_WR); copy return value to "ack" variable
	ack = i2c1_send(ADDR_WR);
	// Send Command (RTR); add return value to "ack" variable
	ack = ack + i2c1_send(RTR);
	// Send Start event (again)
	i2c1_start();
	// Send Address + RD (ADDR_RD); add return value to "ack" variable
	ack =  ack + i2c1_send(ADDR_RD);
	// Receive a value from slave (send NACK as argument); copy
	// received value to "temperature" variable
	*temperature = i2c1_receive(I2C_NACK);
	// Send Stop event
	i2c1_stop();
	return ack;
}
int main(void) {
	int ack, temperature;
	i2c1_init(TC47_CLK_FREQ);
	while(1) {
	ack = getTemperature(&temperature);
	// Test "ack" variable; if "ack" != 0 then an error has occurred;
	if(ack != 0) {
		// send the Stop event, print an error message and exit loop
		i2c1_stop();
		printStr("Erro: ");
		printInt10(ack);
		putChar('\n');
		break;
	}
	// Print "temperature" variable (syscall printInt10)
	printStr("Temperature = ");
	printInt10(temperature);
	printStr("\n");
	delay(250);
	}
	return 0;
}
