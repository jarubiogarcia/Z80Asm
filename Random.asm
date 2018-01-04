; -----------------------------------------------------------------------------
; Graph.asm
;
; Archivo que contiene la rutina de generaci�n de n�meros pseudo aleatorios
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Genera n�meros pseudo aleatorios.
; Sigue un puntero a trav�s de la ROM (a partir de una semilla) y retorna el
; contenido del byte de esta posici�n.
;
; Rutina obtenida de http://old8bits.blogspot.com.es/2016/04/como-escribir-juegos-para-el-zx_18.html
; Se ha modificado ligeramente.
;
; Salida:	A -> N�mero aleatorio generado
;
; Altera el valor de los registros A y HL
; -----------------------------------------------------------------------------
Random:
	; Carga en HL el valor de la semilla
	LD HL, (seed)
	
	; Obtiene el valor del byte apuntado por HL
	LD A, (HL)

	; Avanza HL hasta la siguiente posici�n de memoria
	INC HL

	PUSH AF
	; Mantiene el puntero en los 16Kb de la ROM
	LD A, $3F
	CP H
	JR NC, Random_end

	LD HL, 0

Random_end:
	; Pone el valor en memoria
	LD (seed), HL
	POP AF

	RET
