#include "TM4C123GH6PM.h"
void read_init(void);
void	delay(void);
char *ascii_string(char* arr, int num); 

void read_init(void){
	
	// Timer3 is used. Pin Mux / Pin Assignment is PB2 !!!
	
	// Enable Clock for GPIOB
	SYSCTL->RCGCGPIO 	|= 	(1 << 1);
	// Enable TIMER3
	SYSCTL->RCGCTIMER |= 	(1 << 3); 
	
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	
	// Set PB2 as input
	GPIOB->DIR				&= 	0x4; 
	// Enable Digital for PB2
	GPIOB->DEN				|=  0x4; 
	// Enable AFSEL for PB2
	GPIOB->AFSEL			|=  0x4; 
	// Clear and Set Alternate Function to 7
	GPIOB->PCTL				&=  ~(0x00000F00); 
	GPIOB->PCTL				|=   (0x00000700); 
	
	// Set CTL to 0 to prevent it running unintentionally
	TIMER3->CTL			 	|=		0x0; 
	// Set CFG to 0x4 to enable 16-bit Mode
	TIMER3->CFG			 	|=		0x4;  
	// For Timer A Mode Register
	// TAMR [1:0] : 11 	(Capture Mode)
	// TACMR [2] 	: 1 	(Edge Time Mode) ??
	// TACDIR [4] : 1 	(Count Up)
	TIMER3->TAILR 		|= 	0xFFFF;
	// Clear the TATORIS bit in RIS
	TIMER3->ICR      	|= 	0x1; 	
	// Set TASTALL [1] to make Timer A freeze counting when the processor is halted by the debugger
	// Set TAEVENT[3:2] to 3 --> Edge Detection : Both Edges 
	TIMER3->TAMR		 	|=		0x17; 
	// TAILR specifies the upper bound for count up
	TIMER3->CTL 	   	|= 	0xE; 
	// Set TAEN [0] to enable the Timer
	TIMER3->CTL	    	|= 	0x1; 
	
	return;
}

// ascii_string converts an integer number to a char array
char *ascii_string(char* arr, int num) 
{
    int idx1 = 0;
		int idx2 = 0;
    int digit = 1;
    int temp_num = num;

		// Array Initialization
		while(idx1<32)
		{
			arr[idx1++] = 0;
		}
		
		// Get the digit number
    while (temp_num/10 != 0)
		{
				temp_num /= 10;
				digit *= 10;
		}
		
		// Convert each digit to ASCII
		while (digit > 0) 
		{
        arr[idx2++] = num / digit + 48;
        num %= digit;
        digit /= 10;
    }
		// Preperation for display
    arr[idx2++]   = '\r';
    arr[idx2++] 	= '\4';
		arr[idx2] 		= '\n';
		
    return arr;
}

void	delay(void){
	
	int i;
	
	for(i = 0; i < 100000; i++){
			__ASM("NOP");
			__ASM("NOP");
			__ASM("NOP");
			__ASM("NOP");
	}


}