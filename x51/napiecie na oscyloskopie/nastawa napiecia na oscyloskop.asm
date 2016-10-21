mov p1, #0 ; zeruje oscyloskop
clr P0.7 ; wlaczam oscyloskop

jeszcze_raz:
	call szukaj_liczby
	; liczba w r7
	clr f0
	mov a, r7 ; przenosze liczbe do a
	call sprawdz_5 ; sprawdza czy liczba wieksza lub rowna 5, jesli tak to ustawia na oscyloskopie napiecie 5V i czeka na kratke (po_napieciu)
	mov b, #51 ; 255/5=51
	mul ab
	mov r0, a ; liczba jednosci w r0

	call szukaj_gwiazdki ; czeka na "przecinek"

	call szukaj_liczby
	; liczba w r7
	clr f0

	mov a, r7 ; przenosze liczbe do a
	mov b, #5 ; 255/50=5
	mul ab
	mov r1, a ; ulamek w r1

	mov a, r0
	add a, r1 ; sumuje jednosci i ulamek

	po_napieciu:
	mov p1, a ; napiecie wrzucam na oscyloskop
	call szukaj_kratki ; czekam na kratke, kiedy wcisnieta zaczynam program jeszcze_raz

ajmp jeszcze_raz ; zapetlam program w nieskonczonosc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
szukaj_gwiazdki:
	setb p0.3
	setb p0.2
	setb p0.1
	clr p0.0
	jb p0.6, $ ; nic nie robi dopoki nie zostanie wcisnieta gwiazdka (po gwiazdce wpisywany jest ulamek dziesietny)
	setb p0.0
ret

szukaj_kratki:
	setb p0.3
	setb p0.2
	setb p0.1
	clr p0.0
	jb p0.4, $ ; nic nie robi dopoki nie zostanie nacisnieta kratka (po kratce wpisywana nowa wartosc)
	setb p0.0
ret

szukaj_liczby:
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
	jmp szukaj_liczby
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

sprawdz_5: ; sprawdza, czy wartosc napiecia jest >=5
	mov r3, a ; backup
	jz ok ; a=0
	dec a
	jz ok ; a=1
	dec a
	jz ok ; a=2
	dec a
	jz ok ; a=3
	dec a
	jz ok ; a=4
	call ustaw_5 ; a=5
	ok:
	mov a, r3 ; z backupu spowrotem do a
ret

ustaw_5: ; jesli napiecie wybrane >=5 to ustawiam 5 (nie da sie wiecej)
	mov a, #255
	jmp po_napieciu ; skacze do ustawiania napiecia na oscyloskopie
ret
