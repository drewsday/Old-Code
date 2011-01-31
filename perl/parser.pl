#!/usr/bin/perl

use LWP::Simple;
           use HTML::Parser;
           use HTML::FormatText;
           require HTML::TreeBuilder;
	   my ($html, $ascii);

foreach(@ARGV) 
	{
           $html = get($_);
           defined $html
               or die "Can't fetch HTML from $_";         
	   $tree = HTML::TreeBuilder->new->parse($html);
           $ascii = HTML::FormatText->new->format($tree);
           print $ascii;

	   $ascii =~ m/\n/;
	   $title = $';

	   print $title;


	}
