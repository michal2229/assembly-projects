
mov r0, #13
mov r1, #44
call porownaj

ret ; powrot do poczatku
porownaj:
	mov a, r0
	mov b, r1
	div ab
	jz a_0 ; a = 0
	dec a
	jz a_1 ; a = 1
	jmp a_2 ; a > 1

	a_0:
		jmp koniec_por

	a_1:
		jmp koniec_por

	a_2:
		jmp koniec_por

	r0_eq_r1:
		mov p1, #1
		jmp koniec_por
	r0_lt_r1:
		mov p1, #2
		jmp koniec_por
	r0_gt_r1:
		mov p1, #4
		jmp koniec_por
koniec_por:
ret




	