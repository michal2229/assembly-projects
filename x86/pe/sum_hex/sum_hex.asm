; program sluzacy do obliczania sumy dwoch liczb heksadecymalnych
; liczby szesnastkowe wyswietlane sa w formacie 0xXYZ
; dozwolony przedzial to 0x1..0x7f


format PE console
entry poczatek


section '.text' code readable executable
poczatek:				 ; start programu

	push witam			 ; powitanie
	call [printf]			 ; wyswietlam komunikat

wczytywanie:
					 ; wczytuje dane
	push wpisz_A
	call [printf]

	push liczba_A
	push hex
	call [scanf]			 ; wczytuje A


	push wpisz_B
	call [printf]

	push liczba_B
	push hex
	call [scanf]			; wczytuje B


; liczenie
	mov eax, [liczba_A]		; przenosze A do eax
	cmp eax, 127
	jg blad
	cmp eax, 1
	jl blad

	mov ebx, [liczba_B]		; przenosze B do ebx
	cmp ebx, 127
	jg blad
	cmp ebx, 1
	jl blad

	add eax, ebx			; dodaje A do B



; koniec liczenia, wyswietlanie
	mov	[esp], eax		 ; zapisuje wynik na stosie
	push	wynik			 ; na wierzcholek stosu wrzucam komunikat o wyniku
	call	[printf]		 ; wyswietlam wynik
					 ; koniec programu

	push	pauza			 ; czekanie na dowolny klawisz
	call	[system]

	call	[exit]			 ; wyjscie z programu
blad:
	push blad_
	call [printf]
	jmp wczytywanie


section '.data' data readable writeable

	pauza	       db "pause",0

	hex	       db '%x',0	      ; format liczby heksadecymalnej

	wpisz_A        db 13,10,'Wpisz liczbe A: 0x',0
	wpisz_B        db 13,10,'Wpisz liczbe B: 0x',0

	wynik	       db 13,10,"Suma liczb szesnastkowych wynosi 0x%x.",13,10,0
	blad_		db 13,10,"Liczby musza zawierac sie w przedziale <0x1..0x7f> !",13,10,0

	suma_hex       rd 1   ; rezerwuje miejsce na dane
	liczba_A       rd 1
	liczba_B       rd 1

	witam	       db 'Witam w programie liczacym sume liczb szesnastkowych z przedzialu 1..127 <0x1..0x7f>.',13,10,'Nalezy podac dwie liczby szesnastkowe <0..9,a..f>.',13,10,0



section '.idata' import data readable writeable

	dd 0, 0, 0, RVA msvcrt_name, RVA msvcrt_table
	dd 0, 0, 0, 0, 0

	msvcrt_table:
		  scanf        dd RVA _scanf
		  printf       dd RVA _printf
		  exit	       dd RVA _exit
		  system       dd RVA _system
			       dd 0

	msvcrt_name	     db 'msvcrt.dll', 0
		  _printf    dw 0
			     db  'printf', 0
		  _scanf     dw 0
			     db  'scanf',  0
		  _exit      dw 0
			     db  'exit',   0
		  _system    dw 0
			     db  'system', 0


