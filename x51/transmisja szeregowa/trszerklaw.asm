; NALEZY USTAWIC PREDKOSC TRANSMISJI NA 4800 BODOW I TAKTOWANIE PROCESORA NA 12MHZ
; DANE SA WYSYLANE Z PARZYSTOSCIA PARZYSTA

CLR SM0			
SETB SM1 ; USTAWIAM PORT SZEREGOWY NA 8BIT

MOV A, PCON		
SETB ACC.7		
MOV PCON, A	

MOV TMOD, #20H ; USTAWIAM LICZNIK T1 NA 8BIT Z PRZELADOWANIEM
MOV TH1, #243 ; WARTOSC NA KTORA MA SIE PRZELADOWYWAC DOLNA CZESC LICZNIKA
MOV TL1, #243 ; WARTOSC POCZATKOWA DOLNEJ CZESCI LICZNIKA
SETB TR1 ; START LICZNIKA T1

PETLA:
	CALL CZYTAJ_LICZBE
	CALL WYSYLANIE
JMP PETLA



;;;;;;;;;;;;;;;

WYSYLANIE:
	;ADD A, #'0'
    ;MOV A, @R0 ; PRZENOSZE DO AKUMULATORA ADRES PIERWSZEJ LITERY
    ;JZ $ ; JESLI ZERO TO KONIEC TRANSMIZJI I NIC NIE ROB
    MOV C, P ; PRZENOSZENIE BITU PARZYSTOSCI DO AKUMULATORA
	MOV ACC.7, C ; PRZENOSZENIE BITU PARZYSTOSCI DO NAJWIEKSZEGO BITU AKUMULATORA
	MOV SBUF, A ; PRZENOSZENIE DANYCH DO WYSLANIA DO BUFORA
	;INC R0 ; ZWIEKSZANIE ZAWARTOSCI R0 O JEDEN (CZYLI NA ADRES KOLEJNEJ LITERY)
	JNB TI, $ ; CZEKANIE NA KONIEC TRANSMISJI - USTAWIONY ZOSTAJE WTEDY BIT TI
	CLR TI ; CZYSZCZENIE TI, ZEBY NASTEPNA PETLA MOGLA WYKONAC SIE POPRAWNIE
RET	; NASTEPNE WYKONANIE PETLI W CELU WYSLANIA KOLEJNEGO ZNAKU

CZYTAJ_LICZBE:
	CALL CZYTAJ ; LICZBA A W R7
	MOV A, R7 ; R0 - DZIESIATKI
RET

CZYTAJ:
	MOV R7, #0 ; CYFERKA
	SETB P0.1
	SETB P0.2
	SETB P0.3
	
	;CLR P0.0
	;JNB P0.5, ZNALAZLEM_LICZBE
	;INC R7
	;JB F0, ZNALAZLEM_LICZBE
	
	CLR P0.0
	
	MOV R7, #42
	JNB P0.6, WCISNIETO_PRZYCISK
	JB F0, CZWARTYRZAD
	MOV R7, #48
	JNB P0.5, WCISNIETO_PRZYCISK
	JB F0, CZWARTYRZAD
	MOV R7, #35
	JNB P0.4, WCISNIETO_PRZYCISK
	JB F0, CZWARTYRZAD
	
	JMP DALEJJ

	CZWARTYRZAD:
	CALL ZNALAZLEM_LICZBE
	DALEJJ:

	MOV R7, #49
	SETB P0.0
	CLR P0.3
	CALL SKANUJ_KOLUMNY
	JB F0, ZNALAZLEM_LICZBE
	
	SETB P0.3
	CLR P0.2
	CALL SKANUJ_KOLUMNY
	JB F0, ZNALAZLEM_LICZBE
	
	SETB P0.2
	CLR P0.1
	CALL SKANUJ_KOLUMNY
	JB F0, ZNALAZLEM_LICZBE
	
	JMP CZYTAJ
	
	ZNALAZLEM_LICZBE:
	CLR F0 ; ZERUJE F0, ABY MOZNA BYLO ODCZYTAC LICZBE JESZCZE RAZ
RET

SKANUJ_KOLUMNY:
	JNB P0.6, WCISNIETO_PRZYCISK
	INC R7
	JNB P0.5, WCISNIETO_PRZYCISK
	INC R7
	JNB P0.4, WCISNIETO_PRZYCISK
	INC R7
RET

WCISNIETO_PRZYCISK:
	SETB F0 ; INFORMACJA DLA PETLI, ZE PRZYCISK ZOSTAL WCINIETY
RET