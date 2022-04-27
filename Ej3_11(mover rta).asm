; Ejercicio 3.11
; Escribir un programa que convierta un conjunto de Números Hexadecimales
; codificados ASCII en su equivalente en Hexadecimal no empaquetado. Los
; números codificados ASCII son 8 y están almacenados a partir del Registro 21H.
; Al resultado colocarlo a partir de la posición 31H


    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
CONTA	EQU	0x60
RTA	EQU	0x31

    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
    MOVLW   .8
    MOVWF   CONTA
    BCF	    STATUS,IRP
    MOVLW   0x21
    MOVWF   FSR   
    
CONVERTIR
    BTFSS   INDF,6	;Si el bit 6 del reg es 1 --> Es una letra Hex
    GOTO    NUMERO	;Si es 0 --> Es un numero Hex
    GOTO    LETRA
VUELTA
    INCF    FSR,F
    INCF    RTA
    DECFSZ  CONTA,F
    GOTO    CONVERTIR
    
    GOTO $
       
NUMERO
    MOVLW   0x0F
    ANDWF   INDF,F
    ;MOVER RESPUESTA A RTA
    GOTO    VUELTA
     
LETRA
    MOVLW   0x0F
    ANDWF   INDF,F
    MOVLW   .9
    ADDWF   INDF,F
    ;MOVER RESPUESTA A RTA
    GOTO    VUELTA
    
	
    END