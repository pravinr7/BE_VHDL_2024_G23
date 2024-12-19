#include "sys/alt_stdio.h"
#include "io.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"

int main()
{ 
  alt_putstr("Hello Pravin RUGHOONAUTH, from Nios II!\n");
  IOWR_ALTERA_AVALON_PIO_DATA(AVALON_ANEMO_0_BASE,0,3);

  	  //int vitesse_vent=10;



  	 printf("Vitesse du vent =%d\n ",IORD_ALTERA_AVALON_PIO_DATA(AVALON_ANEMO_0_BASE));


  /* Event loop never exits. */
  while (1);
  {

  }

  return 0;
}
