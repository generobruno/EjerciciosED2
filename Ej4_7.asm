; Ejercicio 4.7
; Realizar un programa en Lenguaje Ensamblador que cuente de 0 a 9
; indefinidamente. Cada número permanecerá encendido 1 seg (retardo por
; software). El conteo iniciará en 0 al apretarse el pulsador y se detendrá al volver
; a pulsarlo en el valor que esté la cuenta. Se muestra el esquema del hardware
; sobre el que correrá el programa. El oscilador es de 4MHz. 
    
    LIST P=16F887
    #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
TIEMPO1 EQU	0X20 
TIEMPO2 EQU	0X21  
TIEMPO3 EQU	0X22
CONTA	EQU	0X23
 
	ORG	0x00
	GOTO	INICIO
	ORG	0x05
INICIO	
	BSF	    STATUS,RP0	
	BSF	    STATUS,RP1
	BCF	    ANSELH,ANS12
	BCF	    STATUS,RP1
	CLRF	    TRISD
	BCF	    STATUS,RP0
	CLRF	    CONTA
	MOVF	    CONTA,W
	CALL	    CONV7SEG
	MOVWF	    PORTD
BUCLE	BTFSC	    PORTB,RB0  ;queda como tarea para el estiante detectar el flanco
	GOTO	    BUCLE
BUCLE2	MOVF	    CONTA,W
	CALL	    CONV7SEG
	CALL	    RETARDO1S
	INCF	    CONTA
	MOVLW	    .4
	SUBWF	    CONTA,W
	BTFSS	    STATUS,Z
	GOTO	    BUCLE2
	CLRF	    CONTA
	GOTO	    BUCLE2
	
CONV7SEG
	ADDWF	    PCL,F       ; Queda como tarea completar la tabla
	RETLW	    B'00111111' ;0  
	RETLW	    B'00000110' ;1
	RETLW	    B'01011011' ;2 
	RETLW	    B'01100111' ;3 

RETARDO1S
	MOVLW	    .5	    
	MOVWF	    TIEMPO1
LOOP3	MOVLW	    .255	    
	MOVWF	    TIEMPO2
LOOP4	BTFSC	    PORTB,RB0; queda como tarea detectar el flanco
	GOTO	    LOOP4
LOOP2	MOVLW	    .255	    
	MOVWF	    TIEMPO3
LOOP1	DECFSZ	    TIEMPO3,F
	GOTO	    LOOP1
	DECFSZ	    TIEMPO2,F
	GOTO	    LOOP2
	DECFSZ	    TIEMPO1
	GOTO	    LOOP3
	RETURN
	
	END