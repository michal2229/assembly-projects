; program sluzacy do obliczania pola pierscienia powstalego z kola i elipsy
; wpisywane sa liczby calkowite


format PE console			 ; typ programu to PE CONSOLE
entry begin				 ; punkt wejsciowy programu

; sekcja kodu
section '.text' code readable executable
begin:					 ; punkt wejsciowy programu

	push witam			 ; wrzucam na stos adres komunikatu powitalnego
	call [printf]			 ; wyswietlam komunikat

wpisywanie:
					 ; wczytuje promien kola
	push wpisz_promien_kola 	 ; wrzucam na stos adres komunikatu wpisania promienia
	call [printf]			 ; wyswietlam komunikat

	push promien_kola		 ; wrzucam na stos adres komorki docelowej wpisania promienia
	push i_ 			 ; wrzucam format liczby calkowitej
	call [scanf]			 ; odczytuje predkosc i zapisuje do pamieci

					 ; wczytuje promien kola
	push wpisz_promienie_elipsy	 ; wrzucam na stos adres komunikatu wpisania promienia
	call [printf]			 ; wyswietlam komunikat

	push promienie_elipsy		 ; wrzucam na stos adres komorki docelowej wpisania promienia
	push i_ 			 ; wrzucam format liczby calkowitej
	call [scanf]			 ; odczytuje predkosc i zapisuje do pamieci

	push drugi_promien_elipsy	 ; wrzucam na stos adres komorki docelowej wpisania promienia
	push i_ 			 ; wrzucam format liczby calkowitej
	call [scanf]			 ; odczytuje predkosc i zapisuje do pamieci

					 ; koniec wczytywania danych
					 ; zaczyna sie liczenie


					 ; sprawdzam poprawnosc wpisania danych (czy kolo i elipsa sie nie przecinaja)
	mov eax, [promien_kola] 	 ; laduje promien kola
	mov ebx, [promienie_elipsy]	 ; laduje 1 promien elipsy
	mov ecx, [drugi_promien_elipsy]  ; laduje 2 promien elipsy


	sub ebx, eax
	sub ecx, eax

	mov eax, ecx
	mul ebx
	cmp eax, 0
	jge ok				 ; jesli (Re1 - Rk) * (Re2 - Rk) >= 0 to przeciecie nie wystepuje

	push blad			 ; komunikat bledu
	call [printf]

	jmp wpisywanie			 ; skok do poczatku wpisywania danych


	ok:

	finit				 ; wlaczam fpu

	fild dword [promien_kola]	 ; st0 = Rk
	fmul st0, st0			 ; st0 = Rk^2

	fild dword [promienie_elipsy]
	fild dword [drugi_promien_elipsy]
	fmul st0, st1			 ; st0 = Re1*Re2     ; st2 = Rk^2

	fsub st0, st2			 ; st0 = Re1*Re2 - Rk^2

	fldpi				 ; st0 = pi          ; st1 = Re1*Re2 - Rk^2
	fmul st0, st1			 ; st0 = (Re1*Re2 - Rk^2)*pi = Pe - Po

	fmul st0, st0			 ; st0 = (Pe - Po)^2
	fsqrt				 ; st0 = |Pe - Po|


	fst	qword [esp]		 ; zapisuje wynik na stosie
	push	wynik			 ; na wierzcholek stosu wrzucam komunikat o wyniku
	call	[printf]		 ; wyswietlam wynik
					 ; koniec programu

	push	pauza			 ; czekanie na dowolny klawisz
	call	[system]

	call	[exit]			 ; wyjscie z programu



section '.data' data readable writeable

	pauza		       db "pause",0	      ; czeka na klawisz

	i_		       db '%i',0	      ; format liczby int

	wpisz_promien_kola     db 13,10,'Wpisz promien Rk: ',13,10,0						  ; komunikat wpisania kata
	wpisz_promienie_elipsy db 13,10,'Wpisz promienie Re1 i Re2: ',13,10,0					  ; komunikat wpisania predkosci

	blad		       db 13,10,"Figury przecinaja sie! Prosze dobrac inne parametry.",13,10,13,10,0	  ; komunikat bledu

	wynik		       db 13,10,"Pole pierscienia skladajacego sie z kola i elipsy wynosi %f",13,10,0	  ; komunikat wyniku

	pole		       rq 1	     ; wynik

	promien_kola	       rd 1	     ; miejsce na promien kola, dwie komorki dla ulatwienia

	promienie_elipsy       rd 1	     ; miejsce na promienie elipsy
	drugi_promien_elipsy   rd 1

	witam		       db 'Witam w programie liczacym pierscien z kola i elipsy:',13,10,'Nalezy podac promien kola Rk i promienie elipsy Re1 i Re2.',13,10,0



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


