; Wysyłka szeregowa  3-ch kolejnych komunikatów min 20 znaków na moduł lcd
;
; Ustawienia:
;  - częstotliwość zegara: 12mhz
;  - częstotliwość odświeżania: 50000x
; 

rs equ p1.3
e  equ p1.2

mov tmod, #11h ; timer w trybie 16bit
clr tf0
clr tr0

call set_lcd
call clear_lcd

call text_1
call input
call opoznienie_bardzo_dlugie

call clear_lcd
call text_2
call input
call opoznienie_bardzo_dlugie

call clear_lcd
call text_3
call input
call opoznienie_bardzo_dlugie

call clear_lcd
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
	mov th0, #0ffh ; 10000h - 40 = ffd5h ; opoznienie 40us
	mov tl0, #0d5h
	setb tr0
	jnb tf0, $
	clr tr0
	clr tf0
ret

opoznienie_dlugie:
	mov th0, #0ech ; opoznienie 5ms
	mov tl0, #078h ; 10000h - 5000 = 0ec78h
	setb tr0
	jnb tf0, $
	clr tr0
	clr tf0
ret

opoznienie_bardzo_dlugie:
	mov a, #200 ; opoznienie 200 * 5ms = 1s
	asadf:
	call opoznienie_dlugie
	dec a
	jnz asadf
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
	mov 30h, #'A'
	mov 31h, #'u'
	mov 32h, #'t'
	mov 33h, #'o'
	mov 34h, #'r'
	mov 35h, #'-'
	mov 36h, #'B'
	mov 37h, #'a'
	mov 38h, #'r'
	mov 39h, #'t'
	mov 3ah, #'l'
	mov 3bh, #'o'
	mov 3ch, #'m'
	mov 3dh, #'i'
	mov 3eh, #'e'
	mov 3fh, #'j'
	
	mov 58h, #'K'
	mov 59h, #'o'
	mov 5ah, #'r'
	mov 5bh, #'z'
	mov 5ch, #'e'
	mov 5dh, #'n'
	mov 5eh, #'i'
	mov 5fh, #'o'
	mov 60h, #'w'
	mov 61h, #'s'
	mov 62h, #'k'
	mov 63h, #'i'
	mov 64h, #'.'
	mov 65h, #' '
	mov 66h, #' '
	mov 67h, #' '
	
	mov 40h, #' '
	mov 41h, #' '
	mov 42h, #' '
	mov 43h, #' '
	mov 44h, #' '
	mov 45h, #' '
	mov 46h, #' '
	mov 47h, #' '
	mov 48h, #' '
	mov 49h, #' '
	mov 4ah, #' '
	mov 4bh, #' '
	mov 4ch, #' '
	mov 4dh, #' '
	mov 4eh, #' '
	mov 4fh, #' '
	mov 50h, #' '
	mov 51h, #' '
	mov 52h, #' '
	mov 53h, #' '
	mov 54h, #' '
	mov 55h, #' '
	mov 56h, #' '
	mov 57h, #' '
	
	mov 68h, #0 ; koniec danych do wyswietlania
ret

text_2:
	mov 30h, #'K'
	mov 31h, #'o'
	mov 32h, #'m'
	mov 33h, #'u'
	mov 34h, #'n'
	mov 35h, #'i'
	mov 36h, #'k'
	mov 37h, #'a'
	mov 38h, #'t'
	mov 39h, #' '
	mov 3ah, #'d'
	mov 3bh, #'r'
	mov 3ch, #'u'
	mov 3dh, #'g'
	mov 3eh, #'i'
	mov 3fh, #' '
	
	mov 58h, #'w'
	mov 59h, #'y'
	mov 5ah, #'s'
	mov 5bh, #'w'
	mov 5ch, #'i'
	mov 5dh, #'e'
	mov 5eh, #'t'
	mov 5fh, #'l'
	mov 60h, #'a'
	mov 61h, #'n'
	mov 62h, #'y'
	mov 63h, #'.'
	mov 64h, #' '
	mov 65h, #' '
	mov 66h, #' '
	mov 67h, #' '
	
	mov 40h, #' '
	mov 41h, #' '
	mov 42h, #' '
	mov 43h, #' '
	mov 44h, #' '
	mov 45h, #' '
	mov 46h, #' '
	mov 47h, #' '
	mov 48h, #' '
	mov 49h, #' '
	mov 4ah, #' '
	mov 4bh, #' '
	mov 4ch, #' '
	mov 4dh, #' '
	mov 4eh, #' '
	mov 4fh, #' '
	mov 50h, #' '
	mov 51h, #' '
	mov 52h, #' '
	mov 53h, #' '
	mov 54h, #' '
	mov 55h, #' '
	mov 56h, #' '
	mov 57h, #' '
	
	mov 68h, #0 ; koniec danych do wyswietlania
ret

text_3:
	mov 30h, #'T'
	mov 31h, #'r'
	mov 32h, #'z'
	mov 33h, #'e'
	mov 34h, #'c'
	mov 35h, #'i'
	mov 36h, #' '
	mov 37h, #'k'
	mov 38h, #'o'
	mov 39h, #'m'
	mov 3ah, #'u'
	mov 3bh, #'n'
	mov 3ch, #'i'
	mov 3dh, #'k'
	mov 3eh, #'a'
	mov 3fh, #'t'
	
	mov 58h, #'n'
	mov 59h, #'a'
	mov 5ah, #' '
	mov 5bh, #'e'
	mov 5ch, #'k'
	mov 5dh, #'r'
	mov 5eh, #'a'
	mov 5fh, #'n'
	mov 60h, #'i'
	mov 61h, #'e'
	mov 62h, #'.'
	mov 63h, #' '
	mov 64h, #' '
	mov 65h, #' '
	mov 66h, #' '
	mov 67h, #' '
	
	mov 40h, #' '
	mov 41h, #' '
	mov 42h, #' '
	mov 43h, #' '
	mov 44h, #' '
	mov 45h, #' '
	mov 46h, #' '
	mov 47h, #' '
	mov 48h, #' '
	mov 49h, #' '
	mov 4ah, #' '
	mov 4bh, #' '
	mov 4ch, #' '
	mov 4dh, #' '
	mov 4eh, #' '
	mov 4fh, #' '
	mov 50h, #' '
	mov 51h, #' '
	mov 52h, #' '
	mov 53h, #' '
	mov 54h, #' '
	mov 55h, #' '
	mov 56h, #' '
	mov 57h, #' '
	
	mov 68h, #0 ; koniec danych do wyswietlania
ret
