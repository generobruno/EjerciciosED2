; Ejemplo para ver los mecanismos y configuracion de la interrupcion
; por puerto B.
    
    LIST P=16F887
    #include <p16f887.inc>
  __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

    CBLOCK  0x70  
    W_TEMP
    STATUS_TEMP
    ENDC  
	
    ORG 0x00
    GOTO INICIO	    ; Ir al programa principal
    ORG 0x04	    ; Vector de interrupci?n
    GOTO INTERRUPCION
    
; ************************ PROGRAMA PRINCIPAL *********************** ***************
    ORG 0x05
INICIO ; Comienza del programa principal
    BSF	    STATUS,RP0
    CLRF   ANSELH
    MOVLW   B'11110000'		
    MOVWF   TRISB
    MOVWF   IOCB		    ; El nibble superior puede interrumpir
    BCF	    INTCON,RBIF
    BSF	    INTCON,RBIE
    BSF	    INTCON,GIE
    BCF	    STATUS,RP0   
    MOVF    PORTB,F		    ; Leo el puerto B para setear un valor de referencia para el cambio
BUCLE
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    GOTO BUCLE ; Permanecer aqu?

INTERRUPCION
    ;---------------------------------------------------
    ;Resguardo del contexto
    MOVWF   W_TEMP; Guarda valor del registro W
    SWAPF   STATUS,W; Guarda valor del registro STATUS
    MOVWF   STATUS_TEMP
    ;---------------------------------------------------
    ;Identificaci?n y asignaci?n de la prioridad de la interrupci?n	
    BTFSC	INTCON,RBIF
    GOTO	R_PORTB	
    GOTO	FININT
    ;---------------------------------------------------
    ; Rutina de servicio a la interrupci?n.
R_PORTB
    NOP
    NOP
    NOP
    NOP
    BCF	    INTCON,RBIF; Borra el flag que pidi? la Interrupci?n
;---------------------------------------------------
;Recuperaci?n del contexto    
FININT    
    SWAPF   STATUS_TEMP,W
    MOVWF   STATUS; a STATUS se le da su contenido original
    SWAPF   W_TEMP,F; a W se le da su contenido original
    SWAPF   W_TEMP,W
    RETFIE; Retorno desde rutina de interrupci?n
    END