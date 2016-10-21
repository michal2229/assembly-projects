org 100h

cr=13 ; ciag znakow ASCII oznaczajacy koniec biezacej linii
lf=10
ht=9

limit=99 ;najwieksa liczba jak¹ mozna wpisac.

mov ah, 9
mov dx, witaj
int 21h

poczatek:

wysokosc: ;
	mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
	mov dx,wpisz_wysokosc
	int 21h

	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah     ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h
	
	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si,znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych

wysokosc_:

	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1
	
	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h mov ah,1
	je dalej1    ; jezeli klawisz enter zostal wcisniety skacz do etykiety ok jezeli nie idz dalej
	
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
	jmp wysokosc_ ; jezeli nie zostal nacisniety enter to skok do start

dalej1:

mov ah,0  ;przeniesienie wartosci wprowadzonej wysokosci z klawiatury z rejestru ax do bx
push bx ;h w na stosie



promien_dol: ; etykieta >odczyt< uzyta do utworzenia petli w przypadku wprowadzenia niepoprawnej liczby
	mov ah,9	 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
	mov dx,wpisz_promien_dol
	int 21h

	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h
	
	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si,znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych

promien_dol_:

	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1
	
	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h mov ah,1
	je dalej2    ; jezeli klawisz enter zostal wcisniety skacz do etykiety ok jezeli nie idz dalej
	
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
	jmp promien_dol_ ; jezeli nie zostal nacisniety enter to skok do start

dalej2:

 mov ah,0  ;przeniesienie wartosci wprowadzonej wysokosci z klawiatury z rejestru ax do bx
push bx ;R na stosie

 promien_gora: ; etykieta >odczyt< uzyta do utworzenia petli w przypadku wprowadzenia niepoprawnej liczby
	mov ah,9	 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
	mov dx, wpisz_promien_gora
	int 21h

	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h
	
	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si, znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych

promien_gora_:

	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1
	
	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h mov ah,1
	je dalej3    ; jezeli klawisz enter zostal wcisniety skacz do etykiety ok jezeli nie idz dalej
	
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
	jmp promien_gora_ ; jezeli nie zostal nacisniety enter to skok do start

 dalej3: ;dalej jest dobrze

 mov ah,0  ;przeniesienie wartosci wprowadzonej wysokosci z klawiatury z rejestru ax do bx
push bx ;r na stosie

  ;stos (esp - stack pointer):
  ;     h <- esp+4
  ;     R <- esp+2
  ;     r <- esp




mov eax, 0
mov ax, [esp+2]
mul eax
pushd eax ; R^2 na stosie

mov eax, 0
mov ax,  [esp+4]
mul eax
pushd eax; r^2 na stosie

mov eax, 0
mov ebx, 0
mov ax, [esp+10]
mov bx, [esp+8]
mul ebx
pushd eax; R*r na stosie

mov eax, 0
add eax, [esp]
add eax, [esp+4]
add eax, [esp+8]
pushd eax; R^2 + Rr + r^2 na stosie

mov ebx, 0
mov ebx, [esp+20]
popd eax
mul ebx
mov ebx, 314
mul ebx
mov edx, 0
mov ebx, 300
div ebx
;eax - wynik

 mov di,1 ; licznik wykonanych instrukcji push, indeks 1 uwzglednia znak dolara na stosie
 mov dx,'$'
 push dx



petla: ;zamiana na dziesietny
	mov ebx,10
	mov edx, 0
	div ebx ; podzielenie rejestru ax przed bx
	add edx,'0' ; zamiana reszty na ascii, reszta jest w dx
	push edx ; wrzucanie na stos znak ascii
	inc di ; po kazdym push zwiekszamy wartosc licznika o 1

	cmp eax,0 ; sprawdzanie czy wynik z dzielenia jest 0
	jne petla ; jezeli wynik z dzielenia nie jest zerem skok do petla






mov ecx, 0
	mov cx,di ; wrzucanie do cx wartosc licznika
	mov di,bufor ; poczatkowy adres docelowego bufora

zdejmowanie_ze_stosu: ;wyswietlanie
	pop eax
	stosb ; przechowywanie znaku z rejestru al pod adres di i zwiekszanie di o 1
	loop zdejmowanie_ze_stosu ; zmniejsz cx o jeden oraz idz do zdejmowanie ze stosu jezeli cx jest rozne od zera
	mov ah,9
	mov dx,wynik
	int 21h
	
	mov ah,9 ; wyswietlanie napisu zakonczonego znakiem dolara
	mov edx, bufor ; adres bufora do dx
	int 21h

	
	mov ah,9
	mov dx,koniec
	int 21h
	
	mov ah,1 ;przerwanie 21h, ah=1 powoduje zakonczenie programu po przez nacisniecie dowolnego klawisza
	int 21h
	
	mov ax, 4c00h ;funkcja wyjscia z programu
	int 21h


blad:
	mov ah,9 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta error zakonczonych znakiem dolara
	mov dx, error
	int 21h
	
	jmp poczatek ; jezeli wprowadzona liczba jest niepoprawna idz do poczatek


witaj db cr,lf, "Witaj. Ten program sluzy do obliczania objetosci stozka scietego",cr,lf
      db 'ze wzoru: V=pi*h*(R^2+R*r+r^2)/3.',cr,lf,cr,lf,'Nalezy podac jego wysokosc h i promienie podstaw R i r.' ,cr,lf
      db 'Nalezy wpisywac liczby calkowite, wynik zaokraglany jest do liczby calkowitej.',cr,lf,'$'
nowa_linia db cr,lf, '$'
koniec db cr,lf,cr,lf,cr,lf, "Nacisnij dowolny klawisz, aby zakonczyc program.$"
error db cr, lf, "Wprowadzona liczba jest niepoprawna.",cr,lf,cr,lf,cr,lf,'$'
bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu
bufor_na_znaki:
rozmiar db 8	 ; miejscie ile znakow mozna maksymalnie odczytac
ile_wczytanych db 0	; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak
wpisz_wysokosc db cr, lf, " Wpisz wysokosc:",cr,lf,cr,lf,ht,"h = $"
wpisz_promien_dol db cr,lf, " Wpisz promien podstawy dolnej:" ,cr,lf,cr,lf,ht,"R = $"
wpisz_promien_gora db cr,lf, " Wpisz promien podstawy gornej:" ,cr,lf,cr,lf,ht,"r = $"
wynik db cr,lf, " Obliczona objetosc stozka wynosi:" ,cr,lf,cr,lf,ht, "t = $"

