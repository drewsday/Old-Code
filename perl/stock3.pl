#!/usr/bin/perl 

use Finance::Quote;

$fname=$ARGV[0] ;

open(FILE1, "$fname") or die "Error opening input: $fname\n\n" ;

while(<FILE1>)
  {
  $line1 = $_ ;

  chomp $line1 ;

$q = Finance::Quote->new;
$q->require_labels(qw/div_yield volume/);
my %stocks = $q->fetch("nyse","$line1");
#print "$k: $v\n" while ($k, $v) = each %stocks;
print 
"$line1,".$stocks{"$line1","div_yield"}.",".$stocks{"$line1","volume"}."\n";
`sleep 2`;

}

close (FILE1);
