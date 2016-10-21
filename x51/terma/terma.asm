; program do sterowania terma z woda

; na poczatku uzytkownik ustawia zadna temperature na suwaku ADC (w realnym ukladzie bylby podlaczony do potencjometru)
; uzytkownik zatwierdza wybor temperatury za pomoca przycisku (SW0, wcisniety to akceptacja, mozna do zwolnik i ustawic temperature ponownie)
; program sprawdza czy ilosc wody jest wystarczajaca aby zaczac grzac (SW1 jako czujnik, wcisniety to wystarczajaca ilosc wody)
; jesli poziom wody jest zbyt niski nastepuje dolewanie sygnalizowane dioda LED6
; jesli ilosc wody jest wystarczajaca porownywana jest temperatura wody z zadana (termometr podlaczony do ADC)
; jesli temperatura wody nie jest wystarczajaca nastepuje ogrzewanie sygnalizowane dioda LED7
; nastepuje skok do sprawdzania zatwierdzenia temp. wody, jesli wcisniety, to kontynuuje, jesli nie to wczytuje nowa wartosc temperatury od uzytkownika

; termometr ma zakres od zera do 85*C
; w realnym ukladzie dioda bylaby podlaczona do innego portu niz wyswietlacz 7seg

; program dziala najlepiej z czestotliwoscia odswiezania ustawiona na 10




start:
	call ustawienia_poczatkowe ; ustawiam wartosci segmentow dla poszczegolnych cyfr, aby mozna bylo przetlumaczyc

ustaw_temp:
	call koniec_grzania ; jak niezatwierdzona wartosc temp to nie grzej
	call odczyt_adc_nastawa_temp_wody ; odczytuje temperature od uzytkownika
	mov 20h, r0 ; temperatura wody zadana Tz przez uzytkownika kopiowana do 20h
	call wyswietlanie_temperatury

zatwierdzanie:
jb p2.0, ustaw_temp ; jesli klawisz zatwierdzenia nie jest wcisniety to powtorz odczyt

poziom_wody:
	jnb p2.1, przestan_dolewac ; jesli czujnik wody jest na zero to dolewa wode (SW7)
	call dolewaj
	call koniec_grzania ; jak za malo jest wody to nie grzej

	call odczyt_adc_temp_wody 
	call wyswietlanie_temperatury
jmp poziom_wody

przestan_dolewac:
	call koniec_dolewania

	call odczyt_adc_temp_wody
	mov 21h, r0 ; temperatura wody Tw kopiowana do 21h
	call wyswietlanie_temperatury

; sprawdzenie czy Twody < Tzadana
	mov a, 21h
	mov b, 20h
	subb a, b ; Tw - Tz
	jnb acc.7, przestan_grzac  ; jesli (Tw-Tz) >=0 to przestan grzac

	call grzej
	jmp zatwierdzanie

przestan_grzac:
	call koniec_grzania
	jmp zatwierdzanie



	
	
	
	
;;;;;;;;; procedury ;;;;;;;;;;;




wyswietlanie_temperatury:
	call przetworz_odczyt_adc_na_temp
	call tlumacz_na_bcd

	mov r0, #11 ; pierwszy segment pusty
	mov a, r2 ; przesuwam dwa segmenty o jeden w lewo
	mov r1, a

	mov a, r3
	mov r2, a

	mov r3, #10 ; do ostatniego segmentu wpisuje litere C oznaczajaca stopnie Cejsjusza

	call tlumacz_na_7segment
	setb p0.7 ; wlaczam wysw. 7seg
	call wyswietl
	clr p0.7 ; wylaczam wysw. 7seg
ret





przetworz_odczyt_adc_na_temp: ; procedura przyjmuje (r0), zwraca (r0)
	mov a, r0
	mov b, #3 ; 0 - 0*C; 255 - 85*C
	div ab
	mov r0, a
ret





dolewaj:
	clr p1.6
ret

koniec_dolewania:
	setb p1.6
ret





grzej:
	clr p1.7
ret

koniec_grzania:
	setb p1.7
ret





ustawienia_poczatkowe:
	mov 60h, #11000000b ; cyfra 0
	mov 61h, #11111001b ; cyfra 1
	mov 62h, #10100100b ; cyfra 2
	mov 63h, #10110000b ; cyfra 3
	mov 64h, #10011001b ; cyfra 4
	mov 65h, #10010010b ; cyfra 5
	mov 66h, #10000010b ; cyfra 6
	mov 67h, #11111000b ; cyfra 7
	mov 68h, #10000000b ; cyfra 8
	mov 69h, #10010000b ; cyfra 9
	mov 6ah, #11000110b ; litera C
	mov 6bh, #11111111b ; pusty
ret





odczyt_adc_temp_wody: ; procedura zwraca (r0) 
		; reset adc
		clr p3.6 ; wylaczenie pomiaru
		setb p3.7 ; linia adc odcieta od p2
		setb p3.6 ; wlacza pomiar adc
   	 
		; sprawdzenie czy konwerter skonwertowal
 		jb p3.2, $ ; jesli nie skonczyl konwersji to rob nic
      	
		clr p3.7   ; linia adc na p2
		mov r0, p2 ; przenosze wynik

		clr p3.6 ; wylaczenie pomiaru
		setb p3.7 ; linia adc odcieta od p2
ret





odczyt_adc_nastawa_temp_wody:; procedura zwraca (r0) 
		; reset adc
		clr p3.6 ; wylaczenie pomiaru
		setb p3.7 ; linia adc odcieta od p2
		setb p3.6 ; wlacza pomiar adc
   	 
		; sprawdzenie czy konwerter skonwertowal
 		jb p3.2, $ ; jesli nie skonczyl konwersji to rob nic
      	
		clr p3.7   ; linia adc na p2
		mov r0, p2 ; przenosze wynik

		clr p3.6 ; wylaczenie pomiaru
		setb p3.7 ; linia adc odcieta od p2
ret





tlumacz_na_bcd: ; procedura przyjmuje (r0), zwraca (r0, r1, r2, r3)
	; setki
	mov a, r0
	mov b, #10
	div ab
	mov r3, b
	
	; dziesiatki
	mov b, #10
	div ab
	mov r2, b

	; jednosci
	mov r1, a

	; tysiace
	mov r0, #0
ret





tlumacz_na_7segment: ; procedura przyjmuje wartosci (r0, r1, r2, r3), zwraca (70h, 71h, 72h, 73h)
		mov 50h, r0 ; zachowanie wartosci r0
	mov a, r0 ; tysiace
	add a, #60h ; dodaje 60h, bo jest to poczatkowy adres wartosci przetlumaczonych na 7seg
	mov r0, a
	mov 70h, @r0	
		mov r0, 50h ; przywrocenie wartosci r0

	mov a, r1 ; setki
	add a, #60h
	mov r0, a
	mov 71h, @r0	
 
	mov a, r2 ; dziesiatki
	add a, #60h
	mov r0, a
	mov 72h, @r0
 
	mov a, r3 ; jednosci
	add a, #60h
	mov r0, a
	mov 73h, @r0
ret





wyswietl: ; procedura przyjmuje wartosci (70h, 71h, 72h, 73h)
	mov p1, #255 ; gaszenie segmentow, zeby nie migalo
	orl p3, #00011000b ; ustawianie, ktory segment zapalic
	mov p1, 70h ; ustawianie wartosci na segmencie

	call odczekaj

	mov p1, #255 
	xrl p3, #00001000b
	mov p1, 71h 
	
	call odczekaj

	mov p1, #255 
	xrl p3, #00011000b
	mov p1, 72h 

	call odczekaj

	mov p1, #255
	xrl p3, #00001000b
	mov p1, 73h 

	call odczekaj

	mov p1, #255 ; koncowe gaszenie segmentu
ret





odczekaj: 
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
ret