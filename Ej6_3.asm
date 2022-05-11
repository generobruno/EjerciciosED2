; Ejercicio 6.3
; Según el esquema que se muestra y utilizando técnicas de multiplexado de
; display desarrolle un programa que muestre ´000005´al iniciarse el programa. El
; número 5 se desplazará hacia la izquierda una posición cada 1 minuto y su lugar
; será reemplazado por 0 (´000050´, ´000500´, etc.). Al llegar a ´500000´se
; repetirá la rutina indefinidamente.

	LIST P=16F887
	include <p16f887.inc>
__CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
	
    TIEMPO EQU 0x21

	ORG 0x0
	GOTO MAIN
	ORG 0x05
    
MAIN
    BANKSEL	TRISA		    ; PORTA y PORTC todos salida
    CLRF	TRISA
    CLRF	TRISC	    
    BANKSEL	ANSEL		    ; PORTA y PORTC todos I/O digital
    CLRF	ANSEL
    CLRF	ANSELH
    BCF		STATUS,RP0
    BCF		STATUS,RP1	    ; vuelvo al banco 0
    MOVLW	0x31
    MOVWF	T1CON		    ; Configuro el Timer1
    MOVLW	.116
    MOVWF	TIEMPO		    ; Cargo el aux del tiempo
TODOS_DIG  
    MOVLW	B'11111110'
    MOVWF	PORTC		    ; habilita digito a mostrar
OTRO_DIG    
    MOVLW	0x12		    ; 5 en 7 segmentos
    MOVWF	PORTA		    ; escribe digito en 7 segmento
    CALL	RETARDO		    ; lo mantiene encendido un tiempo
    BSF		STATUS,C	    ; carry en 1 para poder rotar, asi se pone en 1 lo que estaba en 0.
    RLF		PORTC,F		    ; desplaza el 0 al proximo digito
    BTFSC	PORTC,6		    ; ya mostro los 6 displays?
    GOTO	OTRO_DIG	    ; no mostro todo, va al proximo digito
    GOTO	TODOS_DIG	    ; ya mostro los 6 digitos vuelve a refrescar
    	    
RETARDO
VUELTA
    BANKSEL	PIR1
    BCF		PIR1,TMR1F	    ; Limpio el flag de TMR1
    BTFSS	PIR1,TMR1F	
    GOTO	$-1		    ; Loop hasta que TMR1F sea 1
    DECFSZ	TIEMPO		    ; Decremento el aux de tiempo
    GOTO	VUELTA		    ; Si no es 0, vuelvo a temporizar
    RETURN			    ; Si es 0, vuelvo al MAIN
    

    END
