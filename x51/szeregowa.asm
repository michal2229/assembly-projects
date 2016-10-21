; program odczytujacy napiecie z przetwornika ADC 
; i przesylajacy wartosc tego napiecia szeregowo pinem p1.0
; posiadajacy synchronizacje zegarowa pinem p1.1 wspomagajaca synchronizacje odczytu
; inny uklad moze czytac bit reagujac na zbocze narastajace lub opadajace bitu p1.1

; reset przetwornika adc 
  	clr p3.6 	
	clr p3.7
       
poczatek: 
 	setb p3.6
    setb p3.7
      	 
sprawdzaj: ; sprawdzenie czy konwerter skonwertowal
 	jnb p3.2, sterowanie_w_p2 ; jesli konwersja ukonczona to skocz do sterowanie_w_p2
 	jmp sprawdzaj ; jesli nie to probuje dalej
      	
      
sterowanie_w_p2:
  	clr p3.6 ; wylaczanie adc
 	clr p3.7



	jb p2.7, dalej1 ; sprawdam stan bitu najstarszego
	setb p1.0 ; jesli rowny zero to gasze diode
	ajmp dalej1_ ; skacze dalej
dalej1:
	clr p1.0 ; jesli rowny jeden to zapalam diode
dalej1_: 
clr p1.1 ; zapalam diode p1.1 powodujac powstanie zbocza narastajacego, umozliwiajacego odczyt innemu ukladowi wartosci na diodzie p1.0
setb p1.1  ; gasze diode p1.1 powodujac powstanie zbocza opadajacego, umozliwiajacego odczyt innemu ukladowi wartosci na diodzie p1.0

	jb p2.6, dalej2 ; analogicznie do p2.7
	setb p1.0
	ajmp dalej2_
dalej2:
	clr p1.0
dalej2_:
clr p1.1
setb p1.1

	jb p2.5, dalej3
	setb p1.0
	ajmp dalej3_
dalej3:
	clr p1.0
dalej3_:
clr p1.1
setb p1.1

	jb p2.4, dalej4
	setb p1.0
	ajmp dalej4_
dalej4:
	clr p1.0
dalej4_:
clr p1.1
setb p1.1

	jb p2.3, dalej5
	setb p1.0
	ajmp dalej5_
dalej5:
	clr p1.0
dalej5_:
clr p1.1
setb p1.1

	jb p2.2, dalej6
	setb p1.0
	ajmp dalej6_
dalej6:
	clr p1.0
dalej6_:
clr p1.1
setb p1.1

	jb p2.1, dalej7
	setb p1.0
	ajmp dalej7_
dalej7:
	clr p1.0
dalej7_:
clr p1.1
setb p1.1

	jb p2.0, dalej8
	setb p1.0
	ajmp dalej8_
dalej8:
	clr p1.0
dalej8_:
clr p1.1
setb p1.1

setb p1.0 ; gasze diode na czas przerwy w transmisji

 jmp poczatek ; zaczynam mierzyc od poczatku
