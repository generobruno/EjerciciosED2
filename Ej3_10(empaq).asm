; Ejercicio 3.10
; Escribir un programa que convierta un conjunto de números decimales
; codificados ASCII en su equivalente en BCD empaquetado. Los números
; codificados ASCII están en los Registros 20H a 30H.

    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
CONTA	EQU	0x60
AUX	EQU	0x61

    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
	MOVLW   D'17'   ;Cant de posiciones a convertir
	MOVWF   CONTA
	BCF	STATUS,IRP
	MOVLW   0x20
	MOVWF   FSR
	MOVLW   0x0F
CONVERTIR
	ANDWF   INDF,F
	BTFSS   CONTA,0	    ;Si el bit 0 de INDF es 0 estamos en una pos. par
	SWAPF   INDF,F	    ;y en ese caso hacemos un swaP
	INCF    FSR,F
	DECFSZ  CONTA,F
	GOTO    CONVERTIR
;	FALTA HACER QUE SEAN BCD EMPAQUETADO
    
	GOTO	$
	END