 ; sterownik swiate³ uwzglêdniajacy ¿adanie ruchu pieszego sterowany kluczem sw     
 
droga1:
 	mov p1,#11010111b ; czerwony, zielony
    jnb p2.0, zmiana_na_pasy ; jesli wcisniety zostanie przycisk sw0 to na drodze zostanie zapalone swiatlo czerwone 
                             ; a na przejsciu dla pieszych swiatlo zielone
 	acall opoznienie ; opoznienie zmiany

zmiana_na_droge2:
    mov p1,#01110111b ; zolte na drodze
	acall opoznienie ; opoznienie zmiany
		
droga2:
 	mov p1,#10110111b ; czerwony, zielony
    jnb p2.0, zmiana_na_pasy ; jesli wcisniety zostanie przycisk sw0 to na drodze zostanie zapalone swiatlo czerwone 
                             ; a na przejsciu dla pieszych swiatlo zielone
 	acall opoznienie ; opoznienie zmiany
	
zmiana_na_droge1:
    mov p1,#01110111b ; zolte na drodze
	acall opoznienie ; opoznienie zmiany
ajmp droga1 ; kolejne wykonanie petli (czyli dalej zielone na drodze)
       
zmiana_na_pasy: ; przejscie z zielonego na drodze i czerwonego na przejsciu
 	acall opoznienie ; opoznienie zmiany
    mov p1,#01110111b ; swiatlo zolte na drodze
    acall opoznienie ; opoznienie zmiany
       
pasy:  ; zmiana swiatel
 	mov p1, #10111011b; zielony na przejsciu, czerwony na drodze
	acall opoznienie ; opoznienie zmiany

zmiana_na_droge: ; przejscie z zielonego na przejsciu i czerwonego na drodze
 	acall opoznienie  ; opoznienie zmiany
	; miganie zielonym swiatlem dla pieszych, poprzedzajace zmiane swiatel
    mov p1,#01111011b ; zolte na drodze, zielone na przejsciu
	nop ; brak operacji
    mov p1,#01111111b ; zolte na drodze
	nop ; brak operacji
    mov p1,#01111011b ; zolte na drodze, zielone na przejsciu
	nop ; brak operacji
    mov p1,#01111111b ; zolte na drodze
	nop ; brak operacji
    mov p1,#01111011b ; zolte na drodze, zielone na przejsciu
	nop ; brak operacji
    mov p1,#01111111b ; zolte na drodze
	nop ; brak operacji
    mov p1,#01111011b ; zolte na drodze, zielone na przejsciu
	nop ; brak operacji
    ajmp droga1 ; zmiana swiatel
       
opoznienie: ; opoznienie zmiany swiatel
 	nop ; brak operacji
 	nop ; brak operacji
 	nop ; brak operacji
 	nop ; brak operacji
 	nop ; brak operacji
 	nop ; brak operacji
	nop ; brak operacji
 ret

