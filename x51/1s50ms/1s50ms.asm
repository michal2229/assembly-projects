;
; 26. Generator prostokątny, impuls 1 sek, 50 ms przerwa 
; z wykorzystaniem timera w trybie 0 z obsługą przerwań.
;
; Program przeznaczony jest do używania w symulatorze EDSIM51di.
; Częstotliwość kwarcu: 48kHz = 0,048MHz
; Zalecana częstotliwość odświeżania: 100x.
;

jmp main ; skok do programu glownego

org 0bh  ; obsluga przerwania licznika T0
	jmp obsluga_t0

org 1bh  ; obsluga przerwania licznika T1
	jmp obsluga_t1
	
main: ; program glowny
	clr p0.7 ; wlaczanie oscyloskopu
	mov tmod, #00h ; tryb 0 - licznik 13bit
	mov th0, #082h ; wartosc poczatkowa
	mov tl0, #0b0h ; liczenia sekundy
	mov p1, #200 ; jedynka logiczna
	setb tr0 ; wlaczam licznik t0
	setb et0 ; wlaczam przerwania licznika t0
	setb et1 ; wlaczam przerwania licznika t1
	setb ea	 ; wlaczam wszystkie przerwania

	jmp $ ; petla nieskonczona 

obsluga_t0: ; obsluga przerwania licznika T0
	clr tr0 ; wylaczam licznik t0
	mov th1, #0f9h ; wartosc poczatkowa
	mov tl1, #070h ; liczenia 50ms
	setb tr1 ; wlaczam licznik t1
	mov p1, #0 ; ustawienie wartosci 0
reti

obsluga_t1: ; obsluga przerwania licznika T1
	clr tr1 ; wylaczam licznik t1
	mov th0, #083h ; wartosc poczatkowa
	mov tl0, #008h ; liczenia sekundy
	setb tr0 ; wlaczam licznik t0
	mov p1, #200 ; ustawienie wartosci 1
reti
