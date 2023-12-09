#include "TM4C123GH6PM.h"

// rotation = 0 means Clockwise Rotation (CW)
// rotation = 1 means CounterClockwise Rotation (CCW)

int rotation = 0;
void init_func(void){
	SYSCTL->RCGCGPIO |= 0x02; 
	GPIOB->DIR |= 0x0F; 
	GPIOB->DEN |= 0x0F;
	GPIOB->DATA |= 0x01;
	SysTick->LOAD = 150000;
	SysTick->CTRL = 7;
	SysTick->VAL = 0;
}

void SysTick_Handler (void){
	if(rotation == 0){ 
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

int main(void){
	init_func();
	int step = 0;
	while(1){
		if(step == 5000000){
			GPIOB->DATA = 1;
			rotation = 0;
		}
		else if(step == 10000000){
			GPIOB->DATA = 8;
			rotation = 1;
		}else if(step == 10000001){
			step = 0;
		}
		step += 1;
	}
}
