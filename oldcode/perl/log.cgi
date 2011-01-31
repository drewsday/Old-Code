#!/usr/bin/perl

print "Content-type: text/html\n\n";

# the first line MUST point to the location of perl on your server if
# you are running this program on a unix server.
# you may try also "#!/usr/local/bin/perl".
# for microsoft OS the path is C:/Perl or something like that,
# depending where Perl is installed at.
# note: for microsoft OS there is no need to chmod folders and the script.
##########################################################################
# free CGI scripts by Homemade Scripts / copyright.
# free download at http://www.automarktregistrierung.de/webmaster.html.
# author may not be held responsible
# for any damage caused by use of this script.
# you may change this script for your needs.
# if you need help for setup or like to customize this script,
# or if you found a bug, or any comments,
# drop mail to "deschakovskiholger@freenet.de".
#######################################################################
# set up to be done by admin.
#
# create a folder named maybe "diary2002" inside your cgi-bin.
# chmod folder "diary2002" 755 (or maybe 777 if you get errors with 755).
# upload "diary2002.cgi" in your "diary2002" folder.
# chmod "diary2002.cgi" 755.

$homepath = "/var/www/cgi-bin/observatory";
# absolute homepath to your "diary2002" folder according to your site.
# leave the backslash "/" at the end of homepath.

# following variables maybe changed if you like to!!!

$textdir = "articles";
# name of folder where articles are stored.
# this folder will be created by diary2002 inside your "diary2002" folder.
# you may rename this folder according to your needs.

$userdir = "user";
# name of folder where user info is stored.
# this folder will be created by diary2002 inside your "diary2002" folder.
# you may rename this folder according to your needs.

# following custom variables / do setup.

$css = "
<style>
A:link {color=\"000000\"; text-decoration : underline;}
A:active {color=\"FF0000\"; text-decoration : underline;}
A:visited {color=\"000000\"; text-decoration : underline;}
A:hover {color=\"FF0000\"; text-decoration : underline;}
</style>";
# stylesheet for link layout control.
# change the color codes the way you like them.

$logo = "http://tbone.physics.niu.edu/mars_enhanced8-08-03crop.jpg";
# full url to your logo graphic: http://www.yoursite.com/mylogo.jpg.
# dont give your logo inside your cgi-bin,
# some webservers settings dont allow serving graphic files out of the cgi-bin.

$homelink = "0";
# if you like to have an backlink to your main site / index displayed,
# please enable variable homelink by changing the "0" to "1" -> $homelink = "1";
# by default no homelink is displayed.

$secure = "rooski";
# this is a unique/confidential code to secure your admin area.
# please change this code. give in numbers and letters the way you like it.
# please use no spaces and none of following characters->
# & ? * + ^ $ | \ ( ) [ ]{ } " ' / § ´ ` ~ > < ° % µ = ; , : .

# last step:
# call diary2002.cgi with your browser like this:
# http://www.yoursite.com/cgi-bin/diary2002/diary2002.cgi
# follow instructions displayed on screen.

# there should be no more work to do for you.
# you will be able to change the layout and user info,
# like password and user name plus many more inside your admin area.
#######################################################################
# initiate cgi modul.
use CGI;
my $cgi = new CGI;
use CGI::Carp qw(fatalsToBrowser);

# relative script path.
$rel = $cgi->url(-relative=>1);

# extract your main site url for automated backlink.
$full = $cgi->url(-full => 1);
$script = $cgi->script_name();
$scriptle = length($script);
substr($full, -$scriptle) = "";
#######################################################################
# absolute pathes for directorys.
$textdirectory = "$homepath/$textdir";
$userdirectory = "$homepath/$userdir";
$| = 1;
#######################################################################

# control if file text exists.
$showcontrol = -e "$userdirectory/file.txt";

# if $showcontrol doesnt exist, initiate first time run.
# first time run code following now.
if ("$showcontrol" ne "1") {


# create directorys.
chdir("$homepath");
mkdir($textdir, 0755); # textdirectory where articles are stored.
mkdir($userdir, 0755); # userdirectory where user info is stored.

# print your user info file first time.
open (PRO,">$userdirectory/file.txt");
print PRO "admin\n";
print PRO "pwd";
close(PRO);

# print your layout info file first time.
open (ENV,">$userdirectory/layout.txt");
print ENV "my online journal\n";
print ENV "#FFFFFF\n";
print ENV "#000000\n";
print ENV "4\n";
close (ENV);

# print welcome and instructions for first time use.
print "<h2>welcome to diary2002 - my online journal</h2>";
print "please follow instructions for first time run.<p>";
print "use following: username = 'admin', password = 'pwd' for first time \"admin login\"<br>";
print "login immediately and change your username and password.<br>";
print "inside your admin area you may also change the layout for diary2002<p>";
print "(this info will show up only one time)<p><br>";}
#######################################################################
#######################################################################
#######################################################################
# definition for parameters coming in from html forms.

# for sub "open" & "process".
$user1 = $cgi->param('user');
$pass1 = $cgi->param('pass');

# for sub "post".
$title = $cgi->param('title');
$article = $cgi->param('article');

# for sub "delete".
@file = $cgi->param('file');

# for sub "prolayout".
$slogan1 = $cgi->param('slogan');
$back1 = $cgi->param('back');
$font1 = $cgi->param('font');
$number1 = $cgi->param('number');

# for sub "searchme".
$search = $cgi->param('search');
$moder = $cgi->param('moder');

# for sub "disp".
$art = $cgi->param('art');

# for security.
$sec = $cgi->param('sec');

# for sub "display".
$mode = $cgi->param('mode');
$revdis = $cgi->param('revdis');

# for sub "newpost" mode edit article.
$eart = $cgi->param('eart');

# for sub "post" mode edit article.
$eartdel = $cgi->param('eartdel');
######################################################################
# start the show!
# get layout variables.
&layout;

# get time and date. print html.
&timer;
$dat = "current date and time $date | $time";

print "<html>\n";
print "<head>\n";
print "$head\n";
print "$css\n";
print "</head>\n";

print "<body bgcolor=\"$backcolor\"><center>\n";
print "<table border=0 width=700><tbody><tr valign=top>\n";
print "<td align=left><img src=\"$logo\" border=0 alt='$slogan'></td>\n";
print "<td align=left><font color=\"$fontcolor\" size=\"+3\">$slogan</font>\n";
print "<br><font color=\"$fontcolor\">$dat</font>\n";

print "<table border=0 cellspacing=10><tbody><tr>\n";

if ("$homelink" eq "1") { print "<td><a href='$full'>main site</a></td>"; }
else {}

print "<td><a href='$rel?display'>read entries</a></td>";
print "<td><a href='$rel?search'>search</a></td>\n";
print "<td><a href='$rel?pwd'>login</a></td>\n";
print "</tr></tbody></table>\n";

print "</td></tr></tbody></table>\n";

print "<table border=0 width=700 cellspacing=50><tbody><tr valign=top><td>";
if($ENV{'QUERY_STRING'} =~ /newpost&sec=$secure/g){&newpost;}
elsif($ENV{'QUERY_STRING'} =~ /delpost&sec=$secure/g){&delpost;}
elsif($ENV{'QUERY_STRING'} =~ /admin&sec=$secure/g){&admin;}
elsif($ENV{'QUERY_STRING'} =~ /display&mode=/g){&display;}
elsif($ENV{'QUERY_STRING'} eq 'post') {&post;}
elsif($ENV{'QUERY_STRING'} eq 'delete') {&delete;}
elsif($ENV{'QUERY_STRING'} =~ /delall&sec=$secure/g) {&delall;}
elsif($ENV{'QUERY_STRING'} eq 'process') {&process;}
elsif($ENV{'QUERY_STRING'} eq 'pwd') {&pwd;}
elsif($ENV{'QUERY_STRING'} eq 'open') {&open;}
elsif($ENV{'QUERY_STRING'} eq 'prolayout') {&prolayout;}
elsif($ENV{'QUERY_STRING'} eq 'search') {&search;}
elsif($ENV{'QUERY_STRING'} eq 'searchme') {&searchme;}
elsif($ENV{'QUERY_STRING'} =~ /searchme&search=$search&moder=/g) {&searchme;}
elsif($ENV{'QUERY_STRING'} =~ /disp&art=/g) {&disp;}
elsif($ENV{'QUERY_STRING'} =~ /edit&sec=$secure/g) {&edit;}
elsif($ENV{'QUERY_STRING'} eq 'edit') {&edit;}
else {&display;}
print "</td></tr></tbody></table>";

print "</center></body></html>\n";

######################################################################
# post new article.

sub newpost {

if ("$sec" ne "$secure") { &display; }
else {

if ("$eart" eq "") {
print "<h2><font color=\"$fontcolor\">post new article.</font></h2>"; }

else {
open (ER,"$textdirectory/$eart");
@er = <ER>;
close(ER);

$eftitle = shift(@er);
chomp($eftitle);
$eflast = pop(@er);

print "<h2><font color=\"$fontcolor\">edit article $eart</font></h2>";
print "<font color=\"$fontcolor\">edit your article.<br>click <i>save-edit</i> button to store changes.<br>click <i>leave-like-is</i> button, no changes will be stored.<p></font>"; }

print "<form action=\"$rel?post\" method=\"post\">";
print "<table border=0 cellPadding=3><tbody>";
print "<tr><td><font color=\"$fontcolor\">title</font>&nbsp;&nbsp;";

if ("$eart" eq "") {
print "<INPUT type=text name=title size=55></td></tr>"; }
else { print "<INPUT type=text name=title size=55 value='$eftitle'></td></tr>"; }

print "<tr><td><textarea name=article cols=50 rows=10>";

if ("$eart" eq "") {}
else { foreach $er (@er) { chomp($er); print "$er"; } }

print "</textarea></td></tr></tbody></table>";

if ("$eart" eq "") {
print "<INPUT name=submit type=submit value=submit>&nbsp<INPUT name=reset type=reset value=reset></form>"; }

else {
print "<table border=0><tr>";
print "<INPUT type=hidden name=eartdel value=$eart>";
print "<td><INPUT name=submit type=submit value=save-edit></td></form>";

print "<td><form action=\"$rel?edit\" method=\"post\">";
print "<INPUT type=hidden name=sec value=$secure>";
print "<INPUT name=submit type=submit value=leave-like-is></td></form>";
print "</tr></table>"; }

print "<p><font color=\"$fontcolor\">INFO: if you like to post a link to an website.<br>please use following html syntax:<br><i>&lta href=\"http://www.sitename.com\"&gtsitename&lt/a&gt</i><br>or following for posting an email adress:<br><i>&lta href=\"mailto:webmaster\@yoursite.com\"&gtwebmaster\@yoursite.com&lt/a&gt</i></font>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";

if ("$eart" eq "") {
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n"; }
else { print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n"; }

print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } }
######################################################################
# display articles.

sub display {

chdir ("$textdirectory");
@text = glob "*.txt";

if ("$revdis" eq "") { @sort = sort {$b <=> $a} @text; }
else { @sort = sort {$a <=> $b} @text; }

#print "<h2><font color=\"$fontcolor\">read articles.</font></h2>";

if (@sort == 0) {
print "<font color=\"$fontcolor\">soorry. no articles to read.</font>"; }

else {
#&counter;
#$countdisplay = "number of articles online: $oldcount";
#print "<font color=\"$fontcolor\">$countdisplay</font>";

if (@sort <= $artnr) {

foreach $text (@sort){

open (TEXT,"$textdirectory/$text");
@tex = <TEXT>;
close (TEXT);

$line = shift(@tex);
$popdate = pop(@tex);

print "<table border=1 cellpadding=5 width=600><tbody>";
print "<tr><td align=left><font color=\"$fontcolor\"><b>$line</b></font></td></tr>";
print "<tr><td align=left><font color=\"$fontcolor\">";

foreach $textline (@tex) { print "$textline<br>"; }

print "</font><p>";
print "<font color=\"$fontcolor\" size=\"-1\">$popdate</font></td></tr>";
print "</tbody></table><p>"; } 

&counter;
$countdisplay = "number of log entries online: $oldcount";
print "<font color=\"$fontcolor\">$countdisplay</font>";

}

else {
if ("$mode" eq "") { $mode = 1; } else {}

#print "&nbsp;<font color=\"$fontcolor\">| page no.: $mode.</font><br>";
#print "<font color=\"$fontcolor\">$artnr articles displayed at one page.</font><br>";

#if ("$revdis" eq "") {
#print "<font color=\"$fontcolor\">sort display: old articles <-> new articles 
#<a href='$rel?display&mode=$mode&revdis=rdis'>click here</a>.</font><p>"; }

#else {
#print "<font color=\"$fontcolor\">sort display: new articles <-> old articles 
#<a href='$rel?display&mode=$mode'>click here</a>.</font><p>"; }

&navi;

print "<font color=\"$fontcolor\"><b>navigation:</b></font>&nbsp;@navi<p>";

do {
$shifttext = shift(@sort);
open (TEXT,"$textdirectory/$shifttext");
@tex = <TEXT>;
close (TEXT);

$line = shift(@tex);
$popdate = pop(@tex);

print "<table border=1 cellpadding=5 width=600><tbody>";
print "<tr><td align=left><font color=\"$fontcolor\"><b>$line</b></font></td></tr>";
print "<tr><td align=left><font color=\"$fontcolor\">";

foreach $textline (@tex) { print "$textline<br>"; }

print "</font><p>";
print "<font color=\"$fontcolor\" size=\"-1\">$popdate</font></td></tr>";
print "</tbody></table><p>";
} until (@sort == 0);

print "<font color=\"$fontcolor\"><b>navigation:</b></font>&nbsp;@navi";


if ("$revdis" eq "") {
print "<font color=\"$fontcolor\">sort display: old articles <-> new articles <a href='$rel?display&mode=$mode&revdis=rdis'>click here</a>.</font><p>"; }
                                                                                                  
else {
print "<font color=\"$fontcolor\">sort display: new articles <-> old articles <a href='$rel?display&mode=$mode'>click here</a>.</font><p>"; }
                                                                                                  

}# else close.
} }
######################################################################
sub navi {

$dcount = @sort / $artnr;

if ($dcount =~ /\./g) { @split = split(//, $dcount);
do { $popn = pop(@split); } until ("$popn" eq ".");
$dcount = "@split"; $dcount =~ s/ //g; $dcount++; } else {}

# create display navgation bar.
@navi = (); $ncount = 0;

foreach (1..$dcount) {
$ncount++;

if ("$revdis" eq "") { $navi = "<a href='$rel?display&mode=$ncount'>page$ncount</a>"; }
else { $navi = "<a href='$rel?display&mode=$ncount&revdis=rdis'>page$ncount</a>"; }

push(@navi, $navi); }
# end navigation bar.


# limit articles number display.
@display = ();
$startc = $mode * $artnr; $start = ($startc - $artnr) - 1;
$discount = 0;
do { $discount++; $start++; push(@display, $sort[$start]); }
until (($discount == $artnr) | ("$sort[$start]" eq ""));

if ("$sort[$start]" eq "") { pop(@display); } else {}
@sort = @display; }
######################################################################
# process new post.

sub post {

if (("$title" eq "") || ("$article" eq ""))
{print "<font color=\"$fontcolor\">alert no data input. please return&nbsp;<a href='$rel?pwd'>click here</a>.</font>";}

else {
$title =~ s/^\s+//; $title =~ s/\s+$//;
$article =~ s/^\s+//; $article =~ s/\s+$//;

if ("$eartdel" eq "") { &counter; }

else { $eartdel =~ s/\D//g; $newcount = "$eartdel"; }

&timer;

$countin = "article number: $newcount";
$posted = "posted $date | $time";

open (NEW,">$textdirectory/$newcount.txt");
print NEW "$title\n";
print NEW "$article\n";
print NEW "$posted | $countin\n";
close (NEW);

if ("$eartdel" eq "") {
print "<h2><font color=\"$fontcolor\">new article no.: <i>$newcount</i> / title: <i>$title</i> posted.</font></h2>";
print "<a href='$rel?display'>click here to read</a>"; }

else { print "<h2><font color=\"$foncolor\">saved changes to article no.: <i>$newcount</i> / title: <i>$title</i>.</font></h2>"; }

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } }
######################################################################
# get time and date.

sub timer {
use POSIX qw(strftime);
$date = strftime "%d-%m-%Y", localtime;
$time = strftime "%H:%M:%S", localtime;}
######################################################################
# counter for articles.

sub counter {
chdir("$textdirectory");
@count = glob "*.txt";

$oldcount = @count;
if (@count == 0) { $newcount = 1; }
else { $newcount = $oldcount + 1; } }
######################################################################
# delete article form.

sub delpost {

if ("$sec" ne "$secure") { &display; }
else {

chdir ("$textdirectory");
@deleteun = glob "*.txt";
@delete = sort {$a <=> $b} @deleteun;

print "<h2><font color=\"$fontcolor\">delete articles.</font></h2>";

if (@delete == "0") {
print "<font color=\"$fontcolor\">no articles to delete. please post one.</font>&nbsp;";
print "<a href='$rel?newpost&sec=$secure'>click here</a>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; }

else {
print "<font color=\"$fontcolor\">delete all articles</font>&nbsp;<a href='$rel?delall&sec=$secure'>click here</a>.<br>";
print "<font color=\"$fontcolor\">or choose articles to be deleted.</font>";
print "<form action=\"$rel?delete\" method=\"post\">";
print "<table border=1 cellPadding=3><tbody>";
print "<tr><th><font color=\"$fontcolor\">article no.</font></th><th><font color=\"$fontcolor\">title</font></th><th><font color=\"$fontcolor\">display article</font></th></tr>";

foreach $del (@delete) {

open (DEL,"$del");
@tit = <DEL>;
$tit = shift(@tit);
close (DEL);

print "<tr><td><INPUT type=checkbox name=file value=$del>&nbsp<font color=\"$fontcolor\">$del</font></td><td><font color=\"$fontcolor\">$tit</font></td><td><a href='$rel?disp&art=$del' target='_blank'>click to display $del</a></td></tr>"; }

print "</tbody></table><p>";
print "<INPUT name=submit type=submit value=delete>&nbsp<INPUT name=reset type=reset value=reset></form>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; }}}
######################################################################
# process delete articles.

sub delete {

if ("@file" eq "")
{ print "<font color=\"$fontcolor\">alert no data input. please return&nbsp;<a href='$rel?pwd'>click here</a>.</font>"; }

else {
$fc = @file;

foreach $file (@file) {
unlink "$textdirectory/$file";
print "<font color=\"$fontcolor\">$file deleted.<br></font>"; }

print "<h4>$fc articles deleted</h4>";

chdir ("$textdirectory");
@rebuildun = glob "*.txt";
@rebuild = sort {$a <=> $b} @rebuildun;

if (@rebuild == 0) {}

else {

$rc = 0;
do {
$rc++;
$rebuild = shift(@rebuild);
substr ($rebuild, -4) = "";

if ($rebuild == $rc) {}

else {

open (BUILDER,"$textdirectory/$rebuild.txt");
@build = <BUILDER>;
$builddate = pop(@build);
close(BUILDER);

do { chop($builddate); $zero = length($builddate); } until ($zero == 46);

$newdate = "$builddate $rc";
push(@build, $newdate);

open (BU,">$textdirectory/$rebuild.txt");
foreach $build (@build) { chomp($build); print BU "$build\n"; }
close(BU);

rename ("$rebuild.txt" , "$rc.txt");
print "<font color=\"$fontcolor\">$rebuild.txt renamed to $rc.txt.</font><br>"; }
}until (@rebuild == 0); }# else close.

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } }
######################################################################
# delete all articles.

sub delall {

if ("$sec" ne "$secure") { &display; }
else {

chdir ("$textdirectory");
@delallun = glob "*.txt";
@delall = sort {$a <=> $b} @delallun;


foreach $delall (@delall){
unlink "$textdirectory/$delall";
print "<font color=\"$fontcolor\">$delall deleted.<br></font>"; }

print "<h2><font color=\"$fontcolor\">all articles deleted.</font></h2>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } }
######################################################################
# admin area.

sub admin {

if ("$sec" ne "$secure") { &display; }
else {

open (UV,"$userdirectory/file.txt");
@uv = <UV>;
close(UV);

$userv = shift(@uv); chomp($userv);
$passv = shift(@uv); chomp($passv);

print "<h2><font color=\"$fontcolor\">admin area.</font></h2>";
print "<font color=\"$fontcolor\"><b>1. set username and password.</b></font><br>";
print "<font color=\"$fontcolor\">please use no spaces.</font>";

print "<form action=\"$rel?process\" method=\"post\">";
print "<table border=0 cellPadding=3><tbody>";
print "<tr valign=top><td><font color=\"$fontcolor\">username</font></td>";
print "<td><INPUT type=text name=user size=30></td>";
print "<td><font color=\"$fontcolor\">actual value -> <i>$userv</i></font></font></td></tr>";

print "<tr valign=top><td><font color=\"$fontcolor\">password</font></td>";
print "<td><INPUT type=text name=pass size=30></td>";
print "<td><font color=\"$fontcolor\">actual value -> <i>$passv</i></font></font></td></tr>";

print "</tbody></table>";
print "<INPUT name=submit type=submit value=submit>&nbsp<INPUT name=reset type=reset value=reset></form>";

print "<font color=\"$fontcolor\"><p><b>2. set layout variables.</b><br></font>";

print "<form action=\"$rel?prolayout\" method=\"post\">";
print "<table border=0 cellPadding=3><tbody>";

print "<tr valign=top><td><font color=\"$fontcolor\">slogan for your journal</font></td>";
print "<td><INPUT type=text name=slogan size=40>";
print "<br><font color=\"$fontcolor\">e.g. my personal diary.</font></td>";
print "<td><font color=\"$fontcolor\">actual value -> <i>$slogan</i></font></font></td></tr>";

print "<tr valign=top><td><font color=\"$fontcolor\">background color</font></td>";
print "<td><INPUT type=text name=back size=40>";
print "<br><font color=\"$fontcolor\">e.g. #FFFFFF, which is white.</font></td>";
print "<td><font color=\"$fontcolor\">actual value -> <i>$backcolor</i></font></font></td></tr>";

print "<tr valign=top><td><font color=\"$fontcolor\">font color</font></td>";
print "<td><INPUT type=text name=font size=40>";
print "<br><font color=\"$fontcolor\">e.g. #000000, which is black.</font></td>";
print "<td><font color=\"$fontcolor\">actual value -> <i>$fontcolor</i></font></font></td></tr>";

print "<tr valign=top><td><font color=\"$fontcolor\">number of articles<br>displayed on one site</font></td>";
print "<td><INPUT type=text name=number size=10>";
print "<br><font color=\"$fontcolor\">e.g. 4, only the number nothing else.</font></td>";
print "<td><font color=\"$fontcolor\">actual value -> <i>$artnr</i></font></font></td></tr>";

print "</tbody></table>";
print "<INPUT name=submit type=submit value=submit>&nbsp<INPUT name=reset type=reset value=reset></form>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "</tr></tbody></table>\n";

print "<table border=1 cellspacing=0 cellpadding=5><tbody>";
print "<tr><td><font color=\"$fontcolor\"><b>some hexadezimal color codes:</b></font></td></tr>";
print "<tr><td>";
print "<table border=0 cellspacing=10><tbody>";
print "<tr><td>#FF0000</td><td><font color='#FF0000'>= red</font></td>";
print "<td>#0000FF</td><td><font color='#0000FF'>= blue</font></td>";
print "<td>#008000</td><td><font color='#008000'>= green</font></td></tr>";

print "<tr><td>#FFFF00</td><td><font color='#FFFF00'>= yellow</font></td>";
print "<td>#FF6347</td><td><font color='#FF6347'>= tomato</font></td>";
print "<td>#EE82EE</td><td><font color='#EE82EE'>= violet</font></td></tr>";

print "<tr><td>#C0C0C0</td><td><font color='#C0C0C0'>= silver</font></td>";
print "<td>#A52A2A</td><td><font color='#A52A2A'>= brown</font></td>";
print "<td>#808080</td><td><font color='#808080'>= grey</font></td></tr>";

print "<tr><td>#00BFFF</td><td><font color='#00BFFF'>= deepskyblue</font></td>";
print "<td>#FF69B4</td><td><font color='#FF69B4'>= hotpink</font></td>";
print "<td>#FFE4B5</td><td><font color='#FFE4B5'>= moccasin</font></td></tr>";

print "<tr><td>#800080</td><td><font color='#800080'>= purple</font></td>";
print "<td>#000080</td><td><font color='#000080'>= navy</font></td>";
print "<td>#FFA500</td><td><font color='#FFA500'>= orange</font></td></tr>";
print "</tbody></table>";
print "</td></tr></tbody></table>";
} }
######################################################################
# process user info / password / username.

sub process {

if (("$user1" eq "") && ("$pass1" eq ""))
{print "<font color=\"$fontcolor\">alert no data input. please return&nbsp;<a href='$rel?pwd'>click here</a>.</font>";}

else {
open (PRO,"$userdirectory/file.txt");
@proin = <PRO>;
close(PRO);
$autouser = shift(@proin); chomp($autouser);
$autopass = shift(@proin); chomp($autopass);

open (PRO,">$userdirectory/file.txt");

if ("$user1" ne "") { $user1 =~ s/^\s+//; $user1 =~ s/\s+$//; print PRO "$user1\n"; }
else { print PRO "$autouser\n"; }

if ("$pass1" ne "") { $pass1 =~ s/^\s+//; $pass1 =~ s/\s+$//; print PRO "$pass1\n"; }
else { print PRO "$autopass\n"; }
close(PRO);

print "<font color=\"$fontcolor\"><h2>new user info set.</h2></font>";
if ("$user1" ne "") {
print "<font color=\"$fontcolor\">username = $user1.</font><br>"; }
if ("$pass1" ne "") {
print "<font color=\"$fontcolor\">password = $pass1.</font><br>"; }
print "<font color=\"$fontcolor\">please save for further use.</font>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } }
######################################################################
# user login form.

sub pwd {
print "<font color=\"$fontcolor\"><h2>user login.</h2></font>";
print "<font color=\"$fontcolor\">please type in your password and username.</font>";

print "<form action=\"$rel?open\" method=\"post\">";
print "<table border=0 cellPadding=3><tbody>";
print "<tr><td><font color=\"$fontcolor\">username</font></td>";
print "<td><INPUT type=text name=user size=30></td></tr>";
print "<tr><td><font color=\"$fontcolor\">password</font></td>";
print "<td><INPUT type=password name=pass size=30></td></tr>";
print "</tbody></table>";
print "<INPUT name=submit type=submit value=submit>&nbsp<INPUT name=reset type=reset value=reset></form>"; }
######################################################################
# process user login form data.

sub open {
open (PRO,"$userdirectory/file.txt");
@user = <PRO>;
close(PRO);

$user = shift(@user); chomp($user);
$pass = shift(@user); chomp($pass);

$user1 =~ s/^\s+//; $user1 =~ s/\s+$//;
$pass1 =~ s/^\s+//; $pass1 =~ s/\s+$//;

if (("$user" eq "$user1") && ("$pass" eq "$pass1")) {
print "<font color=\"$fontcolor\"><h2>welcome $user.</h2></font>";
print "<font color=\"$fontcolor\">where do you like to go?<br></font>";
print "<font color=\"$fontcolor\">please choose from following menue.</font>";

print "<table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; }

else {
print "<font color=\"$fontcolor\"><h2>access denied.</h2></font>";
print "<font color=\"$fontcolor\">please try again&nbsp;<a href='$rel?pwd'>click here</a>.</font>"; }
}
######################################################################
# process environment variables.

sub prolayout {
if (("$slogan1" eq "") && ("$back1" eq "") && ("$font1" eq "") && ("$number1" eq ""))
{print "<font color=\"$fontcolor\">alert no data submitted. please return&nbsp;<a href='$rel?pwd'>click here</a>.</font>"; }

else {
open (LAYC,"$userdirectory/layout.txt");
@layc = <LAYC>;
close(LAYC);

$sloganc = shift(@layc); chomp($sloganc);
$backc = shift(@layc); chomp($backc);
$fontc = shift(@layc); chomp($fontc);
$numberc = shift(@layc); chomp($numberc);

open (ENV,">$userdirectory/layout.txt");

if ("$slogan1" ne "") { $slogan1 =~ s/^\s+//; $slogan1 =~ s/\s+$//; print ENV "$slogan1\n"; }
else { print ENV "$sloganc\n"; }

if ("$back1" ne "") { $back1 =~ s/^\s+//; $back1 =~ s/\s+$//; print ENV "$back1\n"; }
else { print ENV "$backc\n"; }

if ("$font1" ne "") { $font1 =~ s/^\s+//; $font1 =~ s/\s+$//; print ENV "$font1\n"; }
else { print ENV "$fontc\n"; }

if ("$number1" ne "") { $number1 =~ s/^\s+//; $number1 =~ s/\s+$//; print ENV "$number1\n"; }
else { print ENV "$numberc\n"; }

close (ENV);

print "<font color=\"$fontcolor\"><h2>set layout variables.</h2></font>";
if ("$slogan1" ne "") {
print "<font color=\"$fontcolor\">slogan = $slogan1.</font><br>"; }
if ("$back1" ne "") {
print "<font color=\"$fontcolor\">background color = $back1.</font><br>"; }
if ("$font1" ne "") {
print "<font color=\"$fontcolor\">font color = $font1.</font><br>"; }
if ("$number1" ne "") {
print "<font color=\"$fontcolor\">number of articles = $number1.</font><br>"; }

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } }
######################################################################
# display articles for review before deleting.

sub disp {

if ("$art" eq "") { &display; }

else {
open (ARTR,"$textdirectory/$art");
@artr = <ARTR>;
close(ARTR);

print "<font color=\"$fontcolor\"><h2>display $art.</h2></font>\n";

$lined = shift(@artr);
$popdated = pop(@artr);

print "<table border=1 cellpadding=5 width=600><tbody>";
print "<tr><td align=left><font color=\"$fontcolor\"><b>$lined</b></font></td></tr>";
print "<tr><td align=left><font color=\"$fontcolor\">";
foreach $textlined (@artr) {
print "$textlined<br>"; }
print "</font><p>";
print "<font color=\"$fontcolor\" size=\"-1\">$popdated</font></td></tr>";
print "</tbody></table><p>"; }}
######################################################################
# get environment variables.

sub layout {

open (LAY,"$userdirectory/layout.txt");
@lay = <LAY>;
close(LAY);

$slogan = shift(@lay);
chomp($slogan);

$backcolor = shift(@lay);
chomp($backcolor);

$fontcolor = shift(@lay);
chomp($fontcolor);

$artnr = shift(@lay);
chomp($artnr);

$head = "
<title>$slogan</title>
<META content=\"all\" name=\"robots\">
<META content=\"follow\" name=\"robots\">
<META content=\"all\" name=\"audience\">
<META content=\"all\" name=\"rating\">
<META content=\"all\" name=\"Classification\">
<META content=\"Global\" name=\"distribution\">
<META content=\"30 days\" name=\"revisit-after\">
<META content=\"all\" name=\"voluntary content rating\">
<META content=\"$slogan, online journal, web diary, weblog\" name=\"page-type\">
<META content=\"$slogan, online journal, web diary, weblog\" name=\"description\">
<META content=\"$slogan,online journal,web diary,weblog,blogger,journal\" name=\"keywords\">";
# end of head.
# leave like is or customize.
}
######################################################################
# search form.

sub search {
print "<font color=\"$fontcolor\"><h2>search $slogan.</h2></font>";
print "<font color=\"$fontcolor\">please type in your search request.</font>";

print "<form action=\"$rel?searchme\" method=\"post\">";
print "<table border=0 cellPadding=3><tbody>";
print "<tr><td><font color=\"$fontcolor\">search for</font></td>";
print "<td><INPUT type=text name=search size=40></td></tr>";
print "</tbody></table>";
print "<INPUT name=submit type=submit value=search>&nbsp<INPUT name=reset type=reset value=reset></form>"; }
######################################################################
# search process.

sub searchme {

if ("$search" eq "")
{print "<font color=\"$fontcolor\">alert no data input. please return&nbsp;<a href='$rel?search'>click here</a>.</font>";}


else {

$search =~ s/[?+*|.()\\^]//g;
$search =~ s/^\s+//; $search =~ s/\s+$//;

if ("$search" eq "") { print "<font color=\"$fontcolor\">alert no data input. please return&nbsp;<a href='$rel?search'>click here</a>.</font>"; }
else {

#display search box.
&search;
#end search box.


chdir ("$textdirectory");
@searchun = glob "*.txt";

if (@searchun == 0) {
print "<font color=\"$fontcolor\">soorry. no articles to search."; }

else {

@search = sort {$b <=> $a} @searchun;

$starttime = (time);

@resultu = ();
 do {
 $se = shift(@search);
 open (SEARCH,"$textdirectory/$se");
 @lookup = <SEARCH>; close(SEARCH);

 $founds = 0;
 $lookup = "@lookup";

  while ($lookup =~ /$search/gio) { $founds++; }
  if ($founds == 0) {}
  else { $resultin = "$founds|$se"; push(@resultu, $resultin); }

 }until (@search == 0);

$endtime = (time);
$runtime = $endtime - $starttime;

@result = sort {$b <=> $a} @resultu;

if ("$moder" eq "") { $moder = 1; } else {}

print "<font color=\"$fontcolor\"><h2>search results page no.: $moder.</h2></font>";
print "<font color=\"$fontcolor\">time to perform search: $runtime sec.</font><br>";

if (@result == 0) {
print "<font color=\"$fontcolor\"><u>ooops, no articles matched your search term: \"$search\".</u></font>"; }

else {
$rescount = @result;

print "<font color=\"$fontcolor\">following $rescount articles contain your search term: \"<u>$search</u>\".</font><p>";


# navigation / number of search results pages.

if (@result > $artnr) {
$dcountr = @result / $artnr;

if ($dcountr =~ /\./g) { @splitr = split(//, $dcountr);
do { $popnr = pop(@splitr); } until ("$popnr" eq ".");
$dcountr = "@splitr"; $dcountr =~ s/ //g; $dcountr++; } else {}

# limit display navgation bar.
@navir = (); $ncountr = 0; $modes = $moder;

if ($moder == 1) {}
else {
$bc = $moder - 1;
$back = "<a href=\"$rel?searchme&search=$search&moder=$bc\">back</a>";
push(@navir, $back); }

if ($modes == $dcountr) {} else {
do {
$modes++; $ncountr++;
$navir = "<a href=\"$rel?searchme&search=$search&moder=$modes\">$modes</a>";
push(@navir, $navir); } until (($ncountr == $artnr) | ($modes == $dcountr)); }

if ($moder == $dcountr) {} else {
$fc = $moder + 1;
$forward = "<a href=\"$rel?searchme&search=$search&moder=$fc\">forward</a>";
push(@navir, $forward); }

# limit search results display.
@displayr = ();
$startcr = $moder * $artnr; $startr = ($startcr - $artnr) - 1;
$discountr = 0;
do { $discountr++; $startr++; push(@displayr, $result[$startr]); }
until (($discountr == $artnr) | ("$result[$startr]" eq ""));

if ("$result[$startr]" eq "") { pop(@displayr); } else {}
@result = @displayr;

} # if @result > $artnr close.
else {}

if (@navir == 0) {} else {
print "<font color=\"$fontcolor\"><b>navigation:</b></font>&nbsp;@navir<p>"; }

foreach $result (@result) {

# extract weighting for search results.
$results = $result;
@char = split(//, $results);

@weight = ();
do { $we = shift(@char); push(@weight, $we); } until ("$we" eq "|");
$weightlength = @weight - 1;
$weight = substr($result, 0, $weightlength);
substr($result, 0, @weight) = "";


open (RES,"$textdirectory/$result");
@res = <RES>;
close(RES);

$liner = shift(@res);
$popdater = pop(@res);

print "<font color=\"$fontcolor\">found $weight matches in following article -></font><br>";
print "<table border=1 cellpadding=5 width=600><tbody>";
print "<tr><td align=left><font color=\"$fontcolor\"><b>$liner</b></font></td></tr>";
print "<tr><td align=left><font color=\"$fontcolor\">";

foreach $res (@res) {

@resp = split(/ /, $res);

foreach $word (@resp) {
if ($word =~ /$search/gio) { print "<i><u>$word</u></i> "; }
else { print "$word "; } }
print "<br>"; }

print "</font><p>";
print "<font color=\"$fontcolor\" size=\"-1\">$popdater</font></td></tr>";
print "</tbody></table><p>"; }

if (@navir == 0) {} else {
print "<font color=\"$fontcolor\"><b>navigation:</b></font>&nbsp;@navir<p>"; }

}# else result close.
}}}}
######################################################################
# display articles to edit.

sub edit {

if ("$sec" ne "$secure") { &display; }
else {

chdir ("$textdirectory");
@editun = glob "*.txt";
@edit = sort {$a <=> $b} @editun;

print "<h2><font color=\"$fontcolor\">edit articles.</font></h2>";

if (@edit == 0) {
print "<font color=\"$fontcolor\">no articles to edit. please post one.</font>&nbsp;";
print "<a href='$rel?newpost&sec=$secure'>click here</a>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?edit&sec=$secure'>edit article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; }

else {

print "<table border=1 cellPadding=3><tbody>";
print "<tr><th><font color=\"$fontcolor\">article no.</font></th><th><font color=\"$fontcolor\">title</font></th><th><font color=\"$fontcolor\">edit article</font></th></tr>";

foreach $edit (@edit) {

open (EDITR,"$edit");
@editr = <EDITR>;
$etitle = shift(@editr);
close (EDITR);

print "<tr><td><font color=\"$fontcolor\">$edit</font></td><td><font color=\"$fontcolor\">$etitle</font></td><td><a href='$rel?newpost&sec=$secure&eart=$edit'>click to edit $edit</a></td></tr>"; }

print "</tbody></table><p>";

print "<p><table border=0 cellspacing=10><tbody><tr>\n";
print "<td><a href='$rel?newpost&sec=$secure'>new article</a></td>\n";
print "<td><a href='$rel?delpost&sec=$secure'>delete article</a></td>\n";
print "<td><a href='$rel?admin&sec=$secure'>admin area</a></td>\n";
print "</tr></tbody></table>\n"; } } }
##################################################################################
##################################################################################
exit;
# END
