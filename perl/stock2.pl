#!/usr/bin/perl 

use Finance::Quote;
#@tickers = "ko de dis rhat cat g wmt ti t s x y z";

$q = Finance::Quote->new;
#my %stocks = $q->fetch("nyse","ko");
#print "$k: $v\n" while ($k, $v) = each %stocks;
#print "div_yield is ".$stocks{"ko","div_yield"};
   %info = $q->fetch("nyse","ko cat");
           print "ko div_yield = ".$info{"KO","div_yield"}."\n";
           print "de div_yield = ".$info{"de","div_yield"}."\n";

