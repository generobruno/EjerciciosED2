;********************************************************************************
;*
;* Programa que enciende en forma din?mica un conjunto de seis displays 7 segmentos
;* y muestra los d?gitos de un buffer de 6 elementos en BCD no empaquetado.
;*
;*********************************************************************************
	    LIST P=16F887
	    include <p16f887.inc>
    __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _MCLRE_ON & _LVP_OFF
TIEMPO EQU 0x21
DIGI1 EQU 0x30

	    ORG 0x0
	    GOTO INICIO
	    ORG 0x05
INICIO
	    BSF STATUS,RP0
	    CLRF TRISA		; pins Puertos A y B todos salida
	    CLRF TRISB
	    BSF STATUS,RP1
	    CLRF ANSEL
	    CLRF ANSELH
	    BCF STATUS,RP0
	    BCF STATUS,RP1	; vuelvo al banco 0
TODOS_DIG   MOVLW DIGI1
	    MOVWF FSR		; apunta al primer d?gito a mostrar
	    MOVLW B'11111110'
	    MOVWF PORTA		; habilita d?gito a mostrar
OTRO_DIG    MOVF INDF,W		; lee dato hexadecimal a mostrar
	    CALL CONV_7SEG	; llama a subrutina convierte a 7 segmentos
	    MOVWF PORTB		; escribe d?gito en 7 segmento
	    CALL RETARDO	; lo mantiene encendido un tiempo
	    BSF STATUS,C	; carry en 1 para poder rotar, asi se pone en 1 lo que estaba en 0.
	    RLF PORTA,F		; desplaza el 0 al pr?ximo d?gito
	    INCF FSR,F		; apunta al pr?ximo dato a mostrar
	    BTFSC PORTA,6	; ya mostr? los 6 d?gitos?
	    GOTO OTRO_DIG	; no mostr? todo, va al pr?ximo d?gito
	    GOTO TODOS_DIG	; ya mostr? los 6 d?gitos vuelve a refrescar
	    
CONV_7SEG   ADDWF PCL,F		; suma a PC el valor del d?gito
	    RETLW 0x40		; obtiene el valor 7 segmentos del 0
	    RETLW 0x79		; obtiene el valor 7 segmentos del 1
	    RETLW 0x24		; obtiene el valor 7 segmentos del 2
	    RETLW 0x30		; obtiene el valor 7 segmentos del 3
	    RETLW 0x19		; obtiene el valor 7 segmentos del 4
	    RETLW 0x12		; obtiene el valor 7 segmentos del 5
	    RETLW 0x02		; obtiene el valor 7 segmentos del 6
	    RETLW 0x78		; obtiene el valor 7 segmentos del 7
	    RETLW 0x00		; obtiene el valor 7 segmentos del 8
	    RETLW 0x18		; obtiene el valor 7 segmentos del 9
	    RETLW 0x08		; obtiene el valor 7 segmentos del A
	    RETLW 0x03		; obtiene el valor 7 segmentos del B
	    RETLW 0x06		; obtiene el valor 7 segmentos del C
	    RETLW 0x21		; obtiene el valor 7 segmentos del D
	    RETLW 0x06		; obtiene el valor 7 segmentos del E
	    RETLW 0x0E		; obtiene el valor 7 segmentos del F
	    
RETARDO
	    MOVLW 0x00
	    MOVWF TIEMPO
	    DECFSZ TIEMPO
	    GOTO $-1
	    RETURN
	    END
;NOTA: La subrutina RETARDO est? puesta a modo de ejemplo. Puede necesitar m?s bucles anidados seg?n el clock