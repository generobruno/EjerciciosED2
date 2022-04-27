; Ejercicio 4.5
; Se desea que al apretar el pulsador conectado a RA4 parpadeen, a una frecuencia
; de 0.5Hz, los 8 LEDs conectados en cátodo común a los 8 terminales del puerto D
; del PIC 16F887. Dicho parpadeo se debe interrumpir
; durante unos instantes (3 segundos) si se aprieta el pulsador conectado al
; terminal RB0. Inicialmente, los LEDs están apagados. El oscilador es de 4MHz. 
    
    LIST P=16F887
    #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
TIEMPO1 EQU	0X20 
TIEMPO2 EQU	0X21  
TIEMPO3 EQU	0X22
TIEMPO4 EQU	0X23 
TIEMPO5 EQU	0X24  
TIEMPO6 EQU	0X25 
 
	ORG	0x00
	GOTO	INICIO
	ORG	0x05
INICIO	
	BSF	    STATUS,RP0	
	BSF	    STATUS,RP1
	BCF	    ANSELH,ANS12
	BCF	    STATUS,RP1
	CLRF	    TRISD
	BCF	    STATUS,RP0
	CLRF	    PORTD
BUCLE	BTFSC	    PORTA,RA4
	GOTO	    BUCLE
	
LOOP4	MOVLW	    .10	    
	MOVWF	    TIEMPO1
LOOP3	MOVLW	    .255	    
	MOVWF	    TIEMPO2
	BTFSS	    PORTB,RB0
	CALL	    RETARDO3S
LOOP2	MOVLW	    .255	    
	MOVWF	    TIEMPO3
LOOP1	DECFSZ	    TIEMPO3,F
	GOTO	    LOOP1
	DECFSZ	    TIEMPO2,F
	GOTO	    LOOP2
	DECFSZ	    TIEMPO1
	GOTO	    LOOP3
	COMF	    PORTD	
    	GOTO	    LOOP4
	
RETARDO3S
	MOVLW	    .15	    
	MOVWF	    TIEMPO4
LOOP3B	MOVLW	    .255	    
	MOVWF	    TIEMPO5
LOOP2B	MOVLW	    .255	    
	MOVWF	    TIEMPO6
LOOP1B	DECFSZ	    TIEMPO6,F
	GOTO	    LOOP1B
	DECFSZ	    TIEMPO5,F
	GOTO	    LOOP2B
	DECFSZ	    TIEMPO4
	GOTO	    LOOP3B
	RETURN
	
	END