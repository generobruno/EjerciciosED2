;********************************************************************************
;* Programa que cambia la asociaci?n del prescaler del WDT a TMR0
;********************************************************************************
	    LIST P=16F887
	    #include <p16f887.inc>
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_ON & _MCLRE_ON & _LVP_OFF
w_temp	    EQU	    0x70
status_temp EQU	    0x71

	    ORG 0x0
	    GOTO INICIO
      	    ORG 0x04 ; Vector de interrupci?n
	    GOTO INTERRUPCION	    
	    ORG 0x05
INICIO 
	BSF STATUS,RP0
	CLRWDT   ;Se limpia WDT, limpiando tambi?n el registro del Prescaler       
	                     ; Se prepara la configuraci?n para que:
	MOVLW	B'11010000'  ; 1.- TMR0 sea controlado por el oscilador
	ANDWF	OPTION_REG,W ; 2.- El Prescaler sea asignado al temporizador TMR0
	IORLW	B'00000001'  ; 3.- Se elige una divisi?n de frecuencia de 1:4
	MOVWF	OPTION_REG   ; Se carga la configuraci?n final.	
	BCF	STATUS,RP0
	MOVLW   B'11110000' 
	MOVWF	TMR0         ; Se carga el valor deseado en el TMR0
	NOP                  ; T[s]= ((256-TMR0)*prescaler+2)*Ty   
	BCF	INTCON,T0IF ; Se limpia bandera de interrucion por timmer
	BSF	INTCON,T0IE ; Interrupci?n por desbordamiento TM0 habilitado
	BSF	INTCON,GIE ; Interrupci?n Global habilitada
L1	NOP
	NOP
	NOP
	NOP
	CLRWDT
	NOP
	GOTO	L1          ; Permanecer aqu? indefinidamente
	
	
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
	MOVLW   B'11110000' 
	MOVWF	TMR0    ; Se carga el valor deseado en el TMR0
	BCF INTCON,T0IF ; Limpio bandera de interrucion por timmer	
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	;---------------------------------------------------
	;Recuperaci?n del contexto
FININT	
	SWAPF status_temp,W
	MOVWF STATUS ; a STATUS se le da su contenido original	
	SWAPF w_temp,F ; a W se le da su contenido original
	SWAPF w_temp,W
	RETFIE ; Retorno desde rutina de interrupci?n
	END ; Fin del programa