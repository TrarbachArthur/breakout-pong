; versão de 18/10/2022
; Uso de diretivas extern e global 
; Professor Camilo Diaz

extern line, full_circle, circle, cursor, caracter, plot_xy 
global cor

segment code

;org 100h
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
		
;desenhar retas
	; cima
		MOV		BX, 450 ; upper bound
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
		MOV		BX, 10 ; lower bound
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
		
;escrever titulo
MSN: 
		MOV 	CX,13						;número de caracteres
    	MOV    	BX,0			
    	MOV    	DH,0						;linha 0-29
    	MOV     DL,30						;coluna 0-79
		MOV		byte [cor],branco_intenso
render_title:
		CALL	cursor

    	MOV     AL,[BX+title]
		
		CALL	caracter
    	INC		BX							;proximo caracter
		INC		DL							;avanca a coluna
    	LOOP    render_title

		MOV    	AH,08h
		INT     21h
	    MOV  	AH,0   						; set video mode
	    MOV  	AL,[modo_anterior]   		; modo anterior
	    INT  	10h
		MOV     AX,4c00h
		INT     21h

;desenha circulos 
		MOV		byte [cor],azul_claro				;cabeça	
		MOV		AX,320
		PUSH	AX
		MOV		AX,230 
		PUSH	AX
		MOV		AX,4
		PUSH	AX
		CALL	full_circle


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
title    	    db  	'Breakout Pong' 

velX			db		1
velY			db		1
posX			db		320
posY			db		230

;*************************************************************************
segment stack stack
		DW 		512
stacktop:
