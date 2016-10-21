; wysyłka szeregowa  3-ch kolejnych komunikatów min 20 znaków na moduł lcd
; zadaniem jest wyswietlenie trzech komunikatow na module lcd hd44780 dostepnym w symulatorze edsim51.
; ustawienia symulatora:
;  - częstotliwość zegara: 12mhz
;  - częstotliwość odświeżania: 2000x
; 

rs equ p1.3
e  equ p1.2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
call set_lcd
call clear_lcd
call text_1
call input
call shift
call clear_lcd
call text_2
call input
call shift
call clear_lcd
call text_3
call input
call shift
call clear_lcd
call text_4
jmp $

input_char:
	mov c, acc.7		
	mov p1.7, c		
	mov c, acc.6		
	mov p1.6, c			
	mov c, acc.5		
	mov p1.5, c			
	mov c, acc.4		
	mov p1.4, c			;  wyzsza czworka

	setb e			
	clr  e			; zbocze opadajace na e

	mov c, acc.3		
	mov p1.7, c			
	mov c, acc.2		
	mov p1.6, c			
	mov c, acc.1		
	mov p1.5, c			
	mov c, acc.0		
	mov p1.4, c			; nizsza czworka

	setb e			
	clr  e			; zbocze opadajace na e

	call opoznienie_krotkie			; oczekiwanie na wyczyszczenie flagi zajetosci

opoznienie_krotkie:
	mov r0, #20
	djnz r0, $
ret

opoznienie_dlugie:
	mov a, #50
	opoznienie_krotkiea:
		call opoznienie_krotkie
		dec a
	jnz opoznienie_krotkiea
ret

opoznienie_z_a:
	mov a, #16
	opoznienie_krotkied:
		call opoznienie_krotkie
		dec a
	jnz opoznienie_krotkied
ret

opoznienie_bardzo_dlugie:
	mov a, #255
	opoznienie_krotkieb:
		call opoznienie_krotkie
		dec a
	jnz opoznienie_krotkieb
ret

set_lcd:
		clr rs		; czyszczenie rs umozliwia wyslanie instrukcji do wyswietlacza
		
		clr  p1.7		
		clr  p1.6	
		setb p1.5		
		clr  p1.4		; wysza czworka
		
			setb e		
			clr  e		; zbocze opadajace na e
		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci
		
			setb e		
			clr  e		; zbocze opadajace na e
		setb p1.7		; nizsza czworka
			setb e		
			clr  e		; zbocze opadajace na e
		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci

		clr p1.7		
		clr p1.6		
		clr p1.5		
		clr p1.4		; wysza czworka

		setb e		
		clr  e		; zbocze opadajace na e

		setb p1.6		
		setb p1.5		; nizsza czworka

		setb e		
		clr  e		; zbocze opadajace na e

		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci

		clr p1.7		
		clr p1.6		
		clr p1.5		
		clr p1.4		; wysza czworka

		setb e		
		clr  e		; zbocze opadajace na e

		setb p1.7		
		setb p1.6		
		setb p1.5		
		setb p1.4		; nizsza czworka

		setb e		
		clr  e		; zbocze opadajace na e

		call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci
ret

clear_lcd:
	clr rs

	clr p1.7
	clr p1.6		
	clr p1.5		
	clr p1.4		; wysza czworka

	setb e		
	clr  e		; zbocze opadajace na e

	setb p1.4		; nizsza czworka

	setb e		
	clr  e		; zbocze opadajace na e

	call opoznienie_dlugie		; oczekiwanie na wyczyszczenie flagi zajetosci
ret

shift:
	mov r5, #16
	opoznienie_krotkiec:
		call opoznienie_bardzo_dlugie	
		call przesun
		dec r5
		mov a, r5
	jnz opoznienie_krotkiec
ret

przesun:
	clr rs

	clr p1.7
	clr p1.6		
	clr p1.5		
	setb p1.4		; wyzsza czworka

	setb e		
	clr  e		; zbocze opadajace na e

	setb p1.7 ; s/c
	clr p1.6 ; r/l		
	clr p1.5
	clr p1.4
	
	setb e		
	clr  e		; zbocze opadajace na e

	call opoznienie_krotkie		; oczekiwanie na wyczyszczenie flagi zajetosci

ret



input:
		setb rs		; czyszczenie rs - umozliwia wysylanie danych
		mov r1, #30h
	peetla:
		mov a, @r1		; przesylanie do akumulatora znaku wzkazywanego przez rejestr r1
		jz endd		; jesli znak to zero, koniec transmisji
		call input_char	; wyslij znak na modul lcd
		inc r1			; zwieksz wskaznik w celu wskazania na kolejny znak
		jmp peetla	; powtorz
	endd:
ret

text_1:
	mov 30h, #'w'
	mov 31h, #'y'
	mov 32h, #'s'
	mov 33h, #'y'
	mov 34h, #'l'
	mov 35h, #'k'
	mov 36h, #'a'
	mov 37h, #' '
	mov 38h, #'s'
	mov 39h, #'z'
	mov 3ah, #'e'
	mov 3bh, #'r'
	mov 3ch, #'e'
	mov 3dh, #'g'
	mov 3eh, #'o'
	mov 3fh, #'w'
	mov 40h, #'a'
	mov 41h, #' '
	mov 42h, #'n'
	mov 43h, #'a'
	mov 44h, #' '
	mov 45h, #'l'
	mov 46h, #'c'
	mov 47h, #'d'
	mov 48h, #0 ; koniec danych do wyswietlania
ret

text_2:
	mov 30h, #'w'
	mov 31h, #' '
	mov 32h, #'t'
	mov 33h, #'r'
	mov 34h, #'y'
	mov 35h, #'b'
	mov 36h, #'i'
	mov 37h, #'e'
	mov 38h, #' '
	mov 39h, #'4'
	mov 3ah, #'-'
	mov 3bh, #'b'
	mov 3ch, #'i'
	mov 3dh, #'t'
	mov 3eh, #'o'
	mov 3fh, #'w'
	mov 40h, #'y'
	mov 41h, #'m'
	mov 42h, #' '
	mov 43h, #'w'
	mov 44h, #'p'
	mov 45h, #'r'
	mov 46h, #'o'
	mov 47h, #'w'
	mov 48h, #'a'
	mov 49h, #'d'
	mov 4ah, #'z'
	mov 4bh, #'a'
	mov 4ch, #'n'
	mov 4dh, #'i'
	mov 4eh, #'a'
	mov 4fh, #0 ; koniec danych do wyswietlania
ret

text_3:
	mov 30h, #'w'
	mov 31h, #'y'
	mov 32h, #'k'
	mov 33h, #'o'
	mov 34h, #'n'
	mov 35h, #'a'
	mov 36h, #'l'
	mov 37h, #' '
	mov 38h, #'l'
	mov 39h, #'u'
	mov 3ah, #'k'
	mov 3bh, #'a'
	mov 3ch, #'s'
	mov 3dh, #'z'
	mov 3eh, #' '
	mov 3fh, #'k'
	mov 40h, #'u'
	mov 41h, #'s'
	mov 42h, #'t'
	mov 43h, #'o'
	mov 44h, #'w'
	mov 45h, #'s'
	mov 46h, #'k'
	mov 47h, #'i'
	mov 48h, #0 ; koniec danych do wyswietlania
ret

text_4:
	mov 30h, #'k'
	mov 31h, #'o'
	mov 32h, #'n'
	mov 33h, #'i'
	mov 34h, #'e'
	mov 35h, #'c'
	mov 36h, #' '
	mov 37h, #'p'
	mov 38h, #'r'
	mov 39h, #'o'
	mov 3ah, #'g'
	mov 3bh, #'r'
	mov 3ch, #'a'
	mov 3dh, #'m'
	mov 3eh, #'u'
	mov 3fh, #0 ; koniec danych do wyswietlania
ret
