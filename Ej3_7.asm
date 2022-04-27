; Ejercicio 3.7
; Escribir un programa que compare dos números A y B. 
;  - Si son iguales, el resultado debe ser 0.
;  - Si A > B, el resultado debe ser la diferencia A ? B.
;  - Y si A < B el resultado debe ser la suma A + B.
; Considere A en posición 30H, B en 31H y R en 32H.
    
    	LIST p=16f887
	#INCLUDE <p16f887.inc>
    
; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
VA	EQU	0x30
VB      EQU     0x31
RTA	EQU     0x32
	    
	ORG 0x0

	GOTO    MAIN

	ORG 0x5
	    
MAIN
	;Limpieza del reg resultado
	CLRF    RTA
	;Carga de valores en A
	MOVLW   0x04
	MOVWF   VA
	;Carga de valores en B
	MOVLW   0x07
	MOVWF   VB
	;Comparación
	MOVFW   VB
	SUBWF   VA,W	;F - W --> VA - VB 
	;Si A==B
	BTFSS   STATUS,Z    ;Si Z = 1 --> A y B son iguales. RTA ya es 0.
	CALL    DIF0	    ;En caso contrario se llama a DIF0

	GOTO $

	;Caso A > B 
DIF0
	BTFSS	STATUS,DC   ;Si DC = 1 --> A >= B y se hace skip.
	CALL	DIF1	    ;Si DC = 0 --> A < B y se llama a DIF1.
	MOVWF	RTA	    ;RTA es A - B.
	RETURN
	
	;Caso A < B
DIF1
	MOVFW	VA	    ;Como A < B se llamo a DIF1
	ADDWF	VB,W	    
	MOVWF	RTA	    ;Entonces RTA debe ser A + B
	RETURN
	
	END
	    
	   
    
    