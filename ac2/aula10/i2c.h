// i2c.h
#ifndef _I2C_H
#define _I2C_H

// Declare symbols here (READ, WRITE, ...)
#define I2C_READ		1
#define I2C_WRITE		0
#define I2C_ACK			0
#define I2C_NACK		1

#define SENS_ADDRESS	0x4D	//device dependent
#define ADDR_WR			((SENS_ADDRESS << 1) | I2C_WRITE)
#define ADDR_RD			((SENS_ADDRESS << 1) | I2C_READ)
#define TC47_CLK_FREQ	100000	// 100 KHz
#define RTR				0		// Read temperature command

//iniciação do módulo I2C
void i2c1_init(unsigned int clock) ;
//função geração evento start
void i2c1_start(void) ;
//função geração evento stop
void i2c1_stop(void) ;
//função transmitir um byte 
int i2c1_send(unsigned char value) ;
//função receber um byte
char i2c1_receive(char ack_bit) ;

#endif
