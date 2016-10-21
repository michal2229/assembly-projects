Org 0h
    sjmp Start
	
Org 0bh
	Ljmp Przerwanie_Timer0

Start: mov A,#10000000b
	call InitTimer
		
		
Bez_przerwy:
        mov P0,A
sjmp Bez_przerwy ; 
      
	  
	  
Przerwanie_Timer0:
        mov tl0,#0b0h
        mov th0,#03ch
        cpl A
reti; wyjście z przerwania
		
		
		
InitTimer:
        mov TMOD,#00000001b;Timer/licznik0 jako Timer
        mov tl0,#0b0h
        mov th0,#03ch
        setb ET0           ;przerwanie Timer0 
        setb EA            ;przerwanie nadrzędne 
        setb TR0           ;Start Timera0
ret ;  koniec programu   
       
