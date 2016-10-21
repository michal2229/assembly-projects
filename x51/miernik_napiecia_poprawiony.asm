; PROGRAM MIERZACY NAPIECIE I WYSWIETLAJACY POMIAR NA WYSWIETLACZU SIEDMIOSEGMENTOWYM
; PROGRAM DZIALA NAJLEPIEJ PRZY CZESTOTLIWOSCI ODSWIERZANIA ROWNEJ 100

; NALEZY USTAWIC WARTOSC ZADANEGO NAPIECIA SUWAKIEM, NAPIECIE ZOSTANIE ZMIERZONE I WYSWIETLONE
; PROGRAM DZIALA W PETLI, WARTOSC ZADANA MOZNA ZMIENIAC W TRAKCIE DZIALANIA PROGRAMU


MOV 20H, #11000000B ;  0
MOV 21H, #11111001B ;  1
MOV 22H, #10100100B ;  2
MOV 23H, #10110000B ;  3
MOV 24H, #10011001B ;  4
MOV 25H, #10010010B ;  5
MOV 26H, #10000010B ;  6
MOV 27H, #11111000B ;  7
MOV 28H, #10000000B ;  8
MOV 29H, #10010000B ;  9

POCZATEK:
CLR P3.6 
SETB P3.7
SETB P3.6

; SPRAWDZENIE CZY SKONWERTOWANO
JB P3.2, $ 
	
CLR P3.7   ;
MOV A, P2 ; PRZENOSZE WYNIK DO A

; PRZETWARZANIE WARTOSCI NAPIECIA NA KOD BCD
mov r0, #0
mov r1, #0
mov r2, #0
mov r3, #0
; 1000MV
MOV B, #51
DIV AB
MOV R0, A

; 100MV
MOV A, #10
mul ab
jnb b.0, dalej1

mov r1, #5

dalej1:
MOV B, #51
DIV AB
add a, R1
mov r1, a

; 100MV
MOV A, #10
mul ab
jnb b.0, dalej2

mov r2, #5

dalej2:
MOV B, #51
DIV AB
add a, R2
mov r2, a

; 100MV
MOV A, #10
mul ab
jnb b.0, dalej3

mov r3, #5

dalej3:
MOV B, #51
DIV AB
add a, R3
mov r3, a

; PRZETWARZANIE KODU BCD NA 7SEG
MOV 50H, R0 
MOV A, R0  
ADD A, #20H ; DODAJE 20H
MOV R0, A
MOV 50H, @R0	
MOV R0, 50H 

MOV A, R1  
ADD A, #20H
MOV R0, A
MOV 51H, @R0	

MOV A, R2  
ADD A, #20H
MOV R0, A
MOV 52H, @R0

MOV A, R3 
ADD A, #20H
MOV R0, A
MOV 53H, @R0

MOV P1, #255 ; GASZENIE SEGMENTOW
ORL P3, #00011000B ; USTAWIANIE SEGMENTU
MOV P1, 50H ; USTAWIANIE WARTOSCI NA SEGMENCIE
CLR P1.7 ; WSTAWIAM KROPKE, ABY ODDZIELIC CZESCI DZIESIETNE OD ULAMKOWYCH

CALL CZEKANIE

MOV P1, #255 
XRL P3, #00001000B
MOV P1, 51H 

CALL CZEKANIE

MOV P1, #255 
XRL P3, #00011000B
MOV P1, 52H 

CALL CZEKANIE

MOV P1, #255
XRL P3, #00001000B
MOV P1, 53H 

CALL CZEKANIE

MOV P1, #255

JMP POCZATEK



CZEKANIE: ; PROCEDURA OPOZNIENIA WYSWIETANIA
MOV A, #100
JESZCZERAZ:
	DEC A
JNZ JESZCZERAZ
RET
