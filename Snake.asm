;Creado por: Rafael Gomez - 

org 100h

    mov ch, 32          ;Cambia el tipo de cursor
    mov ah, 1           ;Parametro 
    int 10h             ;Interrupcion
    call obstaculo      ;Llama un nuevo obstaculo 
    call repint         ;Llama funcion para recuperar los datos de la cabeza de snake
    call caracter       ;Llama imprimir la pocision inicial de la serpiente

inicio: 
    call actual         ;llama actualizar culebrita
    call atrapa         ;llama metodo para saber si comio  
    
    mov ah, 0           ;Parametro
    int 16h             ;interrupcion leer tecla  
    
    call repint         ;Llama funcion para recuperar los datos de la cabeza de snake
    
    cmp ah, 4Dh         ;comparar tecla flecha derecha
    je et1              ;salto a la etiqueta 1 si es igual
    cmp ah, 48h         ;comparar tecla flecha arriba
    je et2              ;salto a la etiqueta 2 si es igual
    cmp ah, 4Bh         ;comparar tecla flecha izquierda
    je et3              ;salto a la etiqueta 3 si es igual
    cmp ah, 50h         ;comparar tecla flecha abajo
    je et4              ;salto a la etiqueta 4 si es igual
    cmp ah, 1Ch         ;comparar tecla enter
    je et5              ;salto a la etiqueta 5 si es igual
    jmp inicio          ;salto incodicional a inicio

et5:
    jmp fin             ;Salta a fin para imprimir puntaje

et4:
    add valorv,1        ;suma uno al valor vertical 
    mov al, valorv      ;mueve el nuevo valor a valor vertical
    cmp al, 25          ;compara si la pocision es 25 (colision abajo)
    je fin              ;termina si se cumple la condicion
    call caracter       ;llama caracter para imprimir cambio
    jmp inicio          ;salta a inicio

et3:
    sub valorh,1        ;resta uno al valor horizontal
    mov al, valorh      ;mueve a valor horizontal el nuevo valor
    cmp al, -1          ;compara si la pocision horizontal es -1 (colision a la izquierda)
    je fin              ;termina si se cumple la condicion
    call caracter       ;llama caracter para imprimir cambio
    jmp inicio          ;salta a inicio

et2:
    sub valorv,1        ;resta uno al valor vertical
    mov al, valorv      ;mueve a valor vertical la nueva pocision
    cmp al, -1          ;compara si la nueva pocision vertical es -1 (colision arriba)
    je fin              ;termina si se cumple la condicion
    call caracter       ;llama caracter para imprimir cambio
    jmp inicio          ;salta a inicio

et1:    
    add valorh,1        ;suma uno al valor horizontal 
    mov al, valorh      ;mueve a valor horizontal la nueva pocision 
    cmp al, 80          ;compara si la nueva pocision horizontal es 80 (colision a la derecha)
    je fin              ;termina si se cumple la condicion
    call caracter       ;llama caracter para imprimir cambio
    jmp inicio          ;salta a inicio 

fin:   
    mov dx, offset msg  ;Trae la pocision del primer de la cadena (msg) a dx
    mov ah, 09h         ;Parametro
    int 21h             ;Interrupcion para imprimir
    mov al, puntos      ;Pasa el valor de puntos a al
    add al, 30h
    mov ah, 0eh         ;Parametro
    int 10h             ;interrupcion imprimir en pantalla
    mov ah, 0           ;Parametro
    int 16h             ;interrupcion leer tecla  
ret   
;--------------------------------------------
repint:
    mov al, vv1         ;mueve la pocision vertical de la cabeza a al
    mov valorv, al      ;mueve al a valor vertical
    mov al, vh1         ;mueve la pocision horizontal de la cabeza a al
    mov valorh, al      ;mueve al a valor horizontal
    mov color, 10       ;cambia el color a verde para culebrita
    mov figura, 176     ;indica la figura q tendra la serpiente
    ret
;--------------------------------------------
atrapa:  
    mov al, vv1         ;mueve a al la pocision vertical de la serpiente
    cmp al, obsv        ;compara si al es igual a la pocision vertical del obstaculo
    jne no              ;si no es igual salta a no para regresar
    mov al, vh1         ;si es igual, mueve la pocision horizontal de la serpiente a al
    cmp al, obsh        ;compara si al es igual a la pocision horizontal del obstaculo
    jne no              ;si no es igual salta a no para regresar
    add puntos,1        ;si es igual, suma un punto al contador de puntos
    call obstaculo      ;llama un obstaculo 
no:
ret
;--------------------------------------------
actual: 
    mov figura, 176
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
    mov color, 10       ;cambia el color a verde para culebrita 
ret
;--------------------------------------------
obstaculo: 
    mov figura, 15
    mov limite, 15
    call aleatorio
    mov al, valor
    add al, 1
    mov color, al
    mov limite, 25
    call aleatorio
    mov al, valor 
    mov obsv, al
    mov valorv, al
    mov limite, 80
    call aleatorio
    mov al, valor
    mov obsh, al
    mov valorh, al  
    call caracter 
ret  
;--------------------------------------------
aleatorio:
    mov ah,0
    int 1ah
    mov ax, dx
    xor dx, dx
    mov cx, limite
    div cx
    mov valor, dl
ret
;--------------------------------------------
caracter:
    mov al, valorv      ;mueve a al el valor vertical del caracter a imprimir
    mov fila, al        ;mueve a fila el valor de al
    mov al, valorh      ;mueve a al el valor horizontal del caracter a imprimir
    mov columna, al     ;mueve a columna el valor de al
    ;Ubicar cursor en coordenadas
    mov dh, fila        ;fila
    mov dl, columna     ;columna
    mov bh, 0           ;pagina
    mov ah, 2           ;parametro
    int 10h             ;interrupcion
    ;imprimir caracter en pantalla
    mov al, figura      ;caracter
    mov bh, 0           ;pagina
    mov bl, color       ;atributo
    mov cx, 1           ;veces
    mov ah, 09h         ;parametro
    int 10h             ;interrupcion 
ret
;--------------------------------------------

vh1 db 0
vh2 db 81
vh3 db 82
vv1 db 10
vv2 db 26
vv3 db 27

figura db 176            
valorv db 10
valorh db 0 
color db 10   

obsv db 0
obsh db 0
limite dw 0

fila db 10
columna db 0
valor db 0
puntos db 0
msg db " Su puntaje es: $"