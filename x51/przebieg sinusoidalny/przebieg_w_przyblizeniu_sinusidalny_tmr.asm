;
; Program generujacy na oscyloskopie sygnal prostokatny o nastawnej czestotliwosci.
;
; Uzytkownik dobiera wybrana przez siebie wartosc opozniena za pomoca suwaka 
; napiecia wejsciowego na przetwonik analogowo cyfrowy,
; nastepnie zatwierdza swoje ustawienie przyciskiem SW0.
; Po zatwierdzeniu program dziala w petli, rysujac na oscyloskopie
; sygnal zblizony do sinusoidalnego o czestotliwosci wynikajacej z zadanego opoznienia.
; Mozliwa jest modyfikacja wybranego opoznienia poprzez ponowne wcisnecie przycisku SW0,
; nastawe na suwaku oraz ponowne zwolnienie przycisku SW0.
;
;

call wpisywanie_danych ; prowadzanie danych probek do pamieci 
call ustawianie_kodu_siedmiosegmentowego          
start:               ; poczatek programu
    setb p0.7        ; wylaczam oscyloskop
	clr tr0          ; wylaczam licznik
    call przetwornik ; zamiana napiecia na forme cyfrowa
    call tlumacz     ; tlumaczenie cyfr na 7seg
    call wysw_
jb p2.0, start       ; jesli przycisk modyfikacji jest wcisniety to powtorz
clr p0.7 ; wlaczenie oscyloskopu

    mov a, r5  ; wczytywanie odczytu z konwertera do akumulatora
    mov b, #2  ; wczytywanie do rejestru 'b' dwojki jako dzielnika
    div ab     ; dzielenie odczytu z konwertera przez dwa
    inc a     ; zwiekszenie o jeden w celu wyeliminowania zera
    mov r5, a

    mov a, #0   ; konwersja wartosci opoznienia 
    subb a, r5  ; na wartosc poprawna dla licznika
    mov r1, a   ; (liczy od pewnej wyliczonej wartosci do 256) 

    mov r0, #15    ; adres poczatkowy probek
    mov tmod, #22h ; 8bit + reload - dolna czesc licznika liczy i po przepelnieniu przyjmuje wartosc gornej czesci
    mov th0, r1    ; ustawianie wartosci odnawiania tl0
    mov tl0, r1    ; ustawienie poczatkowej 
    setb tr0       ; wlaczam liczenie licznika t0

    petla1:            ; skanowanie probek w przod
        clr tf0        ; czyszczenie flagi przepelnienia licznika t0
        inc r0         ; zwiekszanie wskaznika o jeden w celu dostania sie do kolejnej probki
        mov a, @r0     ; przenoszenie wartosci probki okreslonej wskaznikiem do akumulatora
        jz petla2      ; jesli wartosc probki rowna jest wartosci granicznej (zero) to skok do kolejnej petli
        mov p1, a      ; wprowadz wartosc probki na przetwornik cyfrowo-analogowy, do ktorego podlaczony jest oscyloskop
        jnb tf0, $     ; zatrzymanie programu, jesli nie doszlo jeszcze do przepelnienia licznika t0 - tu realizowana jest kontrola czestotliwosci sygnalu
    jnb p2.0,  petla1  ; sprawdzenie wcisniecia przycisku SW0 w celu ponownego ustawienia czasu opoznienia,
jmp start              ; jesli nie jest wcisniety to skok do ustawiania
    petla2:            ; skanowanie probek w tyl
        clr tf0        ; czyszczenie flagi przepelnienia licznika t0
        dec r0         ; zmniejszanie wskaznika o jeden w celu dostania sie do poprzedniej probki
        mov a, @r0     ; przenoszenie wartosci probki okreslonej wskaznikiem do akumulatora
        jz petla1      ; jesli wartosc probki rowna jest wartosci granicznej (zero) to skok do kolejnej petli
        mov p1, a      ; wprowadz wartosc probki na przetwornik cyfrowo-analogowy, do ktorego podlaczony jest oscyloskop
        jnb tf0, $     ; zatrzymanie programu, jesli nie doszlo jeszcze do przepelnienia licznika t0 - tu realizowana jest kontrola czestotliwosci sygnalu
    jnb p2.0,  petla2  ; sprawdzenie wcisniecia przycisku SW0 w celu ponownego ustawienia czasu opoznienia
jmp start              ; jesli nie jest wcisniety to skok do ustawiania

; procedury

chwila_czekania:
    mov a, #100h
    mov r4, a
    asdf:
        nop
    djnz r4, asdf
ret

wysw_:
    mov p1, #255 ; gaszenie segmentu
    orl p3, #00011000b ; ustawianie, ktory segment zapalic
    
    xrl p3, #00001000b 
    mov p1, 70h ; wyswietlanie wartosci na danym segmencie
    
    call chwila_czekania ; czas wyswietlania segmentu
    
    mov p1, #255 
    xrl p3, #00011000b
    mov p1, 71h 
    
    call chwila_czekania

    mov p1, #255
    xrl p3, #00001000b
    mov p1, 72h
    
    call chwila_czekania 
ret

tlumacz: 
    mov a, 70h ; dziesiatki
    add a, #50h
    mov r0, a
    mov 70h, @r0   ; przenosze kod cyfry do pamieci segmentu

    mov a, 71h ; dziesiatki
    add a, #50h
    mov r0, a
    mov 71h, @r0
 
    mov a, 72h ; jednosci
    add a, #50h
    mov r0, a
    mov 72h, @r0
ret

przetwornik:      ; procedura odczytujaca wartosc napiecia na przetworniku analogowo cyfrowym
    clr p3.6      ; reset
    setb p3.6     ; wlacz konwerter
    jb p3.2, $    ; sprawdzenie stanu konwersji
    clr p3.7      ; przygotowanie linii p2 do odczytu z konwertera
    mov r5, p2    ; zapisuje wynik do r5

    mov a, r5 ; wczytywanie odczytu z konwertera do akumulatora

    mov b, #10 ; zapisywanie wartosci opoznienia do segmentow
    div ab
    mov 72h, b

    mov b, #10
    div ab
    mov 71h, b
    mov 70h, a

    setb p3.7     ; odlaczam konwerter od linii p2
ret

ustawianie_kodu_siedmiosegmentowego:
    mov 50h, #11000000b ; 0
    mov 51h, #11111001b ; 1
    mov 52h, #10100100b ; 2
    mov 53h, #10110000b ; 3
    mov 54h, #10011001b ; 4
    mov 55h, #10010010b ; 5
    mov 56h, #10000010b ; 6
    mov 57h, #11111000b ; 7
    mov 58h, #10000000b ; 8
    mov 59h, #10010000b ; 9
ret

wpisywanie_danych: ; wprowadzanie wartosci probek ogramiczonych zerami
    mov    15    , #    0  ; zero graniczne
    mov    16    , #    255
    mov    17    , #    254
    mov    18    , #    253
    mov    19    , #    250
    mov    20    , #    245
    mov    21    , #    240
    mov    22    , #    234
    mov    23    , #    226
    mov    24    , #    218
    mov    25    , #    209
    mov    26    , #    199
    mov    27    , #    188
    mov    28    , #    177
    mov    29    , #    165
    mov    30    , #    153
    mov    31    , #    140
    mov    32    , #    128
    mov    33    , #    116
    mov    34    , #    103
    mov    35    , #    91
    mov    36    , #    79
    mov    37    , #    68
    mov    38    , #    57
    mov    39    , #    47
    mov    40    , #    38
    mov    41    , #    30
    mov    42    , #    22
    mov    43    , #    16
    mov    44    , #    10
    mov    45    , #    5
    mov    46    , #    2
    mov    47    , #    1
    mov    48    , #    0 ; zero graniczne
ret                
