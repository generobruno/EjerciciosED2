;Descripci?n: Ejercicio 5_2
   LIST P=16F887
   #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
        CBLOCK	0x20
	SHIFTREG
	ENDC
	CBLOCK	0x70
	STATUS_TEMP
	W_TEMP
	ENDC
		
	ORG	0x0
	GOTO	INICIO
	ORG	0x4
	GOTO    INTER
	ORG	0x05
INICIO	;Se configura puerto
	BANKSEL TRISB	     
	CLRF	TRISB			    ;Puerto B como salida
	BSF	TRISB,RB0		    ;Salvo RB0 que es entrada
	BCF	OPTION_REG,INTEDG	    ;La inte. es por flanco de bajada ya que es cada vez que se presione
	BANKSEL	PORTB
	CLRF	PORTB			    
	BSF	SHIFTREG,0		    ;Registro aux de rotacion 
	;Se configura interrupcion por RB0
	BCF	INTCON,INTF		    ;Limpiamos la bandera
	BSF	INTCON,INTE		    ;Habilitamos INT/RB0
	BSF	INTCON,GIE		    ;Habilitamos las interrupciones
	MOVLW	B'11110000'		    ;Esto es para ver si el contexto se esta guardando correctamente
	GOTO	$

INTER   ;Se guarda contexto    
        MOVWF   W_TEMP      
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP
	;Consulta de la fuente a la interrupci?n
	;AHORA NO SE PONE NADA PORQUE HAY UNA SOLA ENTRADA DE INTERRUPCION
	;LO QUE HABRIA QUE HACER ES REVISAR LAS FLAGS DE LOS PERIFERICOS
	;Rutina de servicio a la interrupci?n
	BCF	STATUS,C
	RLF	SHIFTREG,F	;Roto el reg auxiliar
	MOVLW	0x02
	BTFSC	SHIFTREG,4
	MOVWF	SHIFTREG
	MOVF	SHIFTREG,W
	MOVWF	PORTB   
		
SALIR	;Se recupera contexto
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS	     
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W
	BCF	INTCON,INTF	;Volvemos a limpiar la bandera
	RETFIE
	END	