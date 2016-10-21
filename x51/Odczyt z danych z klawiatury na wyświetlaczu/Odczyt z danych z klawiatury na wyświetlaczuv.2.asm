   MOV 28h, #01000000B   ; hasz
   MOV 29h, #00000000B   ; gwizadka 
   MOV 30h, #11000000B  
   MOV 31h, #11111001B   
   MOV 32h, #10100100B   
   MOV 33h, #10110000B   
   MOV 34h, #10011001B   
   MOV 35h, #10010010B   
   MOV 36h, #10000010B   
   MOV 37h, #11111000B   
   MOV 38h, #10000000B   
   MOV 39h, #10010000B
     
start:

	MOV R0, #0			

	
	SETB P0.3			
	CLR P0.0			
	CALL kol	
	JB F0, koniec		 
							
	JMP start	
mov a,r0
mov r1,a
koniec:

	JMP skan			



kol:
	JNB P0.4, przycisk
	INC R0				
	JNB P0.5, przycisk	
	INC R0				
	JNB P0.6, przycisk	
	INC R0			
	RET			
przycisk:
clr p3.4
clr p3.3 
mov A, r0
call wypisz_gwiazd
	SETB F0			
	RET				

skan:

	MOV R2, #0			

	
	SETB P0.3			
	CLR P0.0			
	CALL kol2	
	JB F0, koniec1		 
						


	SETB P0.0		
	CLR P0.1			
	CALL kol2	
	JB F0, koniec1		
						

	
	SETB P0.1			
	CLR P0.2			
	CALL kol2		
	JB F0, koniec1		
					

	
	SETB P0.2		
	CLR P0.3		
	CALL kol2		
	JB F0, koniec1		

	JMP skan	

koniec1:

	JMP $			



kol2:
	JNB P0.4, przycisk2
	INC R2				
	JNB P0.5, przycisk2	
	INC R2				
	JNB P0.6, przycisk2	
	INC R2			
	RET			
przycisk2:
clr p3.4
clr p3.3 
mov R3, r2
call wypisz0
	SETB F0			
	RET




wypisz_gwiazd:
CJNE a, #0, wypisz_hash
clr P3.1
jmp skan

wypisz_hash:
CJNE a, #2, wypisz0
clr P3.0
jmp skan

wypisz0:
CJNE R3, #1, wypisz9
mov p1, 30h
jmp czekaj


wypisz9:
CJNE R3, #3, wypisz8
mov p1, 39h
jmp czekaj

wypisz8:
CJNE R3, #4, wypisz7
mov p1, 38h
jmp czekaj

wypisz7:
CJNE R3, #5, wypisz6
mov p1, 37h
jmp czekaj

wypisz6:
CJNE R3, #6, wypisz5
mov p1, 36h
jmp czekaj

wypisz5:
CJNE R3, #7, wypisz4
mov p1, 35h
jmp czekaj

wypisz4:
CJNE R3, #8, wypisz3
mov p1, 34h
jmp czekaj

wypisz3:
CJNE R3, #9, wypisz2
mov p1, 33h
jmp czekaj

wypisz2:
CJNE R3, #10, wypisz1
mov p1, 32h
jmp czekaj

wypisz1:
CJNE R3, #11, wypisz0
mov p1, 31h
jmp czekaj

czekaj:
jmp $
