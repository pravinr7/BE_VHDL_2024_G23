#include "sys/alt_stdio.h"
#include "io.h"
#include "system.h"

int main()
{ 


  /* Event loop never exits. */
  while (1)
  {
	  IOWR(AVALON_ANEMO_0_BASE ,0,3);

	  int vitesse;

	  vitesse = IORD(AVALON_ANEMO_0_BASE ,0);

	  printf("Vitesse = %d\n", vitesse);

  }

  return 0;
}
