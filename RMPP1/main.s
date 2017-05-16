;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Alfred Lohmann
;* Version            : V1.0
;* Date               : 15.07.2012
;* Description        : This is a simple main.
;					  : The output is send to UART 1. Open Serial Window when 
;					  : when debugging. Select UART #1 in Serial Window selection.
;					  :
;					  : Replace this main with yours.
;
;*******************************************************************************

	IMPORT 	Init_TI_Board		; Initialize the serial line
	;IMPORT	initHW				; Init Timer
	IMPORT	puts				; C output function
	IMPORT	TFT_puts			; TFT output function
	

;********************************************
; Data section, aligned on 4-byte boundery
;********************************************
	GLOBAL MyData
	GLOBAL MeinNumFeld	
	GLOBAL MeinHaWoFeld	
	GLOBAL MeinTextFeld	
	GLOBAL MeinByteFeld	
	GLOBAL MeinBlock	
		
	AREA MyData, DATA, align = 4	
		
MeinNumFeld 	DCD 0x33, 2_01111110, -57, 66, 0x70000000, 0x80000000
MeinHaWoFeld 	DCW 0x1234, 0x5678, 0x9abc, 0xdef0
MeinTextFeld 	DCB "ABab0123",0 
	ALIGN 4 
MeinByteFeld 	DCB 0xef, 0xdc, 0xba, 0x98

	ALIGN 4 
MeinBlock 		SPACE 0x20 
	
text	DCB	"Hallo TI-Labor.\n\r",0



;********************************************
; Code section, aligned on 8-byte boundery
;********************************************

	AREA |.text|, CODE, READONLY, ALIGN = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
	EXPORT main [CODE]
	
main	PROC
		
		mov r0,#0x21		; Anw-01
		mov r1,#-4			; Anw-02
		ldr r2,=0xfe543210 	; Anw-03
		ldr r2,[PC, #0x54]
		ldr r0, =MeinByteFeld ; Anw-04
		ldrb r1, [r0] ; Anw-05 mit r0-Inhalt aus Anw-04
		ldrh r2, [r0] ; Anw-06
		ldr r3, [r0] ; Anw-07
		ldr r4, =MeinHaWoFeld ; Anw-08 Startadresse laden
		ldr r5, [r4] ; Anw-09
		ldr r6, [r4, #4] ; Anw-10
		
		ldr r0, =0x123456ab ; Anw-11
		ldr r1, =MeinBlock ; Anw-12
		str r0, [r1] ; Anw-13
		str r0, [r1, #4] ; Anw-14
		mov r2, #0x1a ; Anw-15
		strb r2, [r1, #9] ; Anw-16
		strb r2, [r1, #10] ; Anw-17
		
		ldr r0,=MeinNumFeld ; Anw-18
		ldr r1, [r0] ; Anw-19
		ldr r2, [r0, #4] ; Anw-20
		adds r3, r1, r2 ; Anw-21
		
		ldr r0,=MeinNumFeld+8 ; Anw-22
		ldr r1, [r0] ; Anw-23
		ldr r2, [r0, #4] ; Anw-24
		adds r3, r1, r2 ; Anw-25
		
		ldr r0,=MeinNumFeld+16 ; Anw-26
		ldr r1, [r0] ; Anw-27
		ldr r2, [r0, #4] ; Anw-28
		adds r3, r1, r2 ; Anw-29
		
		ldr r0,=MeinTextFeld ; Anw-30
		ldrb r1, [r0, #1]! ; Anw-31
		ldrb r1, [r0, #1]! ; Anw-32
		
		ldr r0,=MeinHaWoFeld ; Anw-33
		ldr r2, [r0], #4 ; Anw-34
		ldr r2, [r0], #4 ; Anw-35
		
		
		
		BL	Init_TI_Board	; Initialize the serial line to TTY
							; for compatability to out TI-C-Board
		;BL	initHW			; Timer init
		
		LDR	r0,=text
		BL	puts			; call C output method
		
		LDR r0,=text
		BL	TFT_puts		; call TFT output method
				
forever	b	forever		; nowhere to retun if main ends		
		ENDP
	
		ALIGN
       
		END