IDEAL
MODEL small
STACK 100h
DATASEG
gamesplayed db ?
Filename db 'tetdat.txt',0
newgamesp db 0
integerfh2 db ?
startclock dw ?
FileError db 'there has been an error opening your tetris data file, please check if you downloaded it.', '$'
startmes db 'hello player!',13,10, 'welcome to the home screen page, here,',13,10, 'you can:',13,10, 'choose the game dificuly(press 1/2/3',13,10, 'buttons on your keyboard) ',13,10,'or start playeing the game(press space bar)',13,10,13,10,'$'
datames db 'so far, you have been a great player...',13,10,'or not;), here are your stats:',13, 10,'$'
startmes2 db 'start? click space bar...', "$"
scoremes db 'score- ', '$'
isfirst db 0
losemes db'you lost :( ... here are your game stats:',13,10,'$'
choicemes db'play again? (click spacebar)',10,13,'$'
countdown db'returning to home screen in - ','$' 
linespace db 13, 10, 32, 13, 10, '$'
timetos db 39h, '$'
Filehandle dw ?
tetrisign db   ' _________  ________  _________  _______     _____   ______   ',10,13
			db '|  _   _  ||_   __  ||  _   _  ||_   __ \   |_   _|.  ____ \  ',10,13
			db '|_/ | | \_|  | |_ \_||_/ | | \_|  | |__) |    | |  | (___ \_| ',10,13
			db '    | |      |  _| _     | |      |  __ /     | |   _.____`.      ',10,13
			db '   _| |_    _| |__/ |   _| |_    _| |  \ \_  _| |_ | \____) |    ',10,13
		    db '  |_____|  |________|  |_____|  |____| |___||_____| \______.    ',10,13,'$'
losesign db ' __  __   ______   __  __       __       ______   ______   ______   __  ',10,13     
		 db '/_/\/_/\ /_____/\ /_/\/_/\     /_/\     /_____/\ /_____/\ /_____/\ /__/\  ',10,13   
		 db '\ \ \ \ \\:::_ \ \\:\ \:\ \    \:\ \    \:::_ \ \\::::_\/_\::::_\/_\.:\ \    ',10,13
		 db ' \:\_\ \ \\:\ \ \ \\:\ \:\ \    \:\ \    \:\ \ \ \\:\/___/\\:\/___/\\::\ \   ',10,13
		 db '  \::::_\/ \:\ \ \ \\:\ \:\ \    \:\ \____\:\ \ \ \\_::._\:\\::___\/_\__\/_  ',10,13
		 db '    \::\ \  \:\_\ \ \\:\_\:\ \    \:\/___/\\:\_\ \ \ /____\:\\:\____/\ /__/\ ',10,13
		 db '     \__\/   \_____\/ \_____\/     \_____\/ \_____\/ \_____\/ \_____\/ \__\/ ',10,13,'$'
                                                                             

data db 100 dup (?)
integerfh dw ?
score dw 0
dif db 'you should choose a dificuly...:',13,10, 'dificulty- ','1',13,10,13,10, '$'
clock equ es:6Ch
nfrowstoclear db 0
rowstoclear db 3 dup (?) 
gamespeed dw ?
rot db ?
x dw ?
y dw ?
lasty dw ?
lastx dw ?
fcolor db 8
canmover db 1
canmovel db 1
newline db 13,10,'$'
canmoved db 1
numtoprint db  32, 32, '$'
numtoread db 0,0,0,0,0,0,0,0,0,0
color dw ?
cursqu dw ?
lotime db 5 dup (0,0,0,0,0,'$')
timese db 'time- $'
timer db 30h,30h,':',30h,30h,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32,32, '$'
gamespeedloop dw 6
hun db '00', '$'
bestscore db ?
avaregescore db ?
totalscore dw ?
fbestscore db 'best score - '
fgamesplayed db 'games played - '
favaregescore db 'avarege score - '
ftotalscore db 'total score - '
newhighscoremes db ' - thats a new high score$'
newhighscore db 1
CODESEG

proc openfile
	mov al, 2
	lea dx, [Filename]
	mov ah, 3Dh
	int 21h
	jc openerror
	mov [Filehandle], ax
	mov bx, [filehandle]
	mov cx, 100
	lea dx, [data]
	mov ah, 3Fh
	int 21h
	lea bx, [data]
	xor cx, cx
	jmp contwf
openerror:
    mov ah, 9h
	mov dx, offset FileError
	int 21h
	ret
	
contwf:
	push 0
	mov [integerfh2], 0
n0loop:
	mov [numtoread + si], 0
	inc si
	cmp si, 10
	jl n0loop
	
	pop si
floop:
	inc si
	mov al, [data + si]
	cmp al, '$'
	je exitfile
	cmp al, 13
	jne floop
	mov cx, 10
	push si
	jmp readnum
readnum:
	dec cx
	dec si
	mov al, [data + si]
	cmp al, ' '
	je endofnum
	sub al, 30h
	push si
	mov si, cx
	mov [numtoread + si], al
	pop si
	jmp readnum
	
exitfile:
	mov bx, [filehandle]
	mov ah,3Eh
	int 21h
	ret	
	
endofnum:
	mov [integerfh], 0
	pop si
	push si
	cmp [data + si + 2], 'a'
	je gamesplayed1
	jmp other
	
gamesplayed1:
	xor ah, ah
	mov al, [numtoread + 9]
	add [gamesplayed], al
	mov al, [numtoread + 8]
	mov bl, 10
	mul bl
	add [gamesplayed], al
	xor ah, ah
	mov al, [numtoread + 7]
	mov bl, 100
	mul bl
	add [gamesplayed], al
	xor si, si
	jmp n0loop
	
other:
	xor ah, ah
	mov al, [numtoread + 7]
	add [integerfh], ax
	mov al, [numtoread + 6]
	mov bl, 10
	mul bl
	add [integerfh], ax
	mov al, [numtoread + 5]
	mov bl, 100
	mul bl
	add [integerfh], ax
	inc [integerfh2]
	cmp [integerfh2], 1
	je bs
	cmp [integerfh2], 2
	je av
	cmp [integerfh2], 3
	je ts
	pop si
	jmp exitfile
	
bs:
	mov ax, [integerfh]
	mov [bestscore], al
	xor si, si
	jmp n0loop
ts:
	mov ax, [integerfh]
	mov [totalscore], ax
	xor si, si
	jmp n0loop
av:
	mov ax, [integerfh]
	mov [avaregescore], al
	xor si, si
	jmp n0loop
	

endp openfile


proc PrintHomeScreen
    mov ax, 03h
	int 10h
	mov ah, 9h
	mov dx, offset tetrisign
	int 21h
	mov ah, 9h
	mov dx, offset startmes
	int 21h
	mov ah, 09h
	mov dx, offset data
	int 21h
	mov ah, 09h
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
	call printblock1
	add [x], 10
	call printblock1
	sub [y], 10
	call printblock1
	add [y], 10
	add [x], 10
	call printblock1
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
	push cx
	call printblock1
	add [y], 10
	pop cx
	loop b8loop
	pop [y]
	pop [x]
	ret
endp printblock8
	

proc findRandomblock       
	mov ax, 40h
	mov es, ax
	mov ax, [clock]
	mov [color], ax
	and [color], 00001111b
	cmp [color], 8
	Je findRandomblock
	cmp [color], 0
	je findRandomblock
	and ax, 00000111b
	cmp ax, 2
	jne contrb
	xor ax, ax
contrb:
	mov [cursqu], ax
	mov [x], 150
	mov [y], 9
	ret
endp findrandomblock
	
proc printblock
	mov cx, [x]
	add cx, 10
blockloop1:
	dec cx
	mov dx, [y]
	add dx, 9
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
	add cx, 10
	mov dx, [y]
	mov al, [fcolor]
	mov ah, 0Ch
	add dx, 9
frameloop1:
    dec cx
	int 10h
	sub dx, 9
	int 10h
	add dx, 9
	cmp cx, [x]
	JG frameloop1
frameloop2:
    dec dx
	int 10h
	add cx, 9
	int 10h
	sub cx, 9
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
	
proc printgameframe1 
    mov cx, 98
	mov dx, 5
	mov al, 15
	mov ah, 0Ch
gf1loop1:
	int 10h
	add dx, 185
	int 10h
	sub dx, 185
	inc cx
	cmp cx, 221 
	jle gf1loop1
	
	mov cx, 98
	mov dx, 5
	mov al, 15
	mov ah, 0Ch
gf1loop2:
	int 10h
	add cx, 123
	int 10h
	sub cx, 123
	inc dx
	cmp dx, 190
	jle gf1loop2
	ret
endp printgameframe1

proc printgameframe2
	mov cx, 99
	mov dx, 6
	mov al, 15
	mov ah, 0Ch
gf2loop1:                        
	int 10h
	add dx, 183
	int 10h
	sub dx, 183
	inc cx
	cmp cx, 220
	jle gf2loop1
	
	mov cx, 99
	mov dx, 6
	mov al, 15
	mov ah, 0Ch
gf2loop2:
	int 10h
	add cx, 121
	int 10h
	sub cx, 121
	inc dx
	cmp dx, 189
	jle gf2loop2
	ret
endp printgameframe2
	
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
	add dx, 10
	mov bh, 0
	mov ah, 0Dh
	cmp [cursqu], 1
	je squ1f1
	cmp [cursqu], 2
	je squ2f1
	cmp [cursqu], 3
	je squ3f1j
	cmp [cursqu], 4
	je squ3f1j
	cmp [cursqu], 5
	je squ5f1j
	cmp [cursqu], 6
	je squ6f1j
	cmp [cursqu], 7
	je squ7f1jjj
	cmp [cursqu], 0
	je squ8f1jjjj
	ret
	
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
	sub dx, 4
	int 10h
	cmp al, 0
	je retfromfunc
	mov [canmoved], 0
	ret

squ5f1j:
	jmp squ5f1jj
squ6f1j:
	jmp squ6f1jj
squ7f1jjj:
	jmp squ7f1j
squ8f1jjjj:
	jmp squ8f1jjj

retfromfunc:
	ret
squ3f1j:
	jmp squ3f1

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
	sub dx, 4
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
	
squ7f1j:
	jmp squ7f1jj
squ5f1jj:
	jmp squ5f1
squ6f1jj:
	jmp squ6f1
squ8f1jjj:
	jmp squ8f1j
	
squ3f1:
	sub cx, 21
	add dx, 5
	int 10h
	cmp al,0
	je squ4f1
	mov [canmovel], 0
squ4f1:
	cmp [cursqu], 3
	je squ3f2
	sub dx, 10
	int 10h
	add dx, 10
	cmp al, 0
	je squ3f2
	mov [canmovel], 0
squ3f2:
	add cx, 42
	int 10h
	cmp al, 0
	je squ3f3
	mov [canmover], 0
squ3f3:
	mov bx, 4
	sub dx, 4
	add cx, 5
squ3f3loop:
	dec bx
	sub cx, 10
	int 10h
	cmp al, 0
	jne squ3f4
	cmp bx, 0
	jne squ3f3loop
	jmp retfromfunc
squ3f4:
	mov [canmoved], 0
	jmp retfromfunc
	
squ7f1jj:
	jmp squ7f1
squ8f1j:
	jmp squ8f1jj

squ5f1:
	sub cx, 1
	add dx, 5
	int 10h
	cmp al, 0
	je squ5f2
	mov [canmovel], 0
squ5f2:
	add cx, 32
	int 10h
	cmp al, 0
	je squ5f3
	mov [canmover], 0
squ5f3:
	mov bx, 3
	sub dx, 4
	add cx, 5
squ5f3loop:
	dec bx
	sub cx, 10
	int 10h
	cmp al, 0
	jne squ5f4
	cmp bx, 0
	jne squ5f3loop
	jmp retfromfunc
squ5f4:
	mov [canmoved], 0
	ret
	
squ6f1:
	push cx
	push dx
	sub cx, 11
	add dx, 5
	int 10h
	cmp al, 0
	Jne squ6f1n
	add dx, 10
	int 10h
	cmp al, 0
	Jne squ6f1n
	add dx, 10
	int 10h
	cmp al, 0
	Jne squ6f1n
	jmp squ6f2
squ6f1n:
	mov [canmovel], 0
squ6f2:
	pop dx
	pop cx
	push cx
	push dx
	add cx, 21
	add dx, 5
	int 10h
	cmp al, 0
	Jne squ6f2n
	add dx, 10
	int 10h
	cmp al, 0
	Jne squ6f2n
	add dx, 10
	int 10h
	cmp al, 0
	Jne squ6f2n
	jmp squ6f3
squ6f2n:
	mov [canmover], 0
squ6f3:
	pop dx
	pop cx
	add dx, 21
	sub cx, 5
	int 10h
	cmp al, 0
	Jne squ6f3n
	add cx, 10
	int 10h
	cmp al, 0
	Jne squ6f3n
	add cx, 10
	int 10h
	cmp al, 0
	Jne squ6f3n
	ret
squ6f3n:
	mov [canmoved], 0
	ret
squ8f1jj:
	jmp squ8f1
	
squ7f1:
	add dx, 25 
	sub cx, 21
	int 10h
	cmp al, 0
	je squ7f2
	mov [canmovel], 0
squ7f2:
	add cx, 42
	int 10h
	cmp al, 0
	je squ7f3
	mov [canmover], 0
squ7f3:
	sub dx, 10
	int 10h
	cmp al, 0
	je squ7f4
	mov [canmover], 0
squ7f4:
	add cx, 5
	add dx, 6
	mov bx, 4
squ7f4loop:
	dec bx
	sub cx, 10
	int 10h
	cmp al, 0
	jne squ7f5
	cmp bx, 0
	jne squ7f4loop
	ret
squ7f5:
	mov [canmoved], 0
	ret
	
squ8f1:
	dec cx
	sub dx, 5
	mov bx, 4
squ8f1loop:
	dec bx
	add dx, 10
	int 10h
	cmp al, 0
	jne squ8f1n
	cmp bx, 0
	jne squ8f1loop
	jmp squ8f2
squ8f1n:
	mov [canmovel], 0
squ8f2:
	mov cx, [x]
	mov dx, [y]
	add cx, 11
	sub dx, 5
	mov bx, 4
squ8f2loop:
	dec bx
	add dx, 10
	int 10h
	cmp al, 0
	jne squ8f2n
	cmp bx, 0
	jne squ8f2loop
	jmp squ8f3
squ8f2n:
	mov [canmover], 0
squ8f3:
	mov cx, [x]
	mov dx, [y]
	add cx, 5
	add dx, 41
	int 10h
	cmp al, 0
	jne squ8f3n
	ret
squ8f3n:
	mov [canmoved], 0
	ret
endp canmove
	
proc countdownt
	mov ax, 40h
	mov es, ax
	mov ax, [clock]
	sub ax, [startclock]
	mov bl, 18
	div bl
	mov bl, 9
	sub bl, al
	mov al, bl
	add al, 30h
	mov [timetos], al
	ret
endp countdownt

proc printgamescreen
	call updatetime
	xor dx, dx
	mov ah, 2
	int 10h
	mov dx, offset timese
	mov ah, 9h
	int 21h
	mov dx, offset timer
	mov ah, 9h
	int 21h
	mov dx, offset scoremes
	mov ah, 9h
	int 21h
	push [score]
	call printanumber
	mov dx, offset hun
	mov ah, 9h
	int 21h
	call fillblack
	call printcursqu
	;mov cx, [x]            ;for tests...
	;mov dx, [y]
	;mov al, 4
	;mov ah, 0Ch			
	;int 10h
	call printgameframe1
	call printgameframe2          
	ret
endp printgamescreen

proc findfullrows
	mov [nfrowstoclear], 0
	mov si, 0
	mov ah, 0Dh
	mov dx, 188
	mov bh, 0
frpreloop:
	mov cx, 215
frloop1:
	int 10h
	cmp al, 0
	je newrow
	sub cx, 11
	cmp cx, 100
	jg frloop1
	inc [nfrowstoclear]
	mov bl, [dif + 45]
	sub bl, 30h
	add [score], bx
	mov [word ptr rowstoclear + si], dx
	inc si
newrow:
	sub dx, 10
	cmp dx, 30
	jg frpreloop
	ret
endp findfullrows

proc printstartgamescreen
	mov [x], 30
	mov [y], 145
	mov [color], 6
	mov [cursqu], 6
	call printcursqu                    
	mov [x], 280
	mov [y], 13
	mov [color], 2
	mov [cursqu], 7
	call printcursqu
	mov [x], 260
	mov [y], 90
	mov [color], 14
	mov [cursqu], 5
	call printcursqu
	mov [x], 212
	mov [y], 171
	mov [color], 4
	mov [cursqu], 7
	call printcursqu
	mov [x], 78
	mov [y], 191
	mov [color], 6
	mov [cursqu], 5
	call printcursqu
	mov [x], 290
	mov [y], 152
	mov [color], 13
	mov [cursqu], 6
	call printcursqu
	mov [x], 240
	mov [y], 125
	mov [color], 9
	mov [cursqu], 1
	call printcursqu
	mov [x], 78
	mov [y], 80
	mov [color], 1
	mov [cursqu], 7
	call printcursqu
	mov [x], 30
	mov [y], 20
	mov [color], 11
	mov [cursqu], 0
	call printcursqu
	ret
endp printstartgamescreen

proc clearrows
	xor ah, ah
	mov al, [nfrowstoclear]
	mov si, ax
	cmp si, 0
	jne crloop1
	ret
crloop1:
	dec si
	mov dx, [word ptr rowstoclear + si]
	inc dx
crloop2:
	dec dx
	mov cx, 99                     
	cmp dx, 25
	jge crloop3
	cmp si, 0
	jg crloop1
	ret
crloop3:
	inc cx
	mov ah, 0Dh
	sub dx, 10
	int 10h
	mov ah, 0Ch
	add dx, 10
	int 10h
	cmp cx, 220
	jge crloop2
	jmp crloop3
exitfunc:
	ret
endp clearrows

	

proc updatetime
	mov ax, 40h
	mov es, ax
	mov ax, [clock]
	sub ax, [startclock]
	mov bl, 18
	div bl
	xor ah, ah
	mov bl, 60
	div bl
	mov cl, ah
	xor ah, ah
	mov bl, 10
	div bl
	add al, 30h
	add ah, 30h
	mov [timer], al
	mov [timer + 1], ah
	xor ax, ax
	mov al, cl
	mov bl, 10
	div bl
	add al, 30h
	add ah, 30h
	mov [timer + 3], al
	mov [timer + 4], ah
	ret
endp updatetime
	
proc printanumber
	push bp
	mov bp, sp
	mov ax, [bp + 4]
	mov bl, 10
	mov si, 2
pnloop:
	dec si
	div bl
	mov [integerfh2], al
	mov al, ah
	xor ah, ah
	add al, 30h
	mov [numtoprint + si], al
	mov al, [integerfh2]
	xor ah, ah
	cmp ax, 0
	jg pnloop
	mov dx, offset numtoprint
	mov ah, 9h
	int 21h
	pop bp
	ret 2
endp printanumber

proc changestats
	mov [newhighscore], 0
	mov al, [bestscore]
	xor ah, ah
	cmp [score], ax
	jg changebest
	jmp contc1
changebest:
	mov [newhighscore], 1
	mov ax, [score]
	xor ah, ah
	mov [bestscore], al
contc1:
	mov  ax, [score]
	add [totalscore], ax
	mov ax, [totalscore]
	;mov bl, [gamesplayed]
	mov bl, [newgamesp]
	div bl
	mov [avaregescore], al
	ret
endp changestats


proc updatefile
	mov al, 1
	lea dx, [Filename]
	mov ah, 3Dh
	int 21h
	mov [Filehandle], ax
	mov bx, [filehandle]
	xor si,si
uloop1:
	mov [data + si], 32
	inc si
	cmp si, 80
	jl uloop1
	
	xor si, si 
uloop2:
	mov al, [fbestscore + si]
	mov [data + si], al
	inc si
	cmp si, 13
	jl uloop2
	
	xor ah, ah
	mov al, [bestscore]
	mov bl, 100
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	mov al, ah
	xor ah, ah
	mov bl, 10
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	add ah, 30h
	mov [data + si], ah
	inc si
	mov [data + si], 30h
	inc si
	mov [data + si], 30h
	
	inc si
	mov [data + si], 13
	inc si
	mov [data + si], 10
	
	inc si
	mov bx, si
	xor si, si
uloop3:
	mov al, [fgamesplayed + si]
	add si, bx
	mov [data + si], al
	sub si, bx
	inc si
	cmp si, 15
	jl uloop3
	
	add si, bx
	xor ah, ah
	;mov al, [gamesplayed]
	mov al, [newgamesp]
	mov bl, 100
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	mov bl, 10
	mov al, ah
	xor ah, ah
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	mov [data + si], ah
	add [data + si], 30h
	
	inc si
	mov [data + si], 13
	inc si
	mov [data + si], 10
	
	inc si  
	mov bx, si
	xor si, si
	uloop4:
	mov al, [favaregescore + si]
	add si, bx
	mov [data + si], al
	sub si, bx
	inc si
	cmp si, 16
	jl uloop4
	
	add si, bx
	xor ah, ah
	mov al, [avaregescore]
	mov bl, 100
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	mov al, ah
	xor ah, ah
	mov bl, 10
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	add ah, 30h
	mov [data + si], ah
	inc si
	mov [data + si], 30h
	inc si
	mov [data + si], 30h
	
	inc si
	mov [data + si], 13
	inc si
	mov [data + si], 10
	
	inc si    
	mov bx, si
	xor si, si
	uloop5:
	mov al, [ftotalscore + si]
	add si, bx
	mov [data + si], al
	sub si, bx
	inc si
	cmp si, 14
	jl uloop5
	
	add si, bx
	xor ah, ah
	mov ax, [totalscore]
	mov bl, 100
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	mov al, ah
	xor ah, ah
	mov bl, 10
	div bl
	mov [data + si], al
	add [data + si], 30h
	inc si
	add ah, 30h
	mov [data + si], ah
	inc si
	mov [data + si], 30h
	inc si
	mov [data + si], 30h
	
	inc si
	mov [data + si], 13
	inc si
	mov [data + si], 10
	inc si
	mov [data + si], 13
	inc si
	mov [data + si], 10
	inc si
	mov [data + si], '$'
	
	mov dx, offset data
	mov bx, [filehandle]
	mov cx, 100
	mov ah, 40h
	int 21h
	mov	ah, 3Eh
	int	21h
	ret
endp updatefile

start:
	mov ax, @data
	mov ds, ax
	
HomeScreen:
    call openfile
	jc exit1
	cmp [isfirst], 0
	jne conths
	mov al, [gamesplayed]
	mov [newgamesp], al
	mov [isfirst], 1
conths:
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
jtostart:
	jmp start
	
game:
	inc [gamesplayed]
	inc [newgamesp]
	mov [numtoprint], 0
	mov [numtoprint + 1], 0
	mov [timetos], 9
	mov [score], 0
	mov ax, 13h
	int 10h
	call printstartgamescreen
    xor bx, bx
    mov bl, [dif + 45]
	sub bl, 30h
	mov ax, 8000h
	mul bl
	mov [gamespeed], ax 
	mov ax, 40h
	mov es, ax
	mov ax, [clock]
	mov [startclock], ax
newblock:
	call findRandomblock
gameloop1:
	xor cx, cx                           
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
	jmp down
jjtostart:
	jmp jtostart
blockhitbottom:
	call printgamescreen
	call findfullrows
	call clearrows
	call findfullrows
	call clearrows
	call findfullrows
	call clearrows
	call findfullrows
	call clearrows
	cmp [y], 30
	jle lose
	jmp newblock
right:
	cmp [canmover], 0
	je down
	add [x], 10
	mov [rot], 10
	jmp down
left:
	cmp [canmovel], 0
	je down
    sub [x], 10
	mov [rot], 5 
	jmp down
down:
	call canmove
	cmp [canmoved], 0
	je blockhitbottom
	add [y], 10
cont1:
	mov ah,0ch
	mov al,0
	int 21h
	call printgamescreen
	jmp gameloop1  
jjjtstart:
	jmp jjtostart
lose:
	call changestats
	call updatefile
	mov [timetos], 9
	mov ax, 40h
	mov es, ax
	mov ax, [clock]
	mov [startclock], ax
	xor si, si
loloop1:
	mov al, [timer + si]
	mov [lotime + si], al
	inc si
	cmp si, 5
	jl loloop1
	jmp loloop2
jjjjtstart:
	jmp jjjtstart
loloop2:
	mov dx, 8500h
	xor cx, cx
	mov al, 0
	mov ah, 86h
	int 15h
	mov	ah, 0
	mov	al, 2
	int	10h
	cmp [timetos], 30h
	je jjjjtstart
	mov dx, offset losesign
	mov ah, 9h
	int 21h
	mov dx, offset linespace
	mov ah, 9h
	int 21h
	mov dx, offset linespace
	mov ah, 9h
	int 21h
	mov dx, offset losemes
	mov ah, 9h
	int 21h
	mov dx, offset linespace
	mov ah, 9h
	int 21h
	mov dx, offset timese
	mov ah, 9h
	int 21h
	mov dx, offset lotime
	mov ah, 9h
	int 21h
	mov dx, offset newline
	mov ah, 9h
	int 21h
	mov dx, offset scoremes
	mov ah, 9h
	int 21h
	push [score]
	call printanumber
	mov dx, offset hun
	mov ah, 9h
	int 21h
	cmp [newhighscore], 1
	jne lcont7
	mov dx, offset newhighscoremes
	mov ah, 9h
	int 21h
lcont7:
	mov dx, offset newline
	mov ah, 9h
	int 21h
	mov dx, offset linespace
	mov ah, 9h
	int 21h
	call countdownt
	mov dx, offset countdown
	mov ah, 9h
	int 21h
	mov dx, offset timetos
	mov ah, 9h
	int 21h
	jmp loloop2
	
	
exit:
	mov ax, 4c00h
	int 21h
END start
