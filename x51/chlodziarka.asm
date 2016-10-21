clr p1.0
call czytaj ; liczba a w r7

mov a, #0
subb a, r7
mov b, #10
mul ab

mov r3, a
clr p1.1 ; pokazuje oczekiwanie na druga liczbe
call czytaj  ; liczba b w r7
subb a, r7
mov b, #10
mul ab

mov r1, a ; przenosze wartosc temperatury

poczatek: ; reset 
sprawdzenie_drzwi:
	setb p3.7 ; wylaczenie linii odczytu danych z ADC
	jnb p2.0, wylacz_silnik

pomiar:
    clr p3.6  ; wylaczenie ADC	
	setb p3.6 ; wlaczenie ADC 	
 
sprawdzaj: ; sprawdzenie czy konwerter skonwertowal
 	jb p3.2, $ ; jesli nie skonczyl konwersji to rob nic
	clr p3.7 ; wlaczenie linii odczytu danych z ADC

juz_skonwertowal:
; jest sobie napiecie w p2
mov r0, p2

call porownaj

jb p1.2, wlacz_silnik ; jesli temp w chlodziarce wyzsza niz oczekiwana to wlacza silnik
jmp wylacz_silnik ; jesli temp. ok, to wylacz silnik
 
jmp poczatek ; od poczatku

porownaj: ; funkcja realizujaca porownanie r0 i r1
	mov p1, #0 ; zerowanie p1
	mov a, r0
	mov b, r1
	div ab
	jz a_0 ; a = 0
	dec a
	jz a_1 ; a = 1
	jmp a_2 ; a > 1

	a_0:
		jmp r0_lt_r1

	a_1:
		xch a, b
		jz r0_eq_r1
		jmp r0_gt_r1

	a_2:
		jmp r0_gt_r1

	r0_eq_r1:
		setb p1.1
		jmp koniec_por

	r0_lt_r1:
		setb p1.0 
		jmp koniec_por

	r0_gt_r1:
		setb p1.2
		jmp koniec_por
	koniec_por:
ret

wylacz_silnik:
	setb p3.1
jmp poczatek

wlacz_silnik:
	clr p3.1
jmp poczatek

gwiazdka:
	clr f0
	setb p0.3
	setb p0.2
	setb p0.1
	clr p0.0
	jb p0.6, $ ; nic nie robi dopoki nie zostanie wcisnieta gwiazdka
	setb p0.0
ret

czytaj:
	mov r7, #0 ; cyferka
	setb p0.1
	setb p0.2
	setb p0.3
	
	clr p0.0
	jnb p0.5, wcisnieto_przycisk
	inc r7
	jb f0, znalazlem_liczbe
	
	setb p0.0
	clr p0.3
	call skanuj_kolumny
	jb f0, znalazlem_liczbe
	
	setb p0.3
	clr p0.2
	call skanuj_kolumny
	jb f0, znalazlem_liczbe
	
	setb p0.2
	clr p0.1
	call skanuj_kolumny
	jb f0, znalazlem_liczbe
	jmp czytaj
	znalazlem_liczbe:
	clr f0 ; zeruje f0, aby mozna bylo odczytac liczbe jeszcze raz
ret

skanuj_kolumny:
	jnb p0.6, wcisnieto_przycisk
	inc r7
	jnb p0.5, wcisnieto_przycisk
	inc r7
	jnb p0.4, wcisnieto_przycisk
	inc r7
ret

wcisnieto_przycisk:
	setb f0 ; informacja dla petli, ze przycisk zostal wciniety
ret