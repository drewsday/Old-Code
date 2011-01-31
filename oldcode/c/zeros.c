#include <stdio.h>
#include <gsl/gsl_sf_airy.h>


main (void) {

int x;
double a;

x=1;

/* for (x = 1; x < 150; x = x + 1) */

while(x < 150){
	a = gsl_sf_airy_zero_Ai (x);
	printf("%g\n",a);
	x=x+1;}

/*return 0;*/

}





