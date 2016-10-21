; program dodajacy lub odejmujacy dwie liczby dwucyfrowe
; nalezy podac liczbe dwucyfrowa, nastepnie symbol dzialania (gwiazdka to odejmowanie, kratka to dodawanie)
; nastepnie podac nalezy druga liczbe dwucyfrowa
; wynik zostanie wyswietlony na wyswietlaczu siedmiosegmentowym
; nalezy wpisywac liczby, ktorych suma lub roznica miesci sie w granicach od -128 do 127 (ograniczenie U2 na 8 bitach)

; program dziala najlepiej przy ustawieniach predkosci x10
; ustawienie klawiatury w trybie pulse


; ustawianie wartosci segmentow dla znakow
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
	
mov 66h, #10 ; czas zatrzymania liczby na ekranie

; program glowny

call czytaj_pierwsza_liczbe ; liczba pierwsza w r0
call czytaj_dzialanie ; czytanie dzialania, zapala sie odpowiednia dioda; minus - gwiazdka, plus - kratka
call czytaj_druga_liczbe ; liczba druga w r1

call liczenie ; procedura liczenia
call _tlumacz ; tlumaczenie cyfr na 7seg
	
wysw: ; wyswietlanie wyniku
	call wysw_
ajmp wysw  ; zapetlone 

; koniec programu glownego

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; procedury ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

czytaj_pierwsza_liczbe:
	clr p1.0 ; panel diodowy pokazuje postep wpisywania liczb, tutaj pokazuje gotowosc do przyjecia cyfry X
	call czytaj ; liczba a w r7
	setb p1.0 

	mov a, r7
	mov b, #10
	mul ab

	mov r0, a ; r0 - dziesiatki

	clr p1.1 ; pokazuje oczekiwanie na cyfre Y
	call czytaj  ; liczba b w r7
	setb p1.1 

	mov a, r0
	add a, r7

	mov r0, a ; liczba pierwsza w r0
ret

czytaj_druga_liczbe:
	clr p1.2 ; panel diodowy pokazuje postep wpisywania liczb, tutaj pokazuje gotowosc do przyjecia cyfry X
	call czytaj ; liczba a w r7
	setb p1.2 

	mov a, r7
	mov b, #10
	mul ab

	mov r1, a ; r0 - dziesiatki

	clr p1.3 ; pokazuje oczekiwanie na cyfre Y
	call czytaj  ; liczba b w r7
	setb p1.3 

	mov a, r1
	add a, r7

	mov r1, a ; liczba druga w r1
ret

czytaj_dzialanie:
	clr p1.4 ; oczekiwanie na wcisniecie znaku
	clr f0
	setb p0.3
	setb p0.2
	setb p0.1
	clr p0.0

	czytanie:
		jnb p0.6, odejmowanie ; jak gwiazdka to odejmowanie
		jnb p0.4, dodawanie ; jak kratka to dodawanie
	jmp czytanie
	
	odejmowanie:
		SETB p1.4
		clr p1.7
		setb p1.6
	ret
	dodawanie:
		SETB p1.1
		setb p1.7
		clr p1.6
	ret

		setb p0.0
ret

czytaj:
	mov r7, #0 ; cyferka
	setb p0.1
	setb p0.2
	setb p0.3
	
	clr p0.0
	jnb p0.5, znalazlem_liczbe
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

chwila_czekania:
	mov a, 66h
	mov r4, a
	asdf:
		nop
	djnz r4, asdf
ret

wysw_:
	mov p1, #255 ; gaszenie segmentow, zeby nie migalo
	orl p3, #00011000b ; ustawianie, ktory segment zapalic
	mov p1, 6fh ; ustawianie wartosci na segmencie
	
	call chwila_czekania

	mov p1, #255 
	xrl p3, #00001000b
	mov p1, 70h 
	
	call chwila_czekania
	
	mov p1, #255 
	xrl p3, #00011000b
	mov p1, 71h 
	
	call chwila_czekania

	mov p1, #255
	xrl p3, #00001000b
	mov p1, 72h
	
	call chwila_czekania 
ret

_tlumacz:
	mov a, 6fh ; wpisany znak
	add a, #10h
	mov r0, a
	mov 6fh, @r0	

	mov a, 70h ; setki
	add a, #10h
	mov r0, a
	mov 70h, @r0	
 
	mov a, 71h ; dziesiatki
	add a, #10h
	mov r0, a
	mov 71h, @r0
 
	mov a, 72h ; jednosci
	add a, #10h
	mov r0, a
	mov 72h, @r0
ret

liczenie: ;A w r0, B w r1
	mov a, r0 ; wrzucam do a pierwsza liczbe
	mov b, r1 ; wrzucam do b liczbe druga
	
	jb p1.7, dodaj
	jnb p1.7, odejmuj
	
	dodaj:
		add a, b
	jmp zadzialane

	odejmuj:
		subb a, b
	jmp zadzialane

	zadzialane:
		mov 6fh, #11
		jnb acc.7, nieminus
		mov 6fh, #10
		mov b, #-1
		mul ab
	nieminus:
		mov b,#10
		div ab
		mov 72h, b
		mov b, #10
		div ab
		mov 71h, b
		mov 70h, a
ret
