; Ejercicio 6.1
; Realizar un programa que obtener el código ASCII de la tecla que se pulsa en un
; teclado estándar conectado al puerto B de un microcontrolador PIC 16F887, como
; indica la figura. El valor ASCII de la tecla se guardará en el Registros 30H. Se
; pide resolución utilizando el método polling.
    
	    LIST    P=16F887
	    INCLUDE <p16f887.inc>

; CONFIG1
; __config 0x2FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
    KEYNUM	EQU	0x20
    AUX_FILE	EQU	0x21
    TIME        EQU	0x22
    RESULTADO	EQU	0x30
	    
	    ORG 0x00
	    GOTO MAIN
	    ORG 0x05
	    
MAIN
    BANKSEL	ANSELH
    CLRF	ANSELH		    ; PORTB como I/O digital
    BANKSEL	OPTION_REG
    BCG		OPTION_REG,NOT_RBPU
    BANKSEL	TRISB
    MOVLW	B'11110000'
    MOVWF	TRISB		    ; <B0;B3>: OUT , <B4;B7>: IN
    MOVWF	WPUB		    ; Resistencias de Pull-up habilitadas
    BANKSEL	PORTB
    CLRF	PORTB

SCAN
    CLRF    KEYNUM	    ; contador a cero
    MOVLW   b'11100000'	    ; valor para primera fila  --> REVISAR COMO ROTAR
    MOVWF   AUX_FILE	    ; RowSelector
SCAN_NEXT
    MOVF    AUX_FILE,W	    
    MOVWF   PORTB	
    BTFSS   PORTB,RB0	    ; pregunta si la columna 1 es 0
    GOTO    SR_KEY
    INCF    KEYNUM,F
    BTFSS   PORTB,RB1	    ; pregunta si la columna 2 es 0
    GOTO    SR_KEY
    INCF    KEYNUM,F
    BTFSS   PORTB,RB2	    ; pregunta si la columna 3 es 0
    GOTO    SR_KEY
    INCF    KEYNUM,F
    BTFSS   PORTB,RB3	    ; pregunta si la columna 4 es 0
    GOTO    SR_KEY
    
    BSF	    STATUS,C	    ; ninguna columna es 0
    RLF	    AUX_FILE,F	    ; corro el bit 0 a la pr?xima fila --> REVISAR SI TENGO Q HACER ALGO MAS
    INCF    KEYNUM,F	    ; incremento el contador
    MOVLW   .16			    ; --> REVISAR 
    SUBWF   KEYNUM,W	    ; averig?o si ya testeo las 16 teclas
    BTFSS   STATUS,Z		; -> REVISAR	
    GOTO    SCAN_NEXT	    ; no lleg? a 16, busca pr?xima fila
    GOTO    SCAN	    ; si lleg? a 16, reinicio desde la primera tecla
SR_KEY
    CALL    DELAY
    ; ACA SE TIENE QUE PASAR EL VAL DE KEYNUM A W Y DESPUES LLAMAR A UNA TABLA
    ; QUE CONVIERTA EL NUM A ASCII??
;************************************************************
;		Rutina de servicio al teclado
;		....
    MOVF    KEYNUM,W
    MOVWF   RESULTADO
;		....
    GOTO    SCAN
;************************************************************	
    
DELAY	
    MOVLW   0xFF      ; retardar aproximadamente 50 A 150 mseg
    MOVWF   TIME
    DECFSZ  TIME,F
    GOTO    $-1			
    RETURN
    
    
    END