;------------------------------------------------------------------------------
; Const.asm
;
; Contiene las constantes
;------------------------------------------------------------------------------

; Direcci�n de memoria d�nde est� la rutina beeper de la rom
ROMBEEPER:		EQU $03B5
; Direcci�n de memoria d�nde est� la rutina cls de la rom
ROMCLS:			EQU	$0DAF ; $0D6B
; Direcci�n de memoria donde est� la rutina locate de la rom
ROMLOCATE:		EQU	$0DD9
; Direcci�n de memoria donde est� la rutina de abrir canal de la VideoRAM
ROMOPENCHAN:	EQU	$1601
; Direcci�n de memoria d�nde cargar los gr�ficos definidos por el usuario
UDGDIR:			EQU		$5C7B