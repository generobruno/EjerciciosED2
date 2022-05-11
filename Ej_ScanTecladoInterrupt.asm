;***************************************************************************************
; Autor: Martin Ayarde.
; Testers: Fernando Segura, Tomas Magnelli. 
; Comisi?n: COM 8	    
;Descripci?n: Programa que lee un teclado de 16 teclas usando interrupci?n por puerto B
; y coloca su valor a la salida del puerto C. Utiliza ademas interrupci?n por 
; Timer 0 para generar un sistema de antirrebote por temporizaci?n 	    
;****************************************************************************************
	    LIST    P=16F887
	    INCLUDE <p16f887.inc>

; CONFIG1
; __config 0x2FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
	    CBLOCK  0X20
	    KEYNUM
	    AUX_KEYNUM
	    AUX_FILE
	    ENDC
	    CBLOCK  0X70
	    STATUS_TEMP
	    W_TEMP
	    ENDC
	    
	    ORG	    0x00
	    GOTO    START
	    ORG	    0x04
	    GOTO    INT
	    ORG	    0x05
START
	    BSF	    STATUS,RP0
	    BSF	    STATUS,RP1
	    CLRF    ANSELH
	    BCF	    STATUS,RP1
	    MOVLW   B'01110111'	; pullups:ON,T0CS:T0CKI pin(para detener el Timer),PSA:TMR0,PR:256  
	    MOVWF   OPTION_REG
	    MOVLW   B'11110000'	; <b0:b3>OUT;<b4:b7>IN
	    MOVWF   TRISB
	    CLRF    TRISC
	    MOVWF   WPUB        ; Se habilitan resistencias de Pull up 
	    MOVWF   IOCB
	    BCF	    STATUS,RP0
	    CLRF    PORTB	; Se llevan a cero las salidas <b0:b3>    
	    MOVF    PORTB,F     ; Se establece estado de referencia para la interrupci?n por PORTB
	    CLRF    INTCON	; Se limpian banderas de interrupci?n y se deshabilita interrupci?n por TMR0
	    MOVLW   B'10001000' ; Se habilita interrupci?n por PORTB
	    IORWF   INTCON,F      
	    CLRF    PORTC
	    GOTO    $

INT
;---------------------------------------------------
;Resguardo del contexto
            MOVWF   W_TEMP	; Se guarda valor del registro W
	    SWAPF   STATUS,W	; Se guarda valor del registro STATUS
	    MOVWF   STATUS_TEMP
;---------------------------------------------------
;Identificaci?n y asignaci?n de la prioridad de la interrupci?n	
	    BTFSC   INTCON,T0IF
	    GOTO    ISR_TMR0	; ISR que realiza un r?pido SCAN de las teclas 
	    BTFSC   INTCON,RBIF
	    GOTO    ISR_PORTB	; ISR que ante algun cero en <b4:b7> activa el antirebote	
	    GOTO    ENDINT
;---------------------------------------------------
; Rutina de servicio a la interrupci?n.
ISR_PORTB
	    BCF	    STATUS,RP0
	    BCF	    STATUS,RP1
	    MOVF    PORTB,F     ; Se realiza una instrucci?n "read,modify,write" para poder limpiar RBIF
	    BCF	    INTCON,RBIF
	    BCF	    INTCON,RBIE ; Se deshabilita interrupci?n por PORTB	    
	    MOVLW   .60		; Valor que setea 50 mseg aprox. para el antirebote por timer
	    MOVWF   TMR0	; Se carga el valor deseado en el TMR0, T[s]= ((256-TMR0)*prescaler+2)*Ty
	    BSF	    STATUS,RP0
	    BCF	    OPTION_REG,T0CS; T0CS:Ty (para iniciar funcionamiento del Timer) 		    
	    BCF	    INTCON,T0IF ; Se limpia bandera de interrupci?n por TMR0
	    BSF	    INTCON,T0IE ; Se habilita interrupci?n por desbordamiento en TMR0
	    GOTO    ENDINT
;---------------------------------------------------
ISR_TMR0
	    BSF	    STATUS,RP0
	    BCF	    STATUS,RP1
	    BSF	    OPTION_REG,T0CS		    
	    BCF	    INTCON,T0IF ; Se limpia bandera de interrupcion por TMR0
	    BCF	    INTCON,T0IE ; Se deshabilita interrupci?n por TMR0
	    BCF	    STATUS,RP0	    
	    CALL    SCAN
	    CLRF    PORTB	; Se llevan a cero las salidas <b0:b3>
	    MOVF    PORTB,F     ; Se establece estado de referencia para la interrupci?n por PORTB
	    BCF	    INTCON,RBIF  
	    BSF	    INTCON,RBIE ; Se habilita interrupci?n por PORTB	    
;---------------------------------------------------
;Recuperaci?n del contexto    
ENDINT    
	    SWAPF   STATUS_TEMP,W
	    MOVWF   STATUS	; a STATUS se le da su contenido original
	    SWAPF   W_TEMP,F	; a W se le da su contenido original
	    SWAPF   W_TEMP,W
	    RETFIE    

SCAN
	    MOVF    KEYNUM,W
	    MOVWF   AUX_KEYNUM
	    CLRF    KEYNUM	; Se lleva a cero el contador del n?mero de tecla
	    MOVLW   b'00001110'	; valor que permite evaluar primera fila del teclado
	    MOVWF   AUX_FILE
SCAN_NEXT
	    MOVF    AUX_FILE,W    
	    MOVWF   PORTB	
	    BTFSS   PORTB,RB4	; pregunta si la columna 1 es 0
	    GOTO    SR_KEY
	    INCF    KEYNUM,F
	    BTFSS   PORTB,RB5	; pregunta si la columna 2 es 0
	    GOTO    SR_KEY
	    INCF    KEYNUM,F
	    BTFSS   PORTB,RB6	; pregunta si la columna 3 es 0
	    GOTO    SR_KEY
	    INCF    KEYNUM,F
	    BTFSS   PORTB,RB7	; pregunta si la columna 4 es 0
	    GOTO    SR_KEY
	    BSF	    STATUS,C	; ninguna columna es 0
	    RLF	    AUX_FILE,F	; Se rota el cero para evaluar la pr?xima fila
	    INCF    KEYNUM,F	; Se incrementa el contador
	    MOVLW   .16		
	    SUBWF   KEYNUM,W	; Se testea si ya se escane? las 16 teclas
	    BTFSS   STATUS,Z		
	    GOTO    SCAN_NEXT	; no lleg? a 16, busca pr?xima fila
	    MOVF    AUX_KEYNUM,W  ; Si no se ha presionado ninguna tecla se
	    MOVWF   KEYNUM        ; mantiene el ?ltimo valor de tecla presionada
	    RETURN
SR_KEY
;************************************************************
;		Rutina de servicio al teclado
;		....
	    MOVF    KEYNUM,W
	    MOVWF   PORTC     ; se muestra por PORTC el valor de la tecla presionada
;		....
;************************************************************		
	    RETURN
	    END