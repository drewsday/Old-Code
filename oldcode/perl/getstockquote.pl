#!/usr/bin/perl
###############################################################################
# getstockquote.pl - Retrieves stock data for given ticker symbol(s)
#
# Purpose:  This script returns a nicely formatted HTML table containing stock
#           data for ticker symbols given as command line arguments.  This 
#           script can be used from a server-side exec (it's orginal use) or
#           via a call from a regular CGI script.  It could also be called from 
#           PHP, but I haven't tested this.  The script prints its results on 
#           STDOUT.
# Usage:    Script requires at least one ticker symbol.  Example:
#               getstockquote.pl [--fontsize=1..6] [--verbose=yes|no] \
#                                <quote_source> <ticker1> [ticker2] ...
#           The "quote_source" value can can any of the following:
#               yahoo:        NYSE quotes
#               yahoo_europe: Europe quotes
#               fidelity:     Fidelity Investments Quotes
#               troweprice:   Quotes from T. Rowe Price
#               vanguard:     Quotes from Vanguard Group
#               asx:          Australian quotes from ASX
#               tiaacref:     Annuities from TIAA-CREF
#           The only quote source guaranteed to work time is 'yahoo'.
#           Script is meant to be run from within a server-side exec and prints
#           an HTML table with the ticker data to STDOUT.
# Requires: Script requires at least perl 5.005, patch 3.
#           Script must have the Finance::Quote module installed.  This module
#           in turn requires the LWP modules (which in turn have their own 
#           reqs).  See CPAN for exact requirements for LWP: 
#           http://www.perl.com/CPAN-local//modules/by-module/LWP/
# Author:   William Rhodes <wrhodes@27.org>
# Version:  1.02 - 4/15/2000 - 'yahoo_europe' wasn't seen as a valid quote 
#                              source
#           1.01 - 4/15/2000 - Changed input args, added quote source option
#           0.9  - 4/11/2000 - Inital release
#
# See the accompanying readme.txt file for more information.
# 
# Copyright (C) 2000 William Rhodes <wrhodes@27.org>.
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later 
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more 
# details.
#
# The information that you obtain with this script may be copyrighted by Yahoo! 
# Inc., and is governed by their usage license. See 
# http://www.yahoo.com/docs/info/gen_disclaimer.html for more information.
#
# The information that you obtain with this script may be copyrighted by the 
# ASX, and is governed by its usage license.  See 
# http://www3.asx.com.au/Fdis.htm for more information.
#
# The information that you obtain with this script may be copyrighted by 
# TIAA-CREF, and is governed by its usage license.
#
# Other copyrights and conditions may apply to data fetched via this script.
#
# Submitting changes back to the author is not required but certainly 
# encouraged.  Bug fixes are also greatly appreciated.
###############################################################################

# For use on HE
#
use lib "/home/wrhodes/perl-lib/";

use strict;
use Finance::Quote;

# Our defaults, can be modified from args; see readme
#
my $font_size = 2;
my $verbose = 0;

my @tickers = @ARGV;

# Get rid of puncuation in @ARGV.  This will filter out metacharacters and
# such, which makes the script marginally more safe
#
foreach (@tickers) { s/[^a-zA-Z0-9\-=_]//; }

# Check the input to make sure we can look stuff up
#
@tickers = CheckInput(@tickers);

# Get a new Finance::Quote object
#
my $quote_src = $tickers[0];
my $quote = Finance::Quote->new;

# Override LWP's 120 second timeout, throw error if we time out
# Set this pretty short if using as a server-side exec
#
ReturnError("No data available. $!\n") unless ($quote->timeout(10));

# Load the quotes hash for getting data
#
my %quotes = $quote->$quote_src(@tickers);

#print %quotes;

# Start our HTML table output; get the ticker data, print it out
#
shift(@tickers);		# Get rid of the quote source
print "<table border=0>\n";
for (@tickers) { print PrintData($_); }
print "</table>\n";


###############################################################################
# SUBROUTINES
###############################################################################

# You have to specify a valid quote source and at least one ticker symbol
# If this script was a stand-alone CGI, it probably ought to use CGI::CARP to
# send errors to the browser.
#
sub CheckInput {
    my @input = @_;
    my ($src_name, $src_val, $src_err, $src_found);
    my %ticker_src;

    $ticker_src{yahoo} = "NYSE quotes";
    $ticker_src{yahoo_europe} = "Europe quotes";
    $ticker_src{fidelity} = "Fidelity Investments Quotes";
    $ticker_src{troweprice} = "Quotes from T. Rowe Price";
    $ticker_src{vanguard} = "Quotes from Vanguard Group";
    $ticker_src{asx} = "Australian quotes from ASX";
    $ticker_src{tiaacref} = "Annuities from TIAA-CREF";

    # Check for font size option
    #
    if ($input[0] =~ /\-\-fontsize=[1-6]/) {
        $input[0] =~ s/\-\-fontsize=(\d)//;
        $font_size = $1;
        shift(@input);
    } 

    # Check for verbose, shift @input anyway
    #
    if ($input[0] =~ /\-\-verbose=yes/i) {
        $verbose = 1;
        shift(@input);
    } elsif ($input[0] =~ /\-\-verbose=no/i) {
        $verbose = 0;
        shift(@input);
    }

    # No quote source or symbols
    #
    if (!$input[0]) {
        $src_err .= "$0: Error: No quote source given.  Quote source must be one of the following:<br>\n";
        while (($src_name, $src_val) = each(%ticker_src)) {
            $src_err .= "  $src_name - $src_val<br>\n";
        }
        ReturnError("$src_err\n");
    } elsif (!$input[1]) {
        ReturnError("$0: Error: No symbols given.");
    }

    # Check for invalid quote source
    #
    $src_found = 0;
    foreach $src_name (keys %ticker_src) {
        if ($src_name eq lc($input[0])) {
            $src_found = 1;
        }
    }

    # Throw an error unless we had a valid quote source
    #
    unless ($src_found) {
        $src_err .= "$0: Error: Invalid quote source \"$input[0]\". ";
        $src_err .= "Quote source must be one of the following:<br>\n";
        while (($src_name, $src_val) = each(%ticker_src)) {
            $src_err .= "  $src_name - $src_val<br>\n";
        }
        ReturnError($src_err);
    }

    # So everything matched, send out args back
    #
    return(@input);

} # End CheckInput


# Return each ticker data in HTML table rows
#
sub PrintData {
    my ($key, $value, $name, $output);
    my %data;
    

    my $ticker = shift || die "No ticker data given! $!\n";
    if ($quote_src ne "tiaacref") {
        $ticker = uc($ticker);
    }

    # Our hash of stuff that we want to return as table rows
    # We have our default, and then add to it if $verbose is set
    #
    $data{a_Last_Price} = $quotes{"$ticker", "last"};
    $data{b_High} = $quotes{"$ticker", "high"};
    $data(c_Div) = $quotes{"$ticker", "div"};
    if ($verbose) {
        $data{d_Change} = $quotes{"$ticker", "change"};
        $data{e_Last_Trade} = $quotes{"$ticker", "date"} . " at " . $quotes{"$ticker", "time"};
        $data{f_Volume} = $quotes{"$ticker", "volume"} . " shares";
        $data{g_Open} = $quotes{"$ticker", "open"};
        $data{h_Close} = $quotes{"$ticker", "close"};
        $data{i_Bid} = $quotes{"$ticker", "bid"};
        $data{j_Ask} = $quotes{"$ticker", "ask"};

        # Volume needs commas to look good
        #
        $data{f_Volume} = reverse($data{f_Volume});
        $data{f_Volume} =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
        $data{f_Volume} = reverse($data{f_Volume});

    }

    $output = "<tr><td colspan=2 align=center bgcolor=\"#E8E8E8\"><font size=$font_size><b>$ticker</b></font></td></tr>\n";
    foreach $key (sort keys %data) {
        $name = $key;                 # Need to save $key for hash lookups
        $name =~ s/^[a-z]_//;         # Get rid of sorting characters
        $name =~ s/_/ /g;             # Get rid of underscores
        $data{$key} = "N/A" if ($data{$key} eq "");     # Don't show empty values

        # We want at least two decimal places in some fields
        #
        if ($name =~ /Last|High|Div|Open|Close|Bid|Ask/i) {
            $data{$key} =~ s/^(\d+$)$/$1\.00/;
            $data{$key} =~ s/^(\d+\.\d)$/$1\0/;
        }

        $output .= "<tr><td><font size=$font_size>$name: </font></td><td><font size=$font_size> $data{$key}</font></td></tr>\n";
    }

    return($output);
} # End GetData


# Prints a usage and error message to STDOUT, exits with -1
#
sub ReturnError {
    my $error = shift;
    my $usage = "Usage: $0 [--fontsize=1..6] [--verbose=yes|no] &lt;quote_source&gt; &lt;ticker1&gt; [ticker2] ...\n";
    print $error . "<br>" . $usage;
    exit;
} # End ReturnError
