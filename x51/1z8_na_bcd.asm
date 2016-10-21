; program tlumaczacy kod 1z8 na bcd
; wartosci przyjmowane ustawiane sa na przyciskach sw
; wyjscie obrazuje wyswietlacz siedmiosegmentowy

call czekanie_na_wcisniecie ; procedura oczekujaca na wcisniecie przycisku sw
call wcisnieto ; tlumaczenie z kodu 1z8 na bcd
mov 10h,r0 ; przenoszenie liczby bcd do pamieci

call czekanie_na_odcisniecie ; procedura oczekujaca na zwolnienie przycisku
call czekanie_na_wcisniecie

call wcisnieto
mov 11h,r0 ; przenoszenie liczby bcd do pamieci

call czekanie_na_odcisniecie
call czekanie_na_wcisniecie

call wcisnieto
mov 12h,r0 ; przenoszenie liczby bcd do pamieci

call czekanie_na_odcisniecie
call czekanie_na_wcisniecie

call wcisnieto
mov 13h, r0 ; przenoszenie liczby bcd do pamieci

mov r0, 10h ; ustawianie wartosci liczb przyjmowanych przez tlumacz na 7seg
mov r1, 11h
mov r2, 12h
mov r3, 13h

call ustawienia_poczatkowe ; definiowanie wartosci 7seg dla cyfr
call tlumacz_na_7segment ; tlumaczenie z bcd na 7seg
wyswietlaj:
	call wyswietl
jmp wyswietlaj
jmp $

wcisnieto:
	mov a, r0
	mov r0, #0
	jb acc.0, return_
	mov r0, #1
	jb acc.1, return_
	mov r0, #2
	jb acc.2, return_
	mov r0, #3
	jb acc.3, return_
	mov r0, #4
	jb acc.4, return_
	mov r0, #5
	jb acc.5, return_
	mov r0, #6
	jb acc.6, return_
	mov r0, #7
	jb acc.7, return_
	return_:
ret

czekanie_na_wcisniecie:
	czekaj:
		mov a, p2
		cpl a
	jz czekaj
	mov r0, a
ret

czekanie_na_odcisniecie:
	czekaj1:
		mov a, p2
		cpl a
	jnz czekaj1
ret

tlumacz_na_7segment: ; procedura przyjmuje wartosci (r0, r1, r2, r3), zwraca (70h, 71h, 72h, 73h)
		mov 50h, r0 ; zachowanie wartosci r0
	mov a, r0 ; tysiace
	add a, #60h ; dodaje 60h, bo jest to poczatkowy adres wartosci przetlumaczonych na 7seg
	mov r0, a
	mov 70h, @r0	

	mov a, r1 ; setki
	add a, #60h
	mov r0, a
	mov 71h, @r0	
 
	mov a, r2 ; dziesiatki
	add a, #60h
	mov r0, a
	mov 72h, @r0
 
	mov a, r3 ; jednosci
	add a, #60h
	mov r0, a
	mov 73h, @r0

		mov r0, 50h ; przywrocenie wartosci r0

ret

wyswietl: ; procedura przyjmuje wartosci (70h, 71h, 72h, 73h)
	mov p1, #255 ; gaszenie segmentow, zeby nie migalo
	orl p3, #00011000b ; ustawianie, ktory segment zapalic
	mov p1, 70h ; ustawianie wartosci na segmencie

	call odczekaj

	mov p1, #255 
	xrl p3, #00001000b
	mov p1, 71h 
	
	call odczekaj

	mov p1, #255 
	xrl p3, #00011000b
	mov p1, 72h 

	call odczekaj

	mov p1, #255
	xrl p3, #00001000b
	mov p1, 73h 

	call odczekaj

	mov p1, #255 ; koncowe gaszenie segmentu
ret

odczekaj: 
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
ret

ustawienia_poczatkowe:
	mov 60h, #11000000b ; cyfra 0
	mov 61h, #11111001b ; cyfra 1
	mov 62h, #10100100b ; cyfra 2
	mov 63h, #10110000b ; cyfra 3
	mov 64h, #10011001b ; cyfra 4
	mov 65h, #10010010b ; cyfra 5
	mov 66h, #10000010b ; cyfra 6
	mov 67h, #11111000b ; cyfra 7
	mov 68h, #10000000b ; cyfra 8
	mov 69h, #10010000b ; cyfra 9
	mov 6ah, #11000110b ; litera C
	mov 6bh, #11111111b ; pusty
ret