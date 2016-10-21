; program liczacy silnie z liczby od 0 do 12

format PE console  ;typ programu to PE CONSOLE
entry poczatek		 ;punkt wejsciowy programu

; sekcja kodu

section '.text' code readable executable

poczatek:

push witaj 
call [printf] ; wyswietlenie komunikatu powitalnego

jeszcze_raz:

push podaj_liczbe
call [printf]; wyswietlenie prosby podania liczby

push liczb    ; wrzucam na stos adres komorki docelowej wpisania liczby
push integer ; wrzucam format liczby integer
call [scanf]	; odczytuje liczbe i zapisuje do pamieci

mov ebx, [liczb] ; przenosze liczbe do ebx

cmp ebx, 12 ; porownuje z 12 (jesli jest wieksza niz 12 to wynik silni nie zmiesci sie na 32 bitach)
jg jeszcze_raz

cmp ebx, 0 ; porownuje wartosc z zerem (jesli mniejsza to jeszcze raz)
jl jeszcze_raz

; wynik w bx
	mov ecx, 0
	mov ecx, ebx
	mov eax, 1
	mov ebx, 1
	cmp ecx, 2
	jl dalej ; jesli liczba mniejsza niz 2 to wynik = 1

silnia: ; petla doliczenia silni
	mov edx, 0
	mul ebx ; mnoze przez kolejne liczby (2,3,4,...)
	inc ebx ; zwiekszam liczbe, przez ktora mnoze o jeden
	loop silnia

dalej:

; wynik w ax
push eax ; przenosze 
push wynik
call [printf] ; wyswietlam wynik

	push	pauza
	call	[system]

	call	[exit]


; sekcja danych


section '.data' data readable writeable


	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)

	integer db '%i',0
	liczb rd 1

	witaj db " Witaj. Ten program sluzy do obliczania silni.",13,10
		db " Nalezy wprowadzic liczbe, z ktorej chcemy otrzymac silnie (0-12).",13,10
		db " Po wprowadzeniu niepoprawnej wartosci wprowadzanie zostanie ponowione.",0

	podaj_liczbe db 13,10,13,10," Z jakiej liczby chcesz policzyc silnie? (0-12): ",0

	wynik db 13,10, " Silnia tej liczby wynosi %i",13,10,0

; sekcja danych importowanych

section '.idata' import data readable writeable

	; IMAGE_IMPORT_DESCRIPTOR
	dd 0, 0, 0, RVA msvcrt_name, RVA msvcrt_table
	dd 0, 0, 0, 0, 0  ; the end with zero-fill

	; FirstThunk
	msvcrt_table:
		  scanf        dd RVA _scanf
		  printf       dd RVA _printf
		  exit	       dd RVA _exit
		  system       dd RVA _system
			       dd 0	 ; the end with zero-fill

	; Library name
	msvcrt_name	     db 'msvcrt.dll', 0
	; IMAGE_IMPORT_BY_NAME
		  _printf    dw 0		;hint
			     db  'printf', 0   ;Name
		  _scanf     dw 0
			     db  'scanf',  0
		  _exit      dw 0
			     db  'exit',   0
		  _system    dw 0
			     db  'system', 0

