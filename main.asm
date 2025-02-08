; Arthur Trarbach Sampaio

extern line, full_circle, circle, cursor, caracter, plot_xy
extern draw_bricks, brick_colision, start_menu
global cor, brick_height, brick_width, brick_x1, brick_x2, brick_ys
global bricks_left, bricks_right, brick_colided, pos_x, pos_y, ball_rad
global colide_side, vel_x, vel_y, clear_screen
segment code

..start:
	MOV     AX,data			;Inicializa os registradores
	MOV 	DS,AX
	MOV 	AX,stack
	MOV 	SS,AX
	MOV 	SP,stacktop

;Salvar modo corrente de video(vendo como esta o modo de video da maquina)
	MOV  	AH,0Fh
	INT  	10h
	MOV  	[modo_anterior],AL   

;Alterar modo de video para grafico 640x480 16 cores
	MOV     AL,12h
	MOV     AH,0
	INT     10h

game_setup:
	CALL start_menu

	CALL draw_bounds
	CALL draw_bricks

game_loop:

	; draw p1 paddle
	MOV     byte [cor], magenta
	MOV     AX, [p1_pad_x]
	PUSH    AX
	MOV     AX, [p1_pad_top]
	PUSH    AX
	MOV     AX, [p1_pad_x]
	PUSH    AX
	MOV     AX, [p1_pad_bot]
	PUSH    AX
	CALL    line

	; draw p2 paddle
	MOV     byte [cor], azul
	MOV     AX, [p2_pad_x]
	PUSH    AX
	MOV     AX, [p2_pad_top]
	PUSH    AX
	MOV     AX, [p2_pad_x]
	PUSH    AX
	MOV     AX, [p2_pad_bot]
	PUSH    AX
	CALL    line

	CALL update_ball

	; cover last ball position
	MOV     byte [cor], preto
    MOV     AX, [last_x]
    PUSH    AX
    MOV     AX, [last_y]
    PUSH    AX
    MOV     AX, 4	
    PUSH    AX
    CALL    full_circle
	; draw ball
	MOV     byte [cor], branco_intenso
    MOV     AX, [pos_x]
    PUSH    AX
    MOV     AX, [pos_y]
    PUSH    AX
    MOV     AX, 4	
    PUSH    AX
    CALL    full_circle

	; check gameover
	CMP byte [gameover], 0
	JNE near gameover_screen

	CALL delay

	MOV AH,01h
	int 16h
	jnz check_keys

	jmp near game_loop



sair:
	MOV  	AH,0   						; set video mode
	MOV  	AL,[modo_anterior]   		; modo anterior
	INT  	10h
	MOV     AX,4c00h
	INT     21h


check_keys:          ;checa tecla
    mov ah,00h
    int 16h

    cmp al,'q'
    je confirm_screen
	
	; check p1 moves
	cmp al,'w'
	je near move_p1_up
	cmp al,'s'
	je near move_p1_down

	; check p2 moves
	cmp ah, 48h
	je near move_p2_up
	cmp ah, 50h
	je near move_p2_down

	cmp al, 'p'	; pause
	je pause_loop

    jmp near game_loop

confirm_screen:
    MOV CX, 26
    MOV BX, 0
    MOV DH, 10  ;linha 0-29
    MOV DL, 27  ;coluna 0-79

    MOV byte[cor], branco_intenso
loop_text
    CALL cursor
    MOV AL, [BX + confirm_mens]
    CALL caracter
    INC BX ; INC caracter
    INC DL ; INC coluna
    LOOP loop_text

wait_confirm:
	CALL delay
	MOV AH,01h
	int 16h
	jz wait_confirm

	mov ah, 00h
	int 16h

	CMP AL, 'y'
	JE near sair
	CMP AL, 'n'
	JE erase_confirm_text
	JMP wait_confirm

erase_confirm_text:
	MOV CX, 26
    MOV BX, 0
    MOV DH, 10  ;linha 0-29
    MOV DL, 27  ;coluna 0-79

    MOV byte[cor], preto
loop_text1
    CALL cursor
    MOV AL, [BX + confirm_mens]
    CALL caracter
    INC BX ; INC caracter
    INC DL ; INC coluna
    LOOP loop_text1
	JMP near game_loop

pause_loop:
	mov ah,01h
	int 16h
	jz pause_loop

	mov ah, 00h
	int 16h

	CMP AL, 'p'
	JE near game_loop
	JMP pause_loop

gameover_screen:
	CALL clear_screen

	MOV CX, 9
	MOV BX, 0
	MOV DH, 10  ;linha 0-29
	MOV DL, 36  ;coluna 0-79

	MOV byte[cor], branco_intenso

gameover_loop:
	CALL cursor
	MOV AL, [BX + gameover_mens]
	CALL caracter
	INC BX ; INC caracter
	INC DL ; INC coluna
	LOOP gameover_loop

	MOV CX, 34
	MOV BX, 0
	MOV DH, 15  ;linha 0-29
	MOV DL, 23  ;coluna 0-79

	MOV byte[cor], branco_intenso

restart_loop:
	CALL cursor
	MOV AL, [BX + restart_mens]
	CALL caracter
	INC BX ; INC caracter
	INC DL ; INC coluna
	LOOP restart_loop

wait_restart:
	CALL delay
	MOV AH,01h
	int 16h
	jz wait_restart

	mov ah, 00h
	int 16h

	CMP AL, 'y'
	CALL reset_game
	JE near game_setup
	CMP AL, 'n'
	JE near sair
	JMP wait_restart

loop_step:
	jmp near game_loop

move_p1_up:
	MOV AX, [p1_pad_top]
	cmp AX, [up_bound]
	jge loop_step

	CALL erase_p1_paddle

	MOV AX, [p1_pad_top]
	ADD AX, 5
	MOV [p1_pad_top], AX
	MOV AX, [p1_pad_bot]
	ADD AX, 5
	MOV [p1_pad_bot], AX
	jmp near game_loop

move_p1_down:
	MOV AX, [p1_pad_bot]
	cmp AX, [low_bound]
	jle loop_step

	CALL erase_p1_paddle

	MOV AX, [p1_pad_top]
	SUB AX, 5
	MOV [p1_pad_top], AX
	MOV AX, [p1_pad_bot]
	SUB AX, 5
	MOV [p1_pad_bot], AX
	jmp near game_loop

move_p2_up:
	MOV AX, [p2_pad_top]
	cmp AX, [up_bound]	
	jge loop_step

	CALL erase_p2_paddle

	MOV AX, [p2_pad_top]
	ADD AX, 5
	MOV [p2_pad_top], AX
	MOV AX, [p2_pad_bot]
	ADD AX, 5
	MOV [p2_pad_bot], AX
	jmp near game_loop

move_p2_down:
	MOV AX, [p2_pad_bot]
	cmp AX, [low_bound]
	jle loop_step

	CALL erase_p2_paddle

	MOV AX, [p2_pad_top]
	SUB AX, 5
	MOV [p2_pad_top], AX
	MOV AX, [p2_pad_bot]
	SUB AX, 5
	MOV [p2_pad_bot], AX
	jmp near game_loop
;*************************************************************************
;   			FUNÇÕES	

draw_bounds
	; cima
	MOV		BX, [up_bound] ; upper bound
	MOV		byte [cor],branco_intenso
	MOV		AX,0                   		;x1
	PUSH	AX
	MOV		AX,BX                  	;y1
	PUSH	AX
	MOV		AX,639                  	;x2
	PUSH	AX
	MOV		AX,BX                  	;y2
	PUSH	AX
	CALL	line


	; baixo
	MOV		BX, [low_bound] ; lower bound
	MOV		byte [cor],branco_intenso
	MOV		AX,0                   	;x1
	PUSH	AX
	MOV		AX,BX                  	;y1
	PUSH	AX
	MOV		AX,639                  ;x2
	PUSH	AX
	MOV		AX,BX                 	;y2
	PUSH	AX
	CALL	line

	RET

update_ball:
	MOV AX, [pos_x]
	MOV [last_x], AX
	ADD AX, [vel_x]
	MOV [pos_x], AX

	MOV AX, [pos_y]
	MOV [last_y], AX
	ADD AX, [vel_y]
	MOV [pos_y], AX

	CALL handle_colision

	RET

delay:
    MOV     CX, 00FFh
delay_loop:
    LOOP    delay_loop
	RET

handle_colision:
; Checking lower bound
	MOV AX, [low_bound]
	ADD AX, [ball_rad]
	CMP AX, [pos_y]
	JG check1
	CALL colide_bounds

check1:
; Checking upper bound
	MOV AX, [up_bound]
	SUB AX, [ball_rad]
	CMP AX, [pos_y]
	JL check2
	CALL colide_bounds

check2:
; Checking right bound
	MOV AX, 639
	SUB AX, [ball_rad]
	CMP AX, [pos_x]
	JG check3
	MOV byte [gameover], 1
	RET

check3:
; Checking left bound
	MOV AX, 0
	ADD AX, [ball_rad]
	CMP AX, [pos_x]
	JL check4
	MOV byte [gameover], 1
	RET

check4:
;checking p1 paddle
	MOV AX, [p1_pad_x]
	ADD AX, [ball_rad]
	CMP AX, [pos_x]
	JL check5
	MOV AX, [p1_pad_x]
	SUB AX, [ball_rad]
	CMP AX, [pos_x]
	JG check5
	MOV AX, [p1_pad_top]
	CMP AX, [pos_y]
	JL check5
	MOV AX, [p1_pad_bot]
	CMP AX, [pos_y]
	JG check5
	CALL colide_side

check5:
;checking p2 paddle
	MOV AX, [p2_pad_x]
	SUB AX, [ball_rad]
	CMP AX, [pos_x]
	JG check6
	MOV AX, [p2_pad_x]
	ADD AX, [ball_rad]
	CMP AX, [pos_x]
	JL check6
	MOV AX, [p2_pad_top]
	CMP AX, [pos_y]
	JL check6
	MOV AX, [p2_pad_bot]
	CMP AX, [pos_y]
	JG check6
	CALL colide_side

check6:
	CALL brick_colision ; Check bricks and calls colide_side if needed

	RET

colide_bounds:
	MOV AX, [vel_y]
	NEG AX
	MOV [vel_y], AX
	CALL draw_bounds
	RET


colide_side:
	MOV AX, [vel_x]
	NEG AX
	MOV [vel_x], AX
	RET


erase_p1_paddle:
	MOV     byte [cor], preto
	MOV     AX, [p1_pad_x]
	PUSH    AX
	MOV     AX, [p1_pad_top]
	PUSH    AX
	MOV     AX, [p1_pad_x]
	PUSH    AX
	MOV     AX, [p1_pad_bot]
	PUSH    AX
	CALL    line
	RET

erase_p2_paddle:
	MOV     byte [cor], preto
	MOV     AX, [p2_pad_x]
	PUSH    AX
	MOV     AX, [p2_pad_top]
	PUSH    AX
	MOV     AX, [p2_pad_x]
	PUSH    AX
	MOV     AX, [p2_pad_bot]
	PUSH    AX
	CALL    line
	RET

clear_screen:
    mov ah, 0           
    mov al, 12h         
    int 10h             
    ret

reset_game:
	MOV byte [gameover], 0
	MOV byte [bricks_left+0], 1
	MOV byte [bricks_left+1], 1
	MOV byte [bricks_left+2], 1
	MOV byte [bricks_left+3], 1
	MOV byte [bricks_left+4], 1
	MOV byte [bricks_right+0], 1
	MOV byte [bricks_right+1], 1
	MOV byte [bricks_right+2], 1
	MOV byte [bricks_right+3], 1
	MOV byte [bricks_right+4], 1
	MOV word [pos_x], 320
	MOV word [pos_y], 240
	MOV word [last_x], 0
	MOV word [last_y], 0
	MOV word [vel_x], 2
	MOV word [vel_y], 2
	MOV word [p1_pad_top], 275
	MOV word [p1_pad_bot], 215
	MOV word [p2_pad_top], 275
	MOV word [p2_pad_bot], 215

	RET
;*******************************************************************

segment data

cor		db		branco_intenso

;	I R G B COR
;	0 0 0 0 preto
;	0 0 0 1 azul
;	0 0 1 0 verde
;	0 0 1 1 cyan
;	0 1 0 0 vermelho
;	0 1 0 1 magenta
;	0 1 1 0 marrom
;	0 1 1 1 branco
;	1 0 0 0 cinza
;	1 0 0 1 azul claro
;	1 0 1 0 verde claro
;	1 0 1 1 cyan claro
;	1 1 0 0 rosa
;	1 1 0 1 magenta claro
;	1 1 1 0 amarelo
;	1 1 1 1 branco intenso

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

modo_anterior	db		0
linha   	    dw  	0
coluna  	    dw  	0
deltax		    dw		0
deltay		    dw		0	

up_bound		dw		470
low_bound		dw		10
vel_x			dw		2
vel_y			dw		2
pos_x			dw		320
pos_y			dw		240
last_x			dw		0
last_y			dw		0
ball_rad		dw		4

p1_pad_x		dw		40
p1_pad_top		dw		275
p1_pad_bot		dw		215

p2_pad_x		dw		600
p2_pad_top		dw		275
p2_pad_bot		dw		215

brick_width	dw		10
brick_height	dw		82
brick_x1		dw		5
brick_x2		dw		625
brick_ys		dw		15, 107, 199, 291, 383	; 5 obstacles

bricks_left		db		1,1,1,1,1
bricks_right	db		1,1,1,1,1

confirm_mens	db		'Deseja sair do jogo? (y/n)' ; 26 caracteres	

gameover		db 		0
gameover_mens 	db		'GAME OVER'
restart_mens	db		'Gostaria de jogar novamente? (y/n)' ; 34 caracteres
;*************************************************************************
segment stack stack
	resb 	1024
stacktop:
