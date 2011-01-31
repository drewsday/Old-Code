#!/usr/bin/perl 

use Finance::Quote;

$q = Finance::Quote->new;
my %stocks = $q->fetch("nyse","ko de dis rhat cat g wmt ti t s x y z txn a b c d e f q abt");
print "$k: $v\n" while ($k, $v) = each %stocks;
