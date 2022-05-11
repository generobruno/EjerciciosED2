; Ejercicio 5.5
; Se desea que al apretar el pulsador conectado a RA4 parpadeen, a una frecuencia
; de 0.5Hz, los 8 LEDs conectados en cátodo común a los 8 terminales del puerto D
; de un microcontrolador PIC 16F887. Dicho parpadeo se debe interrumpir
; durante unos instantes (3 segundos) si se aprieta el pulsador conectado al
; terminal RB0. Inicialmente, los LEDs están apagados. El oscilador es de 4MHz. 
 ; REVISAR Y HACER NUEVA VERSION
 
    LIST P=16F887
    #INCLUDE<P16F887.INC>    
 
; CONFIG1
; __CONFIG 0X2FD7
 __CONFIG _CONFIG1, _FOSC_EXTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __CONFIG 0X3FFF
__CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF
    
    T1 EQU 0X30
    T2 EQU 0X31
    T3 EQU 0X32
    AUX EQU 0X33
    WAUX EQU 0X34
    SAUX EQU 0X35
    AUXAUX EQU 0X36
    
    ORG 0X00
    GOTO SETTINGS
    ORG 0X04
    GOTO INTER
    ORG 0X05
    
SETTINGS
    BSF STATUS,RP0
    MOVLW 0X10
    ANDWF TRISA,1
    MOVLW 0X01
    ANDWF TRISB,1
    CLRF TRISD
    BSF INTCON,GIE
    BSF INTCON,INTE
    
    BSF STATUS,RP1
    CLRF ANSELH
    CLRF ANSEL
    
    BCF STATUS,RP0
    BCF STATUS,RP1
    CLRF PORTA
    CLRF PORTB
    CLRF PORTD
    
MAIN
    BTFSS PORTA,RA4
    GOTO MAIN
    GOTO INFINITO
    
INFINITO
    BCF STATUS,C
    MOVLW 0X01
    MOVWF AUX
GIRANDO
    MOVWF PORTD
    CALL DELAY
    CALL DELAY
    RLF AUX,1
    MOVF AUX,0
    BTFSS STATUS,C
    GOTO GIRANDO
    GOTO INFINITO
    
INTER
    BTFSS INTCON,INTF
    RETFIE
    ;RESGUARDO CONTEXTO
    MOVWF WAUX
    MOVF AUX,0
    MOVWF AUXAUX
    SWAPF STATUS,0
    MOVWF SAUX
    
    ;RUTINA
    MOVF AUXAUX,0
    MOVWF PORTD
    CALL DELAY
    CALL DELAY
    CALL DELAY
    
    ;REGRESO CONTEXTO
    BCF INTCON,INTF
    SWAPF SAUX,0
    MOVWF STATUS
    MOVF AUXAUX,0
    MOVWF AUX
    MOVF WAUX,0
    RETFIE
    
DELAY
    MOVLW D'6'
    MOVWF T1
    MOVLW D'243'
LOOP3
    MOVWF T2
LOOP2
    MOVWF T3
LOOP1
    DECFSZ T3,1
    GOTO LOOP1
    DECFSZ T2,1
    GOTO LOOP2
    DECFSZ T1,1
    GOTO LOOP3
    RETURN
    
    END