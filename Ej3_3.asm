; Ejercicio 3.3
; Escribir un programa que resuelva la ecuación: (A + B) - C (posiciones 21H, 22H
; y 23H)
    
	LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
    VA		EQU	0x21	;Variable A
    VB		EQU	0x22	;Variable B
    VC		EQU	0x23	;Variable C
    SUMA	EQU	0x24	;Resultado A+B
    RTA		EQU	0x25	;Resultado (A+B)-C
	
	ORG 0x0
	
	GOTO MAIN
	
	ORG 0x5
	
MAIN	
	BCF	STATUS,RP0
	BCF	STATUS,RP1
	CLRW
	MOVF	VA,W
	ADDWF	VB,W
	MOVWF	SUMA
	MOVF	VC,W
	SUBWF	SUMA
	MOVWF	RTA
	
	GOTO	$
	
	END
	
