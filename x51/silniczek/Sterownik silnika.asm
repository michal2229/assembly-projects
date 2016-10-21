; LICZNIK OBROTOW SILNIKA
; PROGRAM POWINIEN BYC UZYWANY Z PROCESOREM O TAKTOWANIU 32768Hz (0.032768MHz)

org 0000h 			;WEKTOR ZERUJACY
	JMP MAIN		;SKOK DO PROGRAMU GLOWNEGO
	
ORG 000BH			;WEKTOR PRZERWANIA LICZNIKA 0
	CLR TR0			;ZATRZYMANIE LICZNIKA
	JMP timer0ISR		;SKOK DO OBSLUGI PRZERWANIA T0
	
ORG 0030H			;WEKTOR PROGRAMU GLOWNEGO
MAIN:
	mov a, 0
	MOV TMOD, #11H		;USTAWIA LICZNIK W TRYB 16BIT
	MOV TL0, #0	;USTAWIA WARTOSC POCZATKOWA 32768
	MOV TH0, #080h
	SETB TR0		;START LICZNIKA
	SETB EA			;GLOBALNE PRZERWANIA WLACZANE
	SETB ET0		;PRZERWANIE LICZNIKA 0 WLACZONE
	
licz:
	jb p0.0, dodaj
ajmp licz			;PETLA NIESKONCZONA
	
dodaj:			
	inc a
ajmp licz

timer0ISR:		;OBSLUGA PRZRWANIA T0 - realizuje obrot 3,5  raza w lewo
	CLR ET0		;WYLACZ PRZERWANIA
	CLR TF0		;WYCZYSC FLAGE
	MOV TMOD, #11H	;USTAWIENIE LICZNIKA W TRYB 2
	MOV TL0, #0 ;WARTOSC POCZATKOWA 21H 
	MOV TH0, #080h
	
CALL WYSWIETLAJ

	SETB TR0	;START LICZNIKA
	SETB EA		;GLOBALNE WLACZENIE PRZERWAN
	SETB ET0	;WLACZENIE PRZERWAN 1
RETI				;WROC

WYSWIETLAJ:
;WYNIK W A
	MOV B, #10
	DIV AB
	MOV P1, B

	MOV B, #10
	DIV AB
	MOV P2, B

	MOV P3, A

RET