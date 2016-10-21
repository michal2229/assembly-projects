; xtal - 10kHz

org 0000h 			; poczatek pamieci programu
	jmp main		; skok do programu glownego
	
org 000bh			; miejsce w pamieci do ktorego przechodzi program przy przerwaniu t0
	clr tr0			; zatrzymanie licznika
	jmp przerwanie	; skok do obslugi przerwania t0
	
org 0030h			; programu glowny

main:
	mov a, #0ffh
	mov b, #27h
	subb a, b
	mov th0, a

	mov a, #0ffh
	mov b, #10h
	subb a, b
	mov tl0, a

	mov tmod, #11h
	setb ea
	setb et0
	setb tr0
	
	clr p3.0
	
	mov r0, #0
jeszcze_raz:
	jnb p2.0, sygnal
jmp jeszcze_raz

sygnal:
	inc r0
jmp jeszcze_raz

przerwanie:
	mov a, r0
	mov b, #6
	mul ab
	
	mov r1, a
	mov b, #10
	div ab
	swap a
	add a, b ; dwucyfrowa bcd

	mov p0, a ; przenosze puls
	
	mov a, r1
	
	mov b, #70
	subb a, b
	jb ov, ujemna ; jesli przepelnienie to jest minus
	
licz_dalej:
	mov b, #10
	mul ab
	
	mov b, #7
	div ab
	
	mov r1, a
	mov b, #10
	div ab
	swap a
	add a, b ; dwucyfrowa bcd
	
	mov p5, a ; przekazuje odchylenie od normy w procentach
	jmp $
reti

ujemna:
	setb p3.0 ; znacznik ujemnej liczby
	mov b, #-1
	mul ab ; mnozenie razy ujemna w u2, zeby nie bylo negacji tylko bit znaku p3.0
jmp licz_dalej