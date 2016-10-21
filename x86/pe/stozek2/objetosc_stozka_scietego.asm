format PE console
entry poczatek	

section '.text' code readable executable

poczatek:
;;;;;;;;; WCZYTYWANIE DANYCH ;;;;;;;;;
	push powitanie
	call [printf]

	push podaj_R
	call [printf]

	push R_
	push int_
	call [scanf]

	push podaj_r
	call [printf]

	push r_
	push int_
	call [scanf]

	push podaj_h
	call [printf]

	push h_
	push int_
	call [scanf]
;;;;;;;;; KONIEC WCZYTYWANIA DANYCH ;;;;;;;;;

;;;;;;;;; LICZENIE ;;;;;;;;;
	fild dword [R_]       ; wczytuje liczbe calkowita R na stos koprocesora, jest konwertowana na float
	fild dword [r_]       ; wczytuje liczbe calkowita r na stos koprocesora, jest konwertowana na float
	fmul st0, st1	      ; mnoze R*r, wynik zapisuje do st0

	ffree st1	      ; czyszcze zawartosc st1

	fild dword [R_]       ; wczytuje liczbe calkowita R po raz kolejny, jest konwertowana na float
	fmul st0, st0	      ; R*R = R^2

	fild dword [r_]       ; wczytuje liczbe calkowita r, nastepuje konwersja int na float
	fmul st0, st0	      ; r*r = r^2
			      ; st0 = r^2, st1 = R^2, st2 - R*r
	fadd st0, st1	      ; dodaje r^2 + R^2
	fadd st0, st2	      ; dodaje (r^2+R^2) + R*r

	ffree st1	      ; czyszcze st1
	ffree st2	      ; czyszcze st2

	fild dword [h_]       ; wczytuje wysokosc h
	fmul st0, st1	      ; mnoze (R^2+R*r+r^2) * h

	fldpi		      ; wrzucam pi na stos
	fmul st0, st1	      ; mnoze ((R^2+R*r+r^2)*h) * pi

	ffree st1	      ; czyszcze st1
	ffree st2	      ; czyszcze st2

	fild dword [trzy]     ; wczytuje 3 na stos
	fdiv st1, st0	      ; dziele ((R^2+R*r+r^2)*h*pi) / 3

	fxch st1	      ; zamieniam st0 i st1 miejscami
	ffree st1	      ; czyszcze st1
;;;;;;;;; KONIEC LICZENIA ;;;;;;;;;

;;;;;;;;; WYSWIETLANIE WYNIKU ;;;;;;;;;
	fstp qword [esp]      ; zapisuje st0 do pamieci
	push wynik
	call [printf]	      ; wyswietlam wynik

	push	pauza
	call	[system]
	call	[exit]
;;;;;;;;; KONIEC PROGRAMU ;;;;;;;;;

section '.data' data readable writeable
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)
	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	powitanie  db "Witam w programie obliczajacym objetosc stozka scietego.",13,10,"Nalezy podac promien R, promien r i wysokosc h.",13,10,"Nalezy wpisywac liczby calkowite.",13,10,"Objestsc liczona jest ze wzoru (R^2 + R*r + r^2) * h * pi / 3.",13,10,13,10,0
	int_	   db "%i",0
	podaj_R    db "Podaj R: ",0
	podaj_r    db "Podaj r: ",0
	podaj_h    db "Podaj h: ",0
	R_	   rd 1
	r_	   rd 1
	h_	   rd 1
	trzy	   dd 3
	test_	   db "%i %i %i",0
	wynik	   db 13,10,"Objetosc stozka scietego wynosi %f.",13,10,13,10,0


section '.idata' import data readable writeable
 dd 0, 0, 0, RVA msvcrt_name, RVA msvcrt_table
 dd 0, 0, 0, 0, 0

msvcrt_table:
 scanf	      dd RVA _scanf
 printf       dd RVA _printf
 exit	      dd RVA _exit
 system       dd RVA _system
	      dd 0

msvcrt_name db 'msvcrt.dll', 0
 _printf    dw 0
	    db	'printf', 0
 _scanf     dw 0
	    db	'scanf',  0
 _exit	    dw 0
	    db	'exit',   0
 _system    dw 0
	    db	'system', 0