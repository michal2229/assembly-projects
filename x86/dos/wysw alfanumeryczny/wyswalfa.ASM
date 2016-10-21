org 100h

push ax
push bx
push cx
push dx

mov ah, 9
mov dx, zaczynam
int 21h

znak = 26h   ; tyle wynosi przesuniecie miedzy dwoma znakami wyswietlacza
mov bl,30h   ; kod ascii znaku '0'
mov bh,7bh   ; kod ascii znaku 'z'

petla:
	mov ah, 7h ; wczytuje znak bez echa
	int 21h ; znak w al

	cmp al, '0'
	jl stop      ; sprawdzam czy znak wprowadzony jest mniejszy niz '0'
	cmp al, 'z'
	jg stop      ; sprawdzam czy znak wprowadzony jest wiekszy niz 'z'

	sub al, '0'  ; zamieniam znak ascii na liczbe porzadkowa znaku wyswietlacza
	mov dl, znak ; wrzucam przesuniecie do dl
	mul dl	     ; mnoze przesuniecie razy liczbe porzadkowa, aby wiedziec o o ile znakow wyswietlacza mam sie przeniesc do przodu

	mov dx, qq   ; wrzucam do dx znak wyswietlacza - zero
	add dx, ax   ; przenosze sie od zera o ilosc znakow wyswietlacza, aby wyswietlic ten wlasciwy

	mov ah, 9h   ; wyswietlam znak wyswietlacza i zaczynam od nowa
	int 21h
jmp petla

stop:
mov ah, 9
mov dx, koncze
int 21h


mov ah,1 ; czeka na klawisz
int 21h

pop ax
pop bx
pop cx
pop dx

mov ah,0 ; ladne wyjscie z programu
int 21h

qq db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

qw db 13,10,'   X '
   db 13,10,'  XX '
   db 13,10,' X X '
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'$'

qe db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'   XX'
   db 13,10,' XX  '
   db 13,10,'XXXXX'
   db 13,10,'$'

qr db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'   XX'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

qt db 13,10,'   X '
   db 13,10,'  XX '
   db 13,10,' X X '
   db 13,10,'XXXXX'
   db 13,10,'   X '
   db 13,10,'$'

qy db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXX '
   db 13,10,'    X'
   db 13,10,'XXXX '
   db 13,10,'$'

qu db 13,10,' XXX '
   db 13,10,'X    '
   db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

qi db 13,10,'XXXXX'
   db 13,10,'    X'
   db 13,10,'   X '
   db 13,10,'  X  '
   db 13,10,' X   '
   db 13,10,'$'

qo db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

qp db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,' XXXX'
   db 13,10,'    X'
   db 13,10,' XXX '
   db 13,10,'$'

qa db 13,10,'  XX '
   db 13,10,'  XX '
   db 13,10,'     '
   db 13,10,'  XX '
   db 13,10,'  XX '
   db 13,10,'$'

qs db 13,10,'  XX '
   db 13,10,'  XX '
   db 13,10,'     '
   db 13,10,'  XX '
   db 13,10,'   X '
   db 13,10,'$'

qd db 13,10,'    X'
   db 13,10,'  X  '
   db 13,10,'X    '
   db 13,10,'  X  '
   db 13,10,'    X'
   db 13,10,'$'

qf db 13,10,'     '
   db 13,10,'XXXXX'
   db 13,10,'     '
   db 13,10,'XXXXX'
   db 13,10,'     '
   db 13,10,'$'

qg db 13,10,'X    '
   db 13,10,'  X  '
   db 13,10,'    X'
   db 13,10,'  X  '
   db 13,10,'X    '
   db 13,10,'$'

qh db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'   X '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'$'

qj db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,' XX X'
   db 13,10,'X  XX'
   db 13,10,' XX  '
   db 13,10,'$'

qk db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'XXXXX'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

ql db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'$'

qz db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X    '
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

qx db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'$'

qc db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'$'

qv db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'$'

qb db 13,10,' XXX '
   db 13,10,'X    '
   db 13,10,'X XXX'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

qn db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'XXXXX'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

qm db 13,10,'  XXX'
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'  XXX'
   db 13,10,'$'

wq db 13,10,' XXXX'
   db 13,10,'    X'
   db 13,10,'    X'
   db 13,10,' X  X'
   db 13,10,'  XX '
   db 13,10,'$'

ww db 13,10,'X  X '
   db 13,10,'X X  '
   db 13,10,'XX   '
   db 13,10,'X X  '
   db 13,10,'X  X '
   db 13,10,'$'

we db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'$'

wr db 13,10,'X   X'
   db 13,10,'XX XX'
   db 13,10,'X X X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

wt db 13,10,'X   X'
   db 13,10,'XX  X'
   db 13,10,'X X X'
   db 13,10,'X  XX'
   db 13,10,'X   X'
   db 13,10,'$'

wy db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

wu db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'$'

wi db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X  XX'
   db 13,10,' XXXX'
   db 13,10,'$'

wo db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

wp db 13,10,' XXXX'
   db 13,10,'X    '
   db 13,10,' XXX '
   db 13,10,'    X'
   db 13,10,'XXXX '
   db 13,10,'$'

wa db 13,10,'XXXXX'
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'$'

ws db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

wd db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' X X '
   db 13,10,'  X  '
   db 13,10,'$'

wf db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X X X'
   db 13,10,'XX XX'
   db 13,10,'X   X'
   db 13,10,'$'

wg db 13,10,'X   X'
   db 13,10,' X X '
   db 13,10,'  X  '
   db 13,10,' X X '
   db 13,10,'X   X'
   db 13,10,'$'

wh db 13,10,'X   X'
   db 13,10,' X X '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'$'

wj db 13,10,'XXXXX'
   db 13,10,'   X '
   db 13,10,'  X  '
   db 13,10,' X   '
   db 13,10,'XXXXX'
   db 13,10,'$'

wk db 13,10,' XX  '
   db 13,10,' X   '
   db 13,10,' X   '
   db 13,10,' X   '
   db 13,10,' XX  '
   db 13,10,'$'

wl db 13,10,'X    '
   db 13,10,' X   '
   db 13,10,'  X  '
   db 13,10,'   X '
   db 13,10,'    X'
   db 13,10,'$'

wz db 13,10,'  XX '
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'  XX '
   db 13,10,'$'

wx db 13,10,'  X  '
   db 13,10,' X X '
   db 13,10,'X   X'
   db 13,10,'     '
   db 13,10,'     '
   db 13,10,'$'

wc db 13,10,'     '
   db 13,10,'     '
   db 13,10,'     '
   db 13,10,'     '
   db 13,10,'XXXXX'
   db 13,10,'$'

wv db 13,10,'  XX '
   db 13,10,'  XX '
   db 13,10,'   X '
   db 13,10,'  X  '
   db 13,10,'     '
   db 13,10,'$'

wn db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'XXXXX'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

wm db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'$'

ew db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X    '
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

ee db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'$'

er db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'$'

et db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'$'

ey db 13,10,' XXX '
   db 13,10,'X    '
   db 13,10,'X XXX'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

eu db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'XXXXX'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

ei db 13,10,'  XXX'
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'   X '
   db 13,10,'  XXX'
   db 13,10,'$'

eo db 13,10,' XXXX'
   db 13,10,'    X'
   db 13,10,'    X'
   db 13,10,' X  X'
   db 13,10,'  XX '
   db 13,10,'$'

ep db 13,10,'X  X '
   db 13,10,'X X  '
   db 13,10,'XX   '
   db 13,10,'X X  '
   db 13,10,'X  X '
   db 13,10,'$'

ea db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'XXXXX'
   db 13,10,'$'

ed db 13,10,'X   X'
   db 13,10,'XX XX'
   db 13,10,'X X X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

ef db 13,10,'X   X'
   db 13,10,'XX  X'
   db 13,10,'X X X'
   db 13,10,'X  XX'
   db 13,10,'X   X'
   db 13,10,'$'

eg db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

eh db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'X    '
   db 13,10,'X    '
   db 13,10,'$'

ej db 13,10,' XXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X  XX'
   db 13,10,' XXXX'
   db 13,10,'$'

ek db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'XXXX '
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'$'

el db 13,10,' XXXX'
   db 13,10,'X    '
   db 13,10,' XXX '
   db 13,10,'    X'
   db 13,10,'XXXX '
   db 13,10,'$'

ez db 13,10,'XXXXX'
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'$'

ex db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' XXX '
   db 13,10,'$'

ec db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,' X X '
   db 13,10,'  X  '
   db 13,10,'$'

ev db 13,10,'X   X'
   db 13,10,'X   X'
   db 13,10,'X X X'
   db 13,10,'XX XX'
   db 13,10,'X   X'
   db 13,10,'$'

eb db 13,10,'X   X'
   db 13,10,' X X '
   db 13,10,'  X  '
   db 13,10,' X X '
   db 13,10,'X   X'
   db 13,10,'$'

en db 13,10,'X   X'
   db 13,10,' X X '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'  X  '
   db 13,10,'$'

gq db 13,10,'XXXXX'
   db 13,10,'   X '
   db 13,10,'  X  '
   db 13,10,' X   '
   db 13,10,'XXXXX'
   db 13,10,'$'

zaczynam db 13, 10, 9, 'Witam w symulatorze wyswietlacza alfanumerycznego.'
	 db 13, 10, 9, 'Wyswietlacz ma wymiary 5x5 pikseli.'
	 db 13, 10, 9, 'Wprowadzony z klawiatury znak zostanie wyswietlony na wyswietlaczu.'
	 db 13, 10, 9, 'Prosze wprowadzic cyfre, litere lub jeden z ponizszych znakow:', 13,10,9,9,' : ; < = > ? @'
	 db 13, 10, 13, 10, 9, 'Wprowadzenie innego znaku zakonczy program.$'

koncze db 13, 10, 13, 10, 9, 'Wprowadzono znak spoza zakresu. Program zostanie zakonczony.'
       db 13, 10,13,10, 9, 'Program napisal: Michal Bokiniec, A1X1S1.$'