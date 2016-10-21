MOV R4, #128 ; AMPLITUDA DOMYSLNA
MOV R5, #128 ; OKRES DOMYSLNY
MOV R6, #128 ; OFFSET (STALY)

MOV A, R5 ; OKRES DOMYSLNY
MOV R1, A ; OKRES TYMCZASOWY = OKRES DOMYSLNY

START:
	MOV A, R6 ; OFFSET (STALY)
	MOV R2, A ; POCZATEK NA OKRESIE DOMYSLNYM
	CALL LICZENIE ; WYWOLANIE PROCEDURY PRZELICZAJACEJ WARTOSCI WEJSCIOWE NA PRAWIDLOWE DO DZIALANIA PROGRAMU

	CLR P0.7 ; WLACZAM OSCYLOSKOP

	CALL GORA_POLOWA ; WYWOLANIE FUNCJI RYSUJACEJ LINIE OD POLOWY DO WARTOSCI MAKSYMALNEJ

	TROJKAT: ; PETLA RYSUJACA PRZEBIEG TROJKATNY NA OSCYLOSKOPIE
		JNB P2.0, CZYTANIE_AMPLITUDY ; PRZY WCISNIECIU PRZYCISKU SW0 NASTEPUJE ODCZYT WARTOSCI AMPLITUDY Z ADC, ZWOLNIENIE PRZYCISKU OZNACZA AKCEPTACJE WYBRANEJ WATOSCI 
		CALL DOL ; WYWOLANIE PROCEDURY RYSUJACEJ LINIE W DOL
		JNB P2.1, CZYTANIE_OKRESU ; PRZY WCISNIECIU PRZYCISKU SW1 NASTEPUJE ODCZYT WARTOSCI OKRESU Z ADC, ZWOLNIENIE PRZYCISKU OZNACZA AKCEPTACJE WYBRANEJ WATOSCI 
		CALL GORA ; WYWOLANIE PROCEDURY RYSUJACEJ LINIE W GORE
	AJMP TROJKAT

CZYTANIE_AMPLITUDY: ; SEKCJA KODU USTAWIAJACA AMPLITUDE
	CALL ODCZYT_AMPLITUDY ; WYWOLANIE PROCEDURY ODCZYTUJACEJ WARTOSC AMPLITUDY Z PRZETWORNIKA ANALOGOWO CYFROWEGO
	MOV A, R4 ; PRZENOSZE ODCZYTANA WARTOSC DO AKUMULATORA
	MOV B, #2
	DIV AB ; DZIELE ODCZYTANA WARTOSC PRZEZ DWA
	MOV P1, A ; POKAZUJE USTAWIENIE AMPLITUDY NA OSCYLOSKOPIE
	JB P2.0, START ; ZWOLNIENIE PRZYCISKU OZNACZA WYJSCIE Z PETLI I ZAAKCEPTOWANIE ZMIAN
	JMP CZYTANIE_AMPLITUDY ; WYKONANIE PETLI PONOWNIE

CZYTANIE_OKRESU: ; SEKCJA KODU USTAWIAJACA OKRES
	CALL ODCZYT_OKRESU ; WYWOLANIE PROCEDURY ODCZYTUJACEJ WARTOSC OKRESU Z PRZETWORNIKA ANALOGOWO CYFROWEGO
	MOV P1, R5  ; POKAZUJE USTAWIENIE OKRESU NA OSCYLOSKOPIE
	JB P2.1, START ; ZWOLNIENIE PRZYCISKU OZNACZA WYJSCIE Z PETLI I ZAAKCEPTOWANIE ZMIAN
	JMP CZYTANIE_OKRESU ; WYKONANIE PETLI PONOWNIE

; KONIEC

;;;;;;;;;;;;;;;;;;;;;;;;;;;

; PROCEDURY:

GORA_POLOWA:
	MOV A, R1
	MOV B, #2
	DIV AB ; DZIELE PRZEZ DWA

	MOV R3, A ; WCZYTUJE OKRES/2 DLA PETLI
	MOV A, R2 ; WCZYTUJE WARTOSC NAPIECIA

	PETLA3:
		ADD A, R0
	MOV P1, A ; NAPIECIE WRZUCAM NA OSCYLOSKOP
	DJNZ R3, PETLA3
	MOV R2, A ; ZACHOWUJE WARTOSC NAPIECIA
RET

GORA:
	MOV A, R1
	MOV R3, A ; WCZYTUJE OKRES/2 DLA PETLI	
	MOV A, R2 ; WCZYTUJE WARTOSC NAPIECIA

	PETLA1:
		ADD A, R0
	MOV P1, A ; NAPIECIE WRZUCAM NA OSCYLOSKOP
	DJNZ R3, PETLA1
	MOV R2, A ; ZACHOWUJE WARTOSC NAPIECIA
RET

DOL:
	MOV A, R1 ; WCZYTUJE OKRES/2
	MOV R3, A

	MOV A, R2 ; WCZUTUJE NAPIECIE

	PETLA2:
		SUBB A, R0
	MOV P1, A ; NAPIECIE WRZUCAM NA OSCYLOSKOP
	DJNZ R3, PETLA2

	MOV R2, A ; ZACHOWUJE NAPIECIE
RET

LICZENIE:
	MOV A, R5
	MOV B, #16 
	DIV AB ; DZIELE WARTOSC WPISANEGO OKRESU NA 16
	MOV R1, A ; ZAPISUJE WYNIK DO R1

	MOV A, R4 
	MOV B, #16
	DIV AB ; DZIELE WARTOSC NACHYLENIA NA 16, OTRZYMUJAC PRZYROST AMPLITUDY NA WYKONANIE PETLI W PROGRAMIE GLOWNYM
	MOV R0, A ; ZAPISUJE SKOK, ABY AMPLITUDA SIE ZGADZALA
RET

ODCZYT_AMPLITUDY: 
	CLR P3.6 
	SETB P3.7
	SETB P3.6 ; WLACZAM POMIAR ADC
 
	JB P3.2, $ ; SPRAWDZENIE CZY KONWERTER SKONWERTOWAL
      	
	CLR P3.7   
	MOV R4, P2 ; PRZENOSZE WYNIK DO R4
	SETB P3.7 
RET

ODCZYT_OKRESU: 
	CLR P3.6 
	SETB P3.7 
	SETB P3.6 ; WLACZAM POMIAR ADC
 
	JB P3.2, $ ; SPRAWDZENIE CZY KONWERTER SKONWERTOWAL
      	
	CLR P3.7  
	MOV R5, P2 ; PRZENOSZE WYNIK DO R5
	SETB P3.7
RET