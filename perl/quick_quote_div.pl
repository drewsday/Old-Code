#!/usr/bin/perl 

use Finance::Quote;

$q = Finance::Quote->new;
foreach $arg (0 .. $#ARGV)
 {
   %info = $q->fetch("nyse","$ARGV[$arg]");
           print "$ARGV[$arg] price = ".$info{"$ARGV[$arg]","price"}."\n";
           #print "de div_yield = ".$info{"de","div_yield"}."\n";
           print "$ARGV[$arg] div = ".$info{"$ARGV[$arg]","div"}."\n";
           print "$ARGV[$arg] div_yield = ".$info{"$ARGV[$arg]","div_yield"}."\n\n";
 }
