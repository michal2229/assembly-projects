org 100h

cr=13 
lf=10 ; cr, lf - enter

limit=20000 ; najwieksza liczba jaka mozna wpisac

mov ah, 9
mov dx, halo
int 21h

start:


; wpisuje x
	mov ebx, 0
x:
	mov ah, 9
	mov dx, podaj_x
	int 21h

	mov bx,0 ; wyzerowanie rejestru bx

	mov ah,0ah ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h 

	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, enter_
	int 21h

	mov si,znaki ; adres poczatku etykiety znaki

x_zamiana: ; zamiana ciagu znakow ascii na liczbe
	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1

	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h, ah=0Ah
	je y ; jezeli klawisz enter zostal wcisniety skacz do etykiety kontynuuj1, jezeli nie idz dalej

	cmp al, '-'
	je x_zamiana

	cmp al,'0' ; porownanie z lewa strona przedzialu cyfr w ascii
	jl blad ; jezeli wprowadzony znak nie miesci sie w przedziale >=0 skacz do etykiety blad

	cmp al,'9' ; prawa strona przedzialu
	jg blad ; jezeli wprowadzony znak nie miesci sie w przedziale <=9 skok do etykiety blad

	mov cl,al ; zapamietywanie wartosci al zeby odtworzyc ja po wymnozeniu rejestru ax przez 10
	mov ax,bx ; wartosc z bx trafia do ax
	mov dx,10
	mul dx ; domyslnie dla mul wymnozona wartosc jest w ax (al-->ax)

	mov bx,ax
	mov al,cl ; przywracanie stara wartosc al poniewaz mul zamazuje ax

	sub al,'0' ; zamiana Ascii na liczbe 
	xor ah,ah ; wyzerowanie rejestru ah
	add bx,ax ; WYNIK JEST W bx
	
	jmp x_zamiana ; jezeli nie zostal nacisniety enter to skok do poczatku petli


; wpisuje y

y:
	cmp ebx, limit
	jg blad
	pushd ebx
	mov ah, 9
	mov dx, podaj_y
	int 21h

	mov bx,0 ; wyzerowanie rejestru bx

	mov ah,0ah ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h 

	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, enter_
	int 21h

	mov si,znaki ; adres poczatku etykiety znaki

y_zamiana: ; zamiana ciagu znakow ascii na liczbe
	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1

	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h, ah=0Ah
	je z ; jezeli klawisz enter zostal wcisniety skacz do etykiety kontynuuj1, jezeli nie idz dalej

	cmp al, '-'
	je y_zamiana

	cmp al,'0' ; porownanie z lewa strona przedzialu cyfr w ascii
	jl blad ; jezeli wprowadzony znak nie miesci sie w przedziale >=0 skacz do etykiety blad

	cmp al,'9' ; prawa strona przedzialu
	jg blad ; jezeli wprowadzony znak nie miesci sie w przedziale <=9 skok do etykiety blad

	mov cl,al ; zapamietywanie wartosci al zeby odtworzyc ja po wymnozeniu rejestru ax przez 10
	mov ax,bx ; wartosc z bx trafia do ax
	mov dx,10
	mul dx ; domyslnie dla mul wymnozona wartosc jest w ax (al-->ax)

	mov bx,ax
	mov al,cl ; przywracanie stara wartosc al poniewaz mul zamazuje ax

	sub al,'0' ; zamiana Ascii na liczbe 
	xor ah,ah ; wyzerowanie rejestru ah
	add bx,ax ; WYNIK JEST W bx
	
	jmp y_zamiana ; jezeli nie zostal nacisniety enter to skok do poczatku petli

; wpisuje z

z:
	cmp ebx, limit
	jg blad
	pushd ebx
	mov ah, 9
	mov dx, podaj_z
	int 21h

	mov bx,0 ; wyzerowanie rejestru bx

	mov ah,0ah ; przerwanie 21 ktore odczytuje ciag znakow do momentu nacisniecia enter
	mov dx, bufor_na_znaki
	int 21h 

	mov ah,9	 ; przeniesienie do nastepnej linii
	mov dx, enter_
	int 21h

	mov si,znaki ; adres poczatku etykiety znaki

z_zamiana: ; zamiana ciagu znakow ascii na liczbe
	lodsb ; odczytywanie znaku spod adresu si do rejestru al i zwieksza si o 1

	cmp al, cr ; porownanie cr=13 oraz znaku ktory trafil do al w wyniku przerwania int 21h, ah=0Ah
	je kontynuuj1 ; jezeli klawisz enter zostal wcisniety skacz do etykiety kontynuuj1, jezeli nie idz dalej

	cmp al, '-'
	je z_zamiana

	cmp al,'0' ; porownanie z lewa strona przedzialu cyfr w ascii
	jl blad ; jezeli wprowadzony znak nie miesci sie w przedziale >=0 skacz do etykiety blad

	cmp al,'9' ; prawa strona przedzialu
	jg blad ; jezeli wprowadzony znak nie miesci sie w przedziale <=9 skok do etykiety blad

	mov cl,al ; zapamietywanie wartosci al zeby odtworzyc ja po wymnozeniu rejestru ax przez 10
	mov ax,bx ; wartosc z bx trafia do ax
	mov dx,10
	mul dx ; domyslnie dla mul wymnozona wartosc jest w ax (al-->ax)

	mov bx,ax
	mov al,cl ; przywracanie stara wartosc al poniewaz mul zamazuje ax

	sub al,'0' ; zamiana Ascii na liczbe 
	xor ah,ah ; wyzerowanie rejestru ah
	add bx,ax ; WYNIK JEST W bx
	
	jmp z_zamiana ; jezeli nie zostal nacisniety enter to skok do poczatku petli



kontynuuj1:
	cmp ebx, limit
	jg blad
	pushd ebx

	; x = [esp+4*2]
	; y = [esp+4*1]
	; z = [esp+4*0]

	mov edx, 0
	mov eax, [esp+4*0]
	imul eax	    ; z^2
	mov [esp+4*0], eax

	mov eax, [esp+4*1]
	imul eax	    ; y^2
	mov [esp+4*1], eax

	mov eax, [esp+4*2]
	imul eax	    ; X^2
	 add eax, [esp+4*1] ; X^2 + Y^2
	 add eax, [esp+4*0] ; X^2 + Y^2 + Z^2 - teraz tylko zrobic pierwiastek...
	mov ecx, eax

	cmp ecx, 3
	jg dalej__

	cmp ecx, 0
	mov eax, 1
	jne kontynuuj2
	mov eax, 0


	jmp kontynuuj2

dalej__:
	mov ebx, 1
	push ebx
	push ebx



pierwiastek:
	mov edx, 0  ; jak nie wyzeruje to bedzie sypac bledem przy dzieleniu
	pop ebx
	mov eax, ecx
	push ebx
	div ebx
	pop ebx
	add eax, ebx
	shr eax, 1
	push eax

	cmp eax, ebx
	jne pierwiastek

	mov edx, 0
kontynuuj2:
	mov di,1 ; licznik wykonanych instrukcji push
	mov dx,'$'
	push dx

petla: ; zamiana na dziesietny
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

zdejmowanie_ze_stosu: ; wyswietlanie
	pop eax
	stosb ; przechowywanie znaku z rejestru al pod adres di i zwiekszanie di o 1
	loop zdejmowanie_ze_stosu ; zmniejsz cx o jeden oraz idz do zdejmowanie ze stosu jezeli cx jest rozne od zera

	mov ah,9
	mov dx,wynik
	int 21h

	mov ah,9 ; wyswietlanie napisu zakonczonego znakiem dolara
	mov edx, bufor ; adres bufora do dx
	int 21h

koniec_:
	mov ah,9
	mov dx,koniec
	int 21h

	mov ah,1 ; przerwanie 21h, ah=1 powoduje zakonczenie programu po przez nacisniecie dowolnego klawisza
	int 21h

	mov ax, 4c00h ; funkcja wyjscia z programu
	int 21h

blad:
	mov ah,9 ; przerwanie 21 wypisuje na ekran ciag znakow pod etykieta popsute
	mov dx, popsute
	int 21h

	jmp start ; jezeli wprowadzona liczba jest niepoprawna idz do start


	
		; -----  poczatek sekcji danych -----
		
halo db " Witaj. Ten program sluzy do obliczania dlugosci odcinka ktorego jeden koniec",cr,lf
     db " znajduje sie w poczatku ukladu wspolrzednych a wspolrzedne drugiego wpisuje uzytkownik.", cr, lf, cr, lf
     db " Nalezy wprowadzic wspolrzedne:",cr,lf, '$'

koniec db cr,lf,cr,lf,cr,lf, 'Koniec programu.',cr,lf,'Nacisnij dowolny klawisz, aby zakonczyc program.$'

bufor rb 6 ; rezerwujemy miejscie na znaki zdjete ze stosu

bufor_na_znaki:
rozmiar db 8 ; miejscie ile znakow mozna maksymalnie odczytac
ile_ db 0 ; ile rzeczywiscie odczytano
znaki rb 8 ; miejsce na znak

enter_ db cr,lf, '$'

popsute db cr, lf, "Blad, jeszcze raz.",cr,lf,cr,lf,'   $'

podaj_x db cr,lf, " x = $"
podaj_y db cr,lf, " y = $"
podaj_z db cr,lf, " z = $"


wynik db cr,lf," Dlugosc odcinka wynosi $"