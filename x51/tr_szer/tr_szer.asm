; program do przesylania tekstu przez uart (rs232)
; NALEZY USTAWIC predkosc transmisji na 4800 bodow i taktowanie procesora na 12MHz
; dane sa wysylane z parzystoscia parzysta

clr sm0			
setb sm1 ; ustawiam port szeregowy na 8bit

mov a, pcon		
setb acc.7		
mov pcon, a	

mov tmod, #20h ; ustawiam licznik T1 na 8bit z przeladowaniem
mov th1, #243 ; wartosc na ktora ma sie przeladowywac dolna czesc licznika
mov tl1, #243 ; wartosc poczatkowa dolnej czesci licznika
setb tr1 ; start licznika T1

mov 50h, #'W' ; zapisuje litery w pamieci, aby potem przeniesc je do akumulatora
mov 51h, #'y'		
mov 52h, #'k'		
mov 53h, #'o'		
mov 54h, #'n'		
mov 55h, #'a'		
mov 56h, #'l'		
mov 57h, #' '		
mov 58h, #'L'		
mov 59h, #'u'		
mov 5ah, #'k'		
mov 5bh, #'a'		
mov 5ch, #'s'		
mov 5dh, #'z'		
mov 5eh, #' '		
mov 5fh, #'K'		
mov 60h, #'u'		
mov 61h, #'s'		
mov 62h, #'t'		
mov 63h, #'o'		
mov 64h, #'w'		
mov 65h, #'s'		
mov 66h, #'k'		
mov 67h, #'i'		
mov 68h, #'.'		

mov 69h, #0	; koniec transmisji oznaczany zerem
mov r0, #50h ; przenosze adres poczatkowy tekstu

wysylanie:
    mov a, @r0 ; przenosze do akumulatora adres pierwszej litery
    jz $ ; jesli zero to koniec transmizji i nic nie rob
    mov c, p ; przenoszenie bitu parzystosci do akumulatora
	mov acc.7, c ; przenoszenie bitu parzystosci do najwiekszego bitu akumulatora
	mov sbuf, a ; przenoszenie danych do wyslania do bufora
	inc r0 ; zwiekszanie zawartosci r0 o jeden (czyli na adres kolejnej litery)
	jnb ti, $ ; czekanie na koniec transmisji - ustawiony zostaje wtedy bit TI
	clr ti ; czyszczenie TI, zeby nastepna petla mogla wykonac sie poprawnie
jmp wysylanie	; nastepne wykonanie petli w celu wyslania kolejnego znaku
