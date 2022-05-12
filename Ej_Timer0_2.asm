	LIST P=16F887
	INCLUDE <p16f887.inc>

	__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF

w_temp	    EQU	    0x20; Variable en la direcci?n 20h
status_temp EQU	    0x21; Variable en la direcci?n 21h
CONTA1	    EQU	    0x22
FLAG	    EQU	    0x23	    
 
	ORG 0x00
	GOTO INICIO ; Ir al programa principal
	ORG 0x04 ; Vector de interrupci?n
	GOTO INTERRUPCION
	ORG 0x05
INICIO ;programa principal
	; Cambiando la asociaci?n del prescaler del WDT a TMR0
	BSF	STATUS,RP0
	BSF	STATUS,RP1
	CLRF	ANSEL
	MOVLW	B'11010001' ; Puedo cambiar OPTION_REG directamente ya que WDT esta desactivado por config word 
	MOVWF	OPTION_REG   
	BCF	STATUS,RP1
	CLRF	TRISA
	BCF	STATUS,RP0
	MOVLW   0x64 
	MOVWF	TMR0         ; Se carga el valor deseado en el TMR0
	                     ; T[s]= ((256-TMR0)*prescaler+2)*Ty   
	BCF	INTCON,T0IF ; Se limpia bandera de interrucion por timmer
	BSF	INTCON,T0IE ; Interrupci?n por desbordamiento TM0 habilitado
	BSF	INTCON,GIE ; Interrupci?n Global habilitada
	MOVLW	D'5'
	MOVWF	CONTA1
	CLRF	PORTA
	GOTO	$          ; Permanecer aqu? indefinidamente
	
INTERRUPCION
	;---------------------------------------------------
	;Resguardo del contexto
	MOVWF w_temp ; Guarda valor del registro W
	SWAPF STATUS,W ; Guarda valor del registro STATUS con swapf para no alterar Z
	MOVWF status_temp
	;---------------------------------------------------
        ;Identificaci?n y asignaci?n de la prioridad de la interrupci?n
	BTFSC	INTCON,T0IF
	GOTO	R_TMR0	
	GOTO	FININT
	;---------------------------------------------------
R_TMR0	;Rutina de servicio a la interrupci?n por timer
	MOVLW   0x64 
	MOVWF	TMR0    ; Se carga el valor deseado en el TMR0
    	DECFSZ	CONTA1,F	
	GOTO	L1	
	MOVLW	D'5'	
	MOVWF	CONTA1	; Esta var se usa para incrementar la temporizacion de TMR0
	INCF	FLAG,F
	BTFSS	FLAG,0
	BCF	PORTA,0
	BTFSC	FLAG,0
	BSF	PORTA,0
	
L1	BCF INTCON,T0IF ; Limpio bandera de interrucion por timmer
	;---------------------------------------------------
	;Recuperaci?n del contexto
FININT	
	SWAPF status_temp,W
	MOVWF STATUS ; a STATUS se le da su contenido original	
	SWAPF w_temp,F ; a W se le da su contenido original
	SWAPF w_temp,W
	RETFIE ; Retorno desde rutina de interrupci?n
	END ; Fin del programa