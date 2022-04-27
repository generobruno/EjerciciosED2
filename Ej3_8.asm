; Ejercicio 3.8
; Escribir un programa para almacenar el valor 33D en 15 posiciones contiguas de
; la memoria de datos, empezando en la dirección 0x30.
    
        LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
	CONTA   EQU	0x20   

	ORG 0x0 
	
	GOTO MAIN
	
	ORG 0x5
	
MAIN
	MOVLW	.15
	MOVWF	CONTA	    ;Cargo la variable CONTA con el num. de posiciones a cargar
	BSF	STATUS,IRP  ;Nos posicionamos en el banco 0
	MOVLW	0x30	    ;Posicion Inicial del "puntero"
	MOVWF	FSR	    ;El "puntero" FSR esta apuntando a 0x30
	MOVLW	.33	    ;Valor a cargar en memoria
	MOVWF	INDF	    ;INDF queda cargado con 33D
	
FULL	
	INCF	FSR	    ;Incremento en 1 FSR
	DECFSZ	CONTA	    ;Decremento en 1 CONTA; CONTA=0?
	GOTO	FULL	    ;NO: Entonces vuelve a empezar el bucle y sigue llenando la memoria
	
	GOTO	$	    ;SI: Entonces termino.
	
	END

