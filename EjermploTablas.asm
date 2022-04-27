; Ejemplo tablas 

    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
CONTA   EQU	0x20

    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
	MOVLW   .16
	MOVWF   CONTA
	BCF	STATUS,IRP
	MOVLW   0x50	    ; Posicion Inicial
	MOVWF   FSR
	
MULT	
	MOVF	INDF,W	    ; Lo que esta cargado donde apunta FSR lo cargo en W
	CALL	TABLA
	INCF    FSR,F
	DECFSZ  CONTA,F
	GOTO    MULT
	
	GOTO	$
	
TABLA
	ADDWF	PCL,F	;PCL: Parte baja del contador del programa
	RETLW	.0	;PC+1. Volvemos con un valor Lit. cargado en W
	RETLW	.4	;PC+2
	RETLW	.8	;PC+3
	RETLW	.12	;PC+4
	RETLW	.16	;PC+5
	RETLW	.20	;PC+6
	
	
	
	END
    