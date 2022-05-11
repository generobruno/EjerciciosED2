; Ejercicio 5.4
; Escribir un código en assembler que realice una interrupción por RB cuando se
; realice un cambio de nivel en cualquiera de los puertos RB4 a RB7. En el servicio
; a la interrupción (ISR) generar un retardo de 100 mseg. Recuerde que estas
; interrupciones por nivel y debe implementar un sistema antirebote. Suponer un
; reloj de 4 Mhz.
    
    LIST P=16F887
    #INCLUDE "p16F887.inc"
   
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
 
    CBLOCK  0x20
    CONT2
    ENDC
    CBLOCK  0x70
    STATUS_TEMP
    W_TEMP
    ENDC
 
    ORG 0x00
    GOTO MAIN
    ORG 0x04
    GOTO INTER
    ORG 0x05
    
MAIN
    BANKSEL	TRISB
    MOVLW	0xF0
    MOVWF	TRISB	    ;RB4 a RB7 como entrada
    BANKSEL	ANSELH	    
    MOVLW	0x28
    MOVWF	ANSELH	    ;RB4 a RB7 como digital I/O
    BANKSEL	WPUB
    BSF		OPTION_REG,7
    MOVLW	0xF0
    MOVWF	WPUB	    ;Pull-up resistors para RB4 a RB7
    BSF		INTCON,GIE  ;Habilitamos interrupciones
    BSF		INTCON,RBIE ;Habilitamos interrupciones por cambio en PORTB
    MOVLW	0xF0	    
    MOVWF	IOCB	    ;Int por cambio de nivel de RB4 a RB7
    BCF		INTCON,RBIF ;Limpiamos bandera de PORTB
    BCF		INTCON,T0IF ; Limpio el flag de TMR0
    
    GOTO	$
    
INTER
    ; Guardamos Contexto
    MOVWF   W_TEMP
    SWAPF   STATUS,W
    MOVWF   STATUS_TEMP
    ; Servicio de interrupcion
    MOVLW   .20
    MOVWF   CONT2	; Cargo el contador
VUELTA
    BCF	    INTCON,T0IF	; Limpio el flag de TMR0
    MOVLW   .61
    MOVWF   TMR0	; Cargo TMR0 con el valor calculado
    BTFSS   INTCON,T0IF
    GOTO    $-1		; Voy chequeando el flag T0IF hasta que sea 1
    DECFSZ  CONT2	; Decremento el contador
    GOTO    VUELTA	; Si no es 0 -> Sigo temporizando
    GOTO    INTEREND	; Si es 0 -> Termine de temporizar
INTEREND
    ; Recuperamos Contexto
    SWAPF   STATUS_TEMP,W
    MOVWF   STATUS
    SWAPF   W_TEMP,F
    SWAPF   W_TEMP,W
    ; Limpio Flags
    BCF	    INTCON,RBIF	
    ; Retorno
    RETFIE
    
    
    END
    
    
    