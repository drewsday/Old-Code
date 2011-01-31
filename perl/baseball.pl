
#!perl 

#warnings added after importing HTML::TableExtract

use LWP::Simple;
use HTML::Parser;
use HTML::TableExtract;
BEGIN {$^W++}
use Sports::Baseball::Teams 0.33;
use strict;

use subs 'speak';

my $team = get_team() || "sea";
my $content = LWP::Simple::get ("http://sports.espn.go.com/mlb/clubhouse?team=$team");

my ($html, $relevant);

my $filter = new HTML::Parser (	start_h=>[\&main_handler,"'start',tagname,attr,text"],
								end_h  =>[\&main_handler,"'end',tagname,attr,text"],
								text_h =>[sub {$html .= shift if $relevant},"text"],
							  );

$filter->parse($content);


my $linescore = new HTML::TableExtract(headers=> [qw(\bR\b \bH\b \bE\b)]);
my $alldata = new HTML::TableExtract;

$linescore->parse($html);
$alldata->parse($html);

#oh, I feel guilty about this one... (there's only one image tag, though)
my ($image) = ($html =~ m!<img[^>]+src="[^"]+/([\w]+\.gif)"!);

#these are all kosher, though
my ($awayscore,$homescore) = $linescore->rows();
my @scoretable = $alldata->table_state(1,0)->rows;
my @upcoming  = $alldata->table_state(0,2)->rows;

my $details   = ($alldata->table_state(0,1)->rows)[0]->[0];

my $status   = $scoretable[0][0];
my $awayteam = Sports::Baseball::Teams->new_fromscore($scoretable[1][0]);
my $hometeam = Sports::Baseball::Teams->new_fromscore($scoretable[2][0]);

my ($ahead,$behind) = $$awayscore[0] > $$homescore[0] ? ($awayteam, $hometeam)
													  : ($hometeam, $awayteam);

my ($score, %RHE);

if ($$awayscore[0] != $$homescore[0]) {
	$score = sprintf "%i to %i", sort {$b <=> $a } $$awayscore[0], $$homescore[0];
} else {
	$score = "tied at $$homescore[0]";
}

$RHE{home} = sprintf "%s run%s, %s hit%s and %s error%s",
					map {($_ == 0 ? "no" : $_), ($_ != 1 ? "s" : "")} @$homescore;
$RHE{away} = sprintf "%s run%s, %s hit%s and %s error%s",
					map {($_ == 0 ? "no" : $_), ($_ != 1 ? "s" : "")} @$awayscore;

if ($status =~ /Final/) {
	my (%winner, %loser,%save);
	@winner{ qw(name w l) } = $details =~ /W: \s+ (\w+) \s+ \( (\d+) - (\d+) \) /x ;
	@loser{  qw(name w l) } = $details =~ /L: \s+ (\w+) \s+ \( (\d+) - (\d+) \) /x;
	@save{   qw(name s  ) } = $details =~ /S: \s+ (\w+) \s+ \( (\d+) \) /x;

	speak 
		qq% $awayteam at $hometeam, Final: $ahead defeats $behind, $score.
			The winning pitcher, $winner{'name'}, advances to $winner{'w'} and $winner{'l'}.
			The loser is $loser{'name'}, he falls to $loser{'w'} and $loser{'l'}. %,
 		$save{'name'}  ? "The save goes to $save{'name'}, giving him $save{'s'}."
					   : "No save in the game.",
		"  $hometeam finishes with $RHE{home}; $awayteam with $RHE{away}.  ",
		"Next game:", getnextgame(@upcoming);

} elsif ($status =~ /Delayed|Postponed/) {
	my $place = $hometeam->getlocation();
	
	speak qq% Tonight's game between $hometeam and $awayteam has been $&;, 
			  presumably due to crappy weather in $place.
			  The next game may therefor not be what was expected.  
			  However, right now we think it will be %,
		   getnext(@upcoming);

} else { #in progress 
	my (%awaypitcher,%homepitcher);
	
	$details =~ /Pitching: \s+ \w{2,3} \s+ - \s+ (\w+) \s* (?: \( ( [^)]+ ) \) )?
						   \s+ \w{2,3} \s+ - \s+ (\w+) \s* (?: \( ( [^)]+ ) \) )?
				/sx; 
						
	@awaypitcher{'name','when'} = ($1,$2);
	@homepitcher{'name','when'} = ($3,$4);
	
	my $report = "In progress, $awayteam at $hometeam: ";
	
	if ($status =~ /top|bot/i) {
		$report .= "with " .  get_situation($image);
	}
	$report .= get_inning($status) . ", ";
	if ($$awayscore[0] == $$homescore[0]) {$report .= "$score.\n";}
	else                                  {$report .= "$ahead leads $behind, $score.\n";}

 
 	$report .= "The current pitcher for $hometeam is $homepitcher{name}";

	if ( $homepitcher{when} && $homepitcher{when} !~ /-/ ) {
		$report .= ", who relieved in the $homepitcher{when}";
	}	
	 	 
	$report .= "; for $awayteam, $awaypitcher{name}";

	if ( $awaypitcher{when} && $awaypitcher{when} !~ /-/ ) {
		$report .= ", who relieved in the $awaypitcher{when}";
	}

	$report .= ".  $hometeam has $RHE{home}; $awayteam has $RHE{away}.";

	speak $report;
}

##End of main code block.

sub get_team {
	my $input;
	if (@ARGV) {
		$input = $ARGV[0];
	} else {
		return unless $^X eq 'MacPerl';
		require MacPerl;
		$input = MacPerl::Ask("What team would you like the score for?");
		$input =~ s/^\s*//;
		$input =~ s/\s*$//;
	}
	
	my $team =    Sports::Baseball::Teams->new($input) 
			   || Sports::Baseball::Teams->new_fromscore($input);

	if ($input && !$team) {die "Unable to resolve a team from '$input'\n";}
	
	return $team ? $team->getkey() : undef;
}

sub main_handler {
	my ($whichend,$tagname,$attr,$text) = @_;
	if ($tagname eq "div") {
     	if ($whichend eq 'start'){
			$relevant = $$attr{id} && ($$attr{id} eq "latest" || $$attr{id} eq "schedOne");
		} else {
			$html .= $text if $relevant; #in case we need the output to be valid HTML
			$relevant = 0;
		}
	}	
	$html .= $text if $relevant;
}	

sub speak {
	if ($^X eq 'MacPerl') {
		require MacPerl;
		MacPerl::DoAppleScript (qq!say "@_"!);
	} else {
		print map {"$_\n"} @_;
	}
}

sub get_inning {    # e.g. "in the middle of the 8th inning" 
	my ($when, $inning) = shift =~ /(Top|Mid|Bot|End)\D*(\d+\w+)/i;
	$when =~ s/Mid/Middle/i;
	$when =~ s/Bot/Bottom/i;
	#return :
 	if ($when eq "End") {"at the end of the $inning inning"} 
 	elsif ($when eq "Middle") {$inning !~ /^7/  ? "in the middle of the $inning inning"
 								 				: "at the 7th inning stretch"} 
 	else {"in the $when of the $inning inning "}
}

sub get_situation {
	my ($outs, $on1st, $on2nd, $on3rd) = shift =~ /^(\d)(\d)(\d)(\d)/;

	if ($& == 0) {return "none on and none out "} #VEEEERY special case :-)
	
	my $menon = $on1st + $on2nd + $on3rd;
	my ($bases, $situation);
	if    ($menon == 1) {
		$bases = "a runner on ";
		if    ($on1st)	{$bases .= "1st"}
		elsif ($on2nd)	{$bases .= "2nd"}
		else            {$bases .= "3rd"}
	}
	elsif ($menon == 2) {
		$bases = "runners on ";
		if 	  (!$on1st) {$bases .= "second and third"}
		elsif (!$on2nd)	{$bases .= "the corners"}
		elsif (!$on3rd)  {$bases .= "first and second"}
	}
	elsif ($menon == 3) {$bases = "the bases loaded"}
	else				{$bases = "the bases empty"}
	return "$bases and " . ($outs ? "$outs out" : "none out") . " ";
}

sub getnextgame {
	my ($date,$opponent,$time) = @{$_[2]}[0..3];
	my $matchup = $_[3][0];
	my ($daypat, $weekday);
	my (@away, @home, $awayteam, $hometeam);
	my ($homename, $awayname, $awayrecord, $homerecord);

	if ($opponent =~  /^\@/) { substr($opponent,0,1) = "at "}
	else					 { substr($opponent,0,0) = "versus "}

	($daypat) = $date =~ /^(\w+)/;
	for (qw (Monday Tuesday Wednesday Thursday Friday Saturday Sunday)) {$weekday = $_ if /$daypat/}	

	(@away[0..2],@home[0..2]) = $matchup =~ /(\w{2,3}) - (\w+) (?:\((\d+-\d+)\))?/g;

	$hometeam =  Sports::Baseball::Teams->new($home[0]);
	$awayteam =  Sports::Baseball::Teams->new($away[0]);

	$homename = $hometeam->getplacename();
	$awayname = $awayteam->getplacename();
	$homerecord = sprintf "%i and %i", $home[2] =~ /(\d+)/g;
	$awayrecord = sprintf "%i and %i", $away[2] =~ /(\d+)/g;

	return  qq% $weekday,  $time Eastern Time, $opponent.
				Expected matchup: 
				for $awayname, $away[1] ($awayrecord);
				for $homename, $home[1] ($homerecord).
			  %;
}






