/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include "alt_types.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "unistd.h"
#include "stdio.h"
//#define control (char *) LEDS_BASE
//#define code_fonction (char *) SWITCHS_BASE
//#define compas (int *)COMPAS_BASE
#define butee_d (int *)(VERRIN_CO_0_BASE+12)
#define butee_g (int *)(VERRIN_CO_0_BASE+8)
#define freq (int *)VERRIN_CO_0_BASE
#define duty (int *)(VERRIN_CO_0_BASE+4)
#define config (int *)(VERRIN_CO_0_BASE+16)
#define angle_barre (int *)(VERRIN_CO_0_BASE+20)
int main()
{
 unsigned int c,d;
 printf("Hello from Nios II!\n");

  //*butee_d=1320;
  //*butee_g=410;
  *butee_d=1320;
    *butee_g=410;
  *freq= 2000;
  *duty=1500;
  *config=3; // circuit gestion_verin actif, sortie pwm inactive

  while (1)
  {
  c=*freq;
  printf("freq= %d\n", c);
  d=*duty;
  printf("duty= %d\n", d);
  c=*butee_d;
  printf("butee_d= %d\n", c);
  d=*butee_g;
  printf("butee_g= %d\n", d);
  c=*config;
  printf("config= %d\n", c);
  d=*angle_barre;
  printf("angle_barre= %d\n", d);
  usleep(100000);

  }
  return 0;
 }
