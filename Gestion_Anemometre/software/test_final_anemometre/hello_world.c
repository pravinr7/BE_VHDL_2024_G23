#include "sys/alt_stdio.h"
#include <stdio.h>
#include "math.h"
#include "system.h"
#include "altera_avalon_pio_regs.h" // pour éviter de renseigner les adresses physiques des périphériques
#include "unistd.h" 				// pour la fonction délai

#define ANEM_BASE (ANEMOMETER_BASE) // Remplace par l'adresse de base de ton périphérique

// Adresses des registres à l'intérieur de ton périphérique
#define ANEM_CONFIG_REG (unsigned int *)(AVALON_MESURE_FREQ_0_BASE)  // Registre de configuration (Start/Stop, Continu, Raz_n)
#define ANEM_CODE_REG (unsigned int *)(AVALON_MESURE_FREQ_0_BASE + 4)    // Registre contenant les données (Valid, Data_anemometre)
void start_anemometer() {
    // Configuration : Start=0, Continu=1, Raz_n=1 (b2=1, b1=0, b0=1)
    *ANEM_CONFIG_REG = 0x03;
}

void stop_anemometer() {
    // Stop the anemometer (b2=0 pour arrêter)
    IOWR(ANEM_CONFIG_REG, 0, 0b001);  // Continuer avec raz_n=1, mais stop
}

/*void read_anemometer_data() {
    // Lire le registre de données
	unsigned int code_data = (*ANEM_CODE_REG & 0xFF);
	//unsigned int data_valid = *ANEM_CODE_REG & 0b1000000000;

    // Vérifier si les données sont valides (b9 == 1)
    //if ((data_valid ) == 1) {  // bit 9 = 0 signifie que les données ne sont pas valides
        //printf("Données  valides\n");
        printf("Vitesse du vent = %u Km/Hr\n", code_data);
        printf("**********************\n");



    	//printf("Données  non valides\n");
    }
*/
void read_anemometer_data()
{

	// Lire le registre de données
		unsigned int code_data = *ANEM_CODE_REG & 0xFF;
		//unsigned int data_valid = *ANEM_CODE_REG & 0b1000000000;

	    // Vérifier si les données sont valides (b9 == 1)
	    //if ((data_valid ) == 1) {  // bit 9 = 0 signifie que les données ne sont pas valides
	        //printf("Données  valides\n");


	        printf("frequence = %u Km/h\n", code_data);
	        printf("**********RAFRAICHISSEMENT**********\n");
	}




int main() {
    printf("Initialisation de l'anémomètre...\n");

    // Démarrer l'anémomètre
    start_anemometer();
    unsigned int i =0;

    while (1) {
        // Lire la fréquence calculée toutes les 1 seconde
    	printf("MESURE %d\n",i);
    	i++;
    	read_anemometer_data();
        usleep(1000000);  // Pause d'une seconde (1 000 000 microsecondes)
    }
    return 0;
}
