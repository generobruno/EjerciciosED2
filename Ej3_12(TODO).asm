; Ejercicio 3.12
; Realizar un programa en Lenguaje Ensamblador que transforme 10 Bytes que
; contienen números BCD empaquetados a ASCII. Los números BCD están
; almacenados empezando en el Registro A0H (BANK 1) y el resultado se almacenará a partir
; del Registro 1A0H(BANK 3).

    LIST p=16f887
    #INCLUDE <p16f887.inc>
    
    ;Etiquetas
    
	ORG	0x00   
	GOTO	MAIN
	ORG	0x05
	
MAIN
	