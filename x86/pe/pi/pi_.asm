; program liczacy liczbe pi

format PE console  ;typ programu to PE CONSOLE
entry poczatek		 ;punkt wejsciowy programu

;---------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja kodu

section '.text' code readable executable

poczatek: ; poczatek programu

push witaj
call [printf]

wpisywanie: ; powrot z bledu

push ilerazy ; wczytywanie wartosci ilosci wykonan petli
push integer
call [scanf]

mov ecx, dword [ilerazy]
cmp ecx, 0 ; sprawdzam, czy wpisane zostalo zero
je zlaliczba ; jesli tak to komunikat i wpisywanie ponowne

push dword [ilerazy] ; wyswietlanie ile razy wykona sie petla
push spoko  ; wyswietlanie ile razy wykona sie petla
call [printf]

mov ecx, dword [ilerazy] ; przenoszenie ilosci wykonan do ecx

; ladowanie wartosci poczatkowych:
; w rejestrach xmm_ znajduja sie po dwie liczby, wiec w jednej operacji liczone sa dwie liczby (czyli dwa ulamki - jeden dodatni, drugi ujemny; znak definiowany jest przy odejmowaniu po petli)
; w petli najpierw nastepuje dzielenie 1/m i 1/m+2 (wynik dzielenia do xmm1) a nastepnie dodanie wyniku dzielenia z xmm1 do dotychczasowego wyniku w xmm0
; nastepnie wartosci sum ulamkow mnozone sa razy 4 (ze wzoru)
; nastepnie od wartosci sumy ulamkow dodatnich odejmowana jest suma ulamkow ujemnych, otrzymujac wartosc ostateczna obliczonej wartosci liczby pi

mov eax, wynik
movupd xmm0, [eax] ; wynik w dwoch czesciach
movupd xmm1, [eax+8*2] ; wyniki czesciowe dodawane do xmm0
movupd xmm2, [eax+8*4] ; licznik: 1 1
movupd xmm3, [eax+8*6] ; mianownik n n+1
movupd xmm4, [eax+8*8] ; dodawanie do mianownika 2 2
movupd xmm5, [eax+8*10] ; 4 4 przez ktorze trzeba pomnozyc, aby miec wynik

petla: ; petla liczaca liczbe pi
	movapd xmm1, xmm2 ; przenosze licznik do xmm1
	divpd xmm1, xmm3 ; dziele licznik przez mianownik
	addpd xmm0, xmm1 ; dodaje wynik czastkowy do xmm0
	addpd xmm3, xmm4 ; dodaje do mianownikow 4, aby uzyskac kolejna wartosc mianownikow
loop petla

mulpd xmm0, xmm5 ; mnoze razy 4 (uzasadnione wzorem)
movupd xmm1, xmm0 ; kopiuje wynik do xmm1
shufps xmm1, xmm1, 01001110b ; zamieniam liczby miejscami

subpd xmm0, xmm1 ; odejmuje czesc ujemna od dodatniej (ze wzoru)

; wypisywanie wyniku
movupd [esp], xmm0 ; wynik z xmm0 na stos

push wynik_ ; wyswietlam komunikat wyniku
call [printf]

fldpi ; wczytuje do rejestru koprocesora wartosc pi
fst [realne_pi] ; zapisuje do pamieci wartosc pi

mov eax, realne_pi ; przenosze do eax adres wartosci pi

movupd xmm1, [eax] ; kopiuje realna wartosc pi do xmm1
movupd [esp], xmm1 ; kopiuje wartosc realna pi na stos, aby moc ja wyswietlic

push realne_pi_komunikat ; wyswietlam realna wartosc liczby pi
call [printf]

; koniec programu

push	pauza ; oczekiwanie na wcisniecie dowolnego klawisza
call	[system]

call	[exit] ; wychodzi z programu

zlaliczba:
	push wpiszpoprawnaliczbe
	call [printf]
	jmp wpisywanie

; ------- koniec sekcji kodu ------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych

section '.data' data readable writeable

	pauza	   db "pause",0   ; komenda cmd, czeka na klawisz
	wyjdz	   db "exit 0",0  ; komenda cmd, wychodzi z programu z kodem 0 (bez bledu)
	witaj	   db '   Witam w programie obliczajacym przyblizona wartosc liczby pi',13,10,'korzystajacym z algorytmu rozwiniecia w szereg sinusow.',13,10,'   Wzor: pi=4*(1/1 - 1/3 + 1/5 - 1/7 + ... + 1/(n-2) - 1/n).',13,10,13,10,'   Wpisz ile iteracji wykonac ma petla (1..4294967295): ',0
	spoko	   db 13,10,'   Petla wykona sie %u-krotnie.',13,10,0
	wpiszpoprawnaliczbe db 13,10,'      Prosze wpisac liczbe zawierajaca sie w przedziale 1..4294967295: ',0

	ilerazy dq 0 ; miejsce w pamieci przechowujace informacje o liczbie wykonan petli
	integer db '%u' ; znak liczby calkowitej

	wynik dq 0.0, 0.0 ; wyzerowany wynik jako wartosc poczatkowa obliczen
	czesciowe dq 0.0, 0.0 ; ulamki czesciowe
	licznik dq 1.0, 1.0 ; licznik ulamkow - zawsze rowny jeden
	mianownik dq 1.0, 3.0 ; wartosci poczatkowe mianownikow ulamka dodatniego i ujemnego
	dodaj dq 4.0, 4.0 ; mianowniki zwiekszaja sie o 4 z kazdym powtorzeniem petli
	
	poczworz dq 4.0, 4.0 ; wynik nalezy pomnozyc razy 4

	realne_pi dq 0.0 ; miejsce w pamieci na realna wartosc liczby pi wczytanej z koprocesora matematycznego
	wynik_ db 13,10,'   Obliczona wartosc liczby pi to: %18.15f.',13,10,0 ; komunikat o obliczonym pi
	realne_pi_komunikat db '   Realna wartosc liczby pi wynosi: %16.15f.',13,10,'      Blad wynika ze zbyt malej liczby powtorzen petli.',13,10,13,10,0 ; komunikat o realnym pi

;------- koniec sekcji danych --------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; sekcja danych importowanych

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
;------- koniec sekcji importu --------------------

