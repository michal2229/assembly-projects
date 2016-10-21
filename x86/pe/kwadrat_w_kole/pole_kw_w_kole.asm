; Obliczanie pola kwadratu wpisanego w koło
; Zadaniem jest obliczenie pola kwadratu wpisanego w koło. Użytkownik wpisuje promień r koła, wynik wyśwetlany jest na ekranie.
; Wzór wykorzystany do liczenia pola kwadratu to: P = d^2/2, gdze d to średnica;  d = 2r.
; Poprawne wartości promienia to zakres od zera do 65535.
; 
; program wspolpracuje z edytorem FASM

format PE console
entry begin

section '.text' code readable executable

begin:
	push komunikat	   ; wyswietlam komunikat powitalny
	call [printf]	   ; wywoluje funkcje printf
	
	push promien	   ; wrzucam adres wyniku na stos
	push integer	   ; wrzucam na stos symbol liczby calkowitej
	call [scanf]	   ; wywoluje funkcje scanf

	mov eax, [promien] ; wczutuje promien do eax
	shl eax, 1	   ; mnoze promien razy dwa, uzyskujac srednice
	mul eax 	   ; mnoze eax*eax, dostaje kwadrat srednicy
	shr eax, 1	   ; dziele d^2 przez 2 (przesuniecie o jeden bit w prawo)

	mov [pole], eax    ; przenosze wynik do pamieci

	push [pole]	   ; wrzucam wynik na stos
	push wynik	   ; wrzucam komunikat wyniku na stos
	call [printf]	   ; wyswietlam wynik

	push	pauza	   ; oczekuje na wcisniecie dowolnego klawisza
	call	[system]
	call	[exit]	   ; zamykam program

section '.data' data readable writeable
	wyjdz		    db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)
	pauza		    db "pause",0  
	komunikat	    db "Witam w programie do obliczania pola kwadratu wpisanego w kolo ze wzoru:",13,10,"        P = (d^2)/2, gdzie d to srednica kola.",13,10,13,10,"Nalezy podac promien kola: ",0
	wynik		    db "Pole kwadratu wynosi: %i", 13,10,13,10,0
	integer 	    db "%i",0 ; symbol liczby calkowitej
	promien 	    rd 1 ; rezerwacja jednej liczby dword
	pole		    rd 1 ; rezerwacja jednej liczby dword

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
