; program liczacy iloczyn macierzy 4x4 i wyswietlajacy wynik

format PE console  ;typ programu to PE CONSOLE
entry poczatek		 ;punkt wejsciowy programu

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja kodu

section '.text' code readable executable

poczatek:

       mov dword [esp], wstep  ; wrzucam na wierzcholek stosu tekst do wyswietlenia
       call [printf]	   ; wyswietlam tekst

       mov dword [esp], wpisz_m1
       call [printf]  ; wyswietlam komunikat

       mov ecx, 16  ; definiuje liczbe powtorzen petli
       mov ebx, m1w1 ; definiuje poczatkowy adres pamieci do wpisywania liczb

       loopa: ; petla pobierajaca liczby i wpisujaca do pamieci
	     mov dword [temp], ecx

	     push ebx
	     push liczby
	     call [scanf]
	     add ebx, 4

	     mov ecx, dword [temp]
       loop loopa



	; wczytuje druga macierz w postaci transponowanej

	mov dword [esp], wpisz_m2
	call [printf] ; wyswietlam komunikat

	mov ebx, m2k1  ; adres poczatkowy na liczby

	mov ecx, 4 ; liczba powtorzen petli wczytujacej kolumne 1
	loopb:
		mov dword [temp], ecx

		push ebx
		push liczby
		call [scanf]
		add ebx, 16

		mov ecx, dword [temp]
       loop loopb

       mov ebx, m2k1
       add ebx, 4
	       mov ecx, 4 ; liczba powtorzen petli wczytujacej kolumne 2
       loopc:
		mov dword [temp], ecx

		push ebx
		push liczby
		call [scanf]
		add ebx, 16

		mov ecx, dword [temp]
       loop loopc

       mov ebx, m2k1
       add ebx, 8

       mov ecx, 4 ; liczba powtorzen petli wczytujacej kolumne 3
       loopd_:
		mov dword [temp], ecx

		push ebx
		push liczby
		call [scanf]
		add ebx, 16

		mov ecx, dword [temp]
       loop loopd_

       mov ebx, m2k1
       add ebx, 12

       mov ecx, 4 ; liczba powtorzen petli wczytujacej kolumne 4
       loope_:
		mov dword [temp], ecx

		push ebx
		push liczby
		call [scanf]
		add ebx, 16

		mov ecx, dword [temp]
       loop loope_

 ; zaczynam mnozenie wczytanych macierzy

mov eax, m1w1 ; adres wiersza 1
mov ebx,m2k1  ; adres kolumny 1
mov edx, w0   ; adres poczatku pamieci pomocniczej, w ktorej zachowywane sa skladniki macierzy

movdqa xmm0, [eax]    ; przenosze wiersz pierwszy do xmm0 (rejestr sse)
cvtdq2ps xmm0, xmm0 ; zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

       mov ecx,4
       loopy:
	       mov dword [temp], ecx

	       movdqa xmm1,[ebx]
		      cvtdq2ps xmm1,xmm1
	       mulps xmm1, xmm0
		      cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	       movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

	       add ebx, 16 ;przechodze do nastepnej kolumny
	       add edx, 16 ; skacze o 4 liczby w macierzy pomocniczej

	       mov ecx, dword [temp]
       loop loopy


add eax, 16 ; przechodze do nastepnego wiersza
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

       mov ebx,m2k1
       mov ecx,4
       loopx:
	       mov dword [temp], ecx

	       movdqa xmm1,[ebx]
		      cvtdq2ps xmm1,xmm1
	       mulps xmm1, xmm0
		      cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	       movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

	       add ebx, 16
	       add edx, 16

	       mov ecx, dword [temp]
       loop loopx

add eax, 16
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

       mov ebx,m2k1
       mov ecx,4
       loopw_:
	       mov dword [temp], ecx

	       movdqa xmm1,[ebx]
		      cvtdq2ps xmm1,xmm1
	       mulps xmm1, xmm0
		      cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	       movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

	       add ebx, 16
	       add edx, 16

	       mov ecx, dword [temp]
       loop loopw_

add eax, 16
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

       mov ebx,m2k1
       mov ecx,4
       loopv:
	       mov dword [temp], ecx

	       movdqa xmm1,[ebx]
		      cvtdq2ps xmm1,xmm1
	       mulps xmm1, xmm0
		      cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	       movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

	       add ebx, 16
	       add edx, 16

	       mov ecx, dword [temp]
       loop loopv  ; mnozy macierze m1 i m2

 mov ebx, w0
 mov edx, wynik
 mov ecx, 16

       loopz_: ; petla sumujaca czworki skladnikow do wynikowej komorki macierzy i zapisuje komorke w odpowiednim miejscu pamieci
		mov dword [temp], ecx

		mov eax, [ebx]

		add ebx, 4
		add eax, [ebx]

		add ebx, 4
		add eax, [ebx]

		add ebx, 4
		add eax, [ebx]

		mov [edx], eax
		add edx, 4
		add ebx, 4

		mov ecx, dword [temp]
       loop loopz_
      ; koniec   ; dodaje cztery skladniki wektora, tworzac komorke macierzy wynikowej


; odwracam wynikowa macierz i wyswietlam wynik
	mov ebx, wynik
	add ebx, 4*15
	mov ecx, 16
	wynik_na_stos:
		push dword [ebx]
		sub ebx, 4
	loop wynik_na_stos

	push macierz
	call [printf]

    
; koniec programu
	push	pauza
	call	[system]

	push odczekaj
	call [system]

	call	[exit]


; ------- end of code section ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych


section '.data' data readable writeable

	temp	   rd 8 ; 8 miejsc na adresy uzywanych miejsc w pamieci, sluzy glownie do zapamietania wartosci ecxprzy wykonywaniu petli

	wynik	   rd 16  ; macierz wynikowa

	m1w1	   rd 4 ; macierz wejsciowa pierwsza
	m1w2	   rd 4
	m1w3	   rd 4
	m1w4	   rd 4

	m2k1	   rd 4 ; macierz wejsciowa druga, transponowana
	m2k2	   rd 4
	m2k3	   rd 4
	m2k4	   rd 4

	w0	   rd 16*4 ; macierz pomocnicza zawierajaca 16 komorek po 4 liczby, ktore nalezy zsumowac

	liczby	   db "%i",0 ; format liczb wprowadzanych
	nowa_linia db 13,10,0

	macierz    db 13,10,"Wynik:",13,10,"|%10i %10i %10i %10i|",13,10,"|%10i %10i %10i %10i|",13,10,"|%10i %10i %10i %10i|",13,10,"|%10i %10i %10i %10i|",13,10,0  ; tekst wyswietlany i miejsca na liczby

	wstep	   db "Program sluzy do obliczania iloczynu dwoch macierzy 4x4.",13,10,"Uzytkownik wprowadza 16 liczb z zakresu od -23000 do 23000 do kazdej maierzy.",13,10,0
	wpisz_m1   db 13,10,"Wpisz elementy pierwszej macierzy 4x4:",13,10,0
	wpisz_m2   db 13,10,"Wpisz elementy drugiej macierzy 4x4:",13,10,0
	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	odczekaj   db "sleep 2",0 ; komenda cmd, czeka 2 sekundy
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)



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
;------- end of import section --------------------

