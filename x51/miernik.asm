; Pomiar napiêcia 0-5 V na wyœwietlaczu
; mierzone jest napiecie z ADC i wartosc wyswietlana jest na wyswietlaczu

; wpisuje kombinacje diod odpowiadajace cyfrom
; 10h to cyfra 1, 16h to cyfra 6 itd...
mov 10h, #11000000b
mov 11h, #11111001b
mov 12h, #10100100b
mov 13h, #10110000b
mov 14h, #10011001b
mov 15h, #10010010b
mov 16h, #10000010b
mov 17h, #11111000b
mov 18h, #10000000b
mov 19h, #10010000b
 
; reset przetwornika adc 
  	clr p3.6 	
	clr p3.7
       
poczatek: 
 	setb p3.6
    setb p3.7
      	 
sprawdzaj: ; sprawdzenie czy konwerter skonwertowal
 	jnb p3.2, sterowanie_w_p2 ; jesli konwersja ukonczona to skocz do sterowanie_w_p2
 	jmp sprawdzaj ; jesli nie to probuje dalej
      	
      
sterowanie_w_p2:
; jest sobie napiecie w p2
  	clr p3.6 ; wylaczanie adc
 	clr p3.7
       
; przerabianie binarnej wartosci napiecia na trzy liczby dziesietne
; wartosc napiecia X,YZ [V] zapisana bedzie w pamieci nastepujaco:
; r0=X, r1=Y, r2=Z
 mov a, p2
 mov 31h, a
 mov 32h, a
       
 mov b, #51
 div ab
 mov 30h, a
       
 mov b, #51
 mul ab
 mov 40h, a
       
 mov a, 31h
 subb a, 40h
 mov b, #5
 div ab
 mov 31h, a
 mov b, #5
 mul ab
 mov 41h, a
       
 mov a, 32h
 subb a, 40h
 subb a, 41h
 mov b, #2
 mul ab
 mov 32h, a
       
 mov r0, 30h
 mov r1, 31h
 mov r2, 32h

; ustawiam w komorkach pamieci 70h, 71h i 72h kombinacje
; binarne oznaczajace liczby na wyswietlaczu
; wyswietlacz drugi wyswietla z 70h, trzeci z 71h a czwarty z 72h
mov a, r0
add a, #10h
mov r0, a
mov a, @r0
anl a, #01111111b
mov 70h, a
 
mov a, r1
add a, #10h
mov r0, a
mov 71h, @r0
 
mov a, r2
add a, #10h
mov r0, a
mov 72h, @r0

mov a, #3 ; petla wyswietlajaca (w realnym ukladzie nie byloby widac migania cyfr, mozna by bylo dac wieksze opoznienia wyswietlania nop i wiecej powtorzen petli)

wyswietlanie:
mov p1, #255
orl p3, #00011000b
xrl p3, #00001000b

mov p1, 70h
nop
nop
nop
nop
nop
mov p1, #255

xrl p3, #00011000b
mov p1, 71h
nop
nop
nop
nop
nop
mov p1, #255

xrl p3, #00001000b
mov p1, 72h
nop
nop
nop
nop
nop
mov p1, #255     

dec a
jnz wyswietlanie

 jmp poczatek ; zaczynam mierzyc od poczatku
