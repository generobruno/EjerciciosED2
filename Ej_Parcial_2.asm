#include <p16f887.inc>
    
TOTAL EQU 0xFA;TODOS ESTOS REGISTROS ESTAN ESPEJADOS
CONT8 EQU 0xFB
CONT EQU 0xFC
AUX EQU 0xFD
NUM EQU 0x11A;PARA PROBAR
NUM1 EQU 0x11C;PARA PROBAR
ORG 0X00
GOTO MAIN
    
ORG 0X05
MAIN
    ;;;;;;;;;CARGO ALGUNOS DATOS PARA PROBAR;;;;
    BSF STATUS,6
    MOVLW 0x26
    MOVWF NUM
    MOVLW 0x26
    MOVWF NUM1
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    BSF STATUS,IRP; ME SITUO EN EL BANK 2-3 PARA DIREC. INDIRECTO
    MOVLW .25
    MOVWF CONT;INICIALIZO EL CONTADOR
    MOVLW 0x1A;NO PONGO 11A PORQUE YA ESTOY EN EL BANK2-3
    MOVWF FSR;CARGO LA DIRECCION INICIAL
   
LECTURA	MOVF INDF,W;CARGO EL DATO A UN AUXILIAR
	MOVWF AUX
	MOVLW .8
	MOVWF CONT8;INICIO/REINICIO EL CONTADOR PARA LA ROTACION
	CALL CONTAR
	INCF FSR,F;SALTO A LA SIGUIENTE POSCICION
	DECFSZ CONT,F
	GOTO LECTURA
	SLEEP
	
CONTAR	RLF AUX,F
	BTFSC STATUS,0;ME FIJO SI AL ROTAR A LA IZQ TENGO ALGUN UNO DEL REGISTRO
	INCF TOTAL,F
	DECFSZ CONT8;ES UN CONTADOR DE 8 PORQUE EL LARGO ES DE 1 BYTE
	GOTO CONTAR
	RETURN

END