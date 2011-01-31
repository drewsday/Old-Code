#!/usr/bin/perl
########################################################################
# portfolio.pl 0.1                   by Rob Hudson <robhudson@atdot.org>
#
# Created  10-Aug-2000 
# Modified 02-Nov-2000
########################################################################
#
# This program reads the file .portfolio from your home directory.
# .portfolio requires the following line format for each stock you own:
#
# TICKER  SHARES_OWNED  PRICE_PAID
#
########################################################################
##
# getquote returns:
#
#    0  -> Symbol         1  -> Name             2  -> Last
#    3  -> Trade Date     4  -> Trade Time       5  -> Change
#    6  -> % Change       7  -> Volume           8  -> Avg. Daily Volume
#    9  -> Bid            10 -> Ask              11 -> Prev. Close
#    12 -> Open           13 -> Day's Range      14 -> 52-Week Range
#    15 -> EPS            16 -> P/E Ratio        17 -> Div. Pay Rate
#    18 -> Div/Share      19 -> Div. Yield       20 -> Mkt. Cap
#    21 -> Exchange 
##
########################################################################
use Finance::YahooQuote;
$Finance::YahooQuote::TIMEOUT = 30;

open (IN, $ENV{HOME} . "/.portfolio") || die "Can't open .portfolio file";
for ($x = 0; <IN>; $x++) {
  push @stocks, [ split ('[\s]+', $_) ];
  $stock_list .= $stocks[$x][0] . " ";
}
close (IN);

@q = getquote ($stock_list);

## Start to print results
format STDOUT_TOP =
                             
                             MY PORTFOLIO

STOCK     Price     Change    % Ch   Worth       Paid       Gain      % Gain
-----------------------------------------------------------------------------
.

format STDOUT =
@<<<<< @####.#### @##.#### @###.##%  $@#####.## $@#####.## $@####.## @###.##%
$ticker, $price, $change, $pctchange, $worth, $paid, $gain, $pctgain
.

$gain_total = 0;
$paid_total = 0;
$worth_total = 0;
$x = 0;

foreach $a (@q) {
  $shares = $stocks[$x][1];
  $priceper = $stocks[$x][2];
  $ticker = $$a[0];
  $price  = $$a[2];
  $change = $$a[5];
  $pctchange = $$a[6];
  $paid = sprintf ("%.2f", ($shares * $priceper));
  $worth = sprintf ("%.2f", ($shares * $price));
  $gain = sprintf ("%.2f", ($worth - $paid));
  $pctgain = sprintf ("%.2f", (($gain / $paid) * 100));

  $gain_total += $gain;
  $worth_total += $worth;
  $paid_total += $paid;

  write;

  $x++;
}

$pctgain_total = sprintf ("%.2f", (($gain_total/$paid_total)*100));

format TOTALS =
-----------------------------------------------------------------------------
                                     $@#####.## $@#####.## $@####.## @###.##%
$worth_total, $paid_total, $gain_total, $pctgain_total

.

$~ = TOTALS;
write;

