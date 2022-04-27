; Ejercicio 4.4
; Escribir un programa que, dependiendo del estado de dos interruptores
; conectados a RA4 y RB0, presente en el puerto D diferentes funciones lógicas
; cuya tabla de verdad se muestra en la guía 
    
    LIST P=16F887
    #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
AUX EQU	0X20 
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
LOOP	MOVF	    PORTA,W
	MOVWF	    AUX
	SWAPF	    AUX,F
	BCF	    STATUS,C
	RLF	    AUX,F
	MOVF	    PORTB,W
	ADDWF	    AUX,F
	MOVLW	    B'00000011'
	ANDWF	    AUX,F
	MOVF	    AUX,W
	CALL	    FUNLOG
	MOVWF	    PORTD
	GOTO	    LOOP
FUNLOG
	ADDWF	    PCL,F
	RETLW	    B'10101010'
	RETLW	    B'01010101'
	RETLW	    B'00001111'
	RETLW	    B'11110000'	

	END