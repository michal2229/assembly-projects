org 100h

cr=13 ; ciag znakow ASCII oznaczajacy koniec biezacej linii
lf=10
ht=9  ; tabulator

limit = 150 ; najwieksza liczba jak¹ mozna wpisac.

mov ah, 9
mov dx, witaj
int 21h

poczatek:
		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_p1
		int 21h

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		mov [xy1], eax

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		mov [xy1+4], eax

		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_p2
		int 21h

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		mov [xy2], eax

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		mov [xy2+4], eax

		mov ebx, 0
		mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
		mov dx,wpisz_p3
		int 21h

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		mov [xy3], eax

		call czytaj_liczbe ; czytam liczbe z klawiatury do eax
		mov [xy3+4], eax
		
		
xor edx, edx
mov eax, [xy1] ; x1
mov ebx, [xy2] ; x2
sub eax, ebx   ; x1 - x2
imul eax	; kwadrat
mov [xy12], eax

xor edx, edx
mov eax, [xy1] ; x1
mov ebx, [xy3] ; x3
sub eax, ebx   ; x1 - x3
imul eax	; kwadrat
mov [xy13], eax

xor edx, edx
mov eax, [xy2] ; x2
mov ebx, [xy3] ; x3
sub eax, ebx   ; x2 - x3
imul eax	; kwadrat
mov [xy23], eax


xor edx, edx
mov eax, [xy1+4] ; y1
mov ebx, [xy2+4] ; y2
sub eax, ebx   ; y1 - y2
imul eax	; kwadrat
mov [xy12+4], eax

xor edx, edx
mov eax, [xy1+4] ; y1
mov ebx, [xy3+4] ; y3
sub eax, ebx   ; y1 - y3
imul eax	; kwadrat
mov [xy13+4], eax

xor edx, edx
mov eax, [xy2+4] ; y2
mov ebx, [xy3+4] ; y3
sub eax, ebx   ; y2 - y3
imul eax	; kwadrat
mov [xy23+4], eax


mov eax, [xy12]
mov ebx, [xy12+4]
add eax, ebx

    mov [sqr_tmp], eax
    call pierwiastek
    mov eax, [sqr_tmp+8]

mov [abc], eax	; a

mov eax, [xy13]
mov ebx, [xy13+4]
add eax, ebx

    mov [sqr_tmp], eax
    call pierwiastek
    mov eax, [sqr_tmp+8]

mov [abc+4], eax ; b

mov eax, [xy23]
mov ebx, [xy23+4]
add eax, ebx

    mov [sqr_tmp], eax
    call pierwiastek
    mov eax, [sqr_tmp+8]

mov [abc+8], eax ; c

mov eax, [abc]
add eax, [abc + 4]
add eax, [abc + 8]
xor edx, edx
mov ebx, 2
div ebx
mov [p], eax	; polowa obwodu

mov eax, [p]
mov ebx, [abc]
sub eax, ebx
mov [pa], eax	; p-a

mov eax, [p]
mov ebx, [abc+4]
sub eax, ebx
mov [pb], eax	; p-b

mov eax, [p]
mov ebx, [abc+8]
sub eax, ebx
mov [pc], eax	; p-c

mov eax, [p]	; p
xor edx, edx
mul [pa]       ; p*(p-a)
xor edx, edx
mul [pb]       ; p*(p-a)*(p-b)
xor edx, edx
mul [pc]       ; p*(p-a)*(p-b)*(p-c)
xor edx, edx
    mov [sqr_tmp], eax
    call pierwiastek
    mov eax, [sqr_tmp+8] ; WYNIK w eax

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
pierwiastek:
	cmp [sqr_tmp], 3
	jg dobrze
	mov eax, 1
	cmp [sqr_tmp], 0
	jne policzone
	mov eax, 0
	jmp policzone

	dobrze:
	mov [sqr_tmp+4], 1
	mov ecx, 20 ; minimalna liczba ileracji do wyprowadzenia poprawnego wyniku z pierwiastka liczby 2^32
    liczymy:
	mov eax, [sqr_tmp] ; liczba
	mov ebx, [sqr_tmp+4] ; X
	xor edx, edx ; takie mov edx, 0 tylko szybsze, potrzebne do dzielenia
	idiv ebx ; L/X
	add eax, ebx ; L/X+X
	mov ebx, 2
	xor edx, edx
	idiv ebx ; (L/X+X)/2
	cmp eax, [sqr_tmp+4]
	mov [sqr_tmp+4], eax
	xor edx, edx
     loop liczymy
     policzone:
	mov [sqr_tmp+8], eax
ret

; ; ; ; ; ; ; DANE ; ; ; ; ; ; ; ;
witaj db cr,lf, "   Liczenie pola powierzchni trojkata o danych wierzcholkach.",13,10,"   Program operuje wylacznie na liczbach calkowitych.",13,10,"   Nalezy wprowadzic wartosci z zakresu od -150 do +150.$"
nowa_linia db cr,lf, '$'
koniec db cr,lf, "   Nacisnij dowolny klawisz, aby zakonczyc program.$"
error db cr, lf, "   Wprowadzona wartosc jest niepoprawna, koniec programu.",cr,lf,cr,lf,cr,lf,'$'
bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu
bufor_na_znaki:
rozmiar db 8	 ; miejscie ile znakow mozna maksymalnie odczytac
ile_wczytanych db 0	; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak
wpisz_p1 db cr, lf,cr,lf,cr,lf, " Wpisz wspolrzedne punktu pierwszego:",13,10,"$"
wpisz_p2 db cr, lf,cr,lf,cr,lf, " Wpisz wspolrzedne punktu drugiego:",13,10,"$"
wpisz_p3 db cr, lf,cr,lf,cr,lf, " Wpisz wspolrzedne punktu trzeciego:",13,10,"$"

wynik db cr,lf, " Pole wynosi okolo: $" ; niedokladnosc wynika z zaokraglania pierwiastkow do liczb calkowitych

xy1 rd 2
xy2 rd 2
xy3 rd 2

xy12 rd 2
xy13 rd 2
xy23 rd 2

abc rd 3

p rd 1

pa rd 1
pb rd 1
pc rd 1

sqr_tmp rd 4 ; tymczasowe miejsce na liczbe z ktorej chcemy pierwiastek, x, i wynik pierwiastka
