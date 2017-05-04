;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Alfred Lohmann
;* Author             : Tobias Jaehnichen	
;* Version            : V2.0
;* Date               : 23.04.2017
;* Description        : This is a simple main.
;					  : The output is send to UART 1. Open Serial Window when 
;					  : when debugging. Select UART #1 in Serial Window selection.
;					  :
;					  : Replace this main with yours.
;
;*******************************************************************************

	EXTERN Init_TI_Board		; Initialize the serial line
	EXTERN ADC3_CH7_DMA_Config  ; Initialize the ADC
	;EXTERN	initHW				; Init Timer
	EXTERN	puts				; C output function
	EXTERN	TFT_puts			; TFT output function
	EXTERN  TFT_cls				; TFT clear function
	EXTERN  TFT_gotoxy      	; TFT goto x y function  
	EXTERN  Delay				; Delay (ms) function
	EXTERN GPIO_G_SET			; Set output-LEDs
	EXTERN GPIO_G_CLR			; Clear output-LEDs
	EXTERN GPIO_G_PIN			; Output-LEDs status
	EXTERN GPIO_E_PIN			; Button status
	EXTERN ADC3_DR				; ADC Value (ADC3_CH7_DMA_Config has to be called before)

;********************************************
; Data section, aligned on 16-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 4
	
DataList	DCD 35, -1, 13, 1773, 0x80000000,-4096, 511, 0x7fffffff, 511, 512, 0, 101, -3, -5, 0, 65
DataListEnd	DCD 0
	
	GLOBAL DataList
	GLOBAL DataListEnd
		
;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
	
main	PROC

;RMPP_2 

		mov r6,#1 ;Register für "getauscht?"
		ldr r7,=DataListEnd-4 ;Adresse von unserem Listenende.
		
while_1 cmp r6,#0 ;Testen ob beim Durchgang getauscht wurde.
		beq forever ;Falls nicht getauscht wurde, springe zum ende.
		mov R6,#0 ;"getauscht?" mit 0 updaten
		ldr r5,=DataList ;Speichere die Startadresse von DataList in r5.

while_2 cmp r5,r7 ;Überprüfen ob wir am ende der Liste sind.
		bhs while_1 ;Falls wir am Ende sind, springe zu while_1.
		ldr r1,[r5],#4 ;Lade in r1 die erste Zahl, danach post index update.
		ldr r2,[r5] ;Lade in r2 die zweite Zahl.
		cmp r1,r2 ;Vergleiche Zahl1 mit Zahl2s.
		ble while_2
		
		;Tauschen
do_1	str r1,[r5] ;Zahl 1 an Speicheradresse von Zahl 2 Speichern.
		str r2,[r5, #-4] ;Zahl 2 an Speicheradresse von Zahl 1 Speichern.
		add r6,#1 ;"Getauscht?" um 1 erhöhen.
		b while_2 ;Wieder zu while_2 springen.
		
forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END