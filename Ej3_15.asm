; Ejercicio 3.15
; Escribir un programa que convierta un conjunto de números de 4 bits en su
; equivalente en código Exceso Tres. Estos números tienen su nibble inferior en 0 y
; el superior contiene un número binario natural BCD. Son 15 números ubicados a
; partir del Registro 40H y luego de modificarlos se deben guardar en el mismo
; lugar y con el mismo formato. No utilizar tabla.
    
    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
CONTA	EQU	0x60

    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
    MOVLW   .15
    MOVWF   CONTA
    BCF	    STATUS,IRP
    MOVLW   0x40
    MOVWF   FSR
    MOVLW   .3		; Cargamos W con 3
EX3
    ADDWF   INDF,F	; A cada num le sumamos W=3, y lo guardamos en el mismo lugar.
    INCF    FSR,F
    DECFSZ  CONTA,F
    GOTO    EX3
    
	GOTO	$
	END