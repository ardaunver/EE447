#include "TM4C123GH6PM.h"
/*
Port B is used for Step Motor PB0,PB1,PB2,PB3 as outputs
(connect 12V to VBus, GND to GND)
Port E is used for Push Buttons PE0,PE1,PE2,PE3 as inputs
(connect VCC to +3.3V, GND to GND)
*/

/*
rotation = -1 means CW rotation (triggered with PushButton1)
rotation = 0 means idle mode (no rotation)
rotation = 1 means CCW rotation (triggered with PushButton2)
*/

int rotation = 0;

void init_func(void){
	/* Enable the clock for Port B and E */
	SYSCTL->RCGCGPIO |= 0x12; 
	/* Configure the Port B registers */
	GPIOB->DIR |= 0x0F; 
	GPIOB->DEN |= 0x0F;
	GPIOB->DATA |= 0x00;
	/* Configure the Port E registers */
	GPIOE->DIR |= 0xF0; 
	GPIOE->DEN |= 0xFF;
	GPIOE->DATA |= 0x00;

	SysTick->LOAD = 149999;
	SysTick->CTRL = 7;
	SysTick->VAL = 0;
}

/*
Change of GPIOB->DATA can be observed at
memory location of 0x400053FC.
GPIOB->DATA will be either one of the following: 1,2,4,8
Indicating the motor coils...
*/
void SysTick_Handler (void){
	if(rotation == -1){ 
			GPIOB->DATA *= 2;
	if(GPIOB->DATA == 8){
			GPIOB->DATA = 1;
			return;
	}
	}
	else if(rotation == 1){ 
			GPIOB->DATA /= 2;
			if(GPIOB->DATA == 1){
				GPIOB->DATA = 8;
				return;
			}
	}
}
/*
Change of GPIOE->DATA can be observed at
memory location of 0x400243FC.
GPIOE->DATA is 0x0F by default.
When PushButton1 is pressed, GPIOE->DATA = 0x0E.
When PushButton1 is pressed, GPIOE->DATA = 0x0D.
*/
int main(void){
	init_func();

	while(1){
		while(GPIOE->DATA == 0x0E){
			GPIOB->DATA = 1;
			rotation = -1;
		}
		while(GPIOE->DATA == 0x0D){
			GPIOB->DATA = 8;
			rotation = 1;
		}
		
	}
}
