; program porownujacy liczbe float i double

format PE console  ;typ programu to PE CONSOLE
entry start	      ;punkt wejsciowy programu

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja kodu

section '.text' code readable executable

start: ; poczatek programu

push witaj ; komunikat powitalny
call [printf]

push wpiszlicznik
call [printf] ; komunikat wpisania licznika

push licznik ; adres dla wyniku wpisania
push integer ; format wpisywanych danych
call [scanf] ; czytanie danych


push wpiszmianownik
call [printf] ; komunikat wpisania mianownika

push mianownik ; adres dla wyniku wpisania
push integer ; format wpisywanych danych
call [scanf] ; czytanie danych


mov eax, licznik ; przenosze adres licznika do eax
mov ebx, mianownik ; przenosze adres mianownika do ebx

movups xmm6, [eax] ; przenosze licznik do xmm6
movups xmm7, [ebx] ; przenosze mianownik do xmm7

cvtdq2ps xmm0, xmm6 ; L zamieniany na liczbe zmiennoprzecinkowa pojedynczej precyzji
cvtdq2ps xmm1, xmm7 ; M zamieniany na liczbe zmiennoprzecinkowa pojedynczej precyzji
divps xmm0, xmm1 ; L/M - dzielnie

cvtps2pd xmm0, xmm0 ; L/M single -> double precision

cvtdq2pd xmm2, xmm6 ; L double
cvtdq2pd xmm3, xmm7 ; M double
divpd xmm2, xmm3 ; L/M double

movupd xmm1, xmm0 ; przenosze wynik single do xmm1
subpd xmm1, xmm2  ; odejmuje single - double

movupd [esp], xmm0 ; przenosze single jako argument 4. funkcji printf
movupd [esp+8], xmm2 ; przenosze double jako argument 3. funkcji printf
movupd [esp+8*2], xmm1 ; przenosze roznice jako argument 2. funkcji printf

push liczby ; przenosze adkres tekstu (1. argument f. printf)
call [printf] ; wyswietlam wynik

; koniec programu

push	pauza ; oczekiwanie na wcisniecie dowolnego klawisza
call	[system] ; wywoluje cmd

call	[exit] ; wychodzi z programu


; ------- koniec sekcji kodu ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych

section '.data' data readable writeable

	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz

	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)

	witaj	   db '   Witam w programie porownujacym liczby pojedynczej i podwojnej precyzji.',13,10
				db '   Nalezy wpisac licznik L i mianownik M liczby.',13,10
				db '   Wynikowe liczby to wynik dzielenia L/M w pojedynczej i podwojnej precyzji.',13,10
				db '   Te liczby zostana nastepnie porownane ze soba.',13,10,0

	wpiszlicznik db 13,10,'Prosze wpisac licznik: ',0
	wpiszmianownik db 13,10,'Prosze wpisac mianownik: ',0

	integer db '%i',0 ; format liczby calkowitej ze znakiem

	licznik rd 4

	mianownik rd 4

	liczby db 13,10, 'Liczba L/M ma wartosc:',13,10,13,10,'   pojedyncza precyzja      podwojna precyzja',13,10,'  %10.17f        %10.17f',13,10,13,10,13,10,'Roznica pomiedzy liczba pojedynczej precyzji a podwojnej precyzji wynosi:',13,10,'  %10.25f',13,10,13,10,0

;------- koniec sekcji danych --------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych importowanych

section '.idata' import data readable writeable
	dd 0, 0, 0, RVA msvcrt_name, RVA msvcrt_table
	dd 0, 0, 0, 0, 0 

	msvcrt_table:
		  scanf        dd RVA _scanf
		  printf       dd RVA _printf
		  exit	       dd RVA _exit
		  system       dd RVA _system
			       dd 0

	msvcrt_name	     db  'msvcrt.dll', 0
		  _printf    dw 0		
			     db  'printf', 0  
		  _scanf     dw 0
			     db  'scanf',  0
		  _exit      dw 0
			     db  'exit',   0
		  _system    dw 0
			     db  'system', 0
;------- koniec sekcji importu --------------------

