;

org 100h

mov ch, 32          ;Cambia el tipo de cursor
mov ah, 1           ;
int 10h             ;
call caracter

inicio:   
    call actual     ;llama actualizar culebrita
    mov color, 10   ;cambia el color a verde para culebrita
    
    mov ah, 0       ;
    int 16h         ;interrupcion leer tecla  
    
    mov al, vv1
    mov valorv, al
    mov al, vh1
    mov valorh, al                                     
    
    cmp ah, 4Dh     ;comparar tecla flecha derecha
    je et1 
    cmp ah, 48h     ;comparar tecla flecha arriba
    je et2
    cmp ah, 4Bh     ;comparar tecla flecha izquierda
    je et3
    cmp ah, 50h     ;comparar tecla flecha abajo
    je et4  
    cmp ah, 1Ch     ;comparar tecla enter
    je et5
    jmp inicio
    
et5:
    mov al,5 
    jmp inicio
          
et4:
    add valorv,1    ;suma uno al valor vertical 
    mov al, valorv
    cmp al, 25
    je fin
    call caracter   ;llama caracter para imprimir cambio
    jmp inicio      ;salta a inicio
              
et3:
    sub valorh,1    ;resta uno al valor horizontal
    mov al, valorh
    cmp al, -1
    je fin
    call caracter   ;llama caracter para imprimir cambio
    jmp inicio      ;salta a inicio
    
et2:
    sub valorv,1    ;resta uno al valor vertical
    mov al, valorv
    cmp al, -1
    je fin
    call caracter   ;llama caracter para imprimir cambio
    jmp inicio      ;salta a inicio

et1:    
    add valorh,1    ;suma uno al valor horizontal 
    mov al, valorh
    cmp al, 80
    je fin
    call caracter   ;llama caracter para imprimir cambio
    jmp inicio      ;salta a inicio 
    
fin:
ret 

actual:
   mov al, vv3
   mov valorv, al
   mov al, vh3
   mov valorh, al
   mov al, vv2
   mov vv3, al
   mov al, vh2
   mov vh3, al
   mov al, vv1
   mov vv2, al
   mov al, vh1
   mov vh2, al   
   mov al, fila
   mov vv1, al
   mov al, columna
   mov vh1, al
   mov color, 0
   call caracter 
ret

caracter:
    mov al, valorv
    mov fila, al  
    mov al, valorh
    mov columna, al
    ;Ubicar cursor en coordenadas
    mov dh, fila    ;fila
    mov dl, columna ;columna
    mov bh, 0       ;pagina
    mov ah, 2       ;parametro
    int 10h         ;interrupcion
    ;imprimir caracter en pantalla
    mov al, 176     ;caracter
    mov bh, 0       ;pagina
    mov bl, color   ;atributo
    mov cx, 1       ;veces
    mov ah, 09h     ;parametro
    int 10h         ;interrupcion 

ret
;--------------------------------------------

vh1 db 0
vh2 db 10
vh3 db 10
vv1 db 10
vv2 db 10
vv3 db 10
            
;valor db 0            
valorv db 10
valorh db 0 
color db 10
limitev dw 25
limiteh dw 80
fila db 10
columna db 0