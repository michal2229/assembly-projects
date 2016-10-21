format PE console  ; typ programu to PE CONSOLE
entry poczatek		 ;punkt wejsciowy programu

; sekcja kodu

section '.text' code readable executable

poczatek:


push kom_pocz ; wyswietlam komunikat poczatkowy
call [printf]

push podaj_liczbe ; komunikat wpisania liczby
call [printf]

push ilosc  ; wczytuje liczbe do komorki ilosc
push int_
call [scanf]

push [ilosc]
push wynik   ; komunikat wyniku
call [printf]

; wprowadzam wartosci poczatkowe
mov ebx,1
mov [L], ebx

mov eax, 0

mov ecx, [ilosc]
mov [C1], ecx

cmp ecx, 2
jl petla1

push  2 ; wyswietlam dwojke
push liczba
call [printf]

petla1:       ; petla skanujaca od 1 do liczba
	mov ebx, [L] ; przenosze liczbe do ebx
	inc ebx      ; zwiekszam ebx o 1
	mov ecx, ebx ; kopiuje ebx do ecx
	mov [L], ebx ; przenosze powiekszone o jeden L do L

	petla2: 	       ; petla skanujaca od L do 2
		 dec ecx		   ; zmniejszam ecx o jeden
		 mov [C2], ecx		   ; przenosze ecx do C2
			xor edx, edx	   ; zeruje edx
			mov eax, [L]
			mov ebx, [C2]
			div ebx 	   ; dziele L/C2
			cmp edx, 0	   ; sprawdzam, czy reszta z dzielenia rowna jest zer0
			je nie_wyswietlaj  ; jesli jest rowna, to liczba jest podzielna, wiec nie ma sensu dalej liczyc, lczba nie pasuje
			xor edx, edx
	mov ecx, [C2]
	cmp ecx, 2
	jg petla2


	push [L]
	push liczba
	call [printf]  ; wyswietlam liczbe piewsza

	nie_wyswietlaj:

mov ebx, [L]
cmp ebx,[C1]
jl petla1

	push newline	   ; nowa linia
	call [printf]

	push	pauza
	call	[system]   ; koniec programu

	call	[exit]


; sekcja danych


section '.data' data readable writeable


	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)
	
	ilosc rd 40
	int_ db "%i",0
	liczba db "%20i",0
	newline db 13,10,13,10,0
	
	kom_pocz db "Witaj w programie wyliczajacym liczby pierwsze.",13,10,13,10 ,0
	wynik db 13,10,"Oto ciag liczb pierwszych z zakresu 0..%i:",13,10,13,10,0
	podaj_liczbe db "Podaj do jakiej liczby chcesz wyswietlic liczby pierwsze: ",0

	L rd 1	; aktualnie przetwarzana liczba
	C1 rd 1 ; liczba sterujaca petla zewnetrzna
	C2 rd 1 ; liczba sterujaca petla wawnetrzna


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


