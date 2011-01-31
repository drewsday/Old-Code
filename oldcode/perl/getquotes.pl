#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Storable;

my $CACHE_VERSION = 1;
my $VERSION = "1.05";

my %opts = (
            timeout       => 3,
            max_cache_age => 10*60,
            cache_file    => "~/.getquotes_cache",
            cache         => 1,
           );

GetOptions (\%opts,
            "timeout=i",
			"cache!",
            "max_cache_age=i",
            "cache_file=s");

$opts{cache_file} = tildeexp($opts{cache_file});

my @symbols = @ARGV;
@symbols = ("HCOW","AMZN","RHAT") unless @symbols;
@symbols = map {uc} @symbols;

my $cache = {};
eval {
  $cache = retrieve $opts{cache_file};
};

$cache = {} unless
  $cache->{CACHE_VERSION} and $cache->{CACHE_VERSION} !~ m/\D/
  and $cache->{CACHE_VERSION} == $CACHE_VERSION;

refetch($cache, @symbols)
  unless $opts{cache} == 1 and
  check_cache($cache, @symbols);

#   0 Symbol
#   1 Company Name
#   2 Last Price
#   3 Last Trade Date
#   4 Last Trade Time
#   5 Change
#   6 Percent Change
#   7 Volume
#   8 Average Daily Vol
#   9 Bid
#  10 Ask
#  11 Previous Close
#  12 Today's Open
#  13 Day's Range
#  14 52-Week Range
#  15 Earnings per Share
#  16 P/E Ratio
#  17 Dividend Pay Date
#  18 Dividend per Share
#  19 Dividend Yield
#  20 Market Capitalization
#  21 Stock Exchange

for my $symbol (@symbols) {
  my $q = $cache->{$symbol}->{data};
  print "No symbol $symbol\n" and next unless ($q);
  printf "%-5s %6.2f %6.2f %6.2f%% - %10s %7s (%s)\n", $q->[0], $q->[2], $q->[5], $q->[6], $q->[3], $q->[4], lc $q->[1];
}

sub refetch {
  my ($cache, @symbols) = @_;
  eval {
    local $^W = 0;  # because Finance::YahooQuote doesn't pass
                    # warnings with 5.6.0.
    require Finance::YahooQuote;
    import  Finance::YahooQuote;
    $Finance::YahooQuote::TIMEOUT = $Finance::YahooQuote::TIMEOUT = $opts{timeout};
    
  };

  die qq[\nYou need to install the Finance::YahooQuote module\n\nTry\n\n  perl -MCPAN -e 'install "Finance::YahooQuote"'\n\nas root\n\n]
	if $@ =~ /locate Finance/;
  die $@ if $@;

  local $SIG{ALRM} = sub { die "TIMEOUT" };
  alarm $opts{timeout};
  my @q;
  eval { @q = getquote(@symbols); };
  return if $@ =~ m/TIMEOUT/;
  die $@ if $@;

  for my $q (@q) {
    my $symbol = $q->[0];
    if ($q->[1] eq $symbol) {
      $q = undef;
    } else {
      $q->[6] =~ s/%$//;
    }
    $cache->{$symbol}->{time} = time;
    $cache->{$symbol}->{data} = $q;
  }
  $cache->{CACHE_VERSION} = $CACHE_VERSION;
  store $cache, $opts{cache_file};
}

sub check_cache {
  my ($cache, @symbols) = @_;
  # check that all symbols are fresh enough
  for my $symbol (@symbols) {
    unless ($cache->{$symbol}->{time}
            and $cache->{$symbol}->{time} > time-$opts{max_cache_age}) {

      # XXX .. cache cleaning should work
#      for my $symbol (keys %{$cache}) {
#        if ($cache->{$symbol}->{time} < time-($opts{max_cache_age}*20)) {
#          delete $cache->{$symbol};
#        }
#      }

      return 0;
    }
  }
  return 1;
}

sub tildeexp {
  my $path = shift;
  $path =~ s{^~([^/]*)} {  
	  $1 
		? (getpwnam($1))[7] 
		: ( $ENV{HOME} || $ENV{LOGDIR} || (getpwuid($>))[7])
	  }ex;
  return $path;
}

=head1 NAME

getquotes - get quotes from Yahoo Finance.

=head1 SYNOPSIS

  getquotes
       (gets the default quotes)

  getquotes YHOO VCLK ANDN 
       (get quotes for Yahoo, ValueClick and Andover Net)

  getquotes --nocache
       (don't use the cache)

  getquotes --max_cache_age=900 YHOO
       (cache is valid for 15 minutes (default is 10*60 seconds, 10 minutes))

  getquotes --cache_file=/tmp/cache
       (alternate cache file (default ~/.getquotes.cache))

  getquotes --timeout 10
       (timeout after 10 seconds instead of the default 3)


=head1 TODO

--help option.

Cache cleanup.

=head1 COPYRIGHT

Copyright 2000-2002 Ask Bjoern Hansen <ask@develooper.com>. All rights
reserved.  This program is free software; you can redistribute it
and/or modify it under the same terms as Perl itself.

