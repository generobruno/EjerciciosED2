; Ejercicio 3.6
; Escribir un programa que su ejecuci�n demore un segundo (Cristal de 4MHz).
    
	LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
   
    T1	EQU	0x30
    T2	EQU	0x31
    T3	EQU	0x32
	
	ORG 0x0
	
	GOTO MAIN
	
	ORG 0x5
	
MAIN
	CALL	RETARDO
	
	GOTO $
	
	
RETARDO
	MOVLW	.5	    ;Valor n calculado
	MOVWF	T3	    
	
B3	MOVLW	.255	    ;Valor p calculado
	MOVWF	T2

B2	MOVLW	.255	    ;Valor m calculado
	MOVWF	T1
			    ;Bucle 1
B1	DECFSZ	T1
	GOTO	B1
			    ;Bucle 2
	DECFSZ	T2
	GOTO	B2
			    ;Bucle 3
	DECFSZ	T3
	GOTO	B3
	
	RETURN
	
	END