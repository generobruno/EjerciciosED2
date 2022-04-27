; Ejercicio 3.13
; Redactar un programa que multiplique por 4 todos los números contenidos en los
; Registros que van de 50H a 5FH (ambos inclusive). Estos números tienen su
; nibble superior en 0 y el inferior contiene un número binario natural. El resultado
; se guarda en el mismo lugar.

    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
CONTA   EQU	0x20

    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
	MOVLW   .16
	MOVWF   CONTA
	BCF	STATUS,IRP
	MOVLW   0x50		;Posicion Inicial
	MOVWF   FSR
	BCF     STATUS,C	;Reseteamos el flag C, ya que se usa para RLF
MULT	
	RLF     INDF,F		;Rotamos 1 vez --> mult. por 2
	RLF	INDF,F		;Rotamos 2 veces --> mult. por 4
	INCF    FSR,F
	DECFSZ  CONTA,F
	GOTO    MULT
	
	GOTO	$
	
	END
    