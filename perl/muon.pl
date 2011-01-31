#!/usr/bin/perl

      open (IN, 'mycount.txt');
$i=0;
$sum=0;
      while (<IN>) {

          chomp;

          $col1 = substr $_, 0, 8;     # extract the first col
          $col2 = substr $_, 9, 2;    # extract the second
          $col3 = substr $_, 12, 2;        # extract the third
	  $col4 = substr $_, 15, 4;

          # do something useful here with each value ...

if(hex($col4)>8){
   if(hex($col3)==1){
        printf("%d, %d\n",hex($col1), hex($col4));
	$i = $i + 1;
	$sum = $sum + hex($col4);
	printf("Time since last decay? = %f\n",hex($col1)*20e-9);
}
  }
      }

      close (IN);
$avg = $sum/$i;
$avgtime = $avg * 20e-9;
print "Average decay time = $avgtime seconds\n";

