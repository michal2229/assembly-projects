mov r0, #13
mov r1, #44
call porownaj

porownaj:
	mov a, r0
	mov b, r1
	div ab

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
