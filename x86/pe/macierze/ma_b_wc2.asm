; program liczacy macierze

format PE console  ;The type of program is a PE CONSOLE
entry poczatek		 ;The entry point is poczatek

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; code section. this name is '.text'(code readable executable).

section '.text' code readable executable

poczatek:


	mov dword [esp], wpisz_m1
	call [printf]

	mov ebx, m1w1

	push ebx
	push liczby
	call [scanf]
	add ebx, 4


	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	 push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	 push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]
	add ebx, 4

	push ebx
	push liczby
	call [scanf]

	;add esp, 16*4

	; druga macierz
	mov dword [esp], wpisz_m2
	call [printf]

	mov ebx, m2k1

	push ebx
	push liczby
	call [scanf]
	add ebx, 16


	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	mov ebx, m2k1
	add ebx, 4

	 push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	mov ebx, m2k1
	add ebx, 8

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	mov ebx, m2k1
	add ebx, 12

	 push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]
	add ebx, 16

	push ebx
	push liczby
	call [scanf]


mov eax, m1w1 ; +16
	mov ebx,m2k1	 ; wykonuje obliczenia
		mov edx, w0


movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k2
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k3
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci


mov ebx, m2k4
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci


mov eax, m1w2 ; cos tu nie tak
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float



mov ebx,m2k1
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k2
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k3
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci
mov ebx, m2k4
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci


mov eax, m1w3 ; cos tu nie tak
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

mov ebx,m2k1
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k2
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k3
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k4
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov eax, m1w4 ; cos tu nie tak
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

mov ebx,m2k1
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k2
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k3
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci

mov ebx, m2k4
add edx, 16
	movdqa xmm1,[ebx]
	       cvtdq2ps xmm1,xmm1
	mulps xmm1, xmm0
	       cvtps2dq xmm1,xmm1  ; zamieniam spowrotem
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci
 ; mnozy macierze m1 i m2

 mov ebx, w0
 mov edx, wynik

  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec
  ; poczatek
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
   ; koniec   ; dodaje cztery skladniki wektora, tworzac komorke macierzy wynikowej



















; tu jest liczenie



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

	call	[exit]

; podprogramy

; ------- end of code section ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; data section. this name is '.data' (data readable executable).


section '.data' data readable writeable

	adresy	   rd 8 ; 8 miejsc na adresy uzywanych miejsc w pamieci

	liczba	   rd 16

	wynik	   rd 16
       ; testt      dd  21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36

	m1w1	   rd 4
	m1w2	   rd 4
	m1w3	   rd 4
	m1w4	   rd 4

	m2k1	   rd 4 ; macierz transponowana
	m2k2	   rd 4
	m2k3	   rd 4
	m2k4	   rd 4

	w0	   rd 16*4 ; 16 komorek po 4 liczby, ktore nalezy zsumowac

	ww1	   rd 4
	ww2	   rd 4
	ww3	   rd 4
	ww4	   rd 4


	znaki	   db "%s",0
	liczby	   db "%i",0
	nowa_linia db 13,10,0
	wpisales   db "Wpisales: %i %i %i %i.",13,10,0

	wiersz	   db "%i %i %i %i",13,10,0
	macierz    db "Macierz:",13,10,"%10i %10i %10i %10i",13,10,"%10i %10i %10i %10i",13,10,"%10i %10i %10i %10i",13,10,"%10i %10i %10i %10i",13,10,0

	wpisz_m1   db "Wpisz elementy pierwszej macierzy 4x4:",13,10,0
	wpisz_m2   db "Wpisz elementy drugiej macierzy 4x4:",13,10,0
	pauza	   db "pause",0
	wyjdz	   db "exit 0",0







;------- end of data section --------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; import section. this name is '.idata' (import data readable executable).

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

