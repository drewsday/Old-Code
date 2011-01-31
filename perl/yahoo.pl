#!/usr/bin/perl

use LWP::Simple;
#           use HTML::Parser;
#           use HTML::FormatText;
	   use HTML::TableExtract

           my ($html, $ascii);
           $html = get("http://story.news.yahoo.com/news?tmpl=story2&cid=676&u=/usatoday/20020815/ts_usatoday/4362807&printer=1");
           defined $html
               or die "Can't fetch HTML from http://www.perl.com/";


$te = new HTML::TableExtract( depth => 0, count => 5, keep_html => 1 );
        $te->parse($html);
        foreach $ts ($te->table_states) {
#           print "Table found at ", join(',', $ts->coords), ":\n";
           foreach $row ($ts->rows) {
#              join(',', @$row);
              print "   ", join(',', @$row);

#              print "   ", join(',', @$row), "\n";
           }
        }




#         require HTML::TreeBuilder;
#        $tree = HTML::TreeBuilder->new->parse($html);
   
        

#           $ascii = HTML::FormatText->new->format($tree);
#           print $ascii;

