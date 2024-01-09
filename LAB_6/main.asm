.model tiny
.186 

code segment
    assume cs:code
    org 100h

main:
    jmp install
    old_interrupt dd ?
    is_installed dw 1
    curr_time db 0                           ; здесь будет храниться секунда предыдущего прерывания
    speed db 1fh                             ; начальная скорость 01 1111

handle_interrupt proc far 
    pusha 
    push es
    push ds
	
    pushf
	call old_interrupt                      ; вызов старого обработчика
    mov ah, 02h
    int 1ah                             ; получить текущее время
                                        ; DH = секунды в коде BCD

    cmp dh, curr_time
    mov curr_time, dh                   
    je quit                             

    mov al, f3h                       ; команда - изменить параметры автоповтора клавиатуры
    out 60h, al
    mov al, speed                     ; передаем параметры команды (в т.ч. скорость)
    out 60h, al 

    dec speed                       
    cmp speed, 00h                
    jz reset

    jmp quit

    reset:
        mov speed, 1fh

    quit:
        pop ds
        pop es                            
        popa 
        iret 
handle_interrupt endp

install proc 
    mov ax, 3508h                      ; получаем адрес текущего обработчика
    int 21h

    cmp es:is_installed, 1          
    je uninstall                       ; => установлен наш обработчик, тогда его убираем

    ; save old ptr
    mov word ptr old_interrupt, bx            ; сохраняем адрес старого обработчик
    mov word ptr old_interrupt + 2, es

    ; set handler
    mov ax, 2508h
    mov dx, offset handle_interrupt           ; устанавливаем наш обработчик
    int 21h

    mov dx, offset installed_msg
    mov ah, 09h
    int 21h

    ; Завершение с сохранением в памяти
    mov dx, offset install               ; выходим, оставляя все до init в памяти
    int 27h                              ; DX = адрес первого байта за резидентным участком программы (смещение от PSP)

install endp
    

uninstall proc
    ;push es                            ; сохраняем сегментные регистры
    push ds

    ; restore ptr
    mov dx, word ptr es:old_interrupt
    mov ds, word ptr es:old_interrupt + 2
    mov ax, 2508h                      ; устанавливаем старый обработчик
    int 21h

    pop ds                             ; восстанавливаем значения регистров
    ;pop es
    
    mov al, f3h
    out 60h, al
    mov al, 0
    out 60h, al

    ; память выделить
    mov ah, 49h
    int 21h

    mov dx, offset uninstalled_msg
    mov ah, 09h
    int 21h

    mov ax, 4c00h
    int 21h

    uninstalled_msg db 'Uninstalled$'
    installed_msg   db 'Installed$'
uninstall endp

code ends
end main