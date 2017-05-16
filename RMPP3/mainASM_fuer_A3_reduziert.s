;**************************************************************
;
; HAW Hamburg, Department Informatik
; Praktikum Rechnerstrukturen und Maschinennahe Programmierung
;
; Zweck:		Asm-Programm zu A3: 'Reaktionstester'
; Dateiname:	mainASM.s
; History:
;
; 5'2014  Cnz	Aufbereitung für Aufgabenstellung 
; 7'2013  Beh	Erstversion für Arm-Cortex M4
; 7'2005  Msl   Urfassung für Pentium (GEME-System)
;
;**************************************************************


		IMPORT	TFT_puts
		IMPORT  TFT_cls
		IMPORT  TFT_gotoxy
		IMPORT  Delay

;********************************************
; Data section, aligned on 4-byte boundary
;********************************************
	
	AREA MyData, DATA, align = 2
	
ADC3_DR         equ	     0x4001224C

PERIPH_BASE     equ      0x40000000
AHB1PERIPH_BASE equ      (PERIPH_BASE + 0x00020000)
	
;blaue LEDs: output
GPIOG_BASE      equ      (AHB1PERIPH_BASE + 0x1800)
GPIO_G_SET		equ      GPIOG_BASE + 0x18
GPIO_G_CLR		equ      GPIOG_BASE + 0x1A
GPIO_G_PIN		equ      GPIOG_BASE + 0x10

;rote LEDs / Taster: input
GPIOE_BASE      equ      (AHB1PERIPH_BASE + 0x1000)
GPIO_E_PIN      equ      GPIOE_BASE + 0x10

Start_Text  	DCB     "Zum Starten  - die S0 Taste druecken\0"
Achtung_Text	DCB		"Achtung !!!\0"
Stop_Text    	DCB     "Stopped\0"



;********************************************
; Code section, aligned on 4-byte boundary
;********************************************

	AREA MyCode, CODE, readonly, align = 3

;--------------------------------------------
; main subroutine
;--------------------------------------------
			GLOBAL mainASM
			
	
;---------------------------------------------------
;--- Testet ob die S0 Taste gedrueckt wurde
;--- in:  void
;--- out: R0 = 0  S0 Taste wurde nicht gedrueckt
;--- out: R0 = 1  S0 Taste wurde gedrueckt
;!!!! für Aufgabe 3 nach S7 ändern!!!!
;---------------------------------------------------
testIfPushButtonPressed

            push {     }			;gerade Anzahl von Registern!	           
			
			mov R0, #0x00			;default Wert
			ldr R3, =GPIO_E_PIN		;Tasten lesen
			ldr R4, [R3]
		 	and R4, #0x01			;S0 maskieren --> S7!
		    cmp						;S0 testen    --> S7!
			...						;Achtung: invertierte Logik:
			...						;Taster gedrückt -> Pin ist 0
			...						;achten Sie mal auf die zum Taster gehörende LED
			...
			pop {     }           
			bx   LR
	
	
;---------------------------------------------------
;--- Laesst die Anzahl LEDs leuchten, die in R0 steht  
;--- in:  R0 = Anzahl LEDs
;--- out: void
;---------------------------------------------------	
outputLEDBar
            push {      }			;gerade Anzahl von Registern!	
		  
			ldr  R3, =GPIO_G_CLR	;alle LEDs loeschen
			mov  R4, #0xffff
			strh R4, [R3]
			
			...						;LED Muster erzeugen
		    ...
		
		    ldr  R3, =GPIO_G_SET	;LEDs anzeigen
		    strh R4, [R3]
			
		    pop  {      }
			bx   LR
		
;---------------------------------------------------
;--- Ermittelt ob alle LEDs leuchten
;--- in:  void
;--- out: R0 = 0 Sie leuchten nicht alle
;--- out: R0 = 1 Sie leuchten alle
;---------------------------------------------------			
LEDBarEndReached
			push {      }		  ;gerade Anzahl von Registern!	
			
			mov R0, #0x01         ;default Wert
			ldr R3, =GPIO_G_PIN   ;LEDs lesen
			ldr R4, [R3]
			ldr R5, =0xffff
		 	and R4, R5            ;LEDs maskieren 
		    cmp 				  ;LEDs testen

			...
			...
			
			pop {      }
			bx   LR
			
;---------------------------------------------------
;--- Delay, ohne dass sich Register aendern
;--- in:  R0 = Millisekunden
;--- out: void
;---------------------------------------------------			
SafeDelay
			push {      }		  ;gerade Anzahl von Registern!

            bl    Delay

			pop  {      }
			bx    LR

;---------------------------------------------------
;--- TFT_cls, ohne dass sich Register aendern
;--- in:  void
;--- out: void
;---------------------------------------------------			
SafeTFT_cls
			push {      }		  ;gerade Anzahl von Registern!

            bl    TFT_cls

			pop  {      }
			bx    LR

;---------------------------------------------------
;--- TFT_gotoxy, ohne dass sich Register aendern
;--- in:  R0 = x-Koordinate
;--- in:  R1 = y-Koordinate
;--- out: void
;---------------------------------------------------			
SafeTFT_gotoxy
			push {      }		  ;gerade Anzahl von Registern!

            bl    TFT_gotoxy

			pop  {      }
			bx    LR

;---------------------------------------------------
;--- TFT_puts, ohne dass sich Register aendern
;--- in:  R0 = Stringadresse
;--- out: void
;---------------------------------------------------			
SafeTFT_puts
			push {      }		  ;gerade Anzahl von Registern!

            bl    TFT_puts

			pop  {      }
			bx    LR

;---------------------------------------------------
;--- Gibt Text auf dem Bildschirm aus
;--- in:  R0 = Adresse des Textes
;--- in:  R1 = x Koordinate (1..40)
;--- in:  R2 = y Koordinate (1..16) 
;--- out: void
;---------------------------------------------------	
SafeTFT
            push {      }		  			;gerade Anzahl von Registern!
			
			mov R4, R0						;Adresse des Strings sichern	
            bl  SafeTFT_cls					;TFT loeschen
			mov R0, R1						;Cursor positionieren
			mov R1, R2
			bl  SafeTFT_gotoxy
			mov R0, R4						;Text anzeigen
			bl	SafeTFT_puts
			
			pop  {      }
			bx    LR
			
			
;-------------------------------------------------------------------------------------------------	
mainASM		PROC
;Dies ist die Hauptaufgabe; nur 3 Codeschnipsel für die Anwendung der Bibliothek
			...
			...
								
			ldr R0, =Start_Text				;Starttext anzeigen
			mov R1, #2
			mov R2, #7
			bl	SafeTFT
			...
			...
			
			mov R0, #3000					;3s warten
			bl  SafeDelay
			
			
			
			mov  R0, #20					;20ms warten
			bl   SafeDelay
		    	

		
forever		b		forever			; nowhere to retun if main ends		

			ENDP
	
			ALIGN 4
			END
	
		