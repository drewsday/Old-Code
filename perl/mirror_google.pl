#!/usr/bin/perl

# script to mirror a website from google's cache
#  ueseful if the site is down, perhaps for good...

# this probably works only on unix varients...

# by William Huston 23 Jun 2001
# bhuston@mu.clarityconnect.net
# http://mu.clarityconnect.net/~bhuston/perl/mirror_google/
#
# GPL or Artistic license. No warranty!
# Feedback, bugfixes, etc. welcome
#

# v0.1 Beta ... may still have bugs regarding URLs w/#anchor tags
#   especilly w/something like http://whatever/dir/#foo
#   where the anchor is on a dir with an implied filename


# TODO:
# should probably make content links relative, as wget...
# make traversal options like --no_parent, --all_domain --all_host, etc.
# Every so often, tell me the status of %links: total, got(1), bad(-1), need2get(0) 

# Caveats:
#   1: google doesn't save images
#   2: this script does not relative-ize content links as does wget
#   3: google's cache may be incomplete (for many reasons; Robot Exclusion, etc)
#   4: dynamicly generated pages (CGIs) may be present, but may get 
#        weird filenames due to URI encodings of the QUERY_STRING
#   5: of course, pages on the orig host that call cgi's will be broken in the mirror
#
# ... but, if the site is down for good, getting something may be better than nothing!


use URI::Escape;       # for URI escaped codings
use LWP::UserAgent;    # the crawler
use HTML::SimpleLinkExtor; # extract the links
use SDBM_File;             # a simple tied hash class free w/perl
use Fcntl qw( O_RDWR O_CREAT );  

tie (%links, "SDBM_File", "links", O_RDWR|O_CREAT, 0644) 
    or die "can't open links.db";

$fake_user_agent="Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)";

# ----------  main  -----------------

if ($url=shift) {

  # for my purposes, I wanted ANYTHING from any host in the domain.
  # thus, I throw away links not matching /$domain/ 
  # you may want to restrict not by domain but by host, or even
  # within a particular directory on a host...

  ($host) = ($url =~ m!^([^/]*)!);
  ($domain)= ($host =~ m!^.+\.(\w+\.\w+)$!);
  $restrict = $domain;  # throw away links not matching this

  traverse ($url);
  
  # repeat until we make a complete pass without finding a new link

  $gotone=1;
  while ($gotone) {  
    $gotone=0;
    foreach my $link (keys %links) {
      # assume these have already been "fixed" when entered
      next if $links{$link};
      traverse ($link);
      $gotone=1;
    } 
  }
} else { 
  print "Usage: $0 webpage\n";
  exit;
}

# -------------------------------------------------------------
# traverse a single URL, save content as $PWD/hostname/dir/file 
#   extract links to %links DB 
# -------------------------------------------------------------

sub traverse {
   my ($url) = @_;

   if (/^ftp:/i || /^mailto:/i || /^gopher:/i || /^telnet:/) {
      ($scheme=$url)=~s/(^[^:]+):.*$/$1/; 
      print "Can't traverse scheme ($scheme) in url $url\n";
   } 

   print "traversing $url ...\n";
  
   ($page = $url) =~ s!^http://!!i;  

   $page=uri_escape($page);

   $filename=$page;

   # make it look as google wants it:

   $page = "http://www.google.com/search?q=cache:$page&hl=en";

   #print "page: $page\nfilename: $filename   host: $host   domain: $domain\n";

   if ($filename =~ m!^(.*)/(.*)$!) {
     $dir=$1; $leaf=$2;
     $leaf="index.html" unless $leaf;
   }else{
     $dir=$filename; $leaf="index.html"; 
   }

   print "dir: $dir  leaf: $leaf\n";

   $response=fetch_page($page);
   my $extor = HTML::SimpleLinkExtor->new();
   print "$response->{_rc} $response->{_msg}\n\n";

   if (($response->{_content} =~ /no content found for this URL|did not match any documents/ ) ||
       ($response->{_rc} =~ /^[45]/))  {

      print "Bummer: No Content Found for $url!\n";

      # probably don't need a fix here, since this 
      # was likely fixed when first entered...

      $links{fix_link($url)}=-1;  # we visited this one and it's bad

   } else {

     # probably don't need a fix here, since this 
     # was likely fixed when first entered...

     $links{fix_link($url)}=1;  # we visited this one and it's good

     $extor->parse($response->{_content});
     @all_links   = $extor->links;
     ($base) = $extor->base;
     print "Base: ($base)\n";

     foreach my $link (@all_links) {
        if ($link =~ /$restrict/) {
          my $fixed=fix_link($link);  # THIS is where the fix really matters 
          if (!defined $links{$fixed}) {
             $links{$fixed}=0; 
             print "Adding $fixed to database...\n";
          } # else it's already been found ... so what
        } else {
          print "$link not in $restrict ... discarding\n";
        }
     }

     # strip off the google header
     $response->{_content} =~ s/^.*?<hr>\n//sm;

     # write the content to a file
     `mkdir -p $dir 2>/dev/null`;  
     open F, ">$dir/$leaf" or warn "can't open $dir/$file for write: $! $?";
     print F $response->{_content};
     close F;
  }
} 

sub fetch_page ($) {
  my ($page) = @_;
  $ua = LWP::UserAgent->new;
  $ua->agent($fake_user_agent);
  $request = HTTP::Request->new('GET', $page);
  $response = $ua->request($request);
  return $response;  
} 

sub fix_link ($) {
   # perhaps do other things here, like downcase host.domain
   my $link=shift;
   $link =~ s/#.*$//g;   # get rid of anchor names
   return $link; 
}

# this is the structure of LWP::UserAgent response

#  _request  
#  _protocol  
#  _content
#  _headers
#          client-peer
#          connection
#          etag
#          client-date
#          title
#          content-type
#          content-length
#          last-modified
#          accept-ranges
#          date
#          server
#  _rc
#  _msg
