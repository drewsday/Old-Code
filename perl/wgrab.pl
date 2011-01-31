#!/usr/bin/perl -w

use LWP ;
use MIME::Base64; # used for basic www-authentication
use HTTP::Date ; # used for parsing 'lastModified' dates and setting timestamp

my $version = "v1.21 of Feb. 22 2002" ;
# some version history at the end of file


my $usage = qq{wgrab [opts] [-a saveAs] {counters} startURL {patterns}\t $version
         make http downloads based on dates, numbers and regular expressions
         (c) Heiko Hellweg (hellweg\@snark.de), 2002; see http://snark.de/wgrab/
options include:
-h: long help and license, -hX prints some eXamples...
-v: verbose (multiple -v make it more verbose)
-p: don\'t get last pattern - just print matches to stdout
-P substPat: like -p, but apply % substitution (like in saveAs) before printig
-n: noClobber - overwrite existing files instead of renaming
-w seconds: wait between downloads (don\'t overrun the other host)
-A: save all (not just the files retrieved with the last pattern)
-r: rewrite saved (make links to unsaved docs absolute; links to saved relative)
-H: span hosts - auto-patterns may contain ":" (like http://) 
-R: follow HREFs only 
-S: follow SRC only
--user string: username for basic www-authentification
--pass string: passphrase for basic www-authentification
--userAgent string: UserAgent header transmitted to server
counters are:   type start end [-s step]   with these types:
-d : iterate over dates, relative to now (start and end are integer)
-D : iterate over absolute dates (start and end are YYYYMMDD)
-e enumerate over integers (may occur multiple times - use %e...%h) 
-E enumerate over characters (may occur multiple times - use %E...%H) 
} ;


my $moreusage = qq{
All patterns following the startURL may contain everything that makes up a perl
regex. With multiple patterns, wgrab gets the startURL document, extracts all 
quoted strings, tries to match the first pattern, interprets the results as 
URLs, downloads them, applies the next pattern to their content... and saves 
the documents downloaded via the last pattern.

If a pattern contains "(" and ")", it is left unmodified. Otherwise a new 
pattern is constructed: [\"\']([^\"\']*yourpattern)[\"\'] (details of the prefix
depend on -H, -R and -S options). Anyway: perls \$1 [the matched part in '()']
is used for going on.

Patterns starting with "+" are recursed into on the same level and applied to
their own result again (this way you can easily iterate thru "next" links)

additional rexexp shorthand: \\I (image) expands to "[gGjJpP][iIpPnN][eE]?[fFgG]"
(i.e. gif or jpg or jpeg or png - with arbitrary mixes of upper/lower case).

saveAs and all the patterns may contain %[[+-]number[.fillchar]]X 
\(\'+\' truncates from the right and \'-\' truncates from the left\) where X is one of
d: Day of Month \tm: Month of Year 
y: Year (4 digit) \tD: Day of Week [0..6] 
w: Day of Week name lowercase \tW: Day of Week name Uppercase
n: Month name lowercase \tN: Month name Uppercase 
T: That day (shorthand for %4y%2m%2d)
t: today (shorthand for %4y%2m%2d with current date)
e/f/g/h: counter 1..4 (depends on number of -e/-E parameters)
E/F/G/H: chr(counter 1..4) (depends on number of -e/-E parameters)
=: referenced filename in -a or -P: URL split at "/"(from right: %1= = filename)
i: counter for saved files in saveAs
       ...better look at the examples with "-hX" to see how \%substitution works

Tricks with the saveAs pattern (-a):
%.= flattens the filename, replacing '/' in the url with a '.' in the filename.
use "-" for the saveAs pattern to print all results to stdout.
if the saveAs pattern starts with a "|", it is executed as a shell command.
(e.g. mail each document to yourself with -a '|mutt -s "%=" myself\@mail.edu')

some additional options (wich i bailed out of explaining before...):
--nocache: if a proxy is used (from http_proxy env.) urge him to reload 
--rpre and --rpost: on rewrite(-r) prefix/postfix these strings to external URLs
or --rimg <image url> (its what rpre and rpost are mostly used for):
  attach this (hopefully small) image to every external link on rewrite
 
LICENSE: use, modify and redistribute as much as you want - as long as credit
to me (hellweg\@snark.de) remains in the docs. No warranty that wgrab does or 
does not perform in any specific or predictable way...
It would be nice (not a condition of the license) if you told me about bugs 
you encounter (maybe even with a fix) and/or the uses you find for wgrab.
} ;

# still needs to be explained short and easy:
#
# - -l lang: use language for Names in days and months... default: en; alt: de
#
# - dots ('.') in an auto pattern are expanded to [^\"\'\>]
#
# - %i in saveAs can be used to enumerate the saved files in the order they
#    were encountered - typically used as -a %3i.%1= or such
#
# - %.= flattens the saveAs name: http://www.site.edu/path/file.txt becomes
#    www.site.edu.path.file.txt
#
# - if you want to match something not in "" or '' you need an untouched
#    regexp: simply enclose your rexexp (or parts of it) in '()'
#
# - you can use other formats for defining dates to -D : everything that
#    HTTP::Date accepts (but things like "Wed, 09 Feb 1994 22:23:32 GMT"
#    need to be quoted on the commandline of course)
# 
# - -D dates are themselves expanded... you can use %t for today (only %t !)
#
# - %E/%F/%G expand to chr(%e/%f/%g), 
# - -E start end counts from ord(start) to ord(end) (for use with characters)
# 
# - if you start a pattern with a '+', it remains on the same level and
#   can be appplied over and over to its own results again - use this 
#   for archives with 'previous' or 'next' buttons
# 
# - if saveAs consists of a single '-', every resultfile is printed to stdout
#
# - if saveAs starts with a pipe (|) it is executed as a command with the
#   document content on STDIN

my $examples = qq{wgrab -hX $version
here are some Examples (these work today - your mileage may vary...):

- get all sluggy freelance comics up to today:
wgrab -v -D 19970825 \%t -a \%1= http://www.sluggy.com/d/\%-2y\%2m\%2d.html 
'http://pics.sluggy.com/[^\"]+'

- save the last 4 weeks of dilbert with ungarbled names:
wgrab -v -v -d -1 -28 -a ./dilbert%T.gif http://www.dilbert.com/comics/dilbert/archive/dilbert-%T.html '/archive/images/dilbert[^\"]+\\I'

- get the first 100 freefall strips:
wgrab -v -e 1 100 http://www.purrsia.com/freefall/ff100/fv\%5e.gif

- save the whole SinFest archive:
wgrab -v -n http://sinfest.net/strips_page.htm '\\d+.html' 'sf\\d+.\\I'

- get all of my geman translations of "Dela the Hooda":
wgrab -v -a \%3i.\%1= http://www.snark.de/dela/archiv.html '\\d.html' '\\d.\\I'

- or get the same Dela translations by iterating thru the "next" links with +
wgrab -v -a \%3i.\%1= http://www.snark.de/dela/first.html '+\\d.html' '\\d.\\I'

- get the whole archive from your favorite keenspace comic (with next links)
wgrab -v http://your-favorite.keenspace.com/ '+\\d{8}.html' 'comics.+\\I'

- use '-p' to print the project names of all current freshmeat announcments: 
wgrab -p http://freshmeat.net/ 'href="/projects[^\>]+\>\\s*\<font[^\>]+\>([^\<]+)\<'

- or use -P pattern to print these anouncements with clickable absolute links:
wgrab -P '<a href="http://freshmeat.net%=</font></a>' http://freshmeat.net/ 'href="(/projects[^\>]+\>\\s*\<font[^\>]+\>[^\<]+)\<'

i am sure, you will find many more...
} ;


my @monthNames = qw/January February March April May June July August September October November December/ ;
my @dayNames = qw/Sunday Monday Tuesday Wednesday Thursday Friday Saturday/ ;

@monthNames_de = qw/Januar Februar Maerz April Mai Juni Juli August September Oktober November Dezember/;
@dayNames_de = qw/Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag/;

my $startDate = $endDate = time() ;
my $dateStep = 1 ;
my $saveInterim = 0 ;
my @counters = () ;
my @patterns = () ;
my %beenThere = () ;
my $saveAs = "%=" ; # should i make this %1= or %.= by default?
my $verbose = 0 ;
my $quiet = 0 ;
my $noClob = 0 ;
my $spanHosts = 0 ;
my $printonly = 0 ;
my $refPrefix = '[SsHh][Rr][CcEe][Ff]?\s*\=\s*' ;
my $waitbetween = 0 ;
my $rewriteStored = 0 ;
my $rewritePre = "" ;
my $rewritePost = "" ;

my $userid = '' ;
my $passphrase = '' ;
my $userAgent = "Mozilla/4.0 (compatible; wgrab $version)" ;
my $ownUA = 0 ; # bool flag: has the user set his own userAgent string?

my $saveCounter = 1 ; # for %i pattern in saveAs

my $globalDownloadBytes = 0 ;
my $globalSaveBytes = 0 ;

my $cacheForce = 0 ;

my $knownFile = 0 ;
my $known = 0 ; # hashref
my @newKnown = () ; # only append the new ones to the known fole on finish

my $printFirstSaveLocation = 0 ;

my $staticReferer = 0 ;

# commandline argument processing
my $pat = shift || die "no parameters found...\n$usage" ;
while($pat =~ /^-/) {
    
    if(($pat eq "-h") || ($pat eq "--help")) {
	pageAndExit($usage, $moreusage) ;
    }
    if($pat eq "-hX") {
	pageAndExit($examples) ; 
    }
    if(($pat eq "--version") || ($pat eq "-V")){
	print "wgrab $version \t(c) 2001, Heiko Hellweg (hellweg\@snark.de)\n";
	exit 0 ;
    }

    if($pat eq "-l") {
	my $x = shift || die "no language specified\n$usage" ;
	if($x eq "de") {
	    @monthNames = @monthNames_de ;
	    @dayNames = @dayNames_de ;
	}
	$pat = shift || die "no parameters following -l lang\n$usage" ;
    }
    if($pat eq "-d") { # dates relative to now
	my $x = 0 ;
	die "no date offset\n$usage" unless defined($x = shift) ;
	$startDate += $x * 60 * 60 * 24 ;
	die "no second date offset\n$usage" unless defined($x = shift) ;
	$endDate += $x * 60 * 60 * 24 ;
	$pat = shift || die "no parameters following the date offsets\n$usage";
	if($pat eq "-s") {
	    $dateStep = shift || die "no step width\n$usage" ;
	    $pat = shift || die "no pattern following the step width\n$usage" ;
	}
	else {
	    $dateStep = ($startDate < $endDate) ? 1 : -1
	}
	$dateStep *= (60*60*24) ;
    }
    if($pat eq "-D") { # absolute dates
	my $x ;
	die "no date following -D\n$usage" unless defined($x=shift);
	$startDate = str2time(expand($x)) || die "invalid date: $x\n$usage" ;
	die "no second date following -D\n$usage" unless defined($x=shift);
	$endDate = str2time(expand($x)) || die "invalid date: $x\n$usage" ;
	$pat = shift || die "no pattern following -D$usage" ;
	if($pat eq "-s") {
	    $dateStep = shift || die "no step following -s\n$usage" ;
	    $pat = shift || die "no pattern following -s num\n$usage" ;
	}
	else {
	    $dateStep = ($startDate < $endDate) ? 1 : -1
	}
	$dateStep *= (60*60*24) ;
    }
    if($pat =~ /^\-([Ee])$/) {
	my ($step, $enumType, $start, $end) = (1, $1, 0, 0);
	die "-e\n$usage" unless defined($start = shift) ;
	die "-e2\n$usage" unless defined($end = shift);
	if($enumType eq 'E') {
	    $start = ord($start) ; $end = ord($end) ;
	}
	$pat = shift || die "-$enumType:\n$usage" ;
	if($pat eq "-s") {
	    $step = shift || die "-$enumType\n$usage" ;
	    $pat = shift || die "no pattern following -e\n$usage"
	}
	else {
	    $step = ($start < $end) ? 1 : -1 ;
	}
	push @counters, [$start, $end, $step] ;
    }
    if($pat eq "--user") {
	$userid = shift || die "no userid\n$usage" ;  ;
	$pat = shift || die "--user\n$usage" ;
    }
    if($pat eq "--pass") {
	$passphrase = shift || die "no passphrase\n$usage" ;  ;
	$pat = shift || die "--pass\n$usage" ;
    }
    if($pat eq "--userAgent") {
	$userAgent = shift || die "no user Agent\n$usage" ;  ;
	$ownUA = 1 ;
	$pat = shift || die "--userAgent\n$usage" ;
    }
    if($pat eq "--referer") {
	$staticReferer = shift || die "no referer\n$usage" ;  ;
	$pat = shift || die "--referer\n$usage" ;
    }
    if($pat eq "--nocache") { # force/hint proxys not to cache
	$ownUA = $cacheForce = 1 ;
	$pat = shift || die "--nocache\n$usage" ;
    }
    if($pat eq "-a") {
	$saveAs = shift || die "no save-As name following -a\n$usage" ;  ;
	$pat = shift || die "-a\n$usage" ;
    }
    if($pat eq "-w") {
	$waitbetween = shift || die "no number of seconds to wait\n$usage" ;  ;
	$pat = shift || die "-w\n$usage" ;
    }
    if($pat eq "-n") {
	$noClob = 1 ;
	$pat = shift || die "-n\n$usage"  ;
    }
    if($pat eq "-p") {
	$printonly = "%=" ;
	$pat = shift || die "-p\n$usage" ;
    }
    if($pat eq "-P") {
	$printonly = shift || die "-P\n$usage" ;
	$pat = shift || die "-p\n$usage" ;
    }
    if($pat eq "-A") { # save all encountered documents on the way
	$saveInterim = 1 ;
	$pat = shift || die "-A\n$usage" ;
    }
    if($pat eq "-r") { # rewrite stored documents to use relative links to 
	# other stored docs and absolute links to non downloaded elements
	$rewriteStored = 1 ;
	$pat = shift || die "-r\n$usage" ;
    }
    if($pat eq "--rpre") { # rewrite stored documents: prefix to ext.links
	$rewritePre = shift ;
	$pat = shift || die "-rpre\n$usage" ;
    }
    if($pat eq "--rpost") { # rewrite stored documents: postfix to ext.links
	$rewritePost = shift ;
	$pat = shift || die "-rpost\n$usage" ;
    }
    # alternatively to pre/post: prepend this url as an image to ext.links
    if($pat eq "--rimg") { 
	$rewritePost = "<img src=\"" . (shift) . "\" border=\"0\">" ;
	$rewriteStored = 1 ;
	$pat = shift || die "-rimg\n$usage" ;
    }
    if($pat eq "-H") { # allow spanning of hosts
	$spanHosts = 1 ;
	$pat = shift || die "-H\n$usage" ;
    }
    if($pat eq "-R") { # HREF only
	$refPrefix = '[hH][rR][eE][fF]\s*=\s*' ;
	$pat = shift || die "-R\n$usage" ;
    }
    if($pat eq "-S") { # SRC only
	$refPrefix = '[sS][rR][cC]\s*=\s*' ;
	$pat = shift || die "-S\n$usage" ;
    }
    if($pat eq "-v") { # verbose
	$verbose++ ;
	$quiet = 0 ;
	$pat = shift || die "-v\n$usage" ;
    }
    if($pat eq "-q") { # quiet
	$verbose = 0 ;
	$quiet++ ;
	$pat = shift || die "-q\n$usage" ;
    }
    if($pat eq "--printFirstSave") { # quiet
	$printFirstSaveLocation = 1 ;
	$pat = shift || die "--printFirstSave\n$usage" ;
    }
    if($pat eq "-K") { # list of 'known' (don't get again)
	$knownFile = shift || die "-K\n$usage" ;
	if(open(RH, "<$knownFile")) {
	    my $kcount=0 ;
	    while(<RH>) {
		$kcount++ ;
		chomp ;
		$known->{$_} = 1 ;
	    }
	    close(RH) ;
	    print(STDERR "read $kcount URLs from $knownFile\n") if $verbose;
	} else { # just issue a warning
	    print(STDERR "can not read known URLs from $knownFile\n") 
		unless $quiet ; 
	}
	$pat = shift || die "-K\n$usage" ;
    }

}


# initialize the user agent
my $ua=new LWP::UserAgent;
if(defined($ENV{'http_proxy'}) && ($ENV{'http_proxy'} !~ /^-/)) {
    $ua->env_proxy() ; # use environment variables ...
}
$ua->agent($userAgent) ; 


push @patterns, $pat ;
while($pat = shift) {
    push @patterns, prepPat($pat) ;
}
push @patterns, $saveAs ;

# now we need to expand all possible permutations of -DdEe iterators...
# and start recursing into whatever we find...
for($d=$startDate; ($endDate-$d)*$dateStep >= 0; $d+= $dateStep) {
    expandCounters(\@patterns, [$d], @counters) ;
}

if($knownFile) {
    # save the new list of already downloaded URLs
    if(open(WH, ">>$knownFile")) {
	my $kcount = 0 ;
	foreach(@newKnown) {
	    print WH "$_\n" ;
	    $kcount++ ;
	}
	close WH ;
	print(STDERR "stored $kcount new known URLs to $knownFile\n") if $verbose ;
    }
    else {
	print(STDERR "could not store known URLs to $knownFile\n") 
	    unless $quiet;
    }
}
if($rewriteStored) {
    rewriteStored() ;
}
# finished

if($verbose) {
    # some summary information:
    print(STDERR "downloaded ", prettyVal($globalDownloadBytes), "B\n") ;
    $saveCounter-- ;
    print(STDERR "saved ", prettyVal($globalSaveBytes), 
	  "B in $saveCounter Files\n") ;
}

#################################   the end of main #######################


sub prettyVal { # prepare a big number for printing
    my $val = shift || 0 ;
    my $truncate = shift || 0 ;
    return "$val " if($val < 500) ;
    $val /= 1000 ;
    my $unit = "k" ;
    if($val > 500) { $val /= 1000; $unit = "M" ; }
    if($truncate) {
	$val =~ s/\..+// ;
    } else {
	$val =~ s/(\.\d\d\d).+/$1/ ;
    }
    return "$val $unit" ;
}

sub prettyTime { # prepare a number of seconds for printing
    my $val = shift || 0 ;
    
    my $h = $val / 3600 ;
    $h =~ s/\..+// ;
    my $m = ($val - 3600*$h) / 60 ;
    $m =~ s/\..+// ;
    $s =  (($val - 3600*$h) - $m*60) ;
    return sprintf("%i:%0.2i.%0.2i h", $h, $m, $s) if $h ;
    return sprintf("%i:%0.2i min", $m, $s) if $m ;
    return  "$s sec" ;
}

sub prepPat { # prepare a pattern: 
    # if no braces are in there: put "([^\"]* and [^\"]*)" around it
    # replace \I, with pattern for gif/jpeg/png
    my ($pat) = @_ ;
    my $pre = "" ;
    $pre = "+" if($pat =~ s/^\+//) ;
    $pat =~ s/\\I/\[gGjJpP\]\[iIpPnN\]\[eE\]\?\[fFgG\]/ ;
    if($pat !~ /\(/) {
	if($spanHosts) { # allow ':' in prefix and '.'
	    $pat = '["\']([^"\'>]*'.$pat ;
	    $pat =~ s/([^\\])\./$1\[^\"\'\>\]/g ;
	}
	else {
	    $pat = '["\']([^"\':>]*'.$pat ;
	    $pat =~ s/([^\\])\./$1\[^\"\'\>\:\]/g ;
	}
	$pat .= ')["\']' ;
        # (global) refPrefix can be "", "SRC\s*=\s*" or "HREF\s*=\s*" or both
	return "$pre$refPrefix$pat" ;
    }
    return "$pre$pat" ; # unmodified because it contains () (know what you do)

}


sub pageAndExit { # is there some nicer way to present a multipage output?
    my $content = join("\n", (@_)) ;
    my $tmpdir = $ENV{'TMP'} || $ENV{'TEMP'} || $ENV{'TMP_DIR'} || 
	$ENV{'TMPDIR'} || $ENV{'TEMP_DIR'} || $ENV{'TEMPDIR'} || "." ;
    my $sep = "/" ; $sep = "\\"  if($^O =~ /Win/) ;

    if(-t STDOUT) { # we are in an interactive terminal - right?
	my $tmpcount = 0 ; my $max = 30 ;
	while(($tmpcount < $max) && 
	      (! mkdir "$tmpdir${sep}tmp.$tmpcount", 0700)) {
	    $tmpcount++ ;
	} # is this now a safe directory?
	if($tmpcount < $max) {
	    my $name = "$tmpdir${sep}tmp.$tmpcount${sep}wgrab.hlp" ;
	    if(open(WH, ">$name")) {
		print WH $content ;
		close(WH) ;
		if(defined($ENV{PAGER})) {
		    system("$ENV{PAGER} $name") || cleanExit($name) ; 
		}
		cleanExit($name) unless  system("less $name"); 
		cleanExit($name) unless  system("more $name"); 
	    }
	}
    }
    print "$content" ;
    exit(0) ;
    
}

sub cleanExit { # remove temp file after paging the help text
    my ($name) = (@_) ;
    if(-f "$name") { # plain file? not a symlink?
	unlink("$name") ;
	$name =~ s/[\/\\][^\/\\]+$// ;
	rmdir "$name" ;
    } else {
	die "can not unlink" ;
    }
    exit 0 
}



sub grabRecursive {
    my ($level, $ref, $url, $counters, @patr) = (@_) ;
    $url = expand($url, @{$counters}) ;
    if($verbose) {
	print(STDERR "grab $level: ") if ($verbose > 1);
	print(STDERR $url) ;
	print(STDERR " => $patr[0]") 	if($verbose > 1) ;
	print(STDERR "\n") ;
    }
    
    if($printonly && (scalar(@patr)==1)) {
	# we are alredy at the end... and dont want to download
	# this case should only be encountered, if there is only one expression
	# on the commandline and no download happens at all. (wgrab -p %T)
	print (expand_pe(expand($printonly, @{$counters}), $url), "\n" ); 
	return ;
    }

    # instead of 'wget's way of not touching urls we have encountered before,
    # we will still look it up again, if we have been here - provided it was on
    # another level of recursion (other patterns may apply now)
    if((! $beenThere{$url}) || (! $beenThere{$url}->{$level}) ) {
	
	if((scalar(@patr) == 1) || ($saveInterim && (!$beenThere{$url}))) {
	    # something we ought to save?
	    if($known->{$url}) {
		print(STDERR "been there before!\n") if $verbose ;
		return ;
	    }
	}

	my $duration = time ;
	my ($content, $modified, $base, $mime) = getContent($url, $ref) ;
	if($content) {
	    $duration = time - $duration ;

	    if((scalar(@patr) == 1) || ($saveInterim && (!$beenThere{$url}))) {
		saveContent($content, $url, $patr[-1], 
			    $duration,($modified||0), $counters, $mime);
	    }

	    if(! $beenThere{$url}) { $beenThere{$url} = {$level => 1}; }
	    else { $beenThere{$url}->{$level} = 1 ; }
	    if($base ne $url) { # redirected or rewritten?
		if(! $beenThere{$base}) { $beenThere{$base} = {$level => 1}; }
		else { $beenThere{$base}->{$level} = 1 ; }
		$beenThere{$url}->{'map'} = $base ;
		$url = $base ;
	    }
	    if(scalar(@patr) > 1) { # more levels to go...
		my $pat = shift @patr ;
		my $iterpat = "" ;
		if($pat =~ s/^\+//) {
		    $iterpat = $pat;
		    if(scalar(@patr) > 1) {
			$pat = shift @patr ;
		    }
		    else { $pat = "" ; }
		}
		if($pat) {
		    while($content =~ s/$pat//) {
			if($printonly && (scalar(@patr)==1)) {
			    # we are alredy at the end... and dont want to 
			    # download. This does not have to be a url... 
			    # can be any text matched
			    print(expand_pe(expand($printonly, @{$counters}), 
					    $1), "\n" ); 
			}
			else {
			    my $subURL = qualifyURL($1, $url) ;
			    grabRecursive($level+1, $url, $subURL, $counters, @patr) if $subURL ;
			}
		    }
		    unshift @patr, $pat ;
		}
		if($iterpat) {
		    unshift @patr, "+$iterpat" ;
		    my @goOn = () ;
		    while($content =~ s/$iterpat//) {
			if($printonly && (scalar(@patr)==1)) {
			    # we are alredy at the end... and dont want to 
			    # download. This does not have to be a url... 
			    # can be any text matched
			    print(expand_pe(expand($printonly,@{$counters})
					    ,$1), "\n" ); 
			}
			my $subURL = qualifyURL($1, $url) ;
			push @goOn, $subURL if $subURL ;
		    }
		    undef $content ; # this recursion may be deep - save memory
		    foreach(@goOn) {
			grabRecursive($level, $url, $_, $counters, @patr) 
			    unless($beenThere{$_} && 
				   $beenThere{$_}->{$level}) ;

		    }
		}
	    }
	}
    }
    else {
	if($verbose) {
	    print(STDERR "been there\n") ;
	}
    }
}



sub saveContent {
    my ($content, $url, $savePat, $duration, $modtime, $counters, $mime) = @_ ;

    if($savePat eq "-") {
	print $content ; return ;
    }

    # assume index.html - otherwise, we run into trouble when saving a file
    # with a directory name that is needed later...
    my $orgurl = $url ;
    
    $savePat = expand_pe(expand($savePat, @{$counters}), $url) ;

    if($savePat =~ /^\|/) {
	# if it starts with a pipe... call it
	print(STDERR "executing '$savePat'\n") if $verbose ;
	if(open(WH, $savePat)) {
	    binmode(WH) unless $mime =~ /text/ ;
	    unless (print WH $content)  {
		print(STDERR "could not pipe content to $savePat ",
		      "(external application error?)\n") unless $quiet ;
	    }
	    close WH ;
	}
	else {
	    print(STDERR "can not exec $savePat\n") unless $quiet;
	}
	return ;
    }

    print("save pre=$savePat\n") if ($verbose > 2) ;

    $savePat =~ s/[a-z]{3,4}\:..// ; # cut of 'http|ftp://'
    $savePat =~ tr/A-Za-z0-9\.\_\-\//_/c ; # special chars to '_'
    $duration = 1 unless $duration ; # avoid div by zero

    print("save trimmed=$savePat\n") if ($verbose > 2) ;

    @path = split(/\//, $savePat) ;  # make directories if necessary
    pop @path ;
    my $curpath = "" ;
    while(scalar(@path)){
	$curpath .= (shift @path) ."/" ;
	if(! -d $curpath) {
	    print(STDERR "mkdir $curpath\n") if $verbose > 1;
	    mkdir $curpath, 0755 ;
	}
    }
    if(-e $savePat) {
	print(STDERR "$savePat exists... ") if $verbose > 1 ;
	if(!$noClob) {
	    my ($pre, $count, $post) = ("", 0, "") ;
	    if($savePat =~ /^(.+)\.([^\.]+)$/) {
		$pre = $1 ; $post = $2 ;
	    }
	    while(-e "$pre.$count.$post") { $count++ } ;
	    $savePat = "$pre.$count.$post" ;
	    print(STDERR "save as $savePat instead") if $verbose > 1 ;
	}
	print(STDERR "\n") if ($verbose > 1) ;
    }
    if(open(WH, ">$savePat")) {
	binmode(WH) unless $mime =~ /text/ ;
	if (print WH $content)  {
	    close WH ;
	    #store the url->file mapping for relative-rewriting
	    $beenThere{$url}->{'file'} = $savePat ;
	    $beenThere{$orgurl}->{'map'} = $url if($orgurl ne $url) ;
	    $globalSaveBytes += length $content ;
	    $saveCounter++ ;
	    print(STDERR "$savePat: ") if($verbose > 1) ;
	    print(STDERR "saved ",prettyVal(length($content)),"B") if $verbose;
	    if($verbose > 1) {
		print(STDERR " (", prettyTime($duration), ", ", 
		      prettyVal(length($content)/$duration, 1),"Bps)") ;
	    }
	    print(STDERR "\n") if $verbose ;
	    if($printFirstSaveLocation) {
		print "$savePat\n" ;
		$printFirstSaveLocation = 0 ;
	    }
	    if($knownFile) {
		$known->{$url} = 1 ;
		push @newKnown, $url ;
	    }

	    if($modtime) { # set modification time
		my $timeval = str2time($modtime) || 0 ; # from HTTP::Date ;
		if($timeval) {
		    utime(time(), $timeval, $savePat) ;
		    print(STDERR "timestamp set to ", 
			  scalar(localtime($timeval)), "\n")
			if($verbose > 2) ;
		}
		else {
		    print(STDERR "inval timestamp $modtime\n") if($verbose>2);
		}
	    }
	    else {
		print(STDERR "no timestamp\n") if ($verbose > 2) ;
	    }
	}
	else { # failed to write
	    print(STDERR "could not store content to $savePat ",
		  "(full partition?)\n") unless $quiet ;
	    close WH ;
	}
    }
    else { # failed to open for writing
	print(STDERR "could not save to $savePat\n") unless $quiet;
    }
}



sub qualifyURL {
    # munge relative URLs into absolute ones
    my ($url, $ref) = @_ ;

    return if $url =~ /^mailto\:/ ;

    # also: remove jump-tags (#name) from the url
    $url =~ s/\#[^\?]+// ;
 
    if($url !~ /^[a-z]+\:\/\//) {
	# it is not a fully qualified URL...
	my ($prefix, $path) = ("", "") ;
	if($ref =~  /^([^\/\:]+\:\/\/[^\/]+)(\/[^\/]*)?$/) {
	    # main url of a server
	    $prefix = $1
	}
	else {
	    if($ref =~ /^([^\/\:]+\:\/\/[^\/]+)(\/.+)\/([^\/]*)$/) {
		$prefix = $1 ;
		$path = $2 ;
	    }
	}
	if($url =~ /^\//) { # absolute path within the host
	    print(STDERR "host absolute: $url => $prefix$url\n") 
		if ($verbose > 2) ;
	    $url = "$prefix$url" ;
	}
	else {
	    # relative path from the referring document
	    print(STDERR "host relative: $url => $prefix$path/$url\n") 
		if ($verbose > 2) ;
	    $url = "$prefix$path/$url" ;
	}
	while($url =~ s/\/([^\/]+)\/\.\.\//\//) {
	    print(STDERR "trimmed $1/..\n") if $verbose > 2 ;
	}
	while($url =~ s/\/\.\//\//) {
	    print(STDERR "trimmed /./\n") if $verbose > 2 ;
	}
    }
    return $url ;   
}




sub getContent {
    my ($url, $refer) = (@_, 0, 0) ;
    my $req = new HTTP::Request(GET => $url) ;
    if($staticReferer) {
	$req->header(Referer => $staticReferer) ;
    }
    elsif ($refer) {
	# quoting the referer according to
	# http://www1.ics.uci.edu/pub/websoft/libwww-perl/archive/2000h1/0542.html
	# in order to avoid the occatsional 'Unexpected field value' errors
	$req->header(Referer => "$refer") ;
    }
    $req->header(Pragma => "no-cache", 'Cache-control'=>"Max-age=0")
	if($cacheForce) ;

    if($waitbetween) {
	print(STDERR "sleeping $waitbetween s...\n") if($verbose > 2);
	sleep $waitbetween ;
    }
    my $res = $ua->request($req); 
    
    if($res->code == 401) { # authentication needed
	if($userid) { # should we send www-authenticate info?
	    $req->header(Authorization => 
			 "Basic ".encode_base64("$userid:$passphrase")) ;
	    # try again
	    $res = $ua->request($req); 
	}
	elsif($verbose) {
	    print(STDERR "Authentication needed: ". 
		  $res->header("WWW-Authenticate")."\n");
	}
    }

    if($res->is_success) {
	$globalDownloadBytes += length($res->content) ;
    }
    else {
	if($verbose) {
	    print(STDERR $res->code,": ",
#		  $res->message, 
		  " (not available)\n") ;
	}
	return 0 ;
    }
    return ($res->content, ($res->header('Last-Modified') || 0), 
	    $res->base, $res->header('Content-Type')) ;
}



sub expandCounters {
    my ($patterns, $fixedC, @remainingCounters) = (@_) ;
    if(scalar(@remainingCounters)) {
	my $cr = shift @remainingCounters;
	my $c ;
	for($c = $cr->[0]; ($cr->[1]-$c) * $cr->[2] >= 0; $c += $cr->[2]) {
	    expandCounters($patterns, [@{$fixedC}, $c], @remainingCounters) ;
	}
    }
    else { # all counters expanded
	my @concretePat = () ;
	foreach(@{$patterns}) {
	    push @concretePat, $_ ;
	}
	my $url = shift @concretePat ;
	grabRecursive(0, 0, $url, $fixedC, @concretePat) ;
    }
}


sub expand_pe {
    # expand percent-equals (%=) patterns
    my($pat, $saurl) = (@_) ;

    print("expand_pe $saurl to $pat\n") if ($verbose > 2) ;
    if($saurl) {
	$saurl .= "index.html" if($saurl =~ /\/$/) ;
	my @path = split /\//, $saurl ;

	my $dotname = $saurl; 
#	$dotname =~ s/^[^\:]+\:\/\/// ;
	$dotname =~ s/\//\./g ; # replace / with .

	while($pat =~ /^(.*)\%(\-?[0-9\.]*)\=(.*)$/o) {
	    my $lev = $2 || 0 ;
	    my $pre = $1 ;
	    my $post = $3 ;

	    if($lev eq ".") {
		$pat = "$pre$dotname$post" ;
	    }
	    else {
		$lev *= -1 ;
		if($lev) {
		    $lev-- if($lev > 0) ; # '%-1=' evals to 'www.somehost.dom'
		    $pat = "$pre$path[$lev]$post" ;
		}
		else {
		    $pat = "$pre".join("/", @path)."$post" ;
		}
	    }
	}
    }
    print("expand_pe-ed to $pat\n") if ($verbose > 2) ;
    return $pat ;
}

sub expand { # %-substitution
    my ($pat, @ctr) = (@_, 0) ;
    my $d = shift @ctr || 0 ; 
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($d);
    my %fill = ('y' => $year+1900, 
		'm' => $mon+1 ,
		'd' => $mday,
		'D' => $wday,
		'w' => $dayNames[$wday],
		'W' => $dayNames[$wday],
		'n' => $monthNames[$mon],
		'N' => $monthNames[$mon],
		'i' => $saveCounter
		) ;

    my $cid = ord('E') ;
    foreach (@ctr) { # set up %E, %e, %F, %f, ...
	$fill{chr($cid)} = chr($_) if(($_ > 31) && ($_ < 255));
	$fill{chr($cid+32)} = $_ ;
	$cid++;
    }
    my @tdy = localtime(time) ;
    $fill{'t'} = (($tdy[5]+1900).(($tdy[4]<9)?'0':'').($tdy[4]+1)
		  .(($tdy[3]<10)?'0':'').$tdy[3]) ;

    $fill{'T'} = (($year+1900).(($mon<9)?'0':'').($mon+1)
		  .(($mday<10)?'0':'').$mday) ;
    $fill{'w'} =~ tr/A-Z/a-z/ ; # lowercase weekdays
    $fill{'n'} =~ tr/A-Z/a-z/ ; # lowercase month-names

    my $esc = chr(1) ;
    $pat =~ s/[\\\%]\%/$esc/g ; # chr(1) should not appear-safer than quoting?

    while($pat =~ /^(.*)(\%)(\+?\-?\d*)(\..)?([ymdTDwWnNefghEFGHti])(.*)$/os) 
    {
	my $subs = $fill{$5}|| "?$5?" ; # unknown pattern? how?
	my $pre = $1 || "" ;
	my $post = $6 || "" ;
	my $siz = $3 || 0 ;
	if($siz) {
	    my $fillChar = $4 || ".0" ;
	    $fillChar =~ s/^\.// ;
	    if($siz > 0) { # trunc from the right, fill on the left
		while(length($subs) < $siz) {
		    $subs = "$fillChar$subs" ;
		}
		$subs = substr($subs, 0, $siz) ;
	    }
	    else { #trunc from the left, fill on the right...
		$siz *= -1 ;
		while(length($subs) < $siz) {
		    $subs .= $fillChar ;
		}
		$subs = substr($subs, length($subs)-$siz) ;
	    }
	}
	$pat = "$pre$subs$post" ;
    }

    $pat =~ s/$esc/\%/gs ; # quoted '%'
    return $pat ;
}


sub rewriteStored {
    # rewrite all references to other entities within the set of stored 
    # documents so that documents also downloaded are referred to relatively
    # while references to non-downloaded entities turn absolute...

    foreach (keys %beenThere) { # all the visited entities
	if($beenThere{$_}->{'file'}) { # a saved entity
	    my $url = $_ ;
	    my $file = $beenThere{$_}->{'file'} ;
	    if(open(RH, "<$file")) {
		my $content = join("", <RH>) ;
		close(RH) ;
		if($content =~ /^\s*\</) {
		    my $newContent = "" ;
		    # rewrite only makes sense for html files... assume, they
		    # can be more or less identified by starting with a '<'
		    # (even if the are named .cgi or whatever...)
		    
		    my $rwcount = 0 ;

		    # identify references
		    while($content =~ s/^(.+?)([SsHh][Rr][CcEe][Ff]?)\s*\=s*[\"\']?([^\"\'\ \>]+)[\"\'\ ]?([^\>]*)\>([^\<]*)//so) {
			my $lead = $1 ;
			my $refkind = $2 ;
			my $refurl = $3 ;
			my $otherAttrs = $4 || "" ;
			my $tagText = $5 || "" ;

			print("rw match:\nlead=$lead\nrefkind=$refkind\nrefurl=$refurl\notherAttr=$otherAttrs\ntagText=$tagText\n\n") if ($verbose > 2) ;
			# make the reference absolute first
			my $absurl = qualifyURL($refurl, $url) ;
			if($absurl) {
			    while($beenThere{$absurl}->{'map'}) {
				# hope, there is no cycle of redirects...
				$absurl = $beenThere{$absurl}->{'map'}
			    }

			    if($beenThere{$absurl}->{'file'}) { # saved entity
				my $relRef = makeRelRef($file, $beenThere{$absurl}->{'file'}) ;
				$newContent .= "$lead$refkind=\"$relRef\"$otherAttrs>$tagText";
				$rwcount++ ;
			    }
			    else { # remote entity - force absolute
				if($refkind =~ /href/i) {
				    $newContent .= "$lead$refkind=\"$absurl\"$otherAttrs>$rewritePre$tagText$rewritePost";
				}
				else {
				    $newContent .= "$lead$refkind=\"$absurl\"$otherAttrs>$tagText";
				}
				$rwcount++ ;
			    }
			}
			else { # could not make sense of this... 'as is'
			    $newContent .= "$lead$refkind=\"$refurl\"$otherAttrs>$tagText";
			}
		    }
		    $newContent .= $content ; # reamining content
		    
		    # now save the modified content with the original timestamp
		    my $timeval = (stat($file))[9] ; # original mtime
		    if(open(WH, ">$file")) {
			print(WH $newContent) ;
			close(WH) ;
			utime(time(), $timeval, $file) ;
			print(STDERR "rewrote $rwcount references in $file\n")
			    if ($verbose > 2) ;
		    }
		    else {
			print(STDERR "can not rewrite $file\n") unless $quiet ;
		    }
		    
		}
		else {
		    print(STDERR "ignoring non-html file $file in rewrite\n") 
			if($verbose > 2) ;
		}
	    }
	    else {
		print(STDERR "can not read $file for rewriting\n") 
		    unless $quiet ;
	    }
	}
    }
}

sub makeRelRef {
    # make a relative reference between two files on the local disk
    my ($base, $target) = (@_) ;
    my @base = split /\//, $base ;
    my @target = split /\//, $target ;
    my $result = "" ;
    while((scalar(@base) > 1) && ($base[0] eq $target[0])) {
	shift @base ;
	shift @target ;
    }
    # this is where they are non equal anymore
    while(scalar(@base) > 1) {
	$result .= "../" ;
	shift @base ;
    }
    $result .= join("/", @target) ;
    return $result ;
}

##############################################################################
# version history:
# v1.01, dec. 22 2000: initial announcement on freshmeat, 
# v1.02, jan. 13 2001: removed bug: "0" arguments to -e not accepted
# v1.03, feb. 02 2001: added statistical summary (-v) on finish
# v1.04, feb. 08 2001: -p now prints the _last_ pattern _after_ eval 
#                => can be used to extract and print text from foreign sites
# v1.05, feb. 16 2001: set saved files timestamp according to http 
#                Last-Modified Header (using HTTP::Date for parsing)
# v1.06, feb. 20 2001: escape real '%' in urls as '\%' or '%%'
# v1.07, feb. 21 2001: %.= in saveAs can flatten url paths' to plain files
# v1.08, mar. 02 2001: %E/%F/%G expand to chr(%e/%f/%g)
#                -E start end counts from ord(start) to ord(end)
#                -w waits between individual downloads ... save the servers
#                fixed a bug in %substitution with multiple %expr ambiguity
# v1.09, mar. 11 2001: implemented +pattern syntax to iterate on same level
#                + complete rewrite of the iterator expansion (now recursive)
# v1.10, mar. 12 2001: honor the new URL (document base) if redirected
#                Warnings and errors now go to STDERR (like they should)
#                saveAs '-' cats everything to STDOUT
#                saveAs '| shellcode' executes shellcode with content on STDIN
#                you can do -a '|mutt -s "%=" myself@mail.edu' for example
#                added (experimantal) pager support for showing the -h help
# v.1.11, mar. 26 2001: catch "partition full" on save (can open for writing
#                but actual write fails)
#                added -q (quiet) option: not even errors are reported
#                \I now expands not only to gif/jpg suffixes but also to png
# v.1.12, jun. 21 2001: added --nocache option so send headers to proxy...
# v.1.13, jul. 11 2001: added 'rewrite' feature: make links in saved documents
#                 relative, if the target was also downloaded, make them
#                 absolute (pointing to the original website) if the target
#                 was not downloaded. most usefull with -A (a bit like getleft)
# v.1.14, jul. 13 2001: just some cleanup of the help/doc
#                 (and a typo fix in the parameter analysis... 
#                 instead of -r for rewrite, i double-used -R
#                 (already used for 'follow hRef only') by mistake).
# v.1.15, jul. 15 2001: perl 5.6 seems to be strict about unknown escape
#                 sequences... some of the examples (stored in one String)
#                 used the string '\s' which produced a warning (thanks to 
#                 Michael M. Tung for the hint)
# v.1.16, aug. 7 2001: manage lists of 'known' urls - not to download again(-K)
# v.1.17, aug. 24 2001: send a static referrer in all downloads (--referer)
# v.1.18, oct. 31 2001: found a hint on 
#     http://www1.ics.uci.edu/pub/websoft/libwww-perl/archive/2000h1/0542.html 
#                  why the code sometimes dies with an
#                  "Unexpected field value ... at .../Message.pm":
#                  it seems like the HTTP Response sometimes returns an
#                  object reference instead of an actual String when asked
#                  about the 'Location'. Passing that reference as a 'Referer'
#                  for the next request may (sometimes) produce an error.
#                  Interpolating (use "$ref" instead of plain $ref) helps.
# v.1.19, jan 29 2002: for non-unix compatibility: open filehandles for
#         storing in binmode unless the mimetype looks like text/...
# v.1.20, jan 31 2002: --rimg: easy syntac for highligting external links on 
#                  rewrite
# v.1.21, Feb. 22 2002: for the -K feature (storage of 'known' URLs we don't 
#                  want to get again), only the new ones are appended to
#                  the file now (instead of rewriting it completely).
#                  this makes it less error prone to run concurrent wgrab 
#                  jobs with the same 'known' file.
#          also:   new feature --printFirstSave prints the (pattern generated)
#                  name of the first file saved to stdout. When wgrab is used
#                  from another script in conjunction with -A (saveAll) to
#                  get, rewrite and store an entire subtree, this printed
#                  filename can be used to generate an entry point into the
#                  saved documents...
#############################################################################
# todo: 
# - some saveAs patterns seem not to work ??? why are the dirs not created?
# - a (clean) way and syntax for applying a perl substitution rule before 
#   processing would be nice
# - honor /robots.txt? maybe optionally?
# - handle cookies (on current session) and reuse existing netsape cookie file
