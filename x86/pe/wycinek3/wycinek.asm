format PE console  ;typ programu to PE CONSOLE
entry poczatek	   ;punkt wejsciowy programu

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja kodu
section '.text' code readable executable
poczatek: ;punkt wejsciowy programu

	push czesc ; wrzucam na stos adres komunikatu wpisania promienia
	call [printf]	   ; wyswietlam komunikat


	; wczytuje promien
	push wpisz_promien ; wrzucam na stos adres komunikatu wpisania promienia
	call [printf]	   ; wyswietlam komunikat

	push promien	; wrzucam na stos adres komorki docelowej wpisania promienia
	push format_int ; wrzucam format liczby calkowitej
	call [scanf]	; odczytuje promien i zapisuje do pamieci

	; wczytuje kat
	push wpisz_kat	; to samo dla kata
	call [printf]

	push kat
	push format_int
	call [scanf]

	; przenoszenie wartosci wpisanych do rejestrow xmm
	mov eax, kat	    ; przenosze do eax adres komorki z wartoscia, ktora chce zaladowac
	movlpd xmm0, [eax]  ; przenoszenie kata do pierwszej polowy xmm0
	cvtdq2pd xmm0, xmm0 ; konwertowanie kata na liczbe double

	mov eax, promien    ; przenosze do eax adres komorki z wartoscia, ktora chce zaladowac
	movlpd xmm1, [eax]  ; przenoszenie promienia do pierwszej polowy xmm1
	cvtdq2pd xmm1, xmm1 ; konwertowanie promienia na liczbe double

	mov eax, pomocnicze ; przenosze do eax adres komorki z wartoscia, ktora chce zaladowac
	movupd xmm2, [eax]  ; ladowanie wartosci pomocniczych pi i 360, one juz sa double, wiec nie konwertuje

	; liczenie
	mulpd xmm0, xmm1    ; mnoze kat * promien
	mulpd xmm0, xmm1    ; mnoze (kat * promien) * promien
	mulpd xmm0, xmm2    ; mnoze (kat * promien * promien) * pi
	shufps xmm2, xmm2, 01001110b ; zamieniam miejscami wartosci pomocnicze
	divpd xmm0, xmm2    ; dziele (kat * promien * promien * pi)/360

	; wyswietlanie
	movlpd [esp], xmm0  ; wynik z pierwszej polowy xmm0 wrzucam na wierzcholek stosu

	push wynik	    ; na wierzcholek stosu wrzucam komunikat o wyniku
	call [printf]	    ; wyswietlam wynik, czyli pole wycinka kola
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
	wpisz_promien db 13,10,'Wpisz promien: ',0 ; komunikat wpisania promienia
	wynik db 13,10,"Pole danego wycinka kola jest rowne %.2f.",13,10,0 ; komunikat wyniku

	czesc db 'Witam w programie liczacym pole wycinka kola ze wzoru:',13,10,'       P = r^2 * 3.14 * kat / 360',13,10,'Nalezy podac kat i promien.',13,10,0
	promien dd 0,0 ; 2x32bit miejsca zarezerwowanego, 32bit uzywane na wpisanie promienia do pamieci (nieuzywane wartosci takze sa wczytywane do pierwszej polowy rejestru xmm)
	kat dd 0,0     ; 2x32bit miejsca zarezerwowanego, 32bit uzywane na wpisanie kata do pamieci (nieuzywane wartosci takze sa wczytywane do pierwszej polowy rejestru xmm)
	pomocnicze dq 3.141592,360.0 ; 2 x 64bit miejsca zarezerwowanego, 2 x 64bit uzywane na wartosci pomocnicze

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

