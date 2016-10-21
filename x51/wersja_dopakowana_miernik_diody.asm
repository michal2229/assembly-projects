poczatek: ;reset ADC
	setb p3.6
	setb p3.7
 	clr p3.6
	clr p3.7

sprawdzaj: ; sprawdzenie czy konwerter skonwertowal
	jb p3.2, napiecie ; jesli konwersja ukonczona to skocz do napiecie
	jmp sprawdzaj ; jesli nie to probuje dalej

napiecie:
	mov r0, p2 ; laduje do r0 wartosc napiecia
	mov a, r0 ; kopiuje wartosc napiecia do akumulatora

p_0: ; sprawdzenie czy ustawione napiecie, miesci sie w przedziale zerowym (jesli napiecie jest rowne zero)
	subb a, #05h ; jezeli otrzymana z operacji odejmowania liczba jest ujemna to flaga przeniesienia C=1
	jc zapal ; zakonczenie sprawdzania i wyswietlenie wyniku na diodach 
	mov r1, #11111111b ; definiowanie odpowiedniej kombinacji diod
	mov a,r0 ; zaladowanie ponowne zachowanej wartosci napiecia do akumulatora

p_1: ; sprzedzanie czy wartosc jest wieksza niz pierwsza wartosc progowa
	subb a, #20h
	jc zapal
	mov r1, #01111111b
	mov a,r0
	
p_2:
	subb a, #40h
	jc zapal
	mov r1, #00111111b
	mov a,r0

p_3:
	subb a, #60h
	jc zapal
	mov r1, #00011111b
	mov a,r0

p_4:
	subb a, #80h
	jc zapal
	mov r1, #00001111b
	mov a,r0

p_5:
	subb a, #0a0h
	jc zapal
	mov r1, #00000111b
	mov a,r0

p_6:
	subb a, #0BFh
	jc zapal
	mov r1, #00000011b
	mov a,r0

p_7:
	subb a, #0DFh
	jc zapal
	mov r1, #00000001b
	mov a,r0

p_8:
	subb a, #0FFh
	jc zapal
	mov r1, #00000000b
	mov a,r0

zapal: 
	mov p1, r1 ; zapalam odpowiednie diody
	jmp poczatek ; zaczynam mierzyc od poczatku