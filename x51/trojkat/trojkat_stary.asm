pierwsza: ; nachylenie
	clr p1.0 ;sygnalizuje oczekiwanie na pierwsza liczbe

	call liczba ; czyta z klawiatury nachylenie [nachylenie = liczba * 0.195V - jest to przyrost/spadek napiecia na kazdy okres probkowania]
	; liczba w r7
	mov a, r7
	mov r0, a
	clr f0

	mov p1, #0 ; zapalanie sygnalizuje oczekiwanie na potwierdzenie gwiazdka
	call gwiazdka

druga: ; okres
	mov p1, #255
	clr p1.1 ; sygnalizuje oczekiwanie na druga liczbe

	call liczba  ; czyta z klawiatury okres [liczba * 10 = okres, czyli liczba okresow probkowania na okres funkcji trojkatnej]
	; liczba w r7
	mov a, r7
	clr f0
	jz druga
	mov b, #10
	mul ab	
	mov b, #4
	div ab ; a = 10*okres/4 - dziele cz cztery w celu obliczenia czasu trwania cwiartki

	mov r1, a 
	mov b, #0 

	mov p1, #0

	call gwiazdka
	
trzecia: ; offset
	mov p1, #255
	clr p1.2 ; sygnalizuje oczekiwanie na trzecia liczbe

	call liczba ; czyta z klawiatury offset [V], czyli przesuniecie na oscyloskopie funkcji trojkatnej od zera 
	; liczba w r7
	mov a, r7
	clr f0
	mov b, #51
	mul ab
	mov r2,a
	mov b, #0
	


;mov r0, #7 ; nachylenie
;mov r1, #32 ; okres

;mov r2, #32 ; offset
clr P0.7 ; wlaczam oscyloskop

trojkat:
	mov a, r1
	mov r3, a ; wczytuje okres/4 dla petli

	mov a, r2 ; wczytuje wartosc napiecia

	petla1:
		add a, r0
		mov p1, a ; napiecie wrzucam na oscyloskop
	djnz r3, petla1

	mov r2, a ; zachowuje wartosc napiecia

	mov a, r1 ; wczytuje okres/4
	mov r3, a

	mov a, r2 ; wczutuje napiecie

	petla2:
		subb a, r0
		mov p1, a ; napiecie wrzucam na oscyloskop
	djnz r3, petla2

	mov r2, a ; zachowuje napiecie
ajmp trojkat



gwiazdka:
	setb p0.3
	setb p0.2
	setb p0.1
	clr p0.0
	jb p0.6, $ ; nic nie robi dopoki nie zostanie wcisnieta gwiazdka
	setb p0.0
ret


liczba:
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
	jmp liczba
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
