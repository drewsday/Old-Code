#!/usr/bin/perl -wT

use strict;
use LWP::Simple;
use HTML::Parser;
use HTML::FormatText;

 require HTML::TreeBuilder;

my $location = shift || die "Usage: $0 URL\n";
my $html;

$html = get( $location );
#$getprint( $location );

 $ascii = HTML::FormatText->new->format(parse_html($html));
           print $ascii;

