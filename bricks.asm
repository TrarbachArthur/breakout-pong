extern brick_width
extern brick_height
extern brick_x1
extern brick_x2
extern brick_ys
extern bricks_left
extern bricks_right
extern colide_side
extern pos_x, pos_y, ball_rad

extern cor

extern line

global draw_bricks, brick_colision
draw_bricks:
    MOV AX, [brick_x1]
    CALL draw_column

    MOV AX, [brick_x2]
    CALL draw_column


; Assumes AX contains the xi
draw_column:
    MOV byte [cor], azul

    MOV BX, [brick_width]
	MOV CX, [brick_ys + 0]
    MOV DX, [brick_height]
    PUSH AX ; xi
    ADD BX, AX
    PUSH BX ; xf
    PUSH CX ; yi
    ADD CX, DX
    PUSH CX ; yf
    CALL full_rectangle

    MOV byte [cor], verde

    MOV BX, [brick_width]
	MOV CX, [brick_ys + 2]
    MOV DX, [brick_height]
    PUSH AX ; xi
    ADD BX, AX
    PUSH BX ; xf
    PUSH CX ; yi
    ADD CX, DX
    PUSH CX ; yf
    CALL full_rectangle

    MOV byte [cor], cyan

    MOV BX, [brick_width]
	MOV CX, [brick_ys + 4]
    MOV DX, [brick_height]
    PUSH AX ; xi
    ADD BX, AX
    PUSH BX ; xf
    PUSH CX ; yi
    ADD CX, DX
    PUSH CX ; yf
    CALL full_rectangle

    MOV byte [cor], vermelho

    MOV BX, [brick_width]
	MOV CX, [brick_ys + 6]
    MOV DX, [brick_height]
    PUSH AX ; xi
    ADD BX, AX
    PUSH BX ; xf
    PUSH CX ; yi
    ADD CX, DX
    PUSH CX ; yf
    CALL full_rectangle

    MOV byte [cor], magenta

    MOV BX, [brick_width]
	MOV CX, [brick_ys + 8]
    MOV DX, [brick_height]
    PUSH AX ; xi
    ADD BX, AX
    PUSH BX ; xf
    PUSH CX ; yi
    ADD CX, DX
    PUSH CX ; yf
    CALL full_rectangle

    MOV byte [cor], azul

    RET


; PUSH pos_x PUSH pos_y CALL brick_colision
brick_colision:
    push 	bp
	mov	 	bp,sp
	pushf                        ;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di

    MOV AX, [brick_x1]
    ADD AX, [brick_width]
    ADD AX, [ball_rad]
    CMP AX, [pos_x]
    JL check1
    MOV AX, [brick_x1]
	ADD AX, [ball_rad]
	CMP AX, [pos_x]
    JG check1
    JMP check_brick_left
check1:
	; Check right brick colision
	MOV AX, [brick_x2]
	ADD AX, [brick_width]
	ADD AX, [ball_rad]
	CMP AX, [pos_x]
	JL check2
	MOV AX, [brick_x2]
	SUB AX, [ball_rad]
	CMP AX, [pos_x]
	JG check2
    JMP check_brick_right

check2:

    POP		DI
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	POPF
	POP		BP
	RET		

check_brick_left:
    MOV AX, [brick_ys + 0]
    CMP AX, [pos_y]
    JG check_next_left_1
    MOV AX, [brick_ys + 0]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_left_1

    ; Checking if brick still exists
    MOV BX, [bricks_left+0]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    CALL colide_side
    MOV byte [bricks_left+0], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x1]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 0]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_left_1:
    MOV AX, [brick_ys + 2]
    CMP AX, [pos_y]
    JG check_next_left_2
    MOV AX, [brick_ys + 2]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_left_2

    ; Checking if brick still exists
    MOV BX, [bricks_left+1]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_left+1], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x1]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 2]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_left_2:
MOV AX, [brick_ys + 4]
    CMP AX, [pos_y]
    JG check_next_left_3
    MOV AX, [brick_ys + 4]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_left_3

    ; Checking if brick still exists
    MOV BX, [bricks_left+2]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_left+2], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x1]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 4]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_left_3:
MOV AX, [brick_ys + 6]
    CMP AX, [pos_y]
    JG check_next_left_4
    MOV AX, [brick_ys + 6]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_left_4

    ; Checking if brick still exists
    MOV BX, [bricks_left+3]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_left+3], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x1]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 6]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_left_4:
MOV AX, [brick_ys + 8]
    CMP AX, [pos_y]
    JG near check2
    MOV AX, [brick_ys + 8]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL near check2

    ; Checking if brick still exists
    MOV BX, [bricks_left+4]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_left+4], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x1]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 8]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2


check_brick_right:
    MOV AX, [brick_ys + 0]
    CMP AX, [pos_y]
    JG check_next_right_1
    MOV AX, [brick_ys + 0]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_right_1

    ; Checking if brick still exists
    MOV BX, [bricks_right+0]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_right+0], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x2]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 0]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_right_1:
    MOV AX, [brick_ys + 2]
    CMP AX, [pos_y]
    JG check_next_right_2
    MOV AX, [brick_ys + 2]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_right_2

    ; Checking if brick still exists
    MOV BX, [bricks_right+1]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_right+1], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x2]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 2]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_right_2:
    MOV AX, [brick_ys + 4]
    CMP AX, [pos_y]
    JG check_next_right_3
    MOV AX, [brick_ys + 4]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_right_3

    ; Checking if brick still exists
    MOV BX, [bricks_right+2]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_right+2], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x2]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 4]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_right_3:
    MOV AX, [brick_ys + 6]
    CMP AX, [pos_y]
    JG check_next_right_4
    MOV AX, [brick_ys + 6]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL check_next_right_4

    ; Checking if brick still exists
    MOV BX, [bricks_right+3]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_right+3], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x2]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 6]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

check_next_right_4:
    MOV AX, [brick_ys + 8]
    CMP AX, [pos_y]
    JG near check2
    MOV AX, [brick_ys + 8]
    ADD AX, [brick_height]
    CMP AX, [pos_y]
    JL near check2

    ; Checking if brick still exists
    MOV BX, [bricks_right+4]
    CMP BX, 0
    JE near check2 ; Brick is already destroyed

    ; Brick colided
    ;MOV byte [brick_colided], 1
    CALL colide_side
    MOV byte [bricks_right+4], 0 ; Destroy brick

    ; Erase destroyed brick
    MOV byte [cor], preto
    MOV AX, [brick_x2]
    MOV BX, [brick_width]
    PUSH AX
    ADD BX, AX
    PUSH BX
    MOV AX, [brick_ys + 8]
    MOV BX, [brick_height]
    PUSH AX
    ADD BX, AX
    PUSH BX
    CALL full_rectangle
    JMP near check2

; ------------------------------------

; Função para desenhar um retangulo preenchido
full_rectangle:
	push 	bp
	mov	 	bp,sp
	pushf                        ;coloca os flags na pilha
	push 	ax
	push 	bx
	push	cx
	push	dx
	push	si
	push	di

	mov		ax,[bp+10]    ; resgata xi
	mov		bx,[bp+8]    ; resgata xf
	mov		cx,[bp+6]    ; resgata yi
	mov		dx,[bp+4]    ; resgata yf

	cmp ax, bx
	jb rec_pass
	xchg ax, bx

rec_pass:
	cmp cx, dx
	jb fill
	xchg cx, dx

fill:

	push ax
	push cx
	push bx
	push cx
	call line

	inc cx
	cmp cx, dx
	jle fill

	POP		DI
	POP		SI
	POP		DX
	POP		CX
	POP		BX
	POP		AX
	POPF
	POP		BP
	RET		8

;*******************************************************************

segment data

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