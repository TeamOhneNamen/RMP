// Thorben Schomacker
#include <stdio.h>
#include <math.h>
#include <string.h>

// Berechnet Anzahl der Stellen der Zahl die uebergeben wurde

char *pMeineStrings[] = {
    "Haller       25 EUR",
    "Kandinsky    13 EUR",
    "Brombach      5 EUR",
    "Zaluskowski 120 EUR",
    "Osman        17 EUR",
    ""      };

int bestimmeAnzahlStellen(int zahl){
	int teiler = 1;
	int zaehler = 0;
	while (1){
		if (teiler < zahl){
			teiler = teiler * 10;
			zaehler++;
		}
		else{
			return zaehler;
		}
	}

}

int main(){
	int zahl = 0;
	char* ausgabe[] = { "null", "eins", "zwei", "drei", "vier", "fuenf", "sechs", "sieben", "acht", "neun"};
	// Benutzereingabe abfragen
	printf("Bitte Zahl eingeben:\t");
	scanf("%d",&zahl);
	int stellen = bestimmeAnzahlStellen(zahl);
	// Groeßte 10er Potenz die als Teiler infrage kommt berechnen
	int teiler = round(pow(10, (stellen-1)));

	// Ausgabe der Ziffern in Worten
	int i = 0;
	for (i = 0; i < stellen; i++){
		// Ziffer berechnen
		int ziffer = zahl/teiler;
		// Berechnete Ziffer als Text ausgeben
		printf("%s\t",ausgabe[ziffer]);
		// Zahl um ausgegebene Ziffer verkleinern
		//zahl = zahl-(ziffer*teiler);
		zahl = zahl % teiler;
		// naechst klineren 10er-Potenz Teiler berechnen
		teiler = teiler /10;
	}


	}
