; Ejercicio 3.11
; Escribir un programa que convierta un conjunto de Números Hexadecimales
; codificados ASCII en su equivalente en Hexadecimal no empaquetado. Los
; números codificados ASCII son 8 y están almacenados a partir del Registro 21H.
; Al resultado colocarlo a partir de la posición 31H


    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
CONTA	EQU	0x60
AUX	EQU	0x61
RTA	EQU	0x31

    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN			;Se cargan las variables y se apunta a los lugares correspondientes
    MOVLW   .8
    MOVWF   CONTA
    BCF	    STATUS,IRP
    MOVLW   0x21
    MOVWF   FSR   
    
CONVERTIR		;Convierte de ASCII a Hex-BCD no empaq
    BTFSS   INDF,6	;Si el bit 6 del reg es 1 --> Es una letra Hex
    GOTO    NUMERO	;Si es 0 --> Es un numero Hex
    GOTO    LETRA
    
NUMERO
    MOVLW   0x0F
    ANDWF   INDF,W	;Se hace la op y se guarda el resultado en W
    MOVWF    AUX	;Movemos la respuesta a un registro auxiliar
    CALL    CARGAR	;Vamos a guardar la respuesta
    GOTO    VUELTA
     
LETRA
    MOVLW   0x0F
    ANDWF   INDF,F
    MOVLW   .9
    ADDWF   INDF,W	;Se hace la op y se guarda el resultado en W
    MOVWF    AUX	;Movemos la respuesta a un registro auxiliar
    CALL    CARGAR	;Vamos a guardar la respuesta
    GOTO    VUELTA
    
CARGAR 
    MOVLW       0x10
    ADDWF       FSR,F	;Le sumamos 10 a FSR para que se apunte a donde estará la RTA
    MOVF        AUX,W
    MOVWF       INDF
    MOVLW       0x10
    SUBWF       FSR,F	;Y ahora se lo restamos para que vuelva correctamente
    RETURN
    
VUELTA			;Se modifican las variables
    INCF    FSR,F
    DECFSZ  CONTA,F
    GOTO    CONVERTIR
    
    GOTO $
       
    
	
    END