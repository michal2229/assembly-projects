; obliczanie sumy kwadratow trzech liczb jednopozycyjnych

format PE console  ; typ programu to PE CONSOLE
entry poczatek		 ;punkt wejsciowy programu

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja kodu

section '.text' code readable executable

poczatek:

	push  witam		 ; wyswietlenie powitania
	call  [printf]

	mov   eax, liczba	 ; przenosze do eax adres komorki do ktorej ma byc wpisana liczba
	push  eax		 ; wrzucam adres na stos
	push  jednopozycyjna	 ; wrzucam symbol liczby jednopozycyjnej na stos
	call  [scanf]		 ; odczytuje wartosc od uzytkownika

	mov   eax, liczba
	add   eax, 4
	push  eax		 ; wrzucam na stos adres komorki, do ktorej wpisana ma byc druga liczba
	push  jednopozycyjna
	call  [scanf]

	mov   eax, liczba
	add   eax, 8
	push  eax		 ; wrzucam na stos adres komorki, do ktorej wpisana ma byc tzecia liczba
	push  jednopozycyjna
	call  [scanf]

	mov   eax, [liczba]	 ; przenosze pierwsza liczbe do eax
	mul   [liczba]		 ; robie kwadrat pierszej liczby
	mov   ebx, eax		 ; przenosze kwadrat pierwszej liczby do ebx

	mov   eax, [liczba+4]	 ; robie kwadrat drugiej liczby
	mul   [liczba+4]
	add   ebx, eax		 ; dodaje do ebx

	mov   eax, [liczba+8]
	mul   [liczba+8]
	add   ebx, eax		 ; dodaje kwadrat trzeciej liczby do ebx  -  mam wynik

	push  ebx		 ; wrzucam wynik
	push  [liczba+8]	 ; wrzucam liczbe trzecia
	push  [liczba+4]	 ; wrzucam liczbe druga
	push  [liczba]		 ; wrzucam liczbe pierwsza
	push  wynik		 ; wrzucam komunikat wyniku
	call  [printf]		 ; wyswietlam wynik

	push pauza		 ; czekam na nacisniecie klawisza
	call [system]

	call [exit]		 ; wyjscie z programu


; ------- end of code section ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych


section '.data' data readable writeable


	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)

	liczba rd 3		  ; trzy liczby wpisane przez uzytkownika
	jednopozycyjna db "%i",0  ; symbol liczby jednopozycyjnej

	witam db "Witam w programie liczacym sume kwadratow trzech liczb jednopozycyjnych.",13,10,"Prosze wprowadzic trzy liczby:",13,10,0  ; komunikat powitalny
	wynik db 13,10,13,10,"Suma %i^2 + %i^2 + %i^2 = %i.",13,10,13,10,0  ; komunikat wyniku


;------- end of data section --------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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