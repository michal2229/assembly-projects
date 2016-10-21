mov 3fh, #0
mov 40h, #11110111b
mov 41h, #11101111b
mov 42h, #11011111b
mov 43h, #11111110b
mov 44h, #11111110b
mov 45h, #11111110b
mov 46h, #11111110b
mov 47h, #11111101b
mov 48h, #11111011b
mov 49h, #11110111b
mov 4ah, #11110111b
mov 4bh, #11110111b
mov 4ch, #0

mov 50h, #11111111b
mov 51h, #11111111b
mov 52h, #11111111b
mov 53h, #11110111b
mov 54h, #11101111b
mov 55h, #11100111b
mov 56h, #11100111b
mov 57h, #11100111b
mov 58h, #11100111b
mov 59h, #11101111b
mov 5ah, #11110111b
mov 5bh, #11111111b
mov a, #0

start_przod:
	mov r0, #40h
	mov r1, #50h
	jmp petla; zeby nie wykonal "start_tyl"
start_tyl:
	mov r0, #4bh 
	mov r1, #5bh
	petla:
		mov p1, @r0; ktory element wyswietlacza
		mov p3, @r1; ktory wyswietlacz
		
		mov a, p2; przyciski do akumulatora (sa domyslnie 1)
		xrl a, #11111111b; negacja akumulatora
		jz przod; jesli akumulator == 0
		jnz tyl; jesli akumulator != 0

		przod:
			inc r0
			inc r1
			jmp dalej; zeby nie wykonalo "tak"
		tyl:
			dec r0
			dec r1
		dalej:
			mov a, @r0
			
	jnz petla; skacze jak acc nie rowny 0
	
mov a, p2
xrl a, #11111111b

jz start_przod
jmp start_tyl