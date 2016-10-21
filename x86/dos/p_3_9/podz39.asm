org 100h

cr=13 ; ciag znakow ASCII oznaczajacy koniec biezacej linii
lf=10
ht=9  ; tabulator

limit = 32767 ; najwieksza liczba jak¹ mozna wpisac.

mov ah, 9
mov dx, witaj
int 21h

poczatek:
		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_liczbe
		int 21h

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		cmp eax, 0 ; sprawdzam znak liczby wpisanej
		jge dodatniaa
		xor edx, edx  ; zeruje edx
		mov ebx, -1 ; jesli ujemna, to mnoze razy -1 aby miec dodatnia
		imul ebx

		dodatniaa:
		mov ebx, 3
		mov cx, niepodzielna ; przenosi do cx wskaznik komunikatu o niepodzielnosci
		xor edx, edx ; zeruje edx
		
		div ebx ; dziele eax przez 3, wynik w eax, reszta w edx
		cmp edx, 0 ; sprawdzam, czy jest reszta, jesli jest to liczba nie jest podzielna przez 3
		jne wyswietlanie_wyniku
		mov cx, podzielna3 ; przenosi do cx wskaznik komunikatu o podzielnosci przez 3
		xor edx, edx ; zeruje edx
		
		div ebx ; dziele eax przez 3, wynik w eax, reszta w edx
		cmp edx, 0 ; sprawdzam, czy jest reszta, jesli jest to liczba nie jest podzielna przez 9
		jne wyswietlanie_wyniku
		mov cx, podzielna9 ; przenosi do cx wskaznik komunikatu o podzielnosci przez 3 i 9
		xor edx, edx ; zeruje edx
		; uwaga: zero jest podzielne przez wyszystkie liczby z wyjatkiem zera
		
wyswietlanie_wyniku:		
	mov ah,9
	mov dx,cx ;  przenosze wskaznik odpowiedniego komunikatu do dx, aby wyswietlic
	int 21h
		
		
koniec_:
	mov ah,9
	mov dx,koniec ; wyswietlam tekst konca programu
	int 21h

	mov ah,1 ;przerwanie 21h, ah=1 powoduje zakonczenie programu po przez nacisniecie dowolnego klawisza
	int 21h

	mov ax, 4c00h ;funkcja wyjscia z programu
	int 21h

	   
; ; ; ; ; ; ; PODPROGRAMY ; ; ; ; ; ; ; ;
czytaj_liczbe:
	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah     ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h
	
	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si,znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych
	mov ch, 0
	
	liczba_:
		lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1
		
		cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h mov ah,1
		je enter_    ; jezeli klawisz enter zostal wcisniety skacz do etykiety ok jezeli nie idz dalej

		cmp al, '-'
		jne minusa_brak
		
		mov ch, 1
		jmp liczba_

    minusa_brak:
		cmp al,'0' ; porownanie z lewa strona przedzialu cyfr w ascii
		jl blad ; jezeli wprowadzony znak nie miesci sie w przedziale =<0 skacz do etykiety blad
		
		cmp al,'9'	 ; prawa strona przedzialu
		jg blad ; jezeli wprowadzony znak nie miesci sie w przedziale 9=< skok do etykiety blad
		
		mov cl,al ; zapamietywanie wartosci al zeby odtworzyc ja po wymnozeniu rejestru ax przez 10
		mov ax,bx ; wartosc z bx trafia do ax
		mov dx,10
		mul dx ; domyslnie dla mul wymnozona wartosc jest w ax (al-->ax)
		
		mov bx,ax
		mov al,cl ; przywracanie stara wartosc al poniewaz mul zamazuje ax
		
		sub al,'0' ; '0'-zamiana Ascii na liczbe 
		xor ah,ah ; wyzerowanie rejestru ah
		add bx,ax
		
		cmp ebx,limit ; porownanie otrzymanej liczby z ogranicznikiem
		jg blad ; jezeli liczba za duza skok do blad
		jmp liczba_ ; jezeli nie zostal nacisniety enter to skok do liczba_

	enter_:
		mov eax, 0
		mov ax, bx

		cmp ch, 1 ; sprawdzam, czy liczba jest ujemna
		jne dalej2 ; jesli nie jest ujemna to nie mnozy razy -1
		mov ebx, -1
		imul ebx
   dalej2:
ret

; --------------------------------


; --------------------------------
blad:
	mov ah,9 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta error zakonczonych znakiem dolara
	mov dx, error
	int 21h

	jmp koniec_ ; jezeli wprowadzona liczba jest niepoprawna idz do poczatek
ret

; --------------------------------


; ; ; ; ; ; ; DANE ; ; ; ; ; ; ; ;
witaj db cr,lf, "   Program sprawdza, czy liczba wpisana przez uzytkownika podzielna jest przez 3 lub 9.$"
nowa_linia db cr,lf, '$'
koniec db cr,lf,cr,lf, "Nacisnij dowolny klawisz, aby zakonczyc program.$"
error db cr, lf, "   Wprowadzona wartosc jest niepoprawna, koniec programu.",cr,lf,cr,lf,cr,lf,'$'
bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu
bufor_na_znaki:
rozmiar db 8	 ; miejscie ile znakow mozna maksymalnie odczytac
ile_wczytanych db 0	; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak
wpisz_liczbe db cr, lf,cr,lf,cr,lf, " Wpisz liczbe: $"

niepodzielna db cr, lf, " Liczba nie jest podzielna przez 3 ani przez 9.$"
podzielna3 db cr,lf, " Liczba jest podzielna przez 3.$"
podzielna9 db cr,lf, " Liczba jest podzielna przez 3 i 9.$"


