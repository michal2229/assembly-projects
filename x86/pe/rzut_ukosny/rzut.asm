format PE console  ;typ programu to PE CONSOLE
entry poczatek	   ;punkt wejsciowy programu

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja kodu
section '.text' code readable executable
poczatek: ;punkt wejsciowy programu

	push witam ; wrzucam na stos adres komunikatu powitalnego
	call [printf]	   ; wyswietlam komunikat

	; wczytuje predkosc
	push wpisz_predkosc ; wrzucam na stos adres komunikatu wpisania predkosci
	call [printf]	   ; wyswietlam komunikat

	push predkosc	 ; wrzucam na stos adres komorki docelowej wpisania predkosci
	push format_int ; wrzucam format liczby calkowitej
	call [scanf]	; odczytuje predkosc i zapisuje do pamieci

	; wczytuje kat
	push wpisz_kat	; to samo dla kata
	call [printf]

	push kat
	push format_int
	call [scanf]

	finit ; wlaczam fpu
	fild dword [kat] ; wrzucam kat na wierzcholek (w stopniach! chce zmienic na radiany)
	fldpi ; wrzucam na wierzcholek pi
	fmul st0, st1 ; mnoze razy pi i wrzucam na wierzcholek
	fld qword [pomocnicza]
	fdiv st1, st0
	fxch st1 ; w st0 jest kat w radianach
	fst dword [kat]
	fld st0
	fsin ; w st0 mamy sinus kata

	fild dword [predkosc]
	fld st0
	fmul st0, st2 ; w st0 (sina*V)
	fmul st0, st0 ; w st0 (sina*V)^2
	fld  qword [pomocnicza+8] ; lagowanie 2g
	fdiv st1, st0
	fxch st1 ; W ST0 JEST WYSOKOSC MAKSYMALNA
	fstp qword [wysokosc]

	ffree st6 ; czyszcze stos z niepotrzebnych rzeczy
	ffree st5
	ffree st4
	ffree st3
	ffree st2

	fld st1 ; laduje na wierzcholek predkosc
	fmul st0, st0; robie kwadrat predkosci
	fld dword [kat] ; laduje kat
	fadd st0, st0 ; robie 2*kat
	fsin ; robie sin(2*kat)
	fmul st0, st1
	fld qword [pomocnicza+16]
	fdiv st1, st0
	fxch st1
	fstp qword [zasieg]

	mov eax, wysokosc
	movupd xmm0, [eax]
	movlpd [esp], xmm0

	mov eax, zasieg
	movupd xmm0, [eax]
	movlpd [esp+8], xmm0

	push wynik	    ; na wierzcholek stosu wrzucam komunikat o wyniku
	call [printf]	    ; wyswietlam wynik
	; koniec programu

	push	pauza	    ; czekanie na dowolny klawisz
	call	[system]

	call	[exit]	    ; wyjscie z programu


; ------- koniec kodu ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych
section '.data' data readable writeable

	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)

	format_int db '%i',0  ; format liczby calkowitej, do wpisywania
	wpisz_kat db 13,10,'Wpisz kat: ',0  ; komunikat wpisania kata
	wpisz_predkosc db 13,10,'Wpisz predkosc: ',0 ; komunikat wpisania predkosci
	wynik db 13,10,"Wysokosc maksymalna jest rowna %fm a zasieg %fm",13,10,0 ; komunikat wyniku
	wysokosc dq 6.9456
	zasieg dq 7.77777

	witam db 'Witam w programie liczacym wysokosc maksymalna i zasieg w rzucie ukosnym:',13,10,'Nalezy podac kat [stopnie] i predkosc poczatkowa [m/s].',13,10,0
	predkosc dd 0 ; miejsce na predkosc wpisana
	kat dd 0     ; miejsce na kat
	pomocnicza dq 180.0, 19.6133, 9.80665,0 ; pi rad, 2*g, g - zeby nie robic sobie prolemu

;------- koniec danych --------------------
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
		  _printf    dw 0
			     db  'printf', 0
		  _scanf     dw 0
			     db  'scanf',  0
		  _exit      dw 0
			     db  'exit',   0
		  _system    dw 0
			     db  'system', 0
;------- koniec importu --------------------

