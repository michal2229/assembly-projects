; program do liczenia pierwiastka metoda babilonska
; liczba pobierana jest z P2 a wynik zapisywany jest do P1

poczatek: ; tu zaczyna sie program
	MOV R1, p2 ; LICZBA Z KTOREJ LICZYMY PIERWIASTEK 3-GO STOPNIA
	MOV R0, #8 ; LICZBA POCZATKOWA LICZENIA

	call pierwiastek ; wynik do r0
	
	mov p1, r0 ; przenosze wynik na port P1
	jmp poczatek ; koniec liczenia, i od poczatku
	
	
;;;;;;;;;; procedury wywolywane w programie ;;;;;;;;;;;;;;;;;;

pierwiastek: ; cztery iteracje, po ktorych jest juz dobry wynik pierwiastka
	call iteracja_pierwiastka ; nie oplaca sie robic petli przy czterech iteracjach...
	call iteracja_pierwiastka
	call iteracja_pierwiastka
	call iteracja_pierwiastka
ret ; wynik w r0

iteracja_pierwiastka:
; argumenty funkcji w r0, r1
	mov a, r0 ; chce zrobic kwadrat R0
	mov b, R0
	mul ab ; robie kwadrat
	mov r2, a ; przenosze wynik
	mov a, r1; chce zrobic liczba/x2
	mov B, R2
	div ab ; dziele liczbe przez x^2
	mov r3, a ; przenosze wynik
	mov a, r0 ; chce zrobic 2*X+liczba/x^2
	add a, r0 ; dodaje X do X i mam 2X 
	add a, r3 ; dodaje liczba/x^2
	mov b, #3 ; mam sume, chce podzielic przez 3
	div ab ; dziele przez 3
	mov r0, a ; wynik przenosze do R0
ret ; wynik do r0