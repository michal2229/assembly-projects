; Temat 24. Realizacja kolejnych czynności na LCD:
; - inicjacja modułu LCD z napisem min o 60 znakach
; - napis "przewinięcie o 1 linię".
; - przewinie tekst do góry o 1 linię.
; - napis "czysty wyświetlacz".
; - wyczyści wyświetlacz LCD.
; Program przystosowany jest do symulatora EDSIM51.
; Zalecana czestotliwosc zegara: 12MHz
; Zalecana szybkosc odswiezania: 5000x
;
; ustawianie timerow
;

mov tmod, #11h ; timer w trybie 16bit
clr tf0
clr tf1
clr tr0
clr tr1
; ustawianie lcd
clr p1.3		; czyszczenie p1.3 
clr  p1.7
clr  p1.6
setb p1.5
clr  p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_40us		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.7		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_40us		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.6
setb p1.5		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_40us		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
; wrzucanie dlugiego komunikatu do pamieci
mov 30h, #'W'
mov 31h, #'y'
mov 32h, #'s'
mov 33h, #'y'
mov 34h, #'l'
mov 35h, #'a'
mov 36h, #'n'
mov 37h, #'i'
mov 38h, #'e'
mov 39h, #' '
mov 3ah, #'b'
mov 3bh, #'a'
mov 3ch, #'r'
mov 3dh, #'d'
mov 3eh, #'z'
mov 3fh, #'o'
mov 58h, #' ' ; nowa linia
mov 59h, #'d'
mov 5ah, #'l'
mov 5bh, #'u'
mov 5ch, #'g'
mov 5dh, #'i'
mov 5eh, #'e'
mov 5fh, #'g'
mov 60h, #'o'
mov 61h, #' '
mov 62h, #'t'
mov 63h, #'e'
mov 64h, #'k'
mov 65h, #'s'
mov 66h, #'t'
mov 67h, #'u'
mov 40h, #'n' ; drugi ekran
mov 41h, #'a'
mov 42h, #' '
mov 43h, #'w'
mov 44h, #'y'
mov 45h, #'s'
mov 46h, #'w'
mov 47h, #'i'
mov 48h, #'e'
mov 49h, #'t'
mov 4ah, #'l'
mov 4bh, #'a'
mov 4ch, #'c'
mov 4dh, #'z'
mov 4eh, #' '
mov 4fh, #' '
mov 50h, #'-'
mov 51h, #'-'
mov 52h, #'-'
mov 53h, #'-'
mov 54h, #'-'
mov 55h, #'-'
mov 56h, #'-'
mov 57h, #'-'
mov 68h, #'h' ; nowa linia drugiego ekranu
mov 69h, #'d'
mov 6ah, #'4'
mov 6bh, #'4'
mov 6ch, #'7'
mov 6dh, #'8'
mov 6eh, #'0'
mov 6fh, #'.'
mov 70h, #'.'
mov 71h, #'.'
mov 72h, #'.'
mov 73h, #'.'
mov 74h, #'.'
mov 75h, #'.'
mov 76h, #'.'
mov 77h, #'.'
mov 78h, #0
call wyslij_dane ; wrzucanie na modul
; wlaczenie lcd z komunikatem
clr p1.3		; czyszczenie p1.3 umozliwia wyslanie instrukcji do wyswietlacza
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.7
setb p1.6
setb p1.5
setb p1.4		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_40us		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
call oczekiwanie_na_odczytanie_tekstu ; opoznienie, aby mozna bylo spokojnie przeczytac
; przesuwanie wyswietlacza w lewo, aby wyswietlic reszte dlugiego komunikatu
mov r5, #16
delshortc:
call opoznienie_40us
clr p1.3
clr p1.7
clr p1.6
clr p1.5
setb p1.4		; wyzsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.7 ; s/c
clr p1.6 ; r/l
clr p1.5
clr p1.4
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_40us		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
dec r5
mov a, r5
jnz delshortc
call oczekiwanie_na_odczytanie_tekstu ; opoznienie, aby mozna bylo spokojnie przeczytac
; czyszczenie wyswietlacza lcd
clr p1.3
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.4		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_5ms		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
; wyswietlenie komunikatu przewiniecia linii w gore
mov 30h, #'P'
mov 31h, #'r'
mov 32h, #'z'
mov 33h, #'e'
mov 34h, #'w'
mov 35h, #'i'
mov 36h, #'n'
mov 37h, #'i'
mov 38h, #'ę'
mov 39h, #'c'
mov 3ah, #'i'
mov 3bh, #'e'
mov 3ch, #' '
mov 3dh, #'o'
mov 3eh, #' '
mov 3fh, #' '
mov 58h, #'j'
mov 59h, #'e'
mov 5ah, #'d'
mov 5bh, #'n'
mov 5ch, #'a'
mov 5dh, #' '
mov 5eh, #'l'
mov 5fh, #'i'
mov 60h, #'n'
mov 61h, #'i'
mov 62h, #'e'
mov 63h, #0
call wyslij_dane ; wrzucanie na modul
call oczekiwanie_na_odczytanie_tekstu ; opoznienie, aby mozna bylo spokojnie przeczytac
; czyszczenie wyswietlacza lcd
clr p1.3
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.4		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_5ms		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
; przewijanie w gore
setb p1.3		; czyszczenie p1.3 - umozliwia wysylanie danych
mov r1, #30h
mov a, #40
ADD a, r1
mov r1, a
zxcvb:
mov a, @r1		; przesylanie do akumulatora znaku wzkazywanego przez rejestr r1
jz asdfghh		; jesli znak to zero, koniec transmisji
; wyslij znak na modul lcd
mov c, acc.7
mov p1.7, c
mov c, acc.6
mov p1.6, c
mov c, acc.5
mov p1.5, c
mov c, acc.4
mov p1.4, c			;  wyzsza polowa instrukcji
setb p1.2
clr  p1.2			; zbocze ujemne na p1.2
mov c, acc.3
mov p1.7, c
mov c, acc.2
mov p1.6, c
mov c, acc.1
mov p1.5, c
mov c, acc.0
mov p1.4, c			; nizsza polowa instrukcji
setb p1.2
clr  p1.2			; zbocze ujemne na p1.2
call opoznienie_40us			; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
inc r1			; zwieksz wskaznik w celu wskazania na kolejny znak
jmp zxcvb	; powtorz
asdfghh:
call oczekiwanie_na_odczytanie_tekstu ; opoznienie, aby mozna bylo spokojnie przeczytac
; czyszczenie wyswietlacza lcd
clr p1.3
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.4		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_5ms		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
; komunikat o wyczyszczeniu wyswietlacza
mov 30h, #'C'
mov 31h, #'z'
mov 32h, #'y'
mov 33h, #'s'
mov 34h, #'t'
mov 35h, #'y'
mov 36h, #' '
mov 37h, #' '
mov 38h, #' '
mov 39h, #' '
mov 3ah, #' '
mov 3bh, #' '
mov 3ch, #' '
mov 3dh, #' '
mov 3eh, #' '
mov 3fh, #' '
mov 58h, #'w'
mov 59h, #'y'
mov 5ah, #'s'
mov 5bh, #'w'
mov 5ch, #'i'
mov 5dh, #'e'
mov 5eh, #'t'
mov 5fh, #'l'
mov 60h, #'a'
mov 61h, #'c'
mov 62h, #'z'
mov 63h, #0
call wyslij_dane ; wrzucanie na modul
call oczekiwanie_na_odczytanie_tekstu ; opoznienie, aby mozna bylo spokojnie przeczytac
; czyszczenie wyswietlacza lcd
clr p1.3
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.4		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_5ms		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
; wylaczanie modulu lcd
clr p1.3		; czyszczenie p1.3 umozliwia wyslanie instrukcji do wyswietlacza
clr p1.7
clr p1.6
clr p1.5
clr p1.4		; wysza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
setb p1.7
clr  p1.6
clr  p1.5
clr  p1.4		; nizsza polowa instrukcji
setb p1.2
clr  p1.2		; zbocze ujemne na p1.2
call opoznienie_40us		; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
jmp $ ; petla nieskonczona - koniec programu
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
wyslij_dane:
setb p1.3		; czyszczenie p1.3 - umozliwia wysylanie danych
mov r1, #30h
qwert:
mov a, @r1		; przesylanie do akumulatora znaku wzkazywanego przez rejestr r1
jz werty	; jesli znak to zero, koniec transmisji
; wyslij znak na modul lcd
mov c, acc.7
mov p1.7, c
mov c, acc.6
mov p1.6, c
mov c, acc.5
mov p1.5, c
mov c, acc.4
mov p1.4, c			;  wyzsza polowa instrukcji
setb p1.2
clr  p1.2			; zbocze ujemne na p1.2
mov c, acc.3
mov p1.7, c
mov c, acc.2
mov p1.6, c
mov c, acc.1
mov p1.5, c
mov c, acc.0
mov p1.4, c			; nizsza polowa instrukcji
setb p1.2
clr  p1.2			; zbocze ujemne na p1.2
call opoznienie_40us			; czekanie na wyczyszczenie flagi sygnalizujacej zajetosc ukladu
inc r1			; zwieksz wskaznik w celu wskazania na kolejny znak
jmp qwert	; powtorz
werty:
ret
opoznienie_40us:
mov th0, #0ffh ; 10000h - 40 = ffd5h ; opoznienie 40us
mov tl0, #0d5h
setb tr0
jnb tf0, $
clr tr0
clr tf0
ret
opoznienie_5ms:
mov th0, #0ech ; opoznienie 5ms
mov tl0, #078h ; 10000h - 5000 = 0ec78h
setb tr0
jnb tf0, $
clr tr0
clr tf0
ret
;oczekiwanie_na_odczytanie_tekstu: ; skomentowane w celach symulacji, odkomentowac na realnym ukladzie
;mov a, #200 ; opoznienie 200 * 5ms = 1s
;asadf:
;call opoznienie_5ms
;dec a
;jnz asadf
;ret
oczekiwanie_na_odczytanie_tekstu: ; skomentowac w realnym ukladzie, odkomentowane w celach symulacji
mov a, #20 ; opoznienie 20 * 5ms = 0,1s
asdf:
call opoznienie_5ms
dec a
jnz asdf
ret
