; Ejercicio 5.3
; Escribir un programa que lea de dos teclas conectadas a RB1 y RB2 y actúe sobre un relé
; conectado en RB3.
;   1. Si están ambas teclas abiertas el relé está abierto.
;   2. Si RB2 está abierta y RB1 cerrada se activa el relé por 1 minuto.
;   3. Si RB2 está cerrada y RB1 abierta se activa el relé por 2 minutos.
;   4. Si están ambas cerradas se activa el relé por 3 minutos.
; Cualquier cambio en las teclas mientras esté activado el relé no debe modificar la salida.
    
    LIST P=16F887
   #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
 	CBLOCK	0x70
	STATUS_TEMP
	W_TEMP
	ENDC
 
	ORG	0x0
	GOTO	MAIN
	ORG	0x4
	GOTO    INTER
	ORG	0x05
	
MAIN
    BANKSEL	TRISB
    MOVLW	B'00000110'
    MOVWF	TRISB		; Configuramos RB1 y RB2 como entrada, y RB3 como salida
    BANKSEL	ANSELH
    MOVLW	B'00000000'
    MOVWF	ANSELH		; Configuramos PORTB como I/O digital
    BANKSEL	WPUB
    BCF		OPTION_REG,7	; RBPU = 0 -> Resistencias Pull-up habilitadas
    MOVLW	0x0F
    MOVWF	WPUB		; Resistencias de Pull-up de RB1 y RB2
    BCF		INTCON,RBIF	; Limpiamos la bandera
    BSF		INTCON,GIE	; Habilitamos interrupciones
    BSF		INTCON,RBIE     ; Habilitamos int por cambio en PORTB
    BSF		IOCB,IOCB1	; Habilitamos la int en RB1
    BSF		IOCB,IOCB2	; Habilitamos la int en RB2
    MOVLW	B'11110000'	; Esto es para ver si el contexto se esta guardando correctamente
    
    GOTO	$
    
INTER
    ; Guardamos Contexto
    MOVWF   W_TEMP      
    SWAPF   STATUS,W
    MOVWF   STATUS_TEMP
    ; Servicio de la interrupcion
    BTFSC   RB1		    ;REVISAR!!!!!!!!!!
    BTFSC   RB2
    BTFSS   RB2
    BTFSS   RB1
    GOTO    1MIN    ; RB1=1,RB2=0 -> Delay 1 Minuto
    GOTO    2MIN    ; RB1=0,RB2=1 -> Delay 2 Minutos
    GOTO    3MIN    ; RB1=1,RB2=1 -> Delay 3 Minutos
    
    GOTO    SALIR   
     
SALIR	
    ;Se recupera contexto
    SWAPF   STATUS_TEMP,W
    MOVWF   STATUS	     
    SWAPF   W_TEMP,F
    SWAPF   W_TEMP,W
    BCF	INTCON,RBIF	;Volvemos a limpiar la bandera
    RETFIE
    END	
    