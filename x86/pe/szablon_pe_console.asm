format PE console
entry poczatek	

section '.text' code readable executable

poczatek:

	push komunikat	   ; wyswietlam komunikat powitalny
	call [printf]	   ; wywoluje funkcje printf
	
	push a_x       ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf

	push a_y       ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf

	push b_x       ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf

	push b_y       ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf

	push c_x       ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf

	push c_y       ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf



fild dword [a_x]
fild dword [c_x]
fsub st0, st1
fmul st0, st0

fild dword [a_y]
fild dword [c_y]
fsub st0, st1
fmul st0, st0

fadd st0, st2
fsqrt
fst qword [a_]

ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7




fild dword [a_x]
fild dword [b_x]
fsub st0, st1
fmul st0, st0

fild dword [a_y]
fild dword [b_y]
fsub st0, st1
fmul st0, st0

fadd st0, st2
fsqrt
fst qword [c_]
ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7





fild dword [c_x]
fild dword [b_x]
fsub st0, st1
fmul st0, st0

fild dword [c_y]
fild dword [b_y]
fsub st0, st1
fmul st0, st0

fadd st0, st2
fsqrt
fst qword [b_]
ffree st0
ffree st1
ffree st2
ffree st3
ffree st4
ffree st5
ffree st6
ffree st7


	 fld qword [a_]  ; laduje dlugosci do stosu koprocesora
	 fld qword [b_]
	 fld qword [c_]

	 fadd st0, st1	  ; dodaje
	 fadd st0, st2
	 fld qword [pol]
	 fmul st0, st1

	 fst qword [p_]
	 ffree st0
	 ffree st1
	 ffree st2
	 ffree st3

	 fld qword [c_] ; st1
	 fld  qword [p_] ; st0
	 fsub st0, st1	 ; st0 -> st2 -> st4 -> st5
	 ;ffree st1

	 fld qword [b_] ; st1
	 fld  qword [p_] ; st0
	 fsub st0, st1	 ; st0 -> st2 ->  st3
	 ;ffree st1

	 fld qword [a_] ; st1
	 fld  qword [p_] ; st0
	 fsub st0, st1	 ; st0 -> st1
	 ;ffree st1

	 fld qword [p_]
	 fxch st3
	 fmul st0, st1
	 fmul st0, st3
	 fmul st0, st5

	 fsqrt ; pierwiastek


	fst	qword [esp] ;zapisuje wynik
	push wynik
	call [printf]	   ; wywoluje funkcje printf

	push	pauza
	call	[system]
	call	[exit]




section '.data' data readable writeable
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)
	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	komunikat  db "ADASDASDASD",13,10,13,10, 0
	integer    db "%i",0
	wynik	   db "asddd %f",13,10,0

	a_  dq 0
	b_  dq 0
	c_  dq 0

	a_x  dd 0
	b_x  dd 0
	c_x  dd 0

	a_y  dd 0
	b_y  dd 0
	c_y  dd 0

	pol dq 0.5

	p_  dq 16.0



section '.idata' import data readable writeable
 dd 0, 0, 0, RVA msvcrt_name, RVA msvcrt_table
 dd 0, 0, 0, 0, 0

msvcrt_table:
 scanf	      dd RVA _scanf
 printf       dd RVA _printf
 exit	      dd RVA _exit
 system       dd RVA _system
	      dd 0

msvcrt_name db 'msvcrt.dll', 0
 _printf    dw 0
	    db	'printf', 0
 _scanf     dw 0
	    db	'scanf',  0
 _exit	    dw 0
	    db	'exit',   0
 _system    dw 0
	    db	'system', 0