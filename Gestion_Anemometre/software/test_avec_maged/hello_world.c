#include "sys/alt_stdio.h"
#include "io.h"
#include "system.h"
#include "stdio.h"

//#include "altera_avalon_pio_regs.h"

int main()
{
  alt_putstr("Hello Pravin et Maged, from Nios II!\n");
  IOWR(AVALON_ANEMO_0_BASE,0,3);

  	  //int vitesse_vent=10;



  	 //

int vitesse ;
  /* Event loop never exits. */
  while (1)
  {		vitesse = IORD(AVALON_ANEMO_0_BASE+4,0);
	  printf("Vitesse du vent =%d\n ",vitesse);
  }

  return 0;
}
