; Ejercicio 4.3
; Escribir un programa que cuente el número de veces que se pulsó la tecla
; conectada al terminal RA4 y que saque ese valor en binario natural por el Puerto
; B. Sólo se utilizarán los bits RB0 a RB3 que son los que tienen conectados diodos
; LED para su observación. Como consecuencia, el contador es de 4 bits: de 0 a 15.

    List p=16f887
    #include "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    

AUX EQU 0X20
T1  EQU 0X21
 
		
	ORG	0x0
	GOTO	MAIN
	ORG	0x05
MAIN	
	BSF	STATUS,RP0
	BSF	STATUS,RP1
	CLRF	ANSEL
	CLRF	ANSELH
	BCF	STATUS,RP1	
	MOVLW	0xF0
	MOVWF	TRISB
	BCF	STATUS,RP0
	CLRF	PORTB
L1	MOVF	PORTA,W  ; ----
	MOVWF	AUX      ;     |
	CALL	RETARDO  ;     |
	BTFSC	PORTA,RA4;     |
	GOTO	L1       ;      ------
	BTFSS	AUX,4
	GOTO	L1
	CALL	CONTAR
	GOTO	L1

CONTAR
	INCF	PORTB,F
	MOVLW	0x0F
	ANDWF	PORTB,F
	RETURN
	
RETARDO	MOVLW	.250  ; 50-100 mseg.
	MOVWF	T1
B1	DECFSZ	T1,F
	GOTO	B1
	RETURN
	
	END
	
    List p=16f887
    #include "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    

AUX EQU 0X20
T1  EQU 0X21
 
		
	ORG	0x0
	GOTO	MAIN
	ORG	0x05
MAIN	
	BSF	STATUS,RP0
	BSF	STATUS,RP1
	CLRF	ANSEL
	CLRF	ANSELH
	BCF	STATUS,RP1	
	MOVLW	0xF0
	MOVWF	TRISB
	BCF	STATUS,RP0
	CLRF	PORTB
L1	MOVF	PORTA,W  ; ----
	MOVWF	AUX      ;     |
	CALL	RETARDO  ;     |
	BTFSC	PORTA,RA4;     |
	GOTO	L1       ;      ------
	BTFSS	AUX,4
	GOTO	L1
	CALL	CONTAR
	GOTO	L1

CONTAR
	INCF	PORTB,F
	MOVLW	0x0F
	ANDWF	PORTB,F
	RETURN
	
RETARDO	MOVLW	.250  ; 50-100 mseg.
	MOVWF	T1
B1	DECFSZ	T1,F
	GOTO	B1
	RETURN
	
	END
