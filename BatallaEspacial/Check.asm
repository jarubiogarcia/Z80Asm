;------------------------------------------------------------------------------
; Check.asm
;
; Contiene las rutinas de comprobaci�n
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; Eval�a si se ha producido alguna colisi�n
;
; Destruye el valor de los registros A, BC, DE y HL
;------------------------------------------------------------------------------
CheckCrash:
	; Carga en A los indicadores 1
	; Eval�a si el disparo est� activo, bit 1
	LD A, (flags1)
	BIT 1, A

	; Si el disparo no est� activo comprueba si hay colisi�n con la nave
	JP Z, CheckCrash_ship

	; Obtiene el n�mero de enemigos
	LD B, enemiesConfigIni  - enemiesConfig
	
	; Divide entre dos, hay dos bytes por enemigo
	SRA B
	
	; Obtiene la direcci�n de memoria de la coordenada Y del primer enemigo
	LD HL, enemiesConfig
	
	; Eval�a si hay alguna colisi�n
	CALL CheckCrash_fireEnemies
	
	; Comprueba si hay colisi�n con la nave
	JP CheckCrash_ship

;------------------------------------------------------------------------------
; Eval�a si hay colisi�n entre el disparo y alg�n enemigo	
;------------------------------------------------------------------------------
CheckCrash_fireEnemies:
	; Carga en A la coordenada Y del disparo
	LD A, (fireCoord)

	; La carga en D
	LD D, A
	
	; Carga en A la coordenada Y del enemigo
	; Tambi�n contiene si el enemigo est� activo
	LD A, (HL)
	
	; Comprueba si el enemigo est� activo, y si no lo est� salta
	BIT 7, A
	JR Z, CheckCrash_fireEnemiesNoCrash
	
	; Se queda con la coordenada Y del enemigo
	AND 00011111b
	
	; Lo compara con la coordenada Y del disparo y si no son iguales, salta
	CP D
	JR NZ, CheckCrash_fireEnemiesNoCrash
	
	; Como las coordenadas Y son las mismas, compara las coordenadas X
	; Carga la coordenada X del disparo en A
	LD A, (fireCoord+1)
	
	; La carga en D
	LD D, A
	
	; Avanza a la posici�n de memoria de la coordenada X del enemigo y la carga en A
	INC HL
	LD A, (HL)
	
	; Se queda con la coordenada X del enemigo, ya que tambi�n tiene los indicadores de direcci�n de movimiento
	AND 00111111b
	
	; Lo compara con la coordenada X del disparo y si no son iguales, salta
	CP D
	JR NZ, CheckCrash_fireEnemiesLoop
	
	; Son iguales
	; Vuelve a la posici�n de memoria de la coordenada Y del enemigo
	DEC HL
	
	; Desactiva al enemigo
	RES 7, (HL)

	; Suena la exploxi�n del enemigo
	CALL EnemiesCrashSound

	; Carga los flags y desactiva el disparo
	LD A, (flags1)
	RES 1, A

	; Resta un enemigo y suma cinco puntos
	LD A, (enemiesCount)
	DEC A
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (enemiesCount), A

	; Suma 5 puntos en el byte 3 de la puntuaci�n. Importante sumar en hexadecimal (entre $00 y $99)
	; Aunque el valor de 5 decimal y hexadecimal son el mismo, se pone en hexadecimal por clarifical
	; que se trabaja con n�meros en formaro BCD
	LD A, (scoreCount+2)
	ADD A, $05
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (scoreCount+2), A

	; Hace suma con acarreo en el byte 2 de la puntuaci�n
	LD A, (scoreCount+1)
	ADC A, 0
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (scoreCount+1), A

	; Hace suma con acarreo en el byte 1 de la puntuaci�n
	LD A, (scoreCount)
	ADC A, 0
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (scoreCount), A

	; A�ade 5 puntos al contador para ver si da una vida extra
	; En este caso no se trabaja con n�meros BCD pu�s no se va a imprimir
	LD HL, (livesExtra)
	LD BC, 5
	ADD HL, BC
	LD (livesExtra), HL
	
	; Si se ha llegado a 500, se da una vida extra y se pone a 0 el contador para vida extra
	; Para que se llegue a 500 el byte superior de livesExtra debe valer $01 y el inferior $F4
	LD A, H
	CP $01
	JR NZ, CheckCrash_fireEnemiesCrash

	LD A, L
	CP $F4
	JR NZ, CheckCrash_fireEnemiesCrash

	; Se pone el contador de vida extra a 0	
	LD HL, 0
	LD (livesExtra), HL

	; Se da una vida extra. livesCount es un n�mero BCD pu�s se imprime
	LD A, (livesCount)
	ADD A, $01
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (livesCount), A

CheckCrash_fireEnemiesCrash:
	; Refresca la informaci�n de la partida
	PUSH BC
	PUSH HL
	CALL PaintInfoGame
	POP HL
	POP BC

	; Termina la comprobaci�n de colisi�n entre enemigo y disparo
	JR CheckCrash_fireEnemiesEnd
	
CheckCrash_fireEnemiesNoCrash:	
	; Avanza hasta la posici�n de memoria de la coordenada X del enemigo
	INC HL
	
CheckCrash_fireEnemiesLoop:
	; Avanza hasta la posici�n de memoria de la coordenada Y del siguiente enemigo
	INC HL
	
	; Sigue en el bucle hasta que el contador de enemigos sea 0
	DEC B
	JR NZ, CheckCrash_fireEnemies

CheckCrash_fireEnemiesEnd:
	; Ha terminado la comprobaci�n de colisi�n entre disparo y enemigos
	RET

;------------------------------------------------------------------------------
; Eval�a si hay colisi�n entre la nave y alg�n enemigo	
;------------------------------------------------------------------------------
CheckCrash_ship:
	; Carga en A la coordenada Y de la nave
	LD A, (shipCoord)
	
	; La carga en D
	LD D, A
	
	; Carga en A la coordenada X de la nave
	LD A, (shipCoord+1)
	
	; La carga en E
	LD E, A
	
	; Obtiene el n�mero de enemigos
	LD B, enemiesConfigIni  - enemiesConfig
	
	; Divide entre dos, hay dos bytes por enemigo
	SRA B
	
	; Obtiene la direcci�n de memoria de la coordenada Y del primer enemigo
	LD HL, enemiesConfig
	
	; Eval�a si hay alguna colisi�n
	CALL CheckCrash_shipEnemies

	RET

CheckCrash_shipEnemies:
	; Carga en A la coordenada Y del enemigo
	; Tambi�n contiene si el enemigo est� activo
	LD A, (HL)
	
	; Comprueba si el enemigo est� activo, y si no lo est� salta
	BIT 7, A
	JR Z, CheckCrash_shipEnemiesNoCrash
	
	; Se queda con la coordenada Y del enemigo
	AND 00011111b
	
	; Lo compara con la coordenada Y de la nave y si no son iguales, salta
	CP D
	JR NZ, CheckCrash_shipEnemiesNoCrash
	
	; Como las coordenadas Y son las mismas, compara las coordenadas X
	; Avanza a la posici�n de memoria de la coordenada X del enemigo y la carga en A
	INC HL
	LD A, (HL)
	
	; Se queda con la coordenada X del enemigo, tambi�n contiene los indicadores de direcci�n del movimiento
	AND 00111111b
	
	; Lo compara con la coordenada X de la nave y si no son iguales, salta
	CP E
	JR NZ, CheckCrash_shipEnemiesLoop
	
	; Son iguales
	; Vuelve a la posici�n de memoria de la coordenada Y del enemigo
	DEC HL
	
	; Restaura los ciclos a pasar para animar a los enemigos
	LD A, 5
	LD (enemiesCiclesMax), A
	LD (enemiesCiclesCount), A

	; Restaura el tiempo a pasar para el cambio de velocidad de los enemigos
	LD A, 0
	LD (ticks), A
	LD (seconds), A

	; Desactiva el enemigo
	RES 7, (HL)

	; Resta un enemigo y una vida
	LD A, (enemiesCount)
	SUB $1
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (enemiesCount), A

	LD A, (livesCount)
	SUB $1
	DAA ; Intrucci�n necesaria siempre que se opera con n�meros BCD
	LD (livesCount), A

	; Borra el disparo
	CALL DeleteFire

	; Carga las coordenadas de la nave en BC
	LD B, D
	LD C, E

	; Sonido de explosi�n de la nave
	CALL ShipCrashSound

	; Anima la explosi�n de la nave
	CALL AnimeCrashShip

	; Si no hay vidas se sale
	CP 0
	JR Z, CheckCrash_shipEnemiesEnd

	; Imprime la informaci�n de la partida
	CALL PaintInfoGame
		
	; Imprime la nave
	CALL PaintShip

	; Limpia los enemigos
	CALL DeleteEnemies

	; Reinicia las posiciones de los enemigos
	CALL ResetActiveEnemiesConfig

	; Reinicia la direcci�n de movimiento de los enemigos
	CALL ResetEnemiesDir

	; Sale del bucle
	JR CheckCrash_shipEnemiesEnd
	
CheckCrash_shipEnemiesNoCrash:	
	; Avanza hasta la posici�n de memoria de la coordenada X del enemigo
	INC HL

CheckCrash_shipEnemiesLoop:
	; Avanza hasta la posici�n de memoria de la coordenada Y del siguiente enemigo
	INC HL
	
	; Sigue en el bucle hasta que el contador de enemigos sea 0
	DEC B
	JR NZ, CheckCrash_shipEnemies

CheckCrash_shipEnemiesEnd:
	; Ha terminado la comprobaci�n de colisi�n entre disparo y enemigos
	RET

; -----------------------------------------------------------------------------
; Eval�a si se ha pulsado alguna de la teclas de direcci�n.
; Las teclas de direcci�n son:
;	Z 	->	Izquierda
;	X 	->	Derecha
;	V	->	Disparo
;
; Retorna:	D	->	Teclas pulsadas.
;			Bit 0	->	Izquierda
;			Bit 1	->	Derecha
;			Bit 2	->	Arriba
;			Bit 3	->	Abajo
;			Bit 5	->	Disparo
;
; Altera el valor de los registros A, B y HL
; -----------------------------------------------------------------------------
CheckKey:
	; Reinicia D
	LD D, 0
	
	; Carga en A la semifila CAPS-V
	LD A, $FE
	
	; Lee el puerto del teclado
	IN A, ($FE)
	
	; Invierte los bits para que los pulsados queden a 1
	CPL
	
	; Se queda solo con los bits 0 a 5. Importante pues var�a seg�n ISSUE
	AND 00011111b
	
	; Comprueba si no se ha pulsado ninguna tecla
	OR A
	
	; Si no se ha pulsado ninguna tecla, se va
	RET Z
	
CheckKey_fire:
	; Comprueba si se ha pulsado la tecla V = disparo
	BIT 4, A
	
	; Si no se ha pulsado, sigue con la comprobaci�n del resto de teclas
	JR Z, CheckKey_right
	
	; Activa el bit de disparo pulsado
	SET 5, D
	
	; Comprueba si el disparo ya est� activo, el bit 1 a 1
	; En el caso de que no est� activo hay que activarlo y posicionarlo donde est� la nave
	LD HL, flags1
	LD B, (HL)
	BIT 1, B
	JR NZ, CheckKey_right
	
	; Activa el fuego y asigna a coordenada Y inicial y lo pone en memoria
	SET 1, (HL)

	LD HL, fireCoordIni
	LD B, (HL)
	LD HL, fireCoord
	LD (HL), B
	
	; Preserva AF pues se utilza A
	PUSH AF
	
	; Carga la coordenada X de la nave
	LD A, (shipCoord+1)
	
	; Pone en memoria la coordenada X del disparo
	LD (fireCoord+1), A
	
	; Hay que imprimir el disparo
	CALL PaintFire
	
	; Hay que hacer sonar el disparo
	CALL FireSound

	; Restaura AF
	POP AF
	
CheckKey_right:
	; Comprueba si se ha pulsado la tecla X = derecha
	BIT 2, A
	
	; Si no se ha pulsado, sigue con la comprobaci�n del resto de teclas
	JR Z, CheckKey_left
	
	SET 1, D
	
CheckKey_left:
	; Comprueba si se ha pulsado la tecla Z = izquierda
	BIT 1, A
	
	; Si no se ha pulsado, sigue con la comprobaci�n del resto de teclas
	JR Z, CheckKey_end
	
	SET 0, D

CheckKey_end:
	; Carga el valor de D en A para comprobar si se han pulsado izquierda y derecha a la vez
	LD A, D
	
	; Se queda solo con los bit de izquierda y derecha
	AND 00000011b
	
	; Comprueba si est�n los dos activos
	CP 3
	
	; Si no est�n lo dos activos, sale
	RET NZ
	
	; Desactiva los bits de izquierda y derecha por estar los dos activos
	LD A, D
	AND 00010000b
	LD D, A
	
	RET

; -----------------------------------------------------------------------------
; Espera la pulsaci�n de las teclas Enter o 0
;
; Enter = continuar
; 0		= salir
; -----------------------------------------------------------------------------
WaitKey:
	; Carga en A la semifila ENTER-H
	LD A, $BF

	; Lee el puerto del teclado
	IN A, ($FE)
	
	; Invierte los bits para que los pulsados queden a 1
	CPL
	
	; Se queda solo con los bits 0 a 5. Importante pues var�a seg�n ISSUE
	AND 00011111b
	
	; Comprueba si no se ha pulsado enter
	BIT 0, A
	
	; Si se ha pulsado Enter sale
	RET NZ

	; Carga en A la semifila 0-5
	LD A, $EF

	; Lee el puerto del teclado
	IN A, ($FE)
	
	; Invierte los bits para que los pulsados queden a 1
	CPL
	
	; Se queda solo con los bits 0 a 5. Importante pues var�a seg�n ISSUE
	AND 00011111b
	
	; Comprueba si no se ha pulsado 0
	BIT 0, A
	
	; Si se ha pulsado 0 sale
	CALL NZ, 0

	JR WaitKey