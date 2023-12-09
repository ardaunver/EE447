#include "TM4C123GH6PM.h"
#include "pulse_init.h"
#include "read_init.h"

#define		OFFSET		0x10
#define		LENGTH		0x10

extern void OutStr(char*);

// Variable Decleration and Initialization
int duty_cycle 	= 0;
int pulse_width	= 0;
int period			= 0;
int edge_count  = 0;
int edge_one  	= 0;
int edge_two  	= 0;
int edge_three	= 0;

char array[32];			

// Displays
char edge_one_display[]   	= "The Edge One: 												\r\4";				// 1st Rising
char edge_two_display[]   	= "The Edge Two:   											\r\4";			  // 1st Falling
char edge_three_display[] 	= "The Edge Three: 											\r\4";				// 2nd Rising
char line_display[] 				= "----------------------								\r\4";														// Line 
char duty_cycle_display[] 	= "The Duty Cycle(%): 									\r\4";				// Duty Cycle in %
char period_display[] 			= "The Period (microseconds): 					\r\4";				// Period in microseconds
char pulse_width_display[] 	= "The Pulse Width (microseconds): 			\r\4";				// Pulse Width in microseconds
 
int main()
{
		// Generate Pulse
		pulse_init();
		// Read Input Initialization
		read_init();

		while(1)
		{
			// Wait until an edge is detected
			while(TIMER3->RIS != 0x04);
						
				if(edge_count == 0)
					{
					// Time at which the first rising edge is detected	
					edge_one = TIMER3->TAR;
					edge_count++;
					TIMER3->ICR = 0x04;
					}
				else if(edge_count == 1)
					{
					// Time at which the first falling edge is detected
					edge_two = TIMER3->TAR;
					edge_count++;
					TIMER3->ICR = 0x04;
					}
				else if(edge_count == 2)
					{
					// Time at which the second rising edge is detected
					edge_three = TIMER3->TAR;
					edge_count++;
					}
				else if(edge_count == 3){
					// Calculations for display
					pulse_width	= (edge_two-edge_one)/16;
					duty_cycle	= 100*(edge_two-edge_one)/(edge_three-edge_one);
					period			= (edge_three-edge_one)/16;

						
					// Display Values with OUTSTR
					OutStr(duty_cycle_display);
					OutStr(ascii_string(array,duty_cycle));
						
					OutStr(period_display);
					OutStr(ascii_string(array,period));
						
					OutStr(pulse_width_display);
					OutStr(ascii_string(array,pulse_width));
						
					OutStr(line_display);
						
					OutStr(edge_one_display);
					OutStr(ascii_string(array,edge_one));
						
					OutStr(edge_two_display);
					OutStr(ascii_string(array,edge_two));
						
					OutStr(edge_three_display);
					OutStr(ascii_string(array,edge_three));	
					
					OutStr(line_display);
					
					// Clear the interrupt flag
					TIMER3->ICR = 0x04;
					
					// to run the code in an infinite loop
					// comment out "break"
					// write "edge_count = 0;"
					break;
					
				}
		}
		return 0;

}

