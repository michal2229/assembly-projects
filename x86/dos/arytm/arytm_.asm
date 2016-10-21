org 100h

cr=13 ; ciag znakow ASCII oznaczajacy koniec biezacej linii
lf=10
ht=9  ; tabulator

limit = 10000 ; najwieksza liczba jak¹ mozna wpisac.

mov ah, 9
mov dx, witaj
int 21h

poczatek:
	a:
		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_a
		int 21h
		
		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		pushd eax

	r:
		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_r
		int 21h

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		pushd eax

	n:
		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_n
		int 21h

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax

	cmp eax, 0
	jle blad
; n w eax
; r w [esp]
; a1 w [esp+4]

	 dec eax  ; n-1

	 mov ebx, [esp]
	 imul ebx ; (n-1)*r
	 add eax, [esp+4]  ; policzone an

; eax - wynik

	mov di,1 ; licznik wykonanych instrukcji push, indeks 1 uwzglednia znak dolara na stosie
	mov dx,'$'
	push dx

; dalej jest zamiana ujemnej U2 na -dodatnia
	cmp eax, 0 ; sprawdzam, czy liczba jest ujemna
	jl minus ; jesli tak to wrzucam do ecx "-"
	mov ecx, "" ; jesli nie to wrzucam nic

	jmp dalej

	minus:
		mov ecx, "-"
		mov ebx, -1
		imul ebx

dalej:
	zamiana_na_dziesietny:
		petla: ;zamiana na dziesietny
			mov ebx,10
			mov edx, 0
			div ebx ; podzielenie rejestru ax przed bx
			add edx,'0' ; zamiana reszty na ascii, reszta jest w dx
			push edx ; wrzucanie na stos znak ascii
			inc di ; po kazdym push zwiekszamy wartosc licznika o 1

			cmp eax,0 ; sprawdzanie czy wynik z dzielenia jest 0
			jne petla ; jezeli wynik z dzielenia nie jest zerem skok do petla


			push ecx ; wstawia znak
			inc di	 ; zwieksza di o jeden bo wrzucilismy znak

			mov ecx, 0
			mov cx,di ; wrzucanie do cx wartosc licznika
			mov di,bufor ; poczatkowy adres docelowego bufora

	zdejmowanie_ze_stosu: ;wyswietlanie
		pop eax
		stosb ; przechowywanie znaku z rejestru al pod adres di i zwiekszanie di o 1
		loop zdejmowanie_ze_stosu ; zmniejsz cx o jeden oraz idz do zdejmowanie ze stosu jezeli cx jest rozne od zera
; koniec zamiany
	call wysw_wynik
	jmp poczatek
koniec_:
	mov ah,9
	mov dx,koniec
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
		
		cmp bx,limit ; porownanie otrzymanej liczby z ogranicznikiem
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
wysw_wynik:
	mov ah,9
	mov dx,wynik
	int 21h
	
	mov ah,9 ; wyswietlanie napisu zakonczonego znakiem dolara
	mov edx, bufor ; adres bufora do dx
	int 21h
ret

; --------------------------------
blad:
	mov ah,9 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta error zakonczonych znakiem dolara
	mov dx, error
	int 21h

	jmp koniec_ ; jezeli wprowadzona liczba jest niepoprawna idz do poczatek
ret

; --------------------------------


; ; ; ; ; ; ; DANE ; ; ; ; ; ; ; ;
witaj db cr,lf, "   Witaj. Ten program sluzy do obliczania danego wyrazu szeregu arytmetyczneo.",cr,lf
      db '   Dozwolone jest wpisywanie liczb dodatnich i ujemnych, ktorych modul nie jest wiekszy niz 10000.' ,cr,lf
      db '   Liczba n musi byc liczba dodatnia. Wprowadzenie niepoprawnej wartoœci konczy program.',cr,lf
      db '   Nalezy wpisywac tylko liczby calkowite.$'
nowa_linia db cr,lf, '$'
koniec db cr,lf, "   Nacisnij dowolny klawisz, aby zakonczyc program.$"
error db cr, lf, "   Wprowadzona wartosc jest niepoprawna, koniec programu.",cr,lf,cr,lf,cr,lf,'$'
bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu
bufor_na_znaki:
rozmiar db 8	 ; miejscie ile znakow mozna maksymalnie odczytac
ile_wczytanych db 0	; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak
wpisz_a db cr, lf,cr,lf,cr,lf, " Wpisz wyraz poczatkowy a1: $"
wpisz_r db cr, lf, " Wpisz roznice r: $"
wpisz_n db cr, lf, " Wpisz ktory wyraz wyswietlic, n: $"
wynik db cr,lf, " Zadany wyraz an szeregu arytmetycznego wynosi: $"

