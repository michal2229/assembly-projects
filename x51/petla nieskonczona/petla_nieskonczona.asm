; wyjscie z nieskonczonej petli po czasie rzeczywistym 
; nastawianym z klawiatury 1s, 2s itd. 
; komunikat o zdarzeniu na lcd.
;
; program wspolpracuje ze srodowiskiem edsim.
;
; zalecane ustawienia:
;    * system clock = 0.032768mhz (czyli zegarkowe 32768hz)
;    * update frequency = 500
;    * klawiatura w trybie 'pulse'

; ustawiam nazwy
wybrana_cyfra equ r7
col1 equ p0.6
col2 equ p0.5
col3 equ p0.4
row1 equ p0.3
row2 equ p0.2
row3 equ p0.1
row4 equ p0.0 ; wiersz czwarty nie jest uzywany w programie

RS equ p1.3
E  equ p1.2

DB7 equ p1.7
DB6 equ p1.6
DB5 equ p1.5
DB4 equ p1.4

adres      equ r1
opoznienie equ r0

; ustawiam wyswietlacz i timer
call ustaw_LCD
mov tmod,#01h; licznik 0 w trybie zliczania zegara, 16bit
setb ea
setb et0
		
jmp main ; skok do programu glownego

org 000bh ; tu przechodzi przerwanie licznika T0
	call obsluga_przerwania
	jmp poczatek

main: ; program glowny
	poczatek: 
		call wyswietl_komunikat_oczekiwania ; wyswietlaniekomunikatu na lcd
		call czyszczenie_wyswietlacza
		call wrzuc_na_modul

		call czytaj_klawiature ; czytanie wybranego klawisza z klawiatury

		call czyszczenie_wyswietlacza

		call ustaw_czas ; ustawianie wartosci TH0 i TL0 licznika dla danego opoznienia
		setb tr0; licznik 0 zaczyna liczyc

	petla_nieskonczona:
			call wyswietl_czas ; wyswietlaniekomunikatu na lcd
			call powrot_kursora
			call wrzuc_na_modul
	jmp petla_nieskonczona

obsluga_przerwania:
	clr tr0 ; zatrzymanie licznika T0
	call wyswietl_komunikat_ukonczenia ; wyswietlaniekomunikatu na lcd
	call czyszczenie_wyswietlacza
	call wrzuc_na_modul
	call opoznienie_bardzo_dlugie
reti

ustaw_czas:
	mov a, wybrana_cyfra ; przenoszenie wybranej cyfry do akumulatora
	
	dec a ; zmniejszanie o jeden
	jz czas_1s ; jesli bylo jeden, a po zmniejszeniu jest zero to skok do czas_1s, itd..
	
	dec a
	jz czas_2s
	
	dec a
	jz czas_3s
	
	dec a
	jz czas_4s
	
	dec a
	jz czas_5s
	
	dec a
	jz czas_6s
	
	dec a
	jz czas_7s
	
	dec a
	jz czas_8s
	
	;dec a
	jmp czas_9s ; domyslnie 9s

	czas_1s: ; ustawianie odpowiednich wartosci poczatkowych licznika
		mov th0, #0f5h
		mov tl0, #055h
	jmp koniec_wyboru_czasu
	
	czas_2s:
		mov th0, #0eah
		mov tl0, #0abh
	jmp koniec_wyboru_czasu
	
	czas_3s:
		mov th0, #0e0h
		mov tl0, #000h
	jmp koniec_wyboru_czasu
	
	czas_4s:
		mov th0, #0d5h
		mov tl0, #055h
	jmp koniec_wyboru_czasu
	
	czas_5s:
		mov th0, #0cah
		mov tl0, #0abh
	jmp koniec_wyboru_czasu
	
	czas_6s:
		mov th0, #0c0h
		mov tl0, #000h
	jmp koniec_wyboru_czasu
	
	czas_7s:
		mov th0, #0b5h
		mov tl0, #055h
	jmp koniec_wyboru_czasu
	
	czas_8s:
		mov th0, #0aah
		mov tl0, #0abh
	jmp koniec_wyboru_czasu
	
	czas_9s:
		mov th0, #0a0h
		mov tl0, #000h
		
	koniec_wyboru_czasu:
ret

czytaj_klawiature:
	setb row4 ; ustawiam wartosci
	setb row3 ; poczatkowe
	setb row2 ; dla wierszy
	setb row1 ; klawiatury

	mov wybrana_cyfra, #1 ; licze od jednego do dziewieciu
	
	clr row1 ; sprawdzam wiersz pierwszy (od gory)
	call skanuj_kolumny
	jb f0, znalazlem_liczbe
	setb row1
	
	clr row2  ; sprawdzam wiersz drugi
	call skanuj_kolumny
	jb f0, znalazlem_liczbe
	setb row2
	
	clr row3  ; sprawdzam wiersz trzeci
	call skanuj_kolumny
	jb f0, znalazlem_liczbe
	setb row3
	
	jmp czytaj_klawiature
	
	znalazlem_liczbe:
		clr f0 ; zeruje f0, aby mozna bylo odczytac liczbe jeszcze raz
ret

skanuj_kolumny:
	jnb col1, przycisk_wcisniety ; sprawdzam kolumne pierwsza (od lewej)
	
	inc wybrana_cyfra
	jnb col2, przycisk_wcisniety  ; sprawdzam kolumne druga
	
	inc wybrana_cyfra
	jnb col3, przycisk_wcisniety  ; sprawdzam kolumne trzecia
	
	inc wybrana_cyfra
ret
	przycisk_wcisniety:
		setb f0 ; informacja dla petli, ze przycisk zostal wciniety
ret

wrzuc_literke:
	mov c, acc.7		
	mov DB7, c		
	mov c, acc.6		
	mov DB6, c			
	mov c, acc.5		
	mov DB5, c			
	mov c, acc.4		
	mov DB4, c			;  wyzsza czworka

	setb E			
	clr  E			; zbocze opadajace na e

	mov c, acc.3		
	mov DB7, c			
	mov c, acc.2		
	mov DB6, c			
	mov c, acc.1		
	mov DB5, c			
	mov c, acc.0		
	mov DB4, c			; nizsza czworka

	setb E			
	clr  E			; zbocze opadajace na e

	call opoznienie_krotkie			; oczekiwanie na wyczyszczenie flagi zajetosci

opoznienie_krotkie:
	mov opoznienie, #10
	djnz opoznienie, $
ret

opoznienie_dlugie:
	mov a, #3
	opoznienie_krotkieb:
		call opoznienie_krotkie
		dec a
	jnz opoznienie_krotkieb
ret

opoznienie_bardzo_dlugie:
	mov a, #255
	opoznienie_krotkiea:
		call opoznienie_krotkie
		dec a
	jnz opoznienie_krotkiea
ret

ustaw_LCD:
		clr RS		; czyszczenie rs umozliwia wyslanie instrukcji do wyswietlacza
		
		clr  DB7		
		clr  DB6	
		setb DB5		
		clr  DB4		; wysza czworka
			setb E		
			clr  E		; zbocze opadajace na e
		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci
		
			setb E		
			clr  E		; zbocze opadajace na e
		setb DB7		; nizsza czworka
			setb E		
			clr  E		; zbocze opadajace na e
		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci

		clr DB7		
		clr DB6		
		clr DB5		
		clr DB4		; wysza czworka

		setb E		
		clr  E		; zbocze opadajace na e

		setb DB6		
		setb DB5		; nizsza czworka

		setb E		
		clr  E		; zbocze opadajace na e

		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci

		clr DB7		
		clr DB6		
		clr DB5		
		clr DB4		; wysza czworka

		setb E		
		clr  E		; zbocze opadajace na e

		setb DB7		
		setb DB6		
		setb DB5		
		setb DB4		; nizsza czworka

		setb E		
		clr  E		; zbocze opadajace na e

		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci
ret

czyszczenie_wyswietlacza:
	clr RS

	clr DB7
	clr DB6		
	clr DB5		
	clr DB4		; wysza czworka

	setb E		
	clr  E		; zbocze opadajace na e

	setb DB4		; nizsza czworka

	setb E		
	clr  E		; zbocze opadajace na e

	call opoznienie_dlugie		; oczekiwanie na wyczyszczenie flagi zajetosci
ret

powrot_kursora:
	clr RS

	clr DB7
	clr DB6		
	clr DB5		
	clr DB4		; wysza czworka

	setb E		
	clr  E		; zbocze opadajace na e

	setb DB5		; nizsza czworka

	setb E		
	clr  E		; zbocze opadajace na e

	call opoznienie_dlugie		; oczekiwanie na wyczyszczenie flagi zajetosci
ret

wrzuc_na_modul:
		setb RS		; czyszczenie rs - umozliwia wysylanie danych
		mov adres, #30h
	peetla:
		mov a, @adres		; przesylanie do akumulatora znaku wzkazywanego przez rejestr adres
		jz endd		; jesli znak to zero, koniec transmisji
		call wrzuc_literke	; wyslij znak na modul lcd
		inc adres			; zwieksz wskaznik w celu wskazania na kolejny znak
		jmp peetla	; powtorz
	endd:
ret

wyswietl_komunikat_oczekiwania:
	mov 30h, #'N'
	mov 31h, #'a'
	mov 32h, #'c'
	mov 33h, #'i'
	mov 34h, #'s'
	mov 35h, #'n'
	mov 36h, #'i'
	mov 37h, #'j'
	mov 38h, #' '
	mov 39h, #'k'
	mov 3ah, #'l'
	mov 3bh, #'a'
	mov 3ch, #'w'
	mov 3dh, #'i'
	mov 3eh, #'s'
	mov 3fh, #'z'
	mov 40h, #0 ; koniec danych do wyswietlania
ret

wyswietl_czas:
	mov a, #0
	mov b, th0
	subb a, b ; 256 - th0

	mov b, #11
	div ab ; (256-th0)/11

	add a, #'0'
	mov 30h, a ; wpisanie sekund

	mov 31h, #'.'

	mov a, #10
	mul ab
	mov b, #11
	div ab

	add a, #'0'
	mov 32h, a ; wpisanie dziesiatych sekund
	mov 33h, #'s'
	mov 34h, #0 ; koniec danych do wyswietlania
ret

wyswietl_komunikat_ukonczenia:
	mov 30h, #'K'
	mov 31h, #'o'
	mov 32h, #'n'
	mov 33h, #'i'
	mov 34h, #'e'
	mov 35h, #'c'
	mov 36h, #' '
	mov 37h, #'l'
	mov 38h, #'i'
	mov 39h, #'c'
	mov 3ah, #'z'
	mov 3bh, #'e'
	mov 3ch, #'n'
	mov 3dh, #'i'
	mov 3eh, #'a'
	mov 3fh, #0 ; koniec danych do wyswietlania
ret
