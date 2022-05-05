;***************************************************************************************
; Autor: Martin Ayarde.
; Comisi?n: COM 8	    
;Descripci?n: Programa que lee un teclado de 16 teclas usando tecnica de Polling
; por puerto B y coloca su valor a la salida del puerto C. Utiliza ademas un retardo por 
; software para generar un sistema de antirrebote por temporizaci?n 	    
;****************************************************************************************
	    LIST    P=16F887
	    INCLUDE <p16f887.inc>

; CONFIG1
; __config 0x2FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
KEYNUM	    EQU	0x20
AUX_FILE    EQU	0x21
TIME	    EQU	0x22
		
	    ORG	    0x0
	    GOTO    INICIO
	    ORG	    0x05
INICIO
	    BSF	    STATUS,RP0
	    BSF	    STATUS,RP1
	    CLRF    ANSELH		
	    BCF	    STATUS,RP1
	    BCF	    OPTION_REG,NOT_RBPU
	    MOVLW   b'11110000'	    ; <b0:b3>OUT;<b4:b7>IN
	    MOVWF   TRISB
	    MOVWF   WPUB	    ; Se habilitan resistencias de Pull up 
	    CLRF    TRISC	    ; Los valores se sacan por PORTC
	    BCF	    STATUS,RP0
	    CLRF    PORTC	    ; Limpiamos PORTC
SCAN
	    CLRF    KEYNUM	    ; contador a cero
	    MOVLW   b'00001110'	    ; valor para primera fila
	    MOVWF   AUX_FILE	    ; RowSelector
SCAN_NEXT
	    MOVF    AUX_FILE,W	    
	    MOVWF   PORTB	
	    BTFSS   PORTB,RB4	    ; pregunta si la columna 1 es 0
	    GOTO    SR_KEY
	    INCF    KEYNUM,F
	    BTFSS   PORTB,RB5	    ; pregunta si la columna 2 es 0
	    GOTO    SR_KEY
	    INCF    KEYNUM,F
	    BTFSS   PORTB,RB6	    ; pregunta si la columna 3 es 0
	    GOTO    SR_KEY
	    INCF    KEYNUM,F
	    BTFSS   PORTB,RB7	    ; pregunta si la columna 4 es 0
	    GOTO    SR_KEY
	    BSF	    STATUS,C	    ; ninguna columna es 0
	    RLF	    AUX_FILE,F	    ; corro el bit 0 a la pr?xima fila
	    INCF    KEYNUM,F	    ; incremento el contador
	    MOVLW   .16		
	    SUBWF   KEYNUM,W	    ; averig?o si ya testeo las 16 teclas
	    BTFSS   STATUS,Z			
	    GOTO    SCAN_NEXT	    ; no lleg? a 16, busca pr?xima fila
	    GOTO    SCAN	    ; si lleg? a 16, reinicio desde la primera tecla
SR_KEY
	    CALL    DELAY			
;************************************************************
;		Rutina de servicio al teclado
;		....
	    MOVF    KEYNUM,W
	    MOVWF   PORTC     ; se muestra por PORTC el valor de la tecla presionada
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
;NOTA: La subrutina DELAY est? puesta a modo de ejemplo. Puede necesitar m?s 
;      bucles anidados seg?n el clock para conseguir el tiempo estipulado     