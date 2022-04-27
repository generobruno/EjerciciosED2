; Ejercicio 3.14
; El código Gray es un código binario en el que dos números consecutivos difieren
; solamente en un bit. Escribir un programa que convierta un conjunto de números
; de 4 bits en su equivalente en código Gray. Estos números tienen su nibble
; superior en 0 y el inferior contiene un número binario natural. Son 20 números
; ubicados a partir del Registro 120H. Utilizar tabla.

    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas

; Etiquetas propias del proyecto
 CONTADOR EQU 0x20
 CANTIDAD EQU .20
 AUX1	  EQU 0x21
 AUX2	  EQU 0x22  
 BUSCAR   EQU 0x23
	 
	  ORG	0x00            ;------------------------------------------------------
	  MOVLW  0x20
	  MOVWF  BUSCAR		;inicializa la cantidad de ciclos y desde donde buscar
	  MOVLW	 CANTIDAD
	  MOVWF	 CONTADOR
	  BSF	 STATUS,7	;------------------------------------------------------
BUCLE1	  
	  MOVF	 BUSCAR,0	;Muevo la posicion BUSCAR a W
	  MOVWF	 FSR		;Muevo W a FSR para apuntar a esa posicion
	  MOVF   INDF,0		;Se obtiene el dato de los registros y se lo manda a convertir, moviendo el contenido del reg a W
	  CALL	 PROCESAR
	  MOVWF	 INDF		;Vuelvo con el resultado en W y lo paso de W a INDF, asi queda guardado en el mismo lugar donde apuntaba
	  INCF	 BUSCAR		
	  DECFSZ CONTADOR
	  GOTO	 BUCLE1		;Modifico los contadores y vuelvo a empezar el loop
	  GOTO	 $              ;------------------------------------------------------
	  
	  
	  ORG   0x50
PROCESAR  
	  ADDWF	    PCL,1	;Como tengo el contenido en W, le sumo este a PCL y guardo el result devuelta en PCL
	  RETLW	    .0
	  RETLW	    .1
	  RETLW	    .3
	  RETLW	    .2
	  RETLW	    .6
	  RETLW	    .7
	  RETLW	    .5
	  RETLW	    .4
	  RETLW	    .12
	  RETLW	    .13
	  RETLW	    .15
	  RETLW	    .14
	  RETLW	    .10
	  RETLW	    .11
	  RETLW	    .9
	  RETLW	    .8
	 		;------------------------------------------------------


END