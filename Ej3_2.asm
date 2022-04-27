; Ejercicios 3.2
;Escribir un programa que sume dos valores guardados en los Registros 21H y 22H
;con resultado en 23H y 24H
    
	LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
    VA	    EQU 0x21	;Variable A
    VB	    EQU 0x22	;Variable B
    RTAL    EQU	0x23	;Respuesta baja
    RTAH    EQU 0x24	;Respuesta alta
    
	ORG 0x00

	GOTO INICIO
	
	ORG 0x5
    
INICIO
	BCF	STATUS,RP0	;Ponemos RP0 en 0
	BCF	STATUS,RP1	;Ponemos RP1 en 0 -> Direccionamos al bank 0
	CLRW
	CLRF	RTAL
	CLRF	RTAH	
	MOVF	VA,W		;Movemos F=VA a W
	ADDWF	VB,W		;Sumamos F=VB con W=VA, el resultado se guarda en W
	MOVWF	RTAL		;Movemos el resultado a RTAL
	BTFSC	STATUS,C	;Si el Flag C (Carry) de STATUS es 1 hacemos lo siguiente:
	INCF	RTAH,F		;Incrementamos en 1 F=RTAH, guardando este valor devuelta en F
	
	GOTO	$
	
	END
	
    
	