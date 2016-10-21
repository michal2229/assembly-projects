; MIERNIK NAPIĘCIA 0.00-5.00 V. 
; WYNIK ZE ZNAKIEM NA MODUŁ LCD
;
; PROCEDURY:
;  
; ODCZYTANIE_NAPIECIA      : R0 = F()
; PRZELICZANIE_WARTOSCI    : R0 = F(R0) 
; ZMIANA_WARTOSCI_NA_BCD   : (R0, R1, R2, R3) = F(R0)
; WYSWIETLANIE_NA_LCD      : VOID = F(R0, R1, R2)
; ZMIANA_WARTOSCI_NA_ASCII : (R0, R1, R2, R3) = F(R0, R1, R2, R3)
;
;
; KOMORKI 'A', 'B', 'C', 'D'... ZAWIERAJA ZNAKI ASCII


START:
	CALL ODCZYTANIE_NAPIECIA
	CALL PRZELICZANIE_WARTOSCI
	CALL ZMIANA_WARTOSCI_NA_BCD
	CALL ZMIANA_WARTOSCI_NA_ASCII
	CALL WYSWIETLANIE_NA_LCD
JMP START

; ZAMIANA NA BCD
; ZAMIANA NA 7SEG
; WYSWIETLANIE

ZMIANA_WARTOSCI_NA_ASCII: ; (R0, R1, R2, R3) = F(R0, R1, R2, R3)
	;polega na dodawaniu wartosci ascii zera do cyfry, np: 6 + "0" = "6"
	MOV A, #'0'
	ADD A, R0
	MOV R0, A

	MOV A, #'0'
	ADD A, R1
	MOV R1, A

	MOV A, #'0'
	ADD A, R2
	MOV R2, A

	MOV A, #'0'
	ADD A, R3
	MOV R3, A
RET

PRZELICZANIE_WARTOSCI: ; R0 = F(R0) 
	MOV ACC, R0
	
	MOV 'A', #'+' ; TAK BEDE ROBIL
					; W KOMORCE O ADRESIE '0' UMIESZCZE PREZENTACJE ZNAKU ZERO I BEDE PRZENOSIL DO NA WYSWIETLACZ PIERWSZY: MOV R0, '0'; MOV 'A', @R0
	
	JB ACC.7, NAPIECIE_DODATNIE ; JEŚLI ACC.7 = 1:
	
	MOV 'A', #'-'
	MOV B, A
	MOV A, #255
	SUBB A, B ; ACC=255-ACC

	NAPIECIE_DODATNIE:

	MOV B, #128
	SUBB A, B ; ACC=ACC-128

	MOV B, #2
	MUL AB ;ACC=ACC*2
	MOV R0, A
RET


ODCZYTANIE_NAPIECIA: ; R0 = F()
		; RESET ADC
		CLR P3.6 ; WYLACZENIE POMIARU
		SETB P3.7 ; LINIA ADC ODCIETA OD P2
		SETB P3.6 ; WLACZA POMIAR ADC
   	 
		; SPRAWDZENIE CZY KONWERTER SKONWERTOWAL
 		JB P3.2, $ ; JESLI NIE SKONCZYL KONWERSJI TO ROB NIC
      	
	JUZ_SKONWERTOWAL:
		CLR P3.7   ; LINIA ADC NA P2
		MOV R0, P2 ; PRZENOSZE WYNIK DO R0
RET

ZMIANA_WARTOSCI_NA_BCD: ; (R0, R1, R2, R3) = F(R0)
	; PRZETWARZANIE WARTOSCI NAPIECIA NA KOD BCD
	MOV A, R0
	MOV R0, #0
	MOV R1, #0
	MOV R2, #0
	MOV R3, #0
	; 1000MV
	MOV B, #51
	DIV AB
	MOV R0, A

	; 100MV
	MOV A, #10
	MUL AB
	JNB B.0, DALEJ1

	MOV R1, #5

	DALEJ1:
	MOV B, #51
	DIV AB
	ADD A, R1
	MOV R1, A

	; 100MV
	MOV A, #10
	MUL AB
	JNB B.0, DALEJ2

	MOV R2, #5

	DALEJ2:
	MOV B, #51
	DIV AB
	ADD A, R2
	MOV R2, A

	; 100MV
	MOV A, #10
	MUL AB
	JNB B.0, DALEJ3

	MOV R3, #5

	DALEJ3:
	MOV B, #51
	DIV AB
	ADD A, R3
	MOV R3, A
RET


;------

WYSWIETLANIE_NA_LCD: ; 30H..36H = F(R0..R2)
		MOV 30H, 'A' ; ZNAK
		MOV 31H, R0 ; JEDNOSCI
		MOV 32H, #'.' ; KROPKA
		MOV 33H, R1 ; DZIESIATE
		MOV 34H, R2 ; SETNE
		MOV 35H, #'V' ; V
		MOV 36H, #0 ; KONIEC DANYCH
		
	; inicjalizacja
		CLR P1.3		

	; ustawianie
		CLR P1.7		 
		CLR P1.6		 
		SETB P1.5		 
		CLR P1.4		;  ustawienie gornej czworki

		SETB P1.2		 
		CLR P1.2		;  zbocze opadajace

		CALL OPOZNIENIE	; oczekiwanie na wyczyszczenie bufora	

		SETB P1.2		 
		CLR P1.2		;  zbocze opadajace
					

		SETB P1.7		; ustawianie dolnej czworki (ONLY P1.7 NEEDED TO BE CHANGED)

		SETB P1.2		
		CLR P1.2		; zbocze opadajace
					
		CALL OPOZNIENIE	; oczekiwanie na wyczyszczenie bufora


	; ustawienie trybu wpisywania
	; ustawienie na zwiekszanie bez przesuniecia
		CLR P1.7		
		CLR P1.6		
		CLR P1.5		
		CLR P1.4		; ustawienie gornej czworki

		SETB P1.2		
		CLR P1.2		; zbocze opadajace

		SETB P1.6		
		SETB P1.5		; ustawianie dolnej czworki

		SETB P1.2		;
		CLR P1.2		; zbocze opadajace

		CALL OPOZNIENIE		; oczekiwanie na wyczyszczenie bufora


	; kontrola wlaczenia i wylaczenia wyswietlacza
	; wyswietlacz jest wlaczony, kursor dziala
		CLR P1.7		
		CLR P1.6		
		CLR P1.5		
		CLR P1.4		; ustawienie gornej czworki

		SETB P1.2		
		CLR P1.2		;  zbocze opadajace

		SETB P1.7		
		SETB P1.6		
		SETB P1.5		
		SETB P1.4		; ustawianie dolnej czworki

		SETB P1.2	
		CLR P1.2		; zbocze opadajace

		CALL OPOZNIENIE		; oczekiwanie na wyczyszczenie bufora


	; wysylanie danych
		SETB P1.3		; czyszczenie rs - oznacza to, ze dane beda wysylane
		MOV R1, #30H	; adres poczatkowej komorki danych
		
	PETLA:
		MOV A, @R1		; pobierz znak ascii
		JZ $	; jesli dana == 0 to koniec programu
		CALL WYSLIJ_ZNAK	; wysylanie danych do modulu lcd
		INC R1			; zwiekszanie wskaznika o jeden - nastepny znak
	JMP PETLA		; powtorz, az dana == 0


	WYSLIJ_ZNAK:
		MOV C, ACC.7		
		MOV P1.7, C			
		MOV C, ACC.6		
		MOV P1.6, C			
		MOV C, ACC.5		
		MOV P1.5, C			
		MOV C, ACC.4		
		MOV P1.4, C			; ustawienie gornej czworki

		SETB P1.2			
		CLR P1.2			;  zbocze opadajace

		MOV C, ACC.3		
		MOV P1.7, C			
		MOV C, ACC.2		
		MOV P1.6, C			
		MOV C, ACC.1		
		MOV P1.5, C			
		MOV C, ACC.0		
		MOV P1.4, C			; ustawianie dolnej czworki

		SETB P1.2			
		CLR P1.2			;  zbocze opadajace

		CALL OPOZNIENIE		; oczekiwanie na wyczyszczenie bufora
RET

OPOZNIENIE:
	MOV R0, #50
	DJNZ R0, $
RET