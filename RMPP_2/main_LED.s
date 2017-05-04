;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Alfred Lohmann
;* Author             : Tobias Jaehnichen	
;* Version            : V2.0
;* Date               : 13.04.2017
;* Description        : This is a simple main. 
;					  : It reads the ADC value and displays the most significant 8 bits
;					  : on the LEDs D13 to D20.
;					  : 
;					  : Change this main according to the lab-task.
;
;*******************************************************************************

	EXTERN Init_TI_Board		; Initialize the serial line
	EXTERN ADC3_CH7_DMA_Config  ; Initialize the ADC
	;EXTERN	initHW				; Init Timer
	;EXTERN	puts				; C output function
	;EXTERN TFT_puts			; TFT output function
	;EXTERN TFT_cls				; TFT clear function
	;EXTERN TFT_gotoxy      	; TFT goto x y function  
	EXTERN Delay				; Delay (ms) function
	EXTERN GPIO_G_SET			; Set output-LEDs
	EXTERN GPIO_G_CLR			; Clear output-LEDs
	;EXTERN GPIO_G_PIN			; Output-LEDs status
	;EXTERN GPIO_E_PIN			; Button status
	EXTERN ADC3_DR				; ADC Value (ADC3_CH7_DMA_Config has to be called before)

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	
	AREA MyData, DATA, align = 2
		
;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 2

; RN: Direktive, um Registern ‘Namen’ zu geben 
adc_wert   			RN   7			; Wert!!!
adc_dr	    		RN	 8			; Adresse!!	
gpio_set   			RN   9
gpio_clr   			RN   10

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
		
main	PROC

		BL	Init_TI_Board	; Initialize the serial line to TTY
							; for compatability to out TI-C-Board
		BL 	ADC3_CH7_DMA_Config ;Initialize and config ADC3.7
							
		;	I/O-Adressen in Registern speichern
		LDR     adc_dr, 	=ADC3_DR        	; Adresse des ADC
		LDR     gpio_clr, 	=GPIO_G_CLR			; I/O löschen
		LDR     gpio_set, 	=GPIO_G_SET			; I/O setzen

messschleife
		MOVS 	r5,#15 							;Schleifenzähler		
		MOV		r4,#0							;Speicher für ADC-Werte.

;Schleife

for_1	BMI 	ausgabe 						; Springe aus der Schleife zur Ausgabe. 
		LDR 	adc_wert, [adc_dr]				; Messwert lesen aus dem Speicher lesen(12 Bit).
		ADD 	r4, adc_wert					; Addieren den gelesenen Wert zu r4.
		SUBS	r5,#1							; Schleife zählt hoch.
		B 		for_1
		
ausgabe MOV		r4, r4, LSR #4					; Addierte Werte durch 16 teilen.
		MOV		r2, r4, LSR #8					; Die vorderen 4 bits von r4.
		MOV		r1, #1							; Setze r1 auf den Wert 1.
		MOV		r1, r1, LSL r2					; Ermitteln des Balkens.
		SUB		r1, #1
		
; LED Ausgabe
		MOV		r5, #0xffff
		STRH	r5, [gpio_clr]					; LEDs loeschen
		STRH	r1, [gpio_set]					; Ausgabe Bitmuster
		
		MOV		r0, #0x20
		BL		Delay
		
		B       messschleife
		
		
forever	B	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END