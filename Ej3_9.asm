; Ejercicio 3.9
; Escribir un programa que convierta un número de 8 bits, escrito en ASCII, en su
; equivalente en BCD no empaquetado. El número se encuentra en la posición 0x20.

        LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
AUX	EQU	0x20
AUX1	EQU	0x21
	
    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
    BCF	    STATUS,RP0
    BCF	    STATUS,RP1
    MOVLW   0x0F	
    
    ANDWF   AUX,F
    ANDWF   AUX1,F
    
    GOTO	$
    END