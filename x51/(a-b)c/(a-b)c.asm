call nastawy_7seg
mov 66h, #100 ; czas zatrzymania liczby na ekranie

	clr p1.0 ; panel diodowy pokazuje postep wpisywania liczb, tutaj pokazuje gotowosc do przyjecia liczby a
call czytaj ; liczba a w r7
mov a, r7
mov r0, a ; r0 = a
	clr p1.1 ; pokazuje oczekiwanie na gwiazdke
call gwiazdka

	clr p1.2 ; pokazuje oczekiwanie na liczbe b
call czytaj  ; liczba b w r7
mov a, r7
mov r1, a ; r1 = b
call porownanie_ab ; porownuje a i b, jesli a<b to zamienia wartosci
call odejmij ; a-b
mov a, r0
mov r1, a ; a-b w r1
	clr p1.3 ; pokazuje oczekiwanie na gwiazdke
call gwiazdka

	clr p1.4 ; pokazuje oczekiwanie na liczbe c
call czytaj ; liczba c w r7
call liczenie_glowne	
call tlumacz_na_7seg
	
wysw:
	call wyswietlanie
ajmp wysw  ; zapetlone 
	
	
;;;;;;;;;;;;;;;;; koniec kodu glownego ;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;; poczatek definiowania procedur ;;;;;;;;;;;;;

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

porownanie_ab:
	mov a, r0
	subb a, r1
	anl a, #10000000b
	mov 70h, #0bh
	jz kont

	mov 70h, #0ah 

	mov a, r0 ; zamiana miejscami
	xch a, r1
	mov r0, a
	kont:
ret

odejmij:
	clr c
	mov a, r0
	subb a, r1
	mov r0, a
ret

poczekaj:
	mov a, 66h
	mov r4, a
	asdf:
		nop
	djnz r4, asdf
ret

wyswietlanie:
	mov p1, #255 ; gaszenie segmentow, aby nie migalo
	orl p3, #00011000b ; ustawianie segmentu
	xrl p3, #00001000b
	mov p1, 70h ; zapalanie segmentow
	
	call poczekaj
	
	mov p1, #255 ; gaszenie segmentow...
	xrl p3, #00011000b ; ustawianie segmentu... 
	mov p1, 71h ; zapalanie segmentow...
	
	call poczekaj

	mov p1, #255

	xrl p3, #00001000b
	mov p1, 72h
	
	call poczekaj 
ret

tlumacz_na_7seg:
	mov a, 70h ; wpisany znak
	add a, #10h
	mov r0, a
	mov 70h, @r0	
 
	mov a, 71h
	add a, #10h
	mov r0, a
	mov 71h, @r0
 
	mov a, 72h
	add a, #10h
	mov r0, a
	mov 72h, @r0
ret

liczenie_glowne:
	mov a, r7
	mov r2, a
	mov b, r1
	mul ab
	mov r1, a ; (a-b)*c
	
	mov b, #10
	div ab
	mov 71h, a
	mov 72h, b
ret

nastawy_7seg:
	mov 10h, #11000000b ; 0
	mov 11h, #11111001b ; 1
	mov 12h, #10100100b ; 2
	mov 13h, #10110000b ; 3
	mov 14h, #10011001b ; 4
	mov 15h, #10010010b ; 5
	mov 16h, #10000010b ; 6
	mov 17h, #11111000b ; 7
	mov 18h, #10000000b ; 8
	mov 19h, #10010000b ; 9
	mov 1ah, #10111111b ; -
	mov 1bh, #11111111b ; nic
ret