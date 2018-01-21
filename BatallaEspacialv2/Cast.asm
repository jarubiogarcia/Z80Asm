; -----------------------------------------------------------------------------
; Cast.asm
;
; Archivo que contiene rutinas de conversi�n.
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Convierte un n�mero BCD a binario.
;
; Entrada:	A	->	N�mero BCD
;
; Salida:	A	->	N�mero binario
;
; C�digo tomado de https://www.msx.org/forum/development/msx-development/bcdhex-conversion-asm
; -----------------------------------------------------------------------------
BCD2bin:
	; Preserva el valor de los registros
	PUSH BC

	LD	C,A
	AND	0F0H
	SRL	A
	LD	B,A
	SRL	A
	SRL	A
	ADD	A,B
	LD	B,A
	LD	A,C
	AND	0FH
	ADD	A,B

	; Recupera el valor de los registros
	POP	BC

	RET