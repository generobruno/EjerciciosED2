; Ejercicio 5.6
; Por RB0 ingresa una onda cuadrada como se muestra en la figura y actúa sobre
; un relé conectado a RB3. Se pide que al salir del reset el relé permanezca
; apagado por 1 minuto y luego conectado por 2 minutos y así sucesivamente.
; Utilizar flanco ascendente para activar la interrupción.
    
   LIST P=16F887
   #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
        CBLOCK	0x20
	CONTA1
	CONTA2
	MIN
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
	BANKSEL ANSELH
	CLRF	ANSELH
	CLRF	TRISB
	BSF	TRISB,RB0
	BSF	OPTION_REG,INTEDG	; Flanco ascendente para la interrupcion
	BANKSEL	PORTB
	CLRF	CONTA1
	MOVLW	.2			
	MOVWF	CONTA2			; Usamos 2 contadores para llegar al tiempo
	CALL	INICIALIZAR
	;Se configura interrupci?n por RB0
	BCF	INTCON,INTF
	BSF	INTCON,INTE
	BSF	INTCON,GIE
	GOTO	$

INTER   ;Se guarda contexto    
        MOVWF   W_TEMP      
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP
	;Consulta de la fuente a la interrupci?n
	
	;Rutina de servicio a la interrupci?n
	DECFSZ	CONTA1		; Se decrementa CONTA1 que empieza en 0 -> pasa a 255 y vuelve a decrementar
	GOTO	SALIR		; es por esto que no debemos volver a cargar CONTA1
	DECFSZ	CONTA2		; Ahora decrementamos CONTA2
	GOTO	SALIR
	MOVLW	.2		; Vuelvo a cargar CONTA2
	MOVWF	CONTA2
	BCF	STATUS,C	; Limpiamos el carry para poder rotar
	RLF	MIN		; Rotamos el reg aux cada vez que pasa 1 minuto
	BTFSC	MIN,1		; Si el bit 1 de MIN esta en 1 -> Paso un 1 minuto
	BSF	PORTB,RB3	; Sale un 1 -> Enciendo la lampara
	BTFSC	MIN,3		; Si el bit 3 de MIN esta en 0 -> Se va a SALIR
	CALL	INICIALIZAR	; Si el bit 3 esta en 1 -> Pasaron 2 minutos -> Se vuelve a INICIALIZAR
SALIR	;Se recupera contexto
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS	     
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W
	BCF	INTCON,INTF
	RETFIE	

INICIALIZAR
	BCF	PORTB,RB3	; Pongo en 0 la salida RB3
	CLRF	MIN
	BSF	MIN,0		; Pongo en 1 el reg aux MIN que cuenta los minutos pasados
	RETURN

	END	