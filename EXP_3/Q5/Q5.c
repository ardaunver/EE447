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
int flag = 0; /* Keep this in global */

void init_func(void){
	/* Enable the clock for Port B and E */
	SYSCTL->RCGCGPIO |= 0x12; 
	/* Configure the Port B registers */
	GPIOB->DIR |= 0x0F; 
	GPIOB->DEN |= 0x0F;
	GPIOB->DATA |= 0x00; /*0x400053FC */
	/* Configure the Port E registers */
	GPIOE->DIR |= 0xF0; 
	GPIOE->DEN |= 0xFF;
	GPIOE->DATA |= 0x00; /*0x400243FC*/

	
	SysTick->CTRL = 7; /*Control and Status register at 0xE000E010*/
/* Initial value of SysTick->LOAD determines the initial speed */
	SysTick->LOAD = 150000; /*Check the speed at 0xE000E014*/	
	SysTick->VAL = 0;	/*Check the current value at 0xE000E018*/
	
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
Remark: You can also call for another function in SysTick_Handler.

void SysTick_Handler (void){
	button_pressed(rot);
}

void button_pressed(rot){
	....
	Write your code here
	....
}

*/
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
		/*PushButton1 is pressed*/
		while(GPIOE->DATA == 0x0E){
			/*Set the initial value for GPIOB_DATA*/
			GPIOB->DATA = 1;
			/*Rotate CW*/
			rotation = -1;
			__NOP();
			__NOP();
			__NOP();
		}
		/*PushButton2 is pressed*/
		while(GPIOE->DATA == 0x0D){
			/*Set the initial value for GPIOB_DATA*/
			GPIOB->DATA = 8;
			/*Rotate CCW*/
			rotation = 1;
			__NOP();
			__NOP();
			__NOP();
		}
		/*PushButton3 is pressed*/
		while(GPIOE->DATA == 0x0B){
			/*Set the flag for SPEED DOWN operation*/
			flag = -1;
		}
		/*PushButton4 is pressed*/
		while(GPIOE->DATA == 0x07){
			/*Set the flag for SPEED UP operation*/
			flag = 1;
		}
		if(flag == -1 && SysTick->LOAD > 90000){
			/*SPEED DOWN by increasing the period of the SysTick Interrupt*/
			SysTick->LOAD += 15000;
			/*Clear the flag*/
			flag = 0;
		}
		if(flag == 1 && SysTick->LOAD < 400000){
			/*SPEED UP by decreasing the period of the SysTick Interrupt*/
			SysTick->LOAD -= 15000;
			/*Clear the flag*/
			flag = 0;
		}
		if(SysTick->LOAD < 139999){
			SysTick->LOAD = 149999;
		}
		if(SysTick->LOAD > 400000){
			SysTick->LOAD = 229999;
		}
		
	}
}
