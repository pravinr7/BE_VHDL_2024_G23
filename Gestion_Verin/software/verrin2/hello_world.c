//Schéma fonctionnel du circuit gestion_verin
//Exemple de programme de mise en œuvre :
#include "alt_types.h"
#include "alt_types.h"
#include "system.h"
#include "altera_avalon_pio_regs.h"
#include "unistd.h"
#include "stdio.h"
//#define control (char *) LEDS_BASE
//#define code_fonction (char *) SWITCHS_BASE
//#define compas (int *)VERRIN_CO_0_BASE
#define butee_d (int *)(VERRIN_CO_0_BASE+12)
#define butee_g (int *)(VERRIN_CO_0_BASE+8)
#define freq (int *)VERRIN_CO_0_BASE
#define duty (int *)(VERRIN_CO_0_BASE+4)
#define config (int *)(VERRIN_CO_0_BASE+16)
#define angle_barre (int *)(VERRIN_CO_0_BASE+20)
int main()
{
unsigned char a,b,c,d,e,f;
//unsigned char b;

printf("Hello from Nios II!\n");
//*control=(*control) | 3;//active circuits gestion_bp et gestion_compas
*butee_d=1320;
*butee_g=410;
*freq= 1500;
*duty=1000;
*config=3; // circuit gestion_verin actif, sortie pwm inactive
while (1)
{
//test bp en mode manuel seul
//b=*code_fonction;
//printf("code_fonction= %d\n", b);
//switch(b)
//{
//case 0: *config=1;break;
//case 1: *config=7;break;
//case 2: *config=3;break;
//default:*config=1;
//}//
//a=((*compas)-10)&511;
//printf("compas= %d\n", a);
a=*freq;
printf("freq= %d\n", c);
b=*duty;
printf("duty= %d\n", d);
c=*butee_d;
printf("butee_d= %d\n", c);
d=*butee_g;
printf("butee_g= %d\n", d);
e=*config;
printf("config= %d\n", c);
f=*angle_barre;
printf("angle_barre= %d\n", d);
usleep(100000);
}
return 0;
} // circuit gestion_verin actif, sortie pwm inactive
