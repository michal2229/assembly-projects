; program liczacy macierze

format PE console  ;The type of program is a PE CONSOLE
entry poczatek		 ;The entry point is poczatek

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; code section. this name is '.text'(code readable executable).

section '.text' code readable executable

poczatek:



mov eax, m1w1
movdqa xmm0, [eax]    ; przenosze 128bit (16B) z pamieci do xmm_, movq przenioslo by 64bit a movd 32bit
cvtdq2ps xmm0, xmm0 ;[ zamieniam 4 liczby 32bit int ze znakiem na 4 liczby 32bit float

	mov ebx,m2k1	   ; wykonuje obliczenia
	movdqa xmm1,[ebx]
	cvtdq2ps xmm1,xmm1

	mulps xmm1, xmm0

	cvtps2dq xmm1,xmm1  ; zamieniam spowrotem

	mov edx, w0
	movdqa [edx], xmm1    ; przenosze 128bit (16B) z xmm_ do pamieci


petlunia:










 mov eax, [w0]
 add eax, [w0+4*1]
 add eax, [w0+4*2]
 add eax, [w0+4*3]

 mov [wynik], eax

 mov eax, [w0+4*4]
 add eax, [w0+4*5]
 add eax, [w0+4*6]
 add eax, [w0+4*7]

 mov [wynik+4], eax

mov eax, testt
add eax, 4*4
movdqa xmm1, [eax]
mov eax, wynik
movdqa [eax+4*4], xmm1

mov eax, testt
add eax, 2*4*4
movdqa xmm2, [eax]
mov eax, wynik
movdqa [eax+2*4*4], xmm2

mov eax, testt
add eax, 3*4*4
movdqa xmm3, [eax]
mov eax, wynik
movdqa [eax+3*4*4], xmm3

add eax, [eax]



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



; ------- end of code section ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; data section. this name is '.data' (data readable executable).


section '.data' data readable writeable

	adresy	   rd 8 ; 8 miejsc na adresy uzywanych miejsc w pamieci

	liczba	   rd 16

	wynik	   dd  1,-2,3,-4,5,-6,7,-8,9,-10,11,-12,13,-14,15,-16
	testt	   dd  21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36

	m1w1	   dd 1 ,-2 ,3 ,-4
	m1w2	   dd -5 ,6 ,-7 ,8
	m1w3	   dd 9 ,-10,11,-12
	m1w4	   dd -13,14,-15,16

	m2k1	   dd -17,21,-25,29 ; macierz transponowana
	m2k2	   dd 18,-22,26,-30
	m2k3	   dd -19,23,-27,31
	m2k4	   dd 20,-24,28,-32

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

