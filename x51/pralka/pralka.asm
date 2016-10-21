krok_0:
	jnb p2.0, krok_4 ; jesli przelacznik sw0 zostanie wcisniety to zostanie wykonana procedura wirowania naprzemiennego
krok_1:
	jnb p2.1, krok_6 ; jesli przelacznik sw1 zostanie wcisniety to zostanie wykonana procedura wirowania jednokierunkowego
krok_2:
	jnb p2.2, krok_8 ; jesli przelacznik sw2 zostanie wcisniety to zostanie wykonana procedura wirowania ciaglego
krok_3:
	jmp krok_0 ; powrot do poczatku programu
krok_4:
	call wirowanie_przemienne_loop ; wywolanie procedury wirowania naprzemiennego
krok_5:
	jmp krok_0 ; powrot do poczatku programu
krok_6:
	call wirowanie_jednokierunkowe_loop ; wywolanie procedury wirowania jednokierunkowego
krok_7:
	jmp krok_0 ; powrot do poczatku programu
krok_8:
	call wirowanie_ciagle_loop ; wywolanie procedury wirowania ciaglego
krok_9:
	jmp krok_0 ; powrot do poczatku programu
	
wirowanie_przemienne_loop: ; procedura wirowania naprzemiennego
	mov a, #6 ; przenoszenie do akumulatora liczby oznaczajacej ilosc wykonan petli zmienne_loop
	call pobieraj_wode ; wywolanie procedury pobierajacej wode
	zmienne_loop:
		call wirowanie_cw ; wywolanie procedury wirowania w kierunku zgodnym z kierunkiem ruchu zegara
		call odczekaj_krotko ; wywolanie procedury krotkiego odczekiwania
		call wirowanie_ccw ; wywolanie procedury wirowania w kierunku przeciwnym z kierunkiem ruchu zegara
		call odczekaj_krotko		
		dec a ; zmniejszenie wartosci w akumulatorze o jeden (aby petla wykonala sie okreslona ilosc razy)
	jnz zmienne_loop ; jesli akumulator > 0 to wykonaj petle jeszcze raz
	call odwirowywanie_wody
ret

wirowanie_jednokierunkowe_loop: ; procedura wirowania jednokierunkowego, analogiczna do poprzedniej procedury
	mov a, #12 
	call pobieraj_wode ; wywolanie procedury pobierajacej wode
	standardowe_loop:
		call wirowanie_ccw
		call odczekaj_krotko
		dec a
	jnz standardowe_loop
	call odwirowywanie_wody
ret

wirowanie_ciagle_loop: ; procedura wirowania ciaglego, analogicznie do poprzednich
	mov a, #12
	call pobieraj_wode ; wywolanie procedury pobierajacej wode
	call wirowanie_ciagle ; wywolanie procedury wirowania w jednym kierunku, bez przerw
	ciagle_loop:
		call odczekaj_dlugo
		dec a
	jnz ciagle_loop
	call stop ; po wykonaniu petli zatrzymaj obracanie
	call odwirowywanie_wody
ret

odwirowywanie_wody: ; procedura wirowania jednokierunkowego, analogiczna do poprzedniej procedury
	mov a, #3 
	call otworz_zawor_odprowadzania_wody ; rozpoczecie odprowadzania wody
	call wirowanie_ciagle ; wywolanie procedury wirowania w jednym kierunku, bez przerw
	odwirowywanie_loop:
		call odczekaj_dlugo
		dec a
	jnz odwirowywanie_loop
	call stop ; po wykonaniu petli zatrzymaj obracanie
	call zamknij_zawor_odprowadzania_wody ; zakonczenie odprowadzania wody	 
ret

wirowanie_cw: ; procedura wirowania w kierunku zgodnym z ruchem wskazowek zegara
	call cw   ; wywolanie procedury ustawienia kierunku wirowania na zgodny z ruchem wskazowek zegara
	call odczekaj_dlugo ; wywolanie procedury dlugiego odczekiwania
	call stop ; wywolanie procedury zatrzymujacej obracanie
ret

wirowanie_ccw: ; procedura wirowania w kierunku przeciwnym do ruchu wskazowek zegara
	call ccw ; wywolanie procedury ustawienia kierunku wirowania na przeciwny do ruchu wskazowek zegara
	call odczekaj_dlugo
	call stop
ret

wirowanie_ciagle: ; procedura wirowania ciaglego
	call cw ; wywolanie procedury ustawienia kierunku wirowania na zgodny z ruchem wskazowek zegara
ret

cw: ; procedura ustawienia kierunku wirowania na zgodny z ruchem wskazowek zegara
	clr p3.1 ; wyczyszczenie bitu 1 kontroli silnika 
	setb p3.0 ; ustawienie bitu 0 kontroli silnika 
ret

ccw: ; procedura ustawienia kierunku wirowania na przeciwny do ruchu wskazowek zegara
	setb p3.1 ; ustawienie bitu 1 kontroli silnika 
	clr p3.0 ; wyczyszczenie bitu 0 kontroli silnika 
ret

stop: ; procedura zatrzymujaca obracanie
	setb p3.1 ; ustawienie bitu 1 kontroli silnika 
	setb p3.0 ; ustawienie bitu 0 kontroli silnika 
ret

odczekaj_dlugo: ; procedura dlugiego odczekiwania
	mov b, a ; zachowuje stara wartosc akumulatora
	mov a, #12
	odczekiwanie_dlugie: ; petla odczekiwania dlugiego
		nop ; no operation
		dec a  ; zmniejszenie wartosci w akumulatorze o jeden (aby petla wykonala sie okreslona ilosc razy)
	jnz odczekiwanie_dlugie ; jesli akumulator > 0 to wykonaj petle jeszcze raz
	mov a, b ; przywracam stara wartosc akumulatora
ret

odczekaj_krotko: ; procedura krotkiego odczekiwania
	mov b, a ; zachowuje stara wartosc akumulatora
	mov a, #6
	odczekiwanie_krotkie: ; petla odczekiwania krotkiego
		nop  ; zmniejszenie wartosci w akumulatorze o jeden (aby petla wykonala sie okreslona ilosc razy)
		dec a
	jnz odczekiwanie_krotkie ; jesli akumulator > 0 to wykonaj petle jeszcze raz
	mov a, b ; przywracam stara wartosc akumulatora
ret

pobieraj_wode: ; procedura pobierania wody
	clr p1.0 ; zaswiecenie diody sybolizujace pobieranie wody
	jb p2.7, $ ; oczekiwanie na sygnal z czujnika (przycisku SW7), oznaczajacego, ze ilosc wody jest odpowiednia
	setb p1.0 ; gaszenie diody - koniec pobierania wody
ret

otworz_zawor_odprowadzania_wody: ; procedura odprowadzania wody
	clr p1.1 ; zaswiecenie diody sybolizujace otwarcie zaworu odprowadzania wody
ret

zamknij_zawor_odprowadzania_wody: ; procedura zakonczenia odprowadzania wody
	setb p1.1 ; gaszenie diody sybolizujace zamkniecie zaworu odprowadzania wody
ret