; Ejercicio 3.4
; Escribir un programa que sume dos números de 16 bits A (20H 21H) y B (22H y
; 23H) y al resultado colocarlo en A.
    
	LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
    VAL	    EQU	    0x20    ;Variable A - Low
    VAH	    EQU	    0x21    ;Variable A - High
    VBL	    EQU	    0x22    ;Variable B - Low
    VBH	    EQU	    0x23    ;Variabel B - High

	ORG 0x0
	
	GOTO MAIN
	
	ORG 0x5
	
MAIN
	BCF	STATUS,RP0
	BCF	STATUS,RP1
	CLRW
	MOVF	VAL,W
	ADDWF	VBL,W	    ;Sumo las partes bajas de A y B
	MOVWF	VAL	    ;Guardo el resultado en A - Low
	BTFSC	STATUS,C    ;Chequeo si hay carry
	INCF	VAH,F	    ;Si lo hay se lo agregamos a VAH	
	MOVF	VAH,W	
	ADDWF	VBH,W	    ;Sumo las partes altas de A y B
	MOVWF	VAH	    ;Guardo el resultado en A - High
	BTFSC	STATUS,C    ;Chequeamos otra vez por carry
	MOVLW	.255	    ;Si lo hay, saturamos VAH ¡¡¡¡¡¡¡REVISAR!!!!!!!!!!!
	
	GOTO	$
	
	END