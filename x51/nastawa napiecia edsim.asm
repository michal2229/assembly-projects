setb p0.0
setb p0.1
setb p0.2

mov r1, #2

start:
	setb p0.0
	setb p0.1
	setb p0.2
	
	mov r0, #1		; ustaw r0 = 1 - jedynka

	; skanuj wiersz0
	clr p0.3		; wyczysc wiersz3
	call skanuj_kolumny
	jb f0, koniec		; | jesli f0 jest ustawione, skocz do koniec 
				; | (because the pressed key was found and its number jest in  r0)

	; skanuj wiersz1
	setb p0.3
	clr p0.2
	call skanuj_kolumny	
	jb f0, koniec

	; skanuj wiersz2
	setb p0.2
	clr p0.1
	call skanuj_kolumny	
	jb f0, koniec

	; skanuj wiersz3
	setb p0.1
	clr p0.0
	call skanuj_kolumny	
	jb f0, koniec

	jmp start		; wroc do poczatku



koniec:
	setb p0.3
	setb p0.2
	setb p0.1
	clr p0.0
	jb p0.6, $ ; czeka na wcisniecie gwiazdki 

	djnz r1, start			; program execution arrives here when key jest found - do nothing

	jmp $
; column-skanuj subroutine
skanuj_kolumny:
	jnb p0.6, wcisnieto_przycisk	; jesli col0 jest cleared - key found
	inc r0			; otherwise move do next key
	jnb p0.5, wcisnieto_przycisk	; jesli col1 jest cleared - key found
	inc r0			; otherwise move do next key
	jnb p0.4,  wcisnieto_przycisk	; jesli col2 jest cleared - key found
	inc r0			; otherwise move do next key
	ret			; return from subroutine - key not found
wcisnieto_przycisk:
	setb f0			; key found - ustaw f0
	ret			; and return from subroutine