extern clear_screen
extern caracter, cursor, plot_xy, line
extern cor, vel_x, vel_y

global start_menu

;----------------------------------

start_menu:
    CALL clear_screen

    MOV CX, 42
    MOV BX, 0
    MOV DH, 10  ;linha 0-29
    MOV DL, 17  ;coluna 0-79

    MOV byte[cor], branco_intenso

loop_text
    CALL cursor
    MOV AL, [BX + text]
    CALL caracter
    INC BX ; INC caracter
    INC DL ; INC coluna
    LOOP loop_text

draw_facil:
    MOV CX, 5
    MOV BX, 0
    MOV DH, 15  ;linha 0-29
    MOV DL, 37  ;coluna 0-79
    MOV byte[cor], branco_intenso

    CMP byte[dificuldade], 0
    JNE loop_facil
    MOV byte[cor], magenta
    
loop_facil
    CALL cursor
    MOV AL, [BX + facil]
    CALL caracter
    INC BX ; INC caracter
    INC DL ; INC coluna
    LOOP loop_facil

draw_medio:
    MOV CX, 5
    MOV BX, 0
    MOV DH, 20  ;linha 0-29
    MOV DL, 37  ;coluna 0-79
    MOV byte[cor], branco_intenso

    CMP byte[dificuldade], 1
    JNE loop_medio
    MOV byte[cor], magenta

loop_medio:
    CALL cursor
    MOV AL, [BX + medio]
    CALL caracter
    INC BX ; INC caracter
    INC DL ; INC coluna
    LOOP loop_medio

draw_dificil:
    MOV CX, 7
    MOV BX, 0
    MOV DH, 25  ;linha 0-29
    MOV DL, 36  ;coluna 0-79
    MOV byte[cor], branco_intenso

    CMP byte[dificuldade], 2
    JNE loop_dificil
    MOV byte[cor], magenta

loop_dificil:
    CALL cursor
    MOV AL, [BX + dificil]
    CALL caracter
    INC BX ; INC caracter
    INC DL ; INC coluna
    LOOP loop_dificil

selecao:
    CALL delay
    MOV AH,01h
	int 16h
    jnz check_menu
    JMP selecao

check_menu:
    mov ah,00h
    int 16h

    cmp ah, 48h
    je handle_up
    cmp ah, 50h
    je handle_down
    cmp ah, 1Ch
    je handle_enter
    JMP selecao

handle_up:
    CMP byte[dificuldade], 0
    JE selecao
    DEC byte[dificuldade]
    JMP near start_menu

handle_down:
    CMP byte[dificuldade], 2
    JE selecao
    INC byte[dificuldade]
    JMP near start_menu

handle_enter:
    CMP byte[dificuldade], 0
    MOV word[vel_x], 2
    MOV word[vel_y], 2
    JE start_game
    CMP byte[dificuldade], 1
    MOV word[vel_x], 4
    MOV word[vel_y], 4
    JE start_game
    CMP byte[dificuldade], 2
    MOV word[vel_x], 6
    MOV word[vel_y], 6
    JE start_game

start_game:
    CALL clear_screen
    RET

; ------------- FUNCOES ----------

delay:
    MOV CX, 00FFh
delay_loop:
    LOOP delay_loop
    RET


segment data
    text    db   'Escolha a dificuldade (setas cima e baixo)'
    facil  db   'Facil'
    medio  db   'Medio'
    dificil db   'Dificil'
    dificuldade db 0

    preto		    equ		0
    azul		    equ		1
    verde		    equ		2
    cyan		    equ		3
    vermelho	    equ		4
    magenta		    equ		5
    marrom		    equ		6
    branco		    equ		7
    cinza		    equ		8
    azul_claro	    equ		9
    verde_claro	    equ		10
    cyan_claro	    equ		11
    rosa		    equ		12
    magenta_claro	equ		13
    amarelo		    equ		14
    branco_intenso	equ		15
