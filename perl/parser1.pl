#!/usr/bin/perl

use LWP::Simple;
           use HTML::Parser;
           use HTML::FormatText;
	   use DBI;
           require HTML::TreeBuilder;
	   my ($html, $ascii);

foreach(@ARGV) 
	{
	   $url = $_;
           $html = get($_);
           defined $html
               or die "Can't fetch HTML from $_";         
	   $tree = HTML::TreeBuilder->new->parse($html);
           $ascii = HTML::FormatText->new->format($tree);

#	   $ascii =~ s/(\w+)/\u$1/g;
	   @title = split /\n/, $ascii;
#	   print "$title[0]\n\n";

#           print $ascii;

	  my $dbi = DBI->connect("DBI:mysql:clippings",morris, rooski)
		or die "Cannot connect: " . $DBI::errstr();
	  my $sql = "insert into articles values ($url, $title, $ascii, CURDATE(DATE_FORMAT(%c-%e-%Y)));
	  my $sth = $dbh->prepare($sql) 
		or die "Cannot prepare: " . $dbh->errstr();
	  $sth->execute() or die "Cannot execute: " . $sth->errstr();

	  $sth->finish();
	  $dbh->disconnect;

	}
