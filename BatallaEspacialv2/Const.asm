;------------------------------------------------------------------------------
; Const.asm
;
; Contiene las constantes
;------------------------------------------------------------------------------

; -----------------------------------------------------------------------------
; Declaraciones de variables de sistema
; -----------------------------------------------------------------------------
; Variable de sistema donde est�n los atributos de la pantalla 1, principal.
ATTR_S:		EQU	$5C8D

; Variable de sistema donde est� el atributo actual
ATTR_T:		EQU	$5C8F	

; Variable de sistema donde se guarda el borde. Tambi�n usada por BEEPER.
; Tambi�n se guardan aqu� los atributos de la pantalla 2, �ltimas 2 l�neas
BORDCR:		EQU $5C48

; Direcci�n de memoria donde se cargan los gr�ficos definidos por el usuario.
UDG:		EQU $5C7B

; -----------------------------------------------------------------------------
; Declaraciones de la VideoRAM
; -----------------------------------------------------------------------------
; Primera direcci�n de memoria del �rea de gr�ficos de la VideoRAM
VIDEORAM:	EQU $4000

; Longitud del �rea de gr�ficos de la VideoRAM
VIDEORAM_L:	EQU $1800

; Primera direcci�n de memoria del �rea de atributos de la VideoRAM
VIDEOATTR:	EQU	$5800

; Longitud del �rea de atributos de la VideoRAM
VIDEOATTR_L:EQU $300

; -----------------------------------------------------------------------------
; Declaraciones de rutinas de la ROM
; -----------------------------------------------------------------------------
; -----------------------------------------------------------------------------
; Rutina beeper de la ROM.
;
; Entrada:	HL	->	Nota.
;			DE	->	Duraci�n.
;
; Altera el valor de los registros AF, BC, DE, HL e IX.
; -----------------------------------------------------------------------------
BEEPER:		EQU $03B5	

; -----------------------------------------------------------------------------
; Rutina locate de la ROM.
;
; Entrada:	B	->	Coordenada Y.
;			C	->	Coordenada X.
;
; Para esta rutina, la esquina superior izquierda de la pantalla es (24, 33).
;
; Altera el valor de los registros AF, DE y HL.
; -----------------------------------------------------------------------------
LOCATE:		EQU $0DD9	

; -----------------------------------------------------------------------------
; Rutina de la ROM que abre el canal de la pantalla.
;
; Entrada:	A	->	Canal. 1 = Pantalla 2, 2 = pantalla 1.
;
; -----------------------------------------------------------------------------
OPENCHAN:	EQU $1601