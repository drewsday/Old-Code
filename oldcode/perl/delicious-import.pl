#! /usr/bin/perl

# delicious import tool for Netscape bookmarks.html files
# Brian Del Vecchio <bdv@hybernaut.com>
# 
# Release 1.4: 10 May 2005
# 
# for more information see http://www.hybernaut.com/bdv/delicious-import.html
#

use strict;
use Getopt::Long;
use HTML::Parser ();
use XML::LibXML;
use URI::Escape;
use Digest::MD5 qw(md5_hex);
use Encode qw(encode_utf8);
use LWP;
use File::stat;
use URI::URL;

use Data::Dumper;

my $p;
my $url;

my %links;
my $current = undef;

my %existing;  # user's existing bookmarks

my @apicalls;  # a queue of API calls, done in batch.

my $cache_time = 6000; # seconds
my $cache_dir = "/tmp/delicious-cache"; # no trailing slash

my $pmode = 0;

my @folders = ( ' ' );

my @delicious_protocols = [ 'http', 'https', 'ftp', 'news' ];
my $ua = undef;

my $version = "1.3";

# configuration options

my $deluser = 0;
my $delpass = "password";

my $opt_itag = ".imported"; # -t: tag for imported bookmarks
my $opt_max  = 0;  # -m: max # of posts; 0 = unlimited
my $opt_exec = 0;  # -x: execute
my $opt_v    = 0;  # -v: verbose
my $opt_fc   = 0;  # -C: force use of cache (for debugging)
my $opt_tag  = 0;  # -z: post with tags derived from folder names
my $opt_del  = 0;  # -D: undo mode (delete posts tagged with -t)

my $opt_kw   = 0;  # -j: promote bookmark keywords to del.icio.us tags
my $opt_dd   = 0;  # -l: promote bookmark descr to del.icio.us extended

my @oktags = ();   # -s: only post items with this specific tag
my @badtags = ();  # -n: exclude items with this tag
               
my @xfolders = ( 'del.icio.us' ); # -k: don't convert these folders to tags


# usage

sub main::HELP_MESSAGE {

    print << 'EndHelp';

  Import Netscape style bookmarks.html to del.icio.us:

  $ delicious-import.pl [-xvCDlj] [-u <user>] [-p <pass>] [-m <max>] [-t <tag>]
        [-z [-k <tag>]+] [-s <tag>]+ [-n <tag>]+ <bookmark-file>

  -x: execute (otherwise dry run by default)
  -v: verbose output
  -C: force use of cache, even if expired (for debugging)
  -D: undo: delete all bookmarks tagged with -t tag

  -u: del.icio.us username
  -p: del.icio.us password
  -m: maximum number of api calls (mostly to limit for testing)
  -t: tag to use for imported links (.imported)

  -l: promote bookmark description to delicious extended info
  -j: convert bookmark keywords to delicious tags
  -z: post with tags derived from folder names
  -k: if -z, don't convert these folder names to tags (multiple)
  -s: only post links having these specific derived tags (multiple)
  -n: don't post links having these tags (multiple)


EndHelp
}

sub main {

    GetOptions( "u=s" => \$deluser,
		"p=s" => \$delpass,
		"t=s" => \$opt_itag,
		"m=i" => \$opt_max,
		"x" => \$opt_exec,
		"v+" => \$opt_v,
		"z" => \$opt_tag,
		"C" => \$opt_fc,
		"D" => \$opt_del,
		"j" => \$opt_kw,
		"l" => \$opt_dd,
		"s=s@" => \@oktags,
		"n=s@" => \@badtags,
		"k=s@" => \@xfolders );

    if (!-d $cache_dir) {
	mkdir $cache_dir;
    }

    $ua = LWP::UserAgent->new;
    $ua->agent("Hybernaut::Importer/$version");
    $ua->timeout(30);
    $ua->protocols_allowed( @delicious_protocols );

    if ($deluser) {
	if ($opt_del) {
	    if ($opt_itag) {
		fetch_posts($opt_itag);
	    } else {
		die "I'm too scared to delete all your bookmarks!\n";
	    }
	} else {
	    fetch_posts();
	}
    } else {
	print "No username specified, so can't check existing bookmarks.\n";
    }
    
    if ($opt_del) {

	delete_posts();
	return;

    }

    ## parse the input file (a Netscape Bookmarks file)

    # Create parser object
    $p = HTML::Parser->new( api_version => 3,
			    handlers => 
			    { start => [\&dispatch, "self, event, tagname, attr"],
			      end => [\&dispatch, "self, event, tagname, attr"] }
			    );

    # Parse directly from file
    if ($opt_dd) {
	$p->report_tags( 'a', 'h3', 'dl', 'dd' );
    } else {
	$p->report_tags( 'a', 'h3', 'dl' );
    }

    $p->unbroken_text(1);
    my $file = shift @ARGV || "bookmarks.html";
    if ($opt_v) {
	print "Reading file $file\n";
    }
    $p->parse_file($file);

    my $counter = 0;

    if ($opt_v > 2) {
	print Dumper( \%links );
    }

    foreach my $i ( sort { $a <=> $b } keys %links ) {

	# respect the configured maximum posts 
	last if ($opt_max && $counter >= $opt_max);

	my $link = $links{$i};

	# skip duplicates
	if ($existing{$link->{hash}}) {

	    if ($opt_v > 1) {
		print "skipping duplicate: " . $link->{url} . "\n\n";
	    }
	    next;
	}

	# selective posting by derived tag
	if ((scalar(@oktags) && ! tag_match($link->{tags}, @oktags)) ||
	    (scalar(@badtags) && tag_match($link->{tags}, @badtags))) {

	    next;
	}

	my $ntags;

	if ($opt_tag) {
	    $ntags = ' ' . filter_tags($link->{tags}, @xfolders);
	}

	if ($opt_v) {
	    print $link->{desc} . "\n" . $link->{url} . "\n";

	    if ($opt_dd) {
		print "extended: " . $link->{extn} . "\n";
	    }

	    if ($opt_tag) {
		print "tags: $opt_itag$ntags\n";
	    }
	    print "\n";
	}

	my $call = "http://" . $deluser . ":" . $delpass .
	    "\@del.icio.us/api/posts/add?tags=$opt_itag$ntags" .
	    "&url=" . uri_escape($link->{url}) .
	    "&description=" . $link->{desc};
	if ($opt_dd && $link->{extn}) {
	    $call .= "&extended=" . $link->{extn};
	}
	$call .= "\n";

	push @apicalls, $call;
	$counter++;
    }

    $counter = 0;

    if ($opt_exec) {

	if (! $deluser) {
	    die "no username specified; can't actually post";
	}

	print "adding " . scalar(@apicalls) . " new bookmarks to del.icio.us: ";

	$| = 1;

	my $counter = 0;

	foreach my $call (@apicalls) {
	    my $req = HTTP::Request->new(GET => $call);
	    my $resp = $ua->request($req);

	    $counter++;
	    
	    if (503 == $resp->code) {
		print STDERR "Throttled after $counter api calls\n";
		last;
	    }
	    print ".";
	    sleep 2;
	}

	print "done\n\n";

	print "View your imported bookmarks here: http://del.icio.us/" . 
	    $deluser . "/" . $opt_itag . "\n";

    } else {
	print "we would be adding " . scalar(@apicalls) . " new bookmarks to del.icio.us\n";
    }
}

# fetch user's posts which match $tag, or all if $tag is empty

sub fetch_posts {

    my ($tag) = @_;

    %existing = ();

    my $cache;
    my $url;

    if ($tag) {
	$cache = "$cache_dir/" . $deluser . "-" . $tag . ".xml";
	$url = "http://" . $deluser . ":" . $delpass . 
	    "\@del.icio.us/api/posts/recent?count=100&tag=$tag";
    } else {
	$cache = "$cache_dir/" . $deluser . ".xml";
	$url = "http://" . $deluser . ":" . $delpass . "\@del.icio.us/api/posts/all";
    }
    if (!$opt_fc && ($tag || !stat($cache) || time - stat($cache)->mtime >= $cache_time)) {

	if ($opt_v) {
	    print "fetching url: $url\n";
	}

	my $req = HTTP::Request->new(GET => $url);
	my $resp = $ua->request($req);
	
	if ($resp->code == 200) {
	    open(FILE,'>',$cache);
	    print FILE $resp->content;
	    close FILE;
	} elsif ($resp->code == 401 || $resp->code == 403) {
	    die "Error connecting to del.icio.us: wrong username/password?";
	} elsif ($resp->code == 503) {
	    die "Server side error connecting to del.icio.us: retry in a few minutes.";
	} else {
	    die "Error " . $resp->code . " connecting to del.icio.us";
	}
    }
    
    my $parser = XML::LibXML->new();
    my $tree = $parser->parse_file($cache);
    my $root = $tree->getDocumentElement;
    my @posts = $root->getElementsByTagName('post');

    # build a hash of all existing bookmarks, by hashed URL.
    foreach my $post (@posts) {

	my $hash = $post->getAttribute('hash');
	$existing{$hash} = $post->getAttribute('href');
    }

}

sub delete_posts {

    my $count = keys %existing;
    my $counter = 0;
    $| = 1;

    print "deleting $count posts:";

    foreach my $pkey (keys %existing) {
	my $post = $existing{$pkey};

	my $url = "http://" . $deluser . ":" . $delpass .
	    "\@del.icio.us/api/posts/delete?" .
	    "&url=" . uri_escape($post);

	if ($opt_exec) {
	    my $req = HTTP::Request->new(GET => $url);
	    my $resp = $ua->request($req);
	    $counter++;

	    if (503 == $resp->code) {
		print STDERR "Throttled after $counter api calls\n";
		last;
	    }

	    print ".";
	    sleep 2;
	}
    }

    print "done\n\n";

}

# test if any tags in space-separated string $tags match any in list2

sub tag_match {

    my ($tags, @list2) = @_;

    foreach my $t1 (split ' ', $tags) { 
	foreach my $t2 (@list2) {
	    if ($t1 eq $t2) {
		return 1;
	    }
	}
    }
    
    return 0;
}

# filter a tag list for uniqueness, excluding specified tags

sub filter_tags {

    my ($tags, @exclude) = @_;

    my @new = ();

    foreach my $t (split ' ', $tags) {
	if (! tag_match($t, @exclude)) {
	    push @new, $t;
	}
    }

    return join ' ', @new;
}

my %dispatch = ( start => { a => \&start_a_tag,
			    h3 => \&start_h3_tag,
			    dd => \&start_dd_tag },
		 end => { a => \&end_a_tag,
			  dl => \&end_dl_tag }
		 );

sub dispatch {
    my($self, $event, $tagname, $attr) = @_;

    my $func = $dispatch{$event}{$tagname};

    if ($func) {
	&$func;
    }
}

sub start_a_tag {

  my($self, $event, $tagname, $attr) = @_;

  # stash the url in global variable
  $url = $attr->{href};
  my $kw = $attr->{shortcuturl};

  # del.icio.us only accepts thse protocols
  if ($url =~ /^(http|https|ftp|news):/) {

      my $hash = md5_hex(encode_utf8($url));

      # already on our list?
      if ($links{$hash}{hash} ne $hash) {

	  $links{$hash}{hash} = $hash;
	  $links{$hash}{url} = $url;

      }

      $links{$hash}{shortcuturl} = $attr->{shortcuturl};
      $links{$hash}{tags} .= ' ' . join ' ', @folders;
      if ($opt_kw) {
	  $links{$hash}{tags} .= ' ' . $attr->{shortcuturl};
      }

      # save current link in global state
      $current = $links{$hash};

      $self->handler( text => \&text_a_tag, "self,dtext");

  }
 
}

sub start_dd_tag {

    my($self, $event, $tagname, $attr) = @_;

    $self->handler( text => \&text_dd_tag, "self,dtext");

}


sub text_dd_tag {

  my($self, $dtext) = @_;

  # strip whitespace at front and back
  $dtext =~ s/^\s+//m;
  $dtext =~ s/\s+$//m;

  $current->{extn} = $dtext;
}


sub text_a_tag {

  my($self, $dtext) = @_;
  my $url = $current->{url};

  $current->{desc} = $dtext;

}

sub end_a_tag {

  my($self) = @_;

  $self->handler( text => undef );

}


sub start_h3_tag {

  my($self, $event, $tagname, $attr) = @_;

  return if ($attr->{personal_toolbar_folder} eq 'true');

  $self->handler( text => \&text_h3_tag, "self,dtext");

}

sub text_h3_tag {

  my($self, $text) = @_;
  
  $self->handler( text => undef );

  # replace spaces with dashes
  $text =~ tr/ /-/;
  $text = lc($text);

  push @folders, $text;
}

sub end_dl_tag {

  my($self) = @_;

  my $off = pop @folders;

}


main();
1;

__END__

ChangeLog:


10 May 2005 Release 1.4

    - add protection against wide UTF-8 characters in URLs

15 Feb 2005 Release 1.3

    - post bookmark description text -> extended
    - post bookmark keywords -> extended (user option)

5 Dec 2004 Release 1.2

    - when fetching posts for -D, request only those matching tag
    - new -k option: suppress derived tags (i.e. del.icio.us, when bookmarks
      were generated with foxylicious)
    - if a link appears twice in the input, only post once, with aggregated tags
    - fixed supported protocols (was only http, https)
    - removed obsolete/incorrect code to fetch popular tags
    - removed obsolete url HEAD checking code
    - new -n option: exclude links matching any of these tags
    - -s option may now be specified multiple times
    - fixed a problem where the ".imported" tag wasn't added if -z omitted.

3 Dec 2004 Release 1.1

    - don't try to do real posting when we have -x but no username
    - force refresh of cache when using -D option
    - new -m option specifies maximum links to post (mostly to limit during testing)
    - new -z option derives tags from folder names
    - new -s option posts only links with specific derived tag.

3 Dec 2004 Release 1.0
