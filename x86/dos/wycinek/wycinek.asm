org 100h

cr=13 ; ciag znakow ASCII oznaczajacy koniec biezacej linii
lf=10
ht=9

limitR=3500 ;najwieksa liczba jak� mozna wpisac.
limitalpha=360 ;najwieksa liczba jak� mozna wpisac.

mov ah, 9
mov dx, witaj
int 21h

poczatek:

promien: ;
	mov ah,9       ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
	mov dx,wpisz_promien
	int 21h

	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah     ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h
	
	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si,znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych

promien_:

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
	
	cmp bx,limitR ; porownanie otrzymanej liczby z ogranicznikiem
	jg blad ; jezeli liczba za duza skok do blad
	jmp promien_ ; jezeli nie zostal nacisniety enter to skok do start

dalej1:

mov ah,0
push bx ;R w na stosie



kat: ; etykieta >odczyt< uzyta do utworzenia petli w przypadku wprowadzenia niepoprawnej liczby
	mov ah,9	 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta promien zakonczonych znakiem dolara
	mov dx,wpisz_kat
	int 21h

	mov bx,0       ; wyzerowanie rejestru bx
	
	mov ah,0ah ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h
	
	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, nowa_linia
	int 21h

	mov si,znaki ; poczatkowy adres zrodlowy dla etykiety znaki. Rejestr SI sluzy do operacji na lancuchach danych

kat_:

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
	
	cmp bx,limitalpha ; porownanie otrzymanej liczby z ogranicznikiem
	jg blad ; jezeli liczba za duza skok do blad
	jmp kat_ ; jezeli nie zostal nacisniety enter to skok do start

dalej2:

mov ah,0
push bx ; alpha na stosie


  ;stos (esp - stack pointer):
  ;     R <- esp+2
  ;     alpha <- esp



mov edx, 0  ; zabezpieczenie przed bledem dzielenia i mnozenia
mov eax, 0
mov ax, [esp+2] ; ax = R
mul eax 	; eax = R^2
mov ebx, 314	; ea = 314 * R^2
mul ebx
pushd eax ; R^2*314 na stosie

mov edx, 0
mov eax, 0
mov bx,  [esp+4] ; bx = alpha
mov eax, 36000
div ebx
mov edx, 0
pushd eax; 36000/alpha na stosie

mov eax, [esp+4] ; eax = 314 * R^2
mov ebx, [esp]	 ; ebx = 36000/alpha
div ebx  ; eax = wynik
mov edx, 0



;eax - wynik - pole

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


witaj db cr,lf, "Witaj. Ten program sluzy do obliczania pola wycinka kola",cr,lf
      db 'ze wzoru: P = R^2 * pi * alpha / 360.',cr,lf,cr,lf,'Nalezy podac jego promien R i kat wycinka alpha [deg].' ,cr,lf
      db 'Nalezy wpisywac liczby calkowite, wynik zaokraglany jest do liczby calkowitej.',cr,lf,'$'
nowa_linia db cr,lf, '$'
koniec db cr,lf,cr,lf,cr,lf, "Nacisnij dowolny klawisz, aby zakonczyc program.$"
error db cr, lf, "Wprowadzona liczba jest niepoprawna.",cr,lf,cr,lf,cr,lf,'$'
bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu
bufor_na_znaki:
rozmiar db 8	 ; miejscie ile znakow mozna maksymalnie odczytac
ile_wczytanych db 0	; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak
wpisz_promien db cr, lf, " Wpisz promien R:",cr,lf,cr,lf,ht,"R = $"
wpisz_kat db cr,lf, " Wpisz kat alpha [deg]:" ,cr,lf,cr,lf,ht,"alpha = $"
wynik db cr,lf, " Obliczone pole wycinka kola wynosi:" ,cr,lf,cr,lf,ht, "Pw = $"

