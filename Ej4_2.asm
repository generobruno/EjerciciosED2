; Ejercicio 4_2 
; Escribir un programa que lea de dos pulsadores, conectados a RA4 y RB0, el estado
; lógico y lo muestre en dos de los LEDs, RB2 y RB3. La configuración es como se muestra
; en el esquema.
; Adicionalmente indique los valores de las resistencias colocadas en cada puerto.

    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

ORG	0x00
	GOTO	INICIO
	ORG	0x05
INICIO	
	BSF	    STATUS,RP0	
	BSF	    STATUS,RP1	    ; Apuntamos al Banco 3 para ir a ANSELH
	BCF	    ANSELH,ANS12    ; RB0->ANS12--> Configuramos como DIGITAL
	BCF	    STATUS,RP1	    ; Ahora vamos al Banco 1 para ir a TRISB
	BCF	    TRISB,RB2	    ; Configuramos RB2 como OUTPUT
	BCF	    TRISB,RB3	    ; Configuramos RB3 como OUTPUT
	BSF	    TRISA,RA4	    ; Configuramos RB4 como INPUT
	BCF	    STATUS,RP0	    ; Ahora vamos al Banco 0 para PORTB
L1	
	BTFSS	    PORTB,RB0	    ; If RB0 == 0:
	BCF	    PORTB,RB3	    ; RB3 = 0, else:
	BTFSC	    PORTB,RB0	    ; If RB0 == 1:
	BSF	    PORTB,RB3	    ; RB3 = 1
	BTFSS	    PORTA,RA4	    ; If RA4 == 0:
	BCF	    PORTB,RB2	    ; RB2 = 0, else:
	BTFSC	    PORTA,RA4	    ; If RA4 == 1:
	BSF	    PORTB,RB2	    ; RB2 = 1.
	
	GOTO	    L1		    ; Vuelve a empezar el loop

	END
    