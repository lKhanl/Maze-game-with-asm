org 100h
#start=Emulation_Kit.exe# 
DrawMaze:
    MOV DX,2000h
    MOV BX, 0
    MOV SI,0

    

MAINLOOP:
    MOV SI, 0
    MOV CX, 5

NEXT:
    MOV AL,INIT[BX][SI]
    out dx,al
    INC SI
    INC DX

    CMP SI, 5
    LOOPNE NEXT

    ADD BX, 5
    CMP BX, 40
    JL MAINLOOP
    
MOV DX, 2000h

MOV BX,0
MOV SI,0
mov cx,3

push bx
push si
push cx
mov al,8h
out dx,al

push ax

    
keyboard:
    mov  ah, 00h
    int  16h    
    cmp AH, 48h    
    je  upPressed        
    cmp AH, 50h     
    je  downPressed
    cmp AH, 4Bh     
    je  leftPressed
    cmp AH, 4Dh     
    je  rightPressed
    jne noValidKey
    
    
    
noValidKey:
    jmp keyboard        

leftPressed: 

    cmp dx,2000h    
    je keyboard  
    
    pop ax
    
    call fillTemp1
    
    pop cx
    pop si
    pop bx
 
    dec si
    
    push bx    
    push si
    push cx
    mov di,ax
    push di;ax   
    
    MOV al, INIT[BX][SI] 
    
    mov di,0h
    
    
    call fillTemp2
    pop ax
    pop cx
    mov bx,cx
    
    cmp temp2[bx],1
    je skipLeft
    
    
    mov temp1[bx],0
    push cx 
    push ax
        
    
    
   call horizontalRevert
   
    mov ax,bx
    dec dx
    out dx,al
    
    
    add sp, 2
    push ax   
    


jmp exitMain
skipLeft:
    pop si
    inc si
    push si
    push cx
    push ax
   
    jmp exitMain

rightPressed:
     
    cmp dx,2027h    
    je keyboard  
    
    pop ax
    
    call fillTemp1
    
    pop cx
    pop si
    pop bx
 
    inc si
    
    push bx    
    push si
    push cx
    mov di,ax
    push di;ax   
    
    MOV al, INIT[BX][SI] 
    
    mov di,0h
    
    
    call fillTemp2
    pop ax
    pop cx
    mov bx,cx
    
    cmp temp2[bx],1
    je skipRight
    
    
    mov temp1[bx],0
    push cx 
    push ax
        
    call horizontalRevert
    
    mov ax,bx
    inc dx
    out dx,al
    
    
    add sp, 2
    push ax
    


jmp exitMain
skipRight:
    pop si
    dec si
    push si
    push cx
    push ax
   
    jmp exitMain

upPressed:
    pop ax
    pop cx
    cmp cx,6
   
    je skipUp  

     
    push cx
     
    call fillTemp1
    
    pop bx
    cmp temp1[bx+1],1
    push bx
    push ax
    je keyboard
    
    pop ax
    pop bx
   
    
    mov temp1[bx+1],1
    mov temp1[bx],0
  
    lea si,temp1+6
    
    inc bx
    push bx
    
    call verticalRevert
    
    mov ax,bx
    out dx,al
    push ax
  
    
    jmp exitMain
    
    skipUp:
    push cx
    push ax
    jmp exitMain
    

downPressed:
    pop ax
    pop cx
    cmp cx,0  
    je skipDown  
    
    push cx
    
    call fillTemp1
    
    pop bx  ;cx 
    
    cmp temp1[bx-1],1
    push bx
    push ax
    je keyboard
    
    pop ax
    pop bx
    
    mov temp1[bx-1],1
    mov temp1[bx],0
   
    lea si,temp1+6
    dec bx
    push bx
    call verticalRevert
    
    mov ax,bx
    out dx,al
    push ax
    
  
  jmp exitMain
  skipDown:
  push cx
  push ax
  jmp exitMain        
    
exitMain:
;call putDot
call resetTemps        
jmp keyboard    

RET

INIT DB 0000000B, 0000000B, 0000000B, 0000000B, 0000000B
     DB 1110111B, 1000001B, 1111001B, 1111011B, 1000001B
     DB 1011111B, 1011111B, 1010001B, 1010101B, 1000101B
     DB 1111101B, 1000101B, 1010001B, 1010101B, 1010101B 
     DB 1100011B, 1000001B, 1011101B, 1011101B, 1011101B
     DB 1001001B, 1000101B, 1011101B, 1100001B, 1101111B
     DB 1000001B, 1010101B, 1010101B, 1010101B, 1111101b
     DB 0000000B, 0000000B, 0000000B, 0000000B, 0000000B 




temp1 DB 7 DUP(0)
temp2 DB 7 DUP(0) 

proc verticalRevert
mov cx,0
    
    loopGet1:
    cmp cx,7
    je skipGet1
        mov ax,1
        push cx 
        
        innerfor1:
        cmp cx,0h
        je skipInner1
        
        mov bl,2             
        mul bl
       
                   
        loop innerfor1
    
    skipInner1:
    pop cx
    mov bx,ax 
    lodsb
    mul bl
    push ax
    inc cx
    jmp loopGet1
    
    skipGet1:
    mov cx,7
    mov bx,0
    
    revert1:
    pop ax
    add bx,ax    
    loop revert1
ret
verticalRevert endp    

proc horizontalRevert
    pop di
    mov cx,0  
    
    lea si,temp1+6
    loopGetl:
    cmp cx,7
    je skipGetl
        mov ax,1
        push cx 
        
        innerforl:
        cmp cx,0h
        je skipInnerl
        
        mov bl,2             
        mul bl
       
                   
        loop innerforl
    
    skipInnerl:
    pop cx
    mov bx,ax 
    lodsb
    mul bl
    push ax
    inc cx
    jmp loopGetl
    
    skipGetl:
    mov cx,7
    mov bx,0
    
    revertl:
    pop ax
    add bx,ax    
    loop revertl
    
    mov ax,bx
    out dx,al
    
    
    
    pop ax
    pop bx;cx
    mov temp2[bx],1 
    mov cx,0  
    push bx;cx
    push ax
    
    lea si,temp2+6 
    
    loopGetll:
    cmp cx,7
    je skipGetll
        mov ax,1
        push cx 
        
        innerforll:
        cmp cx,0h
        je skipInnerll
        
        mov bl,2             
        mul bl
       
                   
        loop innerforll
    
    skipInnerll:
    pop cx
    mov bx,ax 
    lodsb
    mul bl
    push ax
    inc cx
    jmp loopGetll
    
    skipGetll:
    mov cx,7
    mov bx,0
    
    revertll:
    pop ax
    add bx,ax    
    loop revertll
    
    push di
    
    
ret
horizontalRevert endp     
      

proc fillTemp1
    
    pop si
    
    push ax
    std
    LEA DI, temp1+6
    mov cx,7
    loop1:
    mov ah,0h   
    mov bl,2
    div bl 
    push ax
    mov al,ah
    stosb
    pop ax
    cmp al,2
    jb skip
    loop loop1
    
    skip:
    stosb
    
    pop ax
    
    push si
    
ret    
fillTemp1 endp    

proc setIndex
    
       
    sub cx,1
    cmp cx,4
    je a
    jne b
    
    a:
    add bx,5
    sub cx,4
    
    b:
    mov SI, cx
    
ret
setIndex endp 

proc fillTemp2
    pop si  
    
    convertSecond:
    LEA DI, temp2+6
    mov cx,7
    loop2:
    mov ah,0h   
    mov bl,2
    div bl 
    push ax
    mov al,ah
    stosb    
    pop ax
    cmp al,2
    jb skip2
    jmp loop2
    
    skip2:
    stosb
    
    push si
        
ret
fillTemp2 endp

proc resetTemps 
cld
lea di,temp1
mov ax,0
mov cx,7
loopReset1:
stosb
loop loopReset1

lea di,temp2
mov ax,0
mov cx,7
loopReset2:
stosb
loop loopReset2
std    
ret
resetTemps endp