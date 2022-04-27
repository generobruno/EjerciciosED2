; Ejercicio ejemplo de parcial. Ejercicio 2
; Programa que comprueba la paridad de un número de 8 bits, guardado en la posicion
; 0x30. Si la paridad es par, el programa guarda el valor 0xEE en la pos. 0x110.
; Si la paridad es impar, se guarda 0xDD en la pos. 0x191
    
    LIST p=16f887
    #INCLUDE <p16f887.inc>
    
    NUMERO  EQU	0x30
    RTAP    EQU	0x10
    RTAI    EQU	0x91
    
    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN
    ;BANKSEL NUMERO --> Podriamos hacere esta tambien
    BCF	    STATUS,RP0
    BCF	    STATUS,RP1
    BTFSS   NUMERO,0	; Vemos si el Bit 0 del num es igual a 0.
    GOTO    PAR		; Si es 0 --> El numero es par.
    BTFSC   NUMERO,0	; Vemos si el Bit 0 del num es igual a 1
    GOTO    IMPAR	; Si es 1 --> El numero es impar.
    GOTO    FIN
    
PAR
    ;BANKSEL RTAP --> Para hacer esto la etiqueta deberia ser 0x110
    BSF	    STATUS,RP1
    BCF	    STATUS,RP0	; Seleccionamos Banco 2 --> para 0x110
    MOVLW   0xEE
    MOVWF   RTAP
    GOTO    FIN
    
IMPAR
    ;BANKSEL RTAI --> Para hacer esto la etiqueta deberia ser 0x191
    BSF	    STATUS,RP1
    BSF	    STATUS,RP0	; Seleccionamos Banco 3 --> para 0x191
    MOVLW   0xDD
    MOVWF   RTAI
    GOTO    FIN
    
FIN
    GOTO    $
    
    END