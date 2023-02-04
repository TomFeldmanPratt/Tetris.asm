IDEAL
MODEL small
STACK 100h
DATASEG
Filename db 'tetdat.txt',0
FileError db 'there has been an error opening your tetris data file, please check if you downloaded it.', '$'
startmes db 'hello player!',13,10, 'welcome to the home screen page, here,',13,10, 'you can:',13,10, 'choose the game dificuly(press 1/2/3',13,10, 'buttons on your keyboard) ',13,10,'or start playeing the game(press space bar)',13,10,13,10,'$'
datames db 'so far, you have been a great player...',13,10,'or not;), here are your stats:',13, 10,'$'
startmes2 db 'start? click space bar...', "$"
Filehandle dw ?
data db 50 dup (?)
avarage db 'avarage score:  ',32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,13,10,'$'
bestscore db 'best score:    ',32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,13,10,'$'
gamesplayed db 'games played:   ',32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,13,10,'$'
integerfh dw ?
dif db 'you should choose a dificuly...:',13,10, 'dificulty- ','1',13,10,13,10, '$'
clock equ 40:6Ch
gamespeed dw ?
rot db ?
x dw ?
y dw ?
lasty dw ?
lastx dw ?
fcolor db 8
canmover db 1
canmovel db 1
canmoved db 1
color dw ?
cursqu dw ?
timer db 30h,30h,':',30h,30h, '$'
del db 8,8,8,8,8,8, '$'
allstarttimeinsec dw ?
allnewtimeinsec dw ?
gamespeedloop dw ?
CODESEG

proc ReadFromFile
	mov al, 2
	lea dx, [Filename]
	mov ah, 3Dh
	int 21h
	jc openerror
	mov [Filehandle], ax
	mov bx, [filehandle]
	mov cx, 50
	lea dx, [data]
	mov ah, 3Fh
	int 21h
	lea bx, [data]
	xor cx, cx
	jmp dataloop1
openerror:
    mov ah, 9h
	mov dx, offset FileError
	int 21h
	ret
dataloop1:
    mov si, cx
	mov al, [bx + si]
	cmp al, 's'
	JE ishere
	cmp al, 'p'
	JE ishere
	cmp al, 'g'
	JE ishere
	cmp al, '$'
	je exitfile
	inc cx
	jmp dataloop1
	
ishere:
	add cx, 4
	xor dx, dx
	mov dl, al
	mov [integerfh], 16
	jmp numloop
	
numloop:
    mov si, cx
    mov al, [bx + si]
	cmp al, 13
	Je dataloop1
	inc cx
	cmp dx, 's'
	JE addtos
	cmp dx, 'p'
	JE addtop
	cmp dx, 'v'
	JE addtov
addtos:
    mov si, [integerfh]
	mov [bestscore + si], al
	inc [integerfh]
	jmp numloop
addtop:
    mov si, [integerfh]
	mov [gamesplayed + si], al
	inc [integerfh]
	jmp numloop
addtov:
    mov si, [integerfh]
	mov [avarage + si], al
	inc [integerfh]
	jmp numloop
	
	
exitfile:
	mov bx, [filehandle]
	mov ah,3Eh
	int 21h
	ret	
endp ReadFromFile

proc PrintHomeScreen
    mov ax, 03h
	int 10h
	mov ah, 9h
	mov dx, offset startmes
	int 21h
	mov ah, 09h
	mov dx, offset datames
	int 21h
	mov ah, 09h
	mov dx, offset bestscore
	int 21h
	mov ah, 9h
	mov dx, offset gamesplayed
	int 21h
	mov ah, 9h
	mov dx, offset avarage
	int 21h
	mov ah, 9h
	mov dx, offset dif
	int 21h
	mov ah, 9h
	mov dx, offset startmes2
	int 21h
	ret
endp PrintHomeScreen


proc printblock1
    push cx
	push dx
	call printblock
	call printframe
	pop dx
	pop cx
	ret
endp printblock1

proc printblock2
    push [x]
	call printblock
	call printframe
	add [x], 10
	call printblock
	call printframe
	pop [x]
	ret
endp printblock2

proc printblock3
    push [x]
	sub [x], 20
	mov bx, 4
bloop3:
    call printblock
	call printframe
	add [x], 10
	dec bx
	cmp bx, 0
	jg bloop3
	pop [x]
	ret
endp printblock3
	
proc printblock4
	push [x]
	push [y]
	add [y], 20
	call printblock3
	sub [y], 10
	sub [x], 20
	call printblock1
	pop [y]
	pop [x]
	ret
endp printblock4

proc printblock5
	push [x]
	push [y]
	add [y], 20
	call printblock3
	sub [y], 10
	sub [x], 30
	call printblock3
	pop [y]
	pop [x]
	ret
endp printblock5

proc printblock6
    push [x]
	push [y]
	sub [x],20
	add [y], 20
	mov cx, 4
b6loop1:
    mov dx, 3
	dec cx
	add [x], 10
	sub [y], 30
	cmp cx, 0
	jg b6loop2
	pop [y]
	pop [x]
	ret
b6loop2:
	add [y], 10
	dec dx
	call printblock1
	cmp dx, 0
	jg b6loop2
	jmp b6loop1
endp printblock6
    
proc printblock7
	push [x]
	push [y]
	add [y], 20
	call printblock3
	sub [y], 10
	add [x], 10
	call printblock1
	pop [y]
	pop [x]
	ret
endp printblock7
	
proc printblock8
	push [x]
	push [y]
	mov cx, 4
b8loop:
	call printblock1
	add [y], 10
	loop b8loop
	pop [y]
	pop [x]
	ret
endp printblock8
	

proc findRandomblock       
	mov ah, 0h
	int 1Ah
	mov ax, dx
	mov [color], ax
	and [color], 00001111b
	cmp [color], 8
	Je findRandomblock
	cmp [color], 0
	je findRandomblock
	and ax, 00000111b
	mov [cursqu], ax
	mov [x], 150
	mov [y], 7
	ret
    
endp findrandomblock
	
proc printblock
	mov cx, [x]
	add cx, 11
blockloop1:
	dec cx
	mov dx, [y]
	add dx, 10
	cmp cx, [x]
	jge blockloop2
	ret
blockloop2:
    dec dx
	mov al, [byte ptr color]
	mov ah, 0Ch
	int 10h
	cmp dx, [y]
	Jg blockloop2
	jmp blockloop1
endp printblock

proc printframe
	mov cx, [x]
	add cx, 11
	mov dx, [y]
	mov al, [fcolor]
	mov ah, 0Ch
	add dx, 10
frameloop1:
    dec cx
	int 10h
	sub dx, 10
	int 10h
	add dx, 10
	cmp cx, [x]
	JG frameloop1
frameloop2:
    dec dx
	int 10h
	add cx, 10
	int 10h
	sub cx, 10
	cmp dx, [y]
	JG frameloop2
exitframe:
    ret
endp printframe
    
proc printcursqu
    mov ax, [cursqu]
	cmp ax, 1
	je block1
	cmp ax, 2
	je block2
	cmp ax, 3
	je block3
	cmp ax, 4
	je block4
	cmp ax, 5
	je block5
	cmp ax, 6
	je block6
	cmp ax, 7
	je block7
	cmp ax, 0
	je block8
	
block1:
	call printblock1
	ret
block2:
	call printblock2
	ret
block3:
	call printblock3
	ret
block4:
	call printblock4
	ret
block5:
	call printblock5
	ret
block6:
    call printblock6
	ret
block7:
    call printblock7
	ret
block8:
    call printblock8
	ret
endp printcursqu
	
proc printgameframe 
    mov cx, 99
	mov dx, 5
	mov al, 15
	mov ah, 0Ch
gfloop1:
	int 10h
	add dx, 185
	int 10h
	sub dx, 185
	inc cx
	cmp cx, 221 
	jle gfloop1
	
	mov cx, 99
	mov dx, 5
	mov al, 15
	mov ah, 0Ch
gfloop2:
	int 10h
	add cx, 122
	int 10h
	sub cx, 122
	inc dx
	cmp dx, 190
	jle gfloop2
	ret
endp printgameframe
	
	
proc fillblack
	push [x]
	push [y]
	push [color]
	mov ax, [lastx]
	mov [x], ax
	mov ax, [lasty]
	mov [y], ax	
	mov [color], 0
	mov [fcolor], 0
	call printcursqu
	mov [fcolor], 8
	pop [color]
	pop [y]
	pop [x]
	ret
endp fillblack
	
proc canmove
	mov [canmover], 1
	mov [canmovel], 1
	mov [canmoved], 1
	mov cx, [x]
	mov dx, [y]
	mov bh, 0
	mov ah, 0Dh
	cmp [cursqu], 1
	je squ1f1
	cmp [cursqu], 2
	je squ2f1
	cmp [cursqu], 3
	;je squ3f1
	
squ1f1:
	sub cx, 1
	add dx, 5
	int 10h
	cmp al, 0
	je squ1f2
	mov [canmovel], 0
squ1f2:
	add cx, 12
	int 10h
	cmp al, 0
	je squ1f3
	mov [canmover], 0
squ1f3:
	sub cx, 5
	add dx, 6
	int 10h
	cmp al, 0
	je retfromfunc
	mov [canmoved], 0
	ret

squ2f1:
	sub cx, 1
	add dx, 5
	int 10h
	cmp al, 0
	je squ2f2
	mov [canmovel], 0
squ2f2:
	add cx, 22
	int 10h
	cmp al, 0
	je squ2f3
	mov [canmover], 0
squ2f3:
	sub cx, 5
	add dx, 6
	int 10h
	cmp al, 0
	je squ2f4
	mov [canmoved], 0
	jmp retfromfunc
squ2f4:
	sub cx, 10
	int 10h
	cmp al, 0
	je retfromfunc
	mov [canmoved], 0
	ret
retfromfunc:
	ret
	
endp canmove
	

proc printgamescreen
	mov dx, offset del
	mov ah, 9h
	int 21h
	call fillblack
	call printcursqu
	;mov cx, [x]            ;for tests...
	;mov dx, [y]
	;mov al, 4
	;mov ah, 0Ch
	;int 10h
	call printgameframe
	;call updatetime           ;not ready
	;mov dx, offset timer
	;mov ah, 9h
	;int 21h
	ret
endp printgamescreen

	

start:
	mov ax, @data
	mov ds, ax
	
HomeScreen:
    call ReadFromFile
	jc exit1
	call PrintHomeScreen
hsloop:
	mov ah, 1
	int 21h
	cmp al, '1'
	Je changedif1
	cmp al, '2'
	Je changedif2
	cmp al, '3'
	Je changedif3
	cmp al, ' '
	Je Game
	call PrintHomeScreen
	jmp hsloop
changedif1:
	mov [dif + 45], '1'
	mov [gamespeedloop], 6
	call PrintHomeScreen
	jmp hsloop
changedif2:
    mov [dif + 45], '2'
	call PrintHomeScreen
	mov [gamespeedloop], 4
	jmp hsloop
changedif3:
    mov [dif + 45], '3'
	call PrintHomeScreen
	mov [gamespeedloop], 2
	jmp hsloop
	
exit1:
	mov ax, 4c00h
	int 21h
	
game:
	mov ax, 13h
	int 10h
    xor bx, bx
    mov bl, [dif + 45]
	sub bl, 30h
	mov ax, 8000h
	mul bl
	mov [gamespeed], ax 
	mov ah, 2Ch
	int 21h
	xor ax,ax
	mov al, cl
	mov bl, 60
	mul bl
	mov dl, dh
	xor dh, dh
	add ax, dx
	mov [allstarttimeinsec], ax
	;call findRandomblock
	mov [cursqu], 2
	mov [color], 5
	mov [x], 150
	mov [y], 9 
gameloop1:
	xor cx, cx                                 ;here dificuly 1 not works
	mov cx, [gamespeedloop]
	xor bx, bx
delayloop:
	push cx
	mov dx, 8500h
	xor cx, cx
	mov al, 0
	mov ah, 86h
	int 15h
	pop cx
	loop delayloop
	
	
	mov ax, [x]
	mov [lastx], ax
	mov ax, [y]
	mov [lasty], ax
	call canmove
	xor ax, ax
	mov ah, 0Bh
	int 21h
	cmp al, 0FFh
	JE isinput
	jmp down
isinput:
	mov ah, 7
	int 21h
	cmp al, 100
	je right
	cmp al, 97
	je left
	jmp cont1
right:
	cmp [canmover], 0
	je cont1
	add [x], 10
	mov [rot], 10
	jmp down
left:
	cmp [canmovel], 0
	je cont1
    sub [x], 10
	mov [rot], 5
	jmp down
down:
	cmp [canmoved], 0
	je cont1                         ;here change after test
	add [y], 10
cont1:
	call printgamescreen
	jmp gameloop1  

    
exit:
	mov ax, 4c00h
	int 21h
END start