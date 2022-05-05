; Ejercicio 5.7
; Utilizando interrupciones por RB0, muestre mediante un display de 7 segmentos
; el número de veces que sucedió un flanco descendente.
; Se pide:
;   a. El programa en assembler del programa principal y de la rutina de interrupción
; con resistencia de pull-up interna.
;   b. El circuito completo considerando que el display es cátodo común y cada
; display consume 20 mA.
;   c. El circuito completo considerando ahora que el display es ánodo común.
;   d. Si cada display consume 50 mA, ¿Cómo quedarían los circuitos para los casos b
; y c?
; ESTE CODIGO ESTA HECHO USANDO PORTB (MENOS RBO) COMO SALIDA EN LUGAR DEL PORTD
    
   LIST P=16F887
   #INCLUDE "p16F887.inc"
; CONFIG1
; __config 0x3FF4
 __CONFIG _CONFIG1, _FOSC_INTRC_NOCLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
        CBLOCK	0x20
	CONTA
	ENDC
	CBLOCK	0x70
	STATUS_TEMP
	W_TEMP
	ENDC
		
	ORG	0x00
	GOTO	INICIO
	ORG	0x04
	GOTO    INTER
	ORG	0x05
INICIO	;Se configura puerto
	BANKSEL ANSELH
	CLRF	ANSELH
	BANKSEL	TRISB
	CLRF	TRISB
	BSF	TRISB,RB0
	MOVLW	B'00111111'
	ANDWF	OPTION_REG,F	   ; Esto es para solo modificar los bits que me interesan???
	MOVLW	B'00000001'
	MOVWF	WPUB	
	;Se configura interrupci?n por RB0
	BCF	INTCON,INTF
	BSF	INTCON,INTE
	BSF	INTCON,GIE
	BANKSEL	PORTB	
	CLRF	CONTA		; Cuenta de 0 a 9
	MOVF	CONTA,W
	CALL	CONV_7SEG
	MOVWF	PORTB
	GOTO	$

INTER   ;Se guarda contexto    
        MOVWF   W_TEMP      
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP
	;Consulta de la fuente a la interrupci?n
	; - 
	;Rutina de servicio a la interrupci?n (ISR)
	INCF	CONTA,F	    ; Se incrementa el contador
	MOVLW	.10
	SUBWF	CONTA,W	    ; Pero al contador se le restan 10
	BTFSC	STATUS,Z    ; Si se supero el valor de 9 -> la resta da 0
	CLRF	CONTA	    ; y se reinicia el contador
	MOVF	CONTA,W	    ; En el otro caso: Se manda el valor de CONTA a W
	CALL	CONV_7SEG   ; y luego se llama a la tabla
	MOVWF	PORTB	    ; sacando el valor de retorno por el PORTB (DEBERIA SER PORTD EN EL EJ ORIGINAL)
	
SALIR	;Se recupera contexto
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS	     
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W
	BCF	INTCON,INTF
	RETFIE	

CONV_7SEG		;REVISAR: ESTE CODIGO ESTA HECHO USANDO COMO SALIDA PORTB (MENOS RB0)
	ADDWF	PCL,F
	RETLW	0X7E
	RETLW	0X0C
	RETLW	0XB6
	RETLW	0X9E
	RETLW	0XCC
	RETLW	0XDA
	RETLW	0XFA
	RETLW	0X0E
	RETLW	0XFE
	RETLW	0XCE
	
	END	