org 100h

cr=13 
lf=10 ; cr, lf - w ASCII oznacza koniec biezacej linii

limit1=99 ;najwieksa liczba jak¹ mozna wpisac, mozna zmienic

mov ah, 9
mov dx, witaj
int 21h

poczatek:

ktory_wyr:
	mov ah, 9
	mov dx, podaj_ktory_wyr
	int 21h

	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah     ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h 

	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si,znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych

ktory_wyr_zamiana:
	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1
	
	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h mov ah,1
	je dalej1    ; jezeli klawisz enter zostal wcisniety skacz do etykiety dalej1, jezeli nie kontynuuj

	liczba:
	cmp al,'0' ; porownanie z lewa strona przedzialu cyfr w ascii
	jl blad ; jezeli wprowadzony znak nie miesci sie w przedziale >=0 skacz do etykiety blad
	
	cmp al,'9'	 ; prawa strona przedzialu
	jg blad ; jezeli wprowadzony znak nie miesci sie w przedziale <=9 skok do etykiety blad
	
	mov cl,al ; zapamietywanie wartosci al zeby odtworzyc ja po wymnozeniu rejestru ax przez 10
	mov ax,bx ; wartosc z bx trafia do ax
	mov dx,10
	mul dx ; domyslnie dla mul wymnozona wartosc jest w ax (al-->ax)
	
	mov bx,ax
	mov al,cl ; przywracanie stara wartosc al poniewaz mul zamazuje ax
	
	sub al,'0' ; '0'-zamiana Ascii na liczbe 
	xor ah,ah ; wyzerowanie rejestru ah
	add bx,ax
	
	cmp bx,limit1 ; porownanie otrzymanej liczby z ogranicznikiem
	jg blad ; jezeli liczba za duza skok do blad
	jmp ktory_wyr_zamiana ; jezeli nie zostal nacisniety enter to skok do poczatku petli
	
dalej1:
 mov cx, bx

; wartosci poczatkowe zmiennych, dx jest zmienna pomocnicza
 mov ax, 1
 mov bx, 0
 mov dx, 0

 cmp cx, 0 ; jesli uzytkownik wpisze 0 to koniec programu
 je blad

 petelka:  ; petla realizujaca ciag fibonacciego

  mov dx, ax
  add ax, bx
  mov bx, dx
  dec cx ; cx to licznik, jesli zejdzie do zera petla jest opuszczana

  cmp cx, 0
 jne petelka

 mov ax, bx  ; przenosze wynik do ax


dalej2:

 mov di,1 ; licznik wykonanych instrukcji push
 mov dx,'$'
 push dx

petla: ;zamiana na dziesietny
	mov bx,10
	mov dx, 0
	div bx ; podzielenie rejestru ax przed bx
	add dx,'0' ; zamiana reszty na ascii, reszta jest w dx
	push dx ; wrzucanie na stos znak ascii
	inc di ; po kazdym push zwiekszamy wartosc licznika o 1

	cmp ax,0 ; sprawdzanie czy wynik z dzielenia jest 0
	jne petla ; jezeli wynik z dzielenia nie jest zerem skok do petla

	mov cx,di ; wrzucanie do cx wartosc licznika
	mov di,bufor ; poczatkowy adres docelowego bufora

zdejmowanie_ze_stosu: ;wyswietlanie
	pop ax
	stosb ; przechowywanie znaku z rejestru al pod adres di i zwiekszanie di o 1
	loop zdejmowanie_ze_stosu ; zmniejsz cx o jeden oraz idz do zdejmowanie ze stosu jezeli cx jest rozne od zera
	mov ah,9
	mov dx,wynik
	int 21h
	
	mov ah,9 ; wyswietlanie napisu zakonczonego znakiem dolara
	mov dx, bufor ; adres bufora do dx
	int 21h



 jmp poczatek ; skok pozwalajacy na wpisanie kolejnej liczby

koniec_:
	

mov ah,9
mov dx,koniec
int 21h
	
mov ah,1 ;przerwanie 21h, ah=1 powoduje zakonczenie programu po przez nacisniecie dowolnego klawisza
int 21h

mov ax, 4c00h ;funkcja wyjscia z programu
int 21h

blad:
	mov ah,9 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta cos_nie_tak 
	mov dx, cos_nie_tak
	int 21h
	
	jmp koniec_ ; jezeli wprowadzona liczba jest niepoprawna idz do odczyt


witaj db " Witaj. Ten program sluzy do wyswietlania wybranego wyrazu ciagu Fibonacciego.", cr, lf, cr, lf
      db " Nalezy wprowadzic numer oczekiwanego wyrazu.",cr,lf
      db " Program obsluguje maksymalna liczbe 99 wyrazow.", cr,lf
      db " Aby zakonczyc program nalezy wprowadzic niepoprawna wartosc (powyzej 99) lub znak inny niz cyfra.", cr, lf, '$'

koniec db cr,lf,cr,lf,cr,lf, " Nacisnij dowolny klawisz, aby zakonczyc program.$"

bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu

bufor_na_znaki:
rozmiar db 8	 ; miejscie ile znakow mozna maksymalnie odczytac
ile_wczytanych db 0	; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak

nowa_linia db cr,lf, '$'

cos_nie_tak db cr, lf, "Koniec programu.",cr,lf,cr,lf,'   $'

podaj_ktory_wyr db cr,lf,cr,lf, " Podaj ktory wyraz chcesz wyswietlic: ", "   $"

wynik db " Ten wyraz to: $", cr, lf,cr,lf