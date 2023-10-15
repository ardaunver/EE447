
/* Arda Unver Question 6 */


extern void OutChar(char);
extern char InChar(void);

int main(void){
			while(1){
				char input = InChar();
				if(input != 32){
					OutChar(input);
				}
				else{
					break;
				}
		}
}