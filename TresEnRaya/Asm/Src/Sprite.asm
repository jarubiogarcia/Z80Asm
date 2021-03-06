; -----------------------------------------------------------------------------
; Fichero: Sprite.asm
;
; Definición de los sprites.
; -----------------------------------------------------------------------------
Sprite_X:
        db $c0, $e0, $70, $38, $1c, $0e, $07, $03       ; $90
        db $03, $07, $0e, $1c, $38, $70, $e0, $c0       ; $91

Sprite_O:
        db $03, $0f, $1c, $30, $60, $60, $c0, $c0       ; $92 Arriba/Izquierda
        db $c0, $f0, $38, $0c, $06, $06, $03, $03       ; $93 Arriba/Derecha
        db $c0, $c0, $60, $60, $30, $1c, $0f, $03       ; $94 Abajo/Izquierda
        db $03, $03, $06, $06, $0c, $38, $f0, $c0       ; $95 Abajo/Derecha

Sprite_CROSS:
        db $18, $18, $18, $ff, $ff, $18, $18, $18       ; $96

Sprite_SLASH:
        db $18, $18, $18, $18, $18, $18, $18, $18       ; $97

Sprite_MINUS:
        db $00, $00, $00, $ff, $ff, $00, $00, $00       ; $98