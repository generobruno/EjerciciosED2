; Ejercicio 3.9 pero con direccionamiento indirecto
    
    List p=16f887			;Dispositivo a utilizar 
    #include <p16f887.inc>		;Etiquetas
	
    ORG	    0x00
    GOTO    MAIN
    ORG	    0x05
    
MAIN	
    BCF	    STATUS,IRP	    ;Ponemos en 0 IRP para estar en el banco 0 (o 1)
    MOVLW   0x20	    ;En lugar de usar un AUX, ponemos esta dir en FSR
    MOVWF   FSR
    MOVLW   0x0F
    
    ANDWF   INDF,F	    ;En este caso hacemos el AND con
    
    GOTO	$
    END