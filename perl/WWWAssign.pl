#! /usr/local/bin/perl
# the line above must be changed to refer to the local installation of perl
# Downloaded by morrison@physics.niu.edu for Northern Illinois University, Fri Mar 30 14:15:31 2001
# updates, documentation, and sample files available at http://www.northpark.edu/~martin/WWWAssign
# $RCSfile: WWWAssign.cgi,v $$Revision: 1.04 $$Date: 3/14/98 4:47:00 $
# $Log: WWWAssign.cgi,v $
# (c) 1997, Larry Martin; free use by educational institutions is permitted, as long as copyright notice is maintained.
#  The author requests that changes in the code be reported to him at martin@northpark.edu
#  Comments and questions are welcome.
#  He also would appreciate receiving clever questions you have found useful along with permission to post them on the demonstration site.
#
# This cgi also requires the module "CGI.pm" installed locally.
#   The most recent version and complete docs are available at:
#   http://www-genome.wi.mit.edu/ftp/pub/software/WWW/cgi_docs.html
#
# Example link: 
#	<A HREF="www.physics.niu.edu/cgi-bin/WWWAssign.cgi?AssignmentName=/~morrison/myclass/assignment">Do this assignment.</A>
#
#Location specific changes here:  (Must edit the subroutine "CheckPassword" to use locally appropriate methods.)

BEGIN { unshift(@INC,'/usr/local/lib/perl5');}
$webmaster='morrison@physics.niu.edu';
$schoolname="<FONT COLOR=blue>Northern Illinois University</FONT>";
$BGCOLOR='#EEEE44';
$pi=atan2(0,-1);

sub CheckPassword
{ local ($username, $passwd)=@_;
#a method of authentication must be chosen or written below and then the following line removed
	1;#this causes no checking of passwords

#Here is one method which works on many Unix sites:
#	$pwd=(getpwnam($username))[1];
#	$salt=$pwd; # some systems may use $salt=substr($pwd,0,2);
#	if (crypt($passwd,$salt) eq $pwd) { return(1); } else { return(0); }
	
#To use teacher assigned passwords, put in the roster after each name a tab followed by the password and use this:
#	$pwd=$outsidepwd{$username};
#	if ($passwd eq $pwd) { return(1); } else { return(0); }

# A combination of the above techniques can be used by only assigning passwords to some students,
# for example, when some students have accounts on the system and some don't.
}


use CGI all;
#use CGI qw(:all); #use this line instead for CGI.pm version 2.37 and later.
#use CGI::Carp qw(fatalsToBrowser); # uncommenting this during debugging phase may be helpful

####Mac/Unix/PC = change 2 things##############################
#Mac/Unix = change next lines and in CGI.pm
$OS = 'UNIX';
#$OS = 'MACINTOSH';
$SL = { UNIX=>'/', WINDOWS=>'\\', NT=>'\\', MACINTOSH=>':', VMS=>'\\' }->{$OS};
# The path separator is a slash, backslash or semicolon, depending on the platform. Note: Unix absolute pathnames must begin with '/'
$incorrect="<FONT COLOR='CC1111' size=+3><B><sub>X</sub></B></FONT>";

$query = new CGI;

#Next line for debugging purposes, writes to a log file.
#if (open(LOGFILE,">>WWWAssign.log")) { foreach $item ($query->param) {if ($item ne 'PassWord') {$response=$query->param($item);$response=~s/\n/<BR>/go;print LOGFILE $item,"=",$response,"&";} } print LOGFILE "\n"; close LOGFILE;} else {die "Error: couldn't write to logfile: $!\n";}

if ($query->param) {
	$assignmentname=$query->param(AssignmentName);
	$username=$query->param(UserName);
	$passwd=$query->param(PassWord);
	&AssignInfo($query->param(AssignmentName));
	&RosterList;
	
	if ((grep($username eq $_,@teachernames)) && (&CheckPassword($username,$passwd)))
	{
		if ($query->param(Start) eq 'Begin')
		{
			if ($query->param(CollectEssayGrades)) {	&CollectEssayGrades;	}
			&ListGrades;
		} else { if ($query->param(Excel) eq 'Begin') {&ExcelGrades;}}
		if ($query->param(Start) eq 'Key')
		{	$URLreturn="$CGIName?Start=Begin&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd";
			&DeliverKey($query->param(StudentName));
		}
		if ($query->param(Start) eq 'GradeEssays') {	&GradeEssays;	}
	} else {
# check on servergraded==1; separate member and password check, warn if password incorrect
		if ((grep($username eq $_,@rostermembers)) && (&CheckPassword($username,$passwd)))
		{
			$sectionnumber=1.*$query->param(SectionNumber);
			$lastqnum=1.*$query->param(LastQnum);
			@sectionlist=split(",",$allfilelist);
			$numsections=@sectionlist;
			$filename=@sectionlist[$sectionnumber];
			$student=$username;
			$answerfile="$filelocation$SL$student";$answerfile=~s|$SL$SL|$SL|go;
			if ($query->param(Start) eq 'Begin') {	&Administer;	}
			if ($query->param(Start) eq 'Next') {	&CollectSection;	}
			if ($query->param(Start) eq 'Key') {	&DeliverKey($username); }
		} else {	&GetName;	}
	}
} else { print $query->header; print $query->start_html; print $query->end_html;	}
	
######################################### END ###################################################
sub GetName {
	$now_string = localtime;
	print $query->header;
	print $query->start_html(-title=>"$longname", -author=>'martin@northpark.edu',
				-meta=>{'keywords'=>'WWWAssign, physics', 'copyright'=>'copyright 1997, Larry Martin'},
				 -BGCOLOR=>'white', -LINK=>'#0000FF', -VLINK=>'#800080', -ALINK=>'#0000FF');
print <<ENDTITLE;
	<CENTER>\n<TABLE BORDER=2 CELLSPACING=2 CELLPADDING=2 WIDTH='80%' BGCOLOR=$BGCOLOR>\n
	<TR><TD><H2 align=center>$schoolname<BR>
	<FONT COLOR="#00BBBB">WWWAssignment</FONT><BR>
	$longname<BR>
	$now_string
	</H2></TD></TR></TABLE></CENTER>
ENDTITLE
	print "<H2 align=center>Please enter your name and password.</H2>";
	print "\n<P><HR><P><CENTER><H2>\n";
	print $query->startform(-method=>'POST', -action=>"$CGIName"),"\n";
	print $query->hidden(-name=>"AssignmentName",-value=>"$assignmentname"),"\n";
	print $query->hidden(-name=>"StartTime",-value=>"$now_string"),"\n";
	if ($username) { print "<BLINK><CENTER><FONT COLOR='#FF0000'>Username or Password was incorrect.</FONT></CENTER></BLINK><BR>\n"; }
	print "User ID:",$query->textfield(-name=>'UserName',-size=>15,-maxlength=>15),"\n";
	print "Password:",$query->password_field(-name=>'PassWord',-size=>15,-maxlength=>15,-default=>''),"\n";
	print $query->submit('Start','Begin'),' ';
	if ($keyavailable) {	print $query->submit('Start','Key');	}
	print $query->endform;
	&quote;
	print $query->end_html;
}

sub getQuestions
{
	local $filename,$filecontents;
	if (!(@allquestions))
	{
		@allquestions=();
		foreach $filename (split(',',$assignvalue{filelist}))
		{
			$queryfile="$filelocation$SL$filename";$queryfile=~s|$SL$SL|$SL|go;
			undef $/; open(TESTFILE,$queryfile) || die "Can't find $queryfile: $!";
			$filecontents=(<TESTFILE>); $/ = "\n";close(TESTFILE);
			$filecontents=~ s/\r/\n/go;$filecontents=~ s/\n\n/\n/go;
			push(@allquestions,split("\n",$filecontents));
		}
		
	}
	@questions=();
	push(@questions,@allquestions);
}

sub DeliverKey
{
	$student=@_[0];
	@grade=&Grade($student); # check for zero grade to make sure assignment is done
	&Heading;
	if (@grade[1]==0) {print "<H1 align=center>You must complete the assignment first.</H1>",$query->end_html;}
	else
	{
		print sprintf("\n<H1>Key: $student - %3d / %3d =",@grade[0]+@grade[3],@grade[1]+@grade[4]);
		if (@grade[1]+@grade[4]) { print sprintf(" %5.2f %%",100.*(@grade[0]+@grade[3])/(@grade[1]+@grade[4]));}
		print "</H1><BR><HR>\n";
		&getQuestions;
		$numquestions=@questions/2;
		$qnum=0;	#="00";
		print "<BR><font color=red>$announcement</font><BR>" if ($announcement);
		print $query->startform(-name=>"Key"),"\n";
		while (@questions)
		{
			++$qnum;
			if ($randommethod eq 'person') {srand($qnum+&hashname($student))} else {srand($qnum)};
			$question=&eqn(shift(@questions));
			$commentary='';
			while (substr($question,0,1) eq '#') {$commentary.=substr($question,1,length $question);$question=&eqn(shift(@questions));}
			print $commentary."<BR>\n" if ($commentary);
			$aname="QA".((substr($question,0,1) eq 'Q')?substr($question,1,1):'C')."_$qnum";
			$thisanswer=$entry{$aname};
			@answers=split("\t",&eqn(shift(@questions)));
			($numanswers=sprintf("%2d",$anum=@answers)) =~ s/ /0/go;
			if (substr($question,0,1) eq 'Q')
			{
					if (substr($question,1,1) eq 'B')	################# Fill-in-the-Blank(s)
					{
						if ($question =~ m/<_>/)
						{
							$question =~ s/QB //;$question =~ s/<_>/ <_> /go;
							@parts=split('<_>',$question,2);
						}
						else #takes care of relic version with different method of indicating boxes
						{
							$question =~ s/QB //;$question =~ s/_/ _ /go; # allows blanks to be at the very beginning or end of a string
							@parts=split("_",$question,2); #only one blank allowed here
						}
						print "$qnum. @parts[0] \n";
						print "<INPUT TEXT VALUE='".$entry{$aname}."' SIZE=20 NAME='$aname'> ";
						@caseanswers=@answers;
						foreach (@caseanswers) {tr/A-Z/a-z/;s/	//go;s/ //go;}	# canonicalize to lower case to be case insensitive
						$caseanswer=$thisanswer;
						$caseanswer=~tr/A-Z/a-z/;
						$caseanswer=~s/	//go;$caseanswer=~s/ //go;	 # remove extra spaces
						print $incorrect if (!(grep($caseanswer eq $_, @caseanswers)));
						print "<FONT COLOR=008800>( ".join(', ',@answers),")</FONT>\n ";
						print @parts[1],"<P>\n";
					}
					if (substr($question,1,1) eq 'N')	################# Fill-in-the-Number(s)
					{
						if ($question =~ m/<_>/)
						{
							$question =~ s/QN //;$question =~ s/<_>/ <_> /go;
							@parts=split('<_>',$question,2);
						}
						else
						{
							$question =~ s/QN //;$question =~ s/_/ _ /go; # allows blanks to be at the very beginning or end of a string
							@parts=split("_",$question,2); #only one blank allowed here
						}
						print "$qnum. @parts[0] \n";
						print "<INPUT TEXT VALUE='".$entry{$aname}."' SIZE=20 NAME='$aname'>";
						if (!(length @answers[1])) {@answers[1]=abs(0.02*@answers[0]);}#default 2% tolerance
						print $incorrect if (($thisanswer<(@answers[0]-@answers[1]))||($thisanswer>(@answers[0]+@answers[1])));
						print "<FONT COLOR=008800> [ ",((!(length @answers[1]))?&threefigs(@answers[0]):@answers[0])," ]</FONT>\n ";
						print @parts[1],"<P>\n";
					}
					if (substr($question,1,1) eq 'P')	################# Proof-reading
					{
						$question =~ s/QP //;
						($directions,$prooftext)=split("\t",$question);
						print "$qnum. $directions <P>\n";
						print $query->blockquote('<FONT COLOR=880000>'.$prooftext.'</FONT>');
						@caseanswers=@answers;
						foreach (@caseanswers) {tr/A-Z/a-z/;s/	//go;s/ //go;}	# canonicalize to lower case to be case insensitive
						$caseanswer=$thisanswer;
						$caseanswer=~tr/A-Z/a-z/;
						$caseanswer=~s/	//go;$caseanswer=~s/ //go;	 # remove extra spaces
						print $query->blockquote('<FONT COLOR=000088>'.$entry{$aname}.'</FONT>'.((!(grep($caseanswer eq $_, @caseanswers)))?$incorrect:''));
						foreach (@answers) { print $query->blockquote("<FONT COLOR=008800>( $_ )</FONT>\n ");}
					}
					if (substr($question,1,1) eq 'E')	################# Essay
					{
						$question =~ s/QE //;
						print "$qnum. $question <P>\n";
						print $query->blockquote('<FONT COLOR=000088>'.$entry{$aname}.'</FONT>'),"\n";
						($essaygrade,$essaytotal,$essaycomment)=split("\t",$entry{"QGE_" . $qnum});
						if ($essaytotal) {		print $query->h3("Score: $essaygrade / $essaytotal<BR>Comment: $essaycomment"),"\n";}
						else	{ print $query->h3("Score: not graded yet."),"\n";	}
						if (@answers[2]) {		print $query->h3("<FONT COLOR='#FF0000'>Exemplar: " . @answers[2]),"</FONT>\n";} # Can make the exemplar contain a link to page where info is found
					}
			}
			else
			{
				$qname="QKC_$qnum";
				print "$qnum. $question <P>\n<DL>";
				@ans=split("\t",$entry{$qname});
				$numa=@answers;
				for ($answer=0;$answer<$numa;$answer++)
				{
					print "<DD><INPUT TYPE=RADIO	NAME='$aname'";
					if ($entry{$aname} ne '') {	 if ($answer==$entry{$aname}) {		print " checked";	}	}
					print "> ";
					if ((((@ans[$answer]!=0)&&($answer==$entry{$aname}))||(($entry{$aname} eq '')&&(@ans[$answer]==0)))&&($thisanswer ne 'correct'))
					{	print $incorrect;}
					print @answers[@ans[$answer]];
					if ((@ans[$answer]==0)&&($thisanswer ne 'correct')) {	 print "<FONT COLOR='008800'> - Correct!</FONT>";}
					print "<BR>\n";
				}
				print '</DL>';
			}
			print "<BR>\n";
		}
		print $query->endform,"\n";
		print "<P><HR><P><H1 ALIGN=CENTER><A HREF=$URLreturn>done</A></H1>\n";
		print $query->end_html;
	}
}

sub AssignInfo
{

	$assignfile=@_[0];
	if ($OS ne 'MACINTOSH') {$assignfile=~s:~(\w+):(getpwnam($1))[7]:e;}
	undef $/; open(ASSIGNFILE,"$assignfile") || die "Can't find $assignfile: $!";
	$assignfilecontents=(<ASSIGNFILE>); $/ = "\n";close(ASSIGNFILE);
	$assignfilecontents=~ s/\r/\n/go;$assignfilecontents=~ s/\n\n/\n/go;
	@line=split("\n",$assignfilecontents);
	foreach(@line)
	{	
		($varname,$value)=split("=",$_,2);
		$value=~s/\s//go;
		$varname=~s/\s//go;$varname=~tr/A-Z/a-z/;	# canonicalize to lower case to protect user from mistakes
		$assignvalue{$varname}=$value;
	}
	$longname=$assignvalue{longname};$longname=~s/_/ /go;
	$rosterfile=$assignvalue{roster};
	$filelocation=$assignvalue{filepath};
	if ($OS ne 'MACINTOSH') {foreach ($rosterfile, $filelocation) {s:~(\w+):(getpwnam($1))[7]:e;}}# Do tilde expansion
	@teachernames=split(",",$assignvalue{teacher});
	$servergraded=$assignvalue{servergraded}; 
	$allfilelist=$assignvalue{filelist};
	$URLreturn=$assignvalue{urlreturn};
	$baseurl=$assignvalue{baseurl};
	$CGIName=$assignvalue{cginame};
	$keyavailable=$assignvalue{keyavailable};
	$randommethod=$assignvalue{randommethod};
	$gradingmethod=$assignvalue{gradingmethod};
	$announcement=$assignvalue{announcement};$announcement=~s/_/ /go;
}

sub RosterList
{
	undef $/; open(ROSTERFILE,"$rosterfile") || die "Can't find $rosterfile: $!";
	$rosterfilecontents=(<ROSTERFILE>); $/ = "\n";close(ROSTERFILE);
	$rosterfilecontents=~ s/\r/\n/go;$rosterfilecontents=~ s/\n\n/\n/go;#allows PC/Mac/Unix edited files with various linefeed characteristics
	@rostermembers=split("\n",$rosterfilecontents);
	# the following splits on tab to assign passwords to students without an account on the system
	%outsidepwd=();
	foreach $rm (@rostermembers)
	{
		($rm,$memberpassword)=split("\t",$rm);
		#$outsidepwd{$rm}=$memberpassword if ($memberpassword);
		if ($memberpassword)
		{
			$outsidepwd{$rm}=$memberpassword;
			@rostermembers[$rmcount++]=$rm;
		}
	}
	
}

sub Heading
{
	$now_string = localtime;
	print $query->header;
	print $query->start_html(-title=>"$longname - $username", -author=>'martin@northpark.edu',-script=>"$JSCRIPTHEAD",
				 -meta=>{'keywords'=>'WWWAssign', 'copyright'=>'copyright 1997, Larry Martin'},
				 -BASE=>"$baseurl",
				 -BGCOLOR=>'white', -LINK=>'#0000FF', -VLINK=>'#800080', -ALINK=>'#0000FF');
print <<ENDTITLE;
	<CENTER>\n<TABLE BORDER=2 CELLSPACING=2 CELLPADDING=2 WIDTH='80%' BGCOLOR=$BGCOLOR>\n
	<TR><TD><center><FONT COLOR="#00DDDD">
	$schoolname<BR>
	<B>$longname - $username</B></FONT><BR>
	$now_string
	</center></TD></TR></TABLE></CENTER><BR><HR><BR>\n\n
ENDTITLE
}

sub GradeEssays
{
	&Heading;
	&getQuestions;
	print $query->startform(-method=>'POST', -action=>$CGIName, -name=>'ESSAYGRADES');
	print "<INPUT TYPE=hidden NAME='Start' VALUE='Begin'>\n";
	print "<INPUT TYPE=hidden NAME='CollectEssayGrades' VALUE='1'>\n";
	print "<INPUT TYPE=hidden NAME='AssignmentName' VALUE='$assignmentname'>\n";
	print "<INPUT TYPE=hidden NAME='UserName' VALUE='$username'>\n";
	print "<INPUT TYPE=hidden NAME='PassWord' VALUE='$passwd'>\n";
	if ($student=$query->param(StudentName))
	{
		@grade=&Grade($student);
		if (@grade[1]==0) {
			print '<BR><HR><BR>',$query->h2($student . "- not taken\n");
		} else {
			$answer=$studentessays{$student};$answer=~s/QAE_//go;
			@answerlist=split("\t",$answer);
			%answerarray=@answerlist;
			foreach $num (sort {$a <=> $b;} keys %answerarray)		{	&EssayForm;	 }
		}
	} else {
		foreach $student (@rostermembers)
		{
			@grade=&Grade($student);
			if (@grade[1]==0) {
				print '<BR><HR><BR>',$query->h2($student . "- not taken\n");
			} else {
				$answer=$studentessays{$student};$answer=~s/QAE_//go;
				@answerlist=split("\t",$answer);
				%answerarray=@answerlist;
				$num = $query->param(EssayNumber);
				if ($num)	{	&EssayForm;	 }
				else {	foreach $num (sort {$a <=> $b;} keys %answerarray)		{	&EssayForm;	 }	}
			}
		}
	}
	print "\n<BR><HR><BR><CENTER>\n<INPUT TYPE=submit VALUE='Record Essay Grades' NAME=Start>\n</CENTER>\n";
	print $query->endform,"\n";
	print "\n\n<BR><BR><HR><BR><BR>\n",$query->end_html;
}

sub EssayForm
{
	@questions[($num-1) *2]=~s/QE //go;
	$thequestion=@questions[($num-1) *2];
	$theanswer=@questions[($num-1) *2 + 1];
	print '<BR><HR><BR>',$query->h2($num . ". " . &eqn( $thequestion) ),"\n";
	print "<FONT COLOR='#0000FF'>",$query->blockquote($answerarray{$num}),"</FONT><P>\n";
	print "Essay Grade: <INPUT TEXT NAME=".$student."_QGE_".$num." SIZE=4>\n";
	print " / <INPUT TEXT NAME=".$student."_QEG_".$num." SIZE=4>\n";
	print " Comment: <TEXTAREA NAME=".$student."_QEC_".$num." rows=3 cols=50 wrap=on></textarea>\n";
	($rows,$cols,$exemplar)=split("\t",&eqn( $theanswer) );
	if ($exemplar) {	print $query->h3("Exemplar: \n"),$query->blockquote("<FONT COLOR='#FF0000'>" . $exemplar . "</FONT><P>\n");	 }
	# Can make the exemplar contain notes on how to grade
}

sub ListGrades
{
	&Heading;
	%studentanswers=();%studentcorrects=();@rank=();
############################################ list total grades ############################################
# put anchor here to get this page content delivered to Excel: "application/x-excel"
	$Spreadsheet="[<A HREF='$CGIName?Excel=Begin&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd'>Excel</A>]";
	print "<BR><H2 ALIGN=CENTER>Grades $Spreadsheet</H2>\n<PRE>\n";
#put Java anchor on percent grade to deliver sorted students with bar graphs and histogram, plot objective vs essays
	print "Name            Score / Total =   Percent      (# essays) Score / Total =   Percent       Raw Total   Total Percent\n\n"; #add separate essay score
	$count=0;@avsc=();@avpt=();@avesc=();@avept=();@avrt=();@avtp=();
	foreach $student (@rostermembers) #could also sort list here rather than go in order of roster
	{
		@grade=&Grade($student);	#table?
		if (@grade[1]==0) {
			print $student,' ' x (15-length($student)),"- not taken\n";
			push(@rank,"0_$student");
		} else {
			$percentgrade=100.*@grade[0]/@grade[1];
			if (@grade[4]) {$percentessay=100.*@grade[3]/@grade[4];} else {$percentessay='';};
			$totpercent=100.*(@grade[0]+@grade[3])/(@grade[1]+@grade[4]);
			print "<A HREF='$CGIName?Start=Key&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd&StudentName=$student'>";
			print $student,'</A>',' ' x (15-length($student));
			print sprintf(" %5d / %5d =  %6.2f %%      ( %3d )    %5d / %5d =  %6.2f %%           %5d      %6.2f %%\n",@grade[0],@grade[1],$percentgrade,@grade[2],@grade[3],@grade[4],$percentessay,@grade[0]+@grade[3],$totpercent);
			push(@rank,(@grade[0]+@grade[3])."_$student");
			if ((@grade[1]+@grade[4])>$maxtotal) {$maxtotal=(@grade[1]+@grade[4])}
			$count++;push(@avsc,@grade[0]);push(@avpt,$percentgrade);
			push(@avesc,@grade[3]);push(@avept,$percentessay);push(@avrt,@grade[0]+@grade[3]);push(@avtp,$totpercent);
		}
	}
	print sprintf("\n%15s  %6.2f       =  %6.2f %%                  %6.2f       =  %6.2f %%            %6.2f    %6.2f %%\n",'Average',&sum(@avsc)/$count,&sum(@avpt)/$count,&sum(@avesc)/$count,&sum(@avept)/$count,&sum(@avrt)/$count,&sum(@avtp)/$count) if ($count);


############################################ Rank list ############################################
	print "</PRE><BR><BR><HR><BR><H2 ALIGN=CENTER>Sorted by Rank</H2>\n<PRE>\n";
	@rankedstudents=();
	foreach $ranking (sort {$b <=> $a;} @rank)
	{
		($grade,$student)=split("_",$ranking);
		push(@rankedstudents,$student) if ($grade>0);
		print "<A HREF='$CGIName?Start=Key&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd&StudentName=$student'>";

		if ($maxtotal) {	$totpercent=100.*$grade/$maxtotal; } else {	 $totpercent=0; }
		print $student,'</A>',' ' x (15-length($student)),sprintf(" %5d / %5d =    %6.2f %%\n",$grade,$maxtotal,$totpercent);
	}

############################################ list choice responses ############################################
# put anchor here to get "key" with item analysis, or Java to generate bar graph histogram
	print "</PRE><BR><BR><HR><BR><H2 ALIGN=CENTER>Multiple Choice Responses</H2>\n<PRE>\n";
	print "Name            0=correct answer; 1,2,3...=distractor #\n\n";
	foreach $student (@rostermembers)
	{
		$answer=$studentanswers{$student};$answer=~s/QAC_//go;
		@answerlist=split("\t",$answer);
		%answerarray=@answerlist;if (@answerlist) {%qlist=%answerarray;}
		print $student,' ' x (15-length($student));
		foreach $qnum (sort {$a <=> $b;} keys %answerarray)
		{ if (substr($qnum,0,1) ne 'Q') {print sprintf(" %3d",$answerarray{$qnum});} }
		print "\n";
	}
	print sprintf("\n%15s","Question #");
	foreach $qnum (sort {$a <=> $b;} keys %qlist)
	{	if (substr($qnum,0,1) ne 'Q') { print " <A HREF='#Q$qnum'>",sprintf("%3d",$qnum),"</A>";	}	} # add link to click to see question
	print "\n";
############################################ list fill-in-the-blank responses ############################################
# put anchor here to get sorted list of responses / histogram ...
	print "</PRE><BR><BR><HR><BR><H2 ALIGN=CENTER>Fill-in-the-blank Responses</H2>\n<PRE>\n";
	print "Name            student's answer\n\n";
	foreach $student (@rostermembers)
	{
		$answer=$studentanswers{$student};$answer=~s/QAB_//go;$answer=~s/QAN_//go;#$answer=~s/QAP_//go; #don't show proof-reading responses since too long
		@answerlist=split("\t",$answer);
		%answerarray=@answerlist;if (@answerlist) {%qlist=%answerarray;}
		print $student,' ' x (15-length($student));
		foreach $qnum (sort {$a <=> $b;} keys %answerarray)
		{ if (substr($qnum,0,1) ne 'Q') {print sprintf(" %15s",$answerarray{$qnum});} }
		print "\n";
	}
	print sprintf("\n%15s","Question #");
	foreach $qnum (sort {$a <=> $b;} keys %qlist)
	{	if (substr($qnum,0,1) ne 'Q') { print " <A HREF='#Q$qnum'>", sprintf("%15s",$qnum),"</A>";		}	}
	print "\n";
############################################ list question totals and Discrimination Index ##################################
	print "</PRE><BR><BR><HR><BR><H2 ALIGN=CENTER>Question Totals</H2>\n<PRE>\n";
	print "Name (ranked)        1=correct answer; 0=wrong answer\n\n";
	@total=();%qarray=();
#	foreach $student (@rostermembers) #sort by rank?
	foreach $student (@rankedstudents)
	{
		print $student,' ' x (22-length($student));
		$studentcorrects{$student}=~s/QAC_//go; $studentcorrects{$student}=~s/QAB_//go; $studentcorrects{$student}=~s/QAN_//go;
		@answerlist=split("\t",$studentcorrects{$student});
		%answerarray=@answerlist;if (@answerlist) {%qlist=%answerarray;}
		foreach $qnum (sort {$a <=> $b;} keys %answerarray)
		{
			if (substr($qnum,0,1) ne 'Q') {
				print sprintf(" %5d",$answerarray{$qnum});
				@total[$qnum]+=$answerarray{$qnum};
				$qarray{$qnum}.=$answerarray{$qnum}."\t";
			}
		}
		print "\n";
	}
	print "\n";
	print sprintf("%22s","Question #");
	foreach $qnum (sort {$a <=> $b;} keys %qlist)
	{
		if (substr($qnum,0,1) ne 'Q') {
			print " <A HREF='#Q$qnum'>", sprintf("  %3d",$qnum),'</A>';
		}
	}
	print sprintf("\n%22s","Total");
	foreach $qnum (sort {$a <=> $b;} keys %qlist)
	{
		if (substr($qnum,0,1) ne 'Q') {
			print sprintf(" %5d",@total[$qnum]);
		}
	}
	print sprintf("\n%22s","Discrimination Index");
	foreach $qnum (sort {$a <=> $b;} keys %qarray)
	{
		chop $qarray{$qnum};
		@listcorrect=split("\t", $qarray{$qnum});
		$lengtharray=@listcorrect;
		$halfarray=int($lengtharray/2);
		$topcorrect=sum(@listcorrect[0..$halfarray-1]);
		$lowcorrect=sum(@listcorrect[($halfarray+(($halfarray==($lengtharray/2))?0:1))..$lengtharray]);
		if ($topcorrect+$lowcorrect)
		{ print $qinfoarray{$qnum} = sprintf(" %5.2f",($topcorrect-$lowcorrect)/($topcorrect+$lowcorrect));}
		else
		{ print $qinfoarray{$qnum} =sprintf(" %5s",'---');}
		$qinfoarray{$qnum} = '<font color=red>Percent Correct = '.(($lengtharray>0)?(sprintf(" %3d",int(100*&sum(@listcorrect)/$lengtharray))):'     -').'%    Discrimination Index = '.$qinfoarray{$qnum}.'</font>';
	}
	print "\n";
	print sprintf("%22s","Percent Correct");
	foreach $qnum (sort {$a <=> $b;} keys %qarray)
	{
		@listcorrect=split("\t", $qarray{$qnum});
		$lengtharray=@listcorrect;
		print (($lengtharray>0)?(sprintf(" %5d",int(100*&sum(@listcorrect)/$lengtharray))):'     -');
	}
############################################ essay counts ############################################
# link to essay grading form
	print "\n</PRE><BR><BR><HR><BR><H2 ALIGN=CENTER><A HREF='$CGIName?Start=GradeEssays&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd'>Essays</A></H2>\n<PRE>\n";
	print "Name           word count\n\n";
	foreach $student (@rostermembers)
	{
		$answer=$studentessays{$student};$answer=~s/QAE_//go;
		@answerlist=split("\t",$answer);
		%answerarray=@answerlist;
		if (@answerlist) {%essaylist=%answerarray;}
		print "<A HREF='$CGIName?Start=GradeEssays&StudentName=$student&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd'>";
		print $student,"</A>",' ' x (15-length($student));
		foreach $essaynum (sort {$a <=> $b;} keys %answerarray)
		{ print sprintf("%6d ",($numwords=split(" ",$answerarray{$essaynum}))); }
		print "\n";
	}
	print sprintf("\n%15s","Question #");
	foreach $essaynum (sort {$a <=> $b;} keys %essaylist)
	{	print "   <A HREF='$CGIName?Start=GradeEssays&EssayNumber=$essaynum&AssignmentName=$assignmentname&UserName=$username&PassWord=$passwd'>";
		print sprintf("%3d</A> ",$essaynum);
	}
	print "\n";

############################################ Question List ############################################
# links from question numbers above?
	print "\n</PRE><BR><BR><HR><BR><H2 ALIGN=CENTER>Questions</H2>\n<PRE>\n";
	&getQuestions;
	$numquestions=@questions/2;
	$qnum=0;
	while (@questions)
	{
		++$qnum;
		if ($randommethod eq 'person') {srand($qnum+&hashname($student))} else {srand($qnum)};
		$question=shift(@questions);
		while (substr($question,0,1) eq '#') {$question=shift(@questions);}
		$question=~s/</&lt;/go;$question=~s/>/&gt;/go;#&eqn(shift(@questions));
		@answers=split("\t",shift(@questions));#&eqn(shift(@questions));
		($numanswers=sprintf("%2d",$anum=@answers)) =~ s/ /0/go;
		print "\n<A NAME='Q$qnum'>$qnum.</A> $question\n<BLOCKQUOTE>";
		$anum=0;
		foreach $answer (@answers)
		{
			$answer=~s/</&lt;/go;$answer=~s/>/&gt;/go;
			print "$anum. ";
			print "<font color=red>[ ".sprintf("%4d",$dcounter{$qnum.'_'.$anum})." ]</font>" if (substr($question,0,1) ne 'Q');
			print " $answer\n";
			++$anum;
		}
		print "</BLOCKQUOTE>";
		print '  ',$qinfoarray{$qnum},"\n";
	}
	print "\n\n</PRE>\n<BR><BR><HR><BR><BR><FONT COLOR=CYAN SIZE=-1><CENTER>produced by <A HREF='http://www.northpark.edu/~martin/WWWAssign'>WWWAssign</A></CENTER></FONT><BR>\n",$query->end_html;
}

sub ExcelGrades
{
	print $query->header('application/x-excel');
	%studentanswers=();%studentcorrects=();@rank=();
############################################ list total grades ############################################
	$now_string = localtime;
	print "WWWAssign Grades\t",$longname,"\t",@teachernames[0],"\t",$now_string,"\n";
#put Java anchor on percent grade to deliver sorted students with bar graphs and histogram, plot objective vs essays
	print "Name\tScore\tTotal\tPercent\t(# essays)\tScore\tTotal\tPercent\tRaw Total\tTotal Percent\n";
	foreach $student (@rostermembers) #could also sort list here rather than go in order of roster
	{
		@grade=&Grade($student);	#table?
		if (@grade[1]==0) {
			print $student,"\t'- not taken\n";
			push(@rank,"0_$student");
		} else {
			$percentgrade=100.*@grade[0]/@grade[1];
			if (@grade[4]) {$percentessay=100.*@grade[3]/@grade[4];} else {$percentessay='';};
			$totpercent=100.*(@grade[0]+@grade[3])/(@grade[1]+@grade[4]);
			print $student,"\t";
			print @grade[0],"\t",@grade[1],"\t",$percentgrade,"\t",@grade[2],"\t",@grade[3],"\t",@grade[4],"\t",$percentessay,"\t",@grade[0]+@grade[3],"\t",$totpercent,"\n";
			push(@rank,(@grade[0]+@grade[3])."_$student");
			if ((@grade[1]+@grade[4])>$maxtotal) {$maxtotal=(@grade[1]+@grade[4])}
		}
	}

############################################ list question totals ############################################
	@rankedstudents=();
	foreach $ranking (sort {$b <=> $a;} @rank)
	{
		($grade,$student)=split("_",$ranking);
		push(@rankedstudents,$student) if ($grade>0);
	}
	print "\n\n\n\nQuestion Totals\n";
	print "Name (ranked)\t1=correct answer\t0=wrong answer\n\n";
	@total=();%qarray=();
#	foreach $student (@rostermembers) #sort by rank?
	foreach $student (@rankedstudents)
	{
		print $student;
		$studentcorrects{$student}=~s/QAC_//go; $studentcorrects{$student}=~s/QAB_//go; $studentcorrects{$student}=~s/QAN_//go;
		@answerlist=split("\t",$studentcorrects{$student});
		%answerarray=@answerlist;if (@answerlist) {%qlist=%answerarray;}
		foreach $qnum (sort {$a <=> $b;} keys %answerarray)
		{
			if (substr($qnum,0,1) ne 'Q') {
				print "\t",$answerarray{$qnum};
				@total[$qnum]+=$answerarray{$qnum};
				$qarray{$qnum}.=$answerarray{$qnum}."\t";
			}
		}
		print "\n";
	}
	print "Total";
	foreach $qnum (sort {$a <=> $b;} keys %qlist)
	{
		if (substr($qnum,0,1) ne 'Q') {
			print "\t",@total[$qnum];
		}
	}
	print "\n";
	print "Question #";
	foreach $qnum (sort {$a <=> $b;} keys %qlist)
	{
		if (substr($qnum,0,1) ne 'Q') {
			print "\t",$qnum;
		}
	}
	print "\n";
	print "Discrimination Index";
	foreach $qnum (sort {$a <=> $b;} keys %qarray)
	{
			chop $qarray{$qnum};
			@listcorrect=split("\t", $qarray{$qnum});
			$lengtharray=@listcorrect;
			$halfarray=int($lengtharray/2);
			$topcorrect=sum(@listcorrect[0..$halfarray-1]);
			$lowcorrect=sum(@listcorrect[($halfarray+(($halfarray==($lengtharray/2))?0:1))..$lengtharray]);
			if ($topcorrect+$lowcorrect)
			{ print "\t",($topcorrect-$lowcorrect)/($topcorrect+$lowcorrect);}
			else
			{ print "\t",'---';}
	}
}

sub Grade
{
	$gradestudent=@_[0];
	&getQuestions;
	$answerfile="$filelocation$SL$gradestudent";$answerfile=~s|$SL$SL|$SL|go;
	undef $/;
	if (open(ANSWERFILE,"$answerfile")) # || die "Can't find $answerfile: $!";
	{
		$filecontents=(<ANSWERFILE>);
		$/ = "\n";close(ANSWERFILE);
		@entries=split("\n",$filecontents);
		%entry=();
		$studentanswers{$gradestudent}=();
		$studentcorrects{$gradestudent}=();
		$studentessays{$gradestudent}=();
		$numresponses=0;
		foreach(@entries)
		{	($qname,$answer)=split("\t",$_,2);
			if ($qname eq 'CollectTime') {$numresponses++;}#this only works for monosection?
			if ($gradingmethod eq 'last')	# first is default (even though multiple submissions are allowed), last must be explicit
			{
				$entry{$qname}=$answer;
			}
			else {if (!(length $entry{$qname})) {$entry{$qname}=$answer;}}# this actually allows null submissions in first to be replaced by later response
		}
		$qnum=0;$numq=0;$numessays=0;$totessays=0;$sumessays=0;$numcorrect=0;
		while (@questions) # previously, foreach $qname (keys(%entry))
		{
			++$qnum;
			if ($randommethod eq 'person') {srand($qnum+&hashname($student))} else {srand($qnum)};
			$correct=0;
			$question=&eqn(shift(@questions));
			$commentary='';
			while (substr($question,0,1) eq '#') {$commentary.=substr($question,1,length $question);$question=&eqn(shift(@questions));}
			#print $commentary."<BR>\n" if ($commentary);
			
			
			$mode='C';
			if (substr($question,0,2) eq 'QN') { $mode='N';}
			if (substr($question,0,2) eq 'QB') { $mode='B';}
			if (substr($question,0,2) eq 'QP') { $mode='P';}
			if (substr($question,0,2) eq 'QE') { $mode='E';}
			$qname='QA'.$mode."_$qnum";
			
			$qname=~s/QK/QA/o;
			$thisanswer=$entry{$qname};
			@answers=split("\t",&eqn(shift(@questions)));
			
	# mutiple-Choice question
			if ($mode eq 'C')
			{	++$numq;
				$numa=@answers;
				@ans=();@ans=ShuffleDeck($numa);
				if ($thisanswer ne '') {if (@ans[$thisanswer]==0) {$correct=1;}}
				$studentanswers{$gradestudent}.="$qname\t@ans[$thisanswer]\t";
				$dcounter{$qnum.'_'.@ans[$thisanswer]}++ if ($thisanswer ne '');
			}
	# Numerical question
			if ($mode eq 'N')
			{	++$numq;
				if (!(length @answers[1])) {@answers[1]=abs(0.02*@answers[0]);}#default 2% tolerance
				if ($thisanswer ne '') {if (($thisanswer<=(@answers[0]+@answers[1]))&&($thisanswer>=(@answers[0]-@answers[1]))) {$correct=1;}}
				$studentanswers{$gradestudent}.="$qname\t$thisanswer\t";
			}
	# fill-in-the-Blank question
			if ($mode eq 'B')
			{	++$numq;
				$caseanswer=$thisanswer;
				$caseanswer=~tr/A-Z/a-z/;	# canonicalize to lower case to be case insensitive
				$caseanswer=~s/	//go;$caseanswer=~s/ //go;	 # remove extra tabs and spaces
				foreach $possible (@answers) {		$possible=~tr/A-Z/a-z/;$possible=~s/  //go;$possible=~s/ //go; if ($possible eq $caseanswer) {$correct=1;}}
				$studentanswers{$gradestudent}.="$qname\t$thisanswer\t";
			}
	# proof-reading question (formerly Poll)
			if ($mode eq 'P')
			{
				++$numq;
				$caseanswer=$thisanswer;
				$caseanswer=~tr/A-Z/a-z/;	# canonicalize to lower case to be case insensitive
				$caseanswer=~s/	//go;$caseanswer=~s/ //go;	 # remove extra tabs and spaces
				foreach $possible (@answers) {		$possible=~tr/A-Z/a-z/;$possible=~s/  //go;$possible=~s/ //go; if ($possible eq $caseanswer) {$correct=1;}}
				$studentanswers{$gradestudent}.="$qname\t$thisanswer\t";
			}
			if ($correct) { $numcorrect++; }
			$studentcorrects{$gradestudent}.="$qname\t$correct\t";
	# Essay question
			if ($mode eq 'E')
			{	$numessays++;
				$studentessays{$gradestudent}.="$qname\t$thisanswer\t";
				($sum,$tot,$comment)=split("\t",$entry{'QGE_'.$qnum});
				$sumessays+=$sum;$totessays+=$tot;
			}
		}
		$numtotal=$numq; # -$numessays not included any more
	} else {
		$numcorrect=0;$numtotal=0;$numessays=0;$/ = "\n";
	}
	return ($numcorrect,$numtotal,$numessays,$sumessays,$totessays);
}

sub CollectSection
{
	open(ANSWERFILE,">>$answerfile") || die "Error: couldn't write to ANSWERFILE:$answerfile: $!\n";
	@qnames = $query->param;
	$now_string = localtime;
	print ANSWERFILE 'CollectTime'.(($sectionnumber>1)?"$sectionnumber":''),"\t",$now_string,"\n";
	foreach $qname (@qnames)
	{
		$answer=$query->param($qname);
		$answer=~ s/\r/\n/go;	$answer=~ s/\n\n/\n/go;$answer=~ s/\n/<BR>/go;$answer=~ s/\t/ - /go;	# essay answers (only?) must first be stripped of \n,\r, etc.
		if (substr($qname,0,1) eq 'Q')
		{
			$qname=~s/_0/_/go; #strip leading zero which was required by Javascript -- no longer necessary?
			print ANSWERFILE $qname,"\t",$answer,"\n";
		} else {#this could record other info than StartTime, ought to make this more general; but don't want passwords recorded!
			if ($qname eq 'StartTime') {	print ANSWERFILE $qname,"\t",$answer,"\n";		}
		}
	}
	close(ANSWERFILE);
	# add: go on to next section, or grade whole test.
	@sectionlist=split(",",$allfilelist);
	$filename=@sectionlist[$sectionnumber];
	if ($filename) { &Administer; } else { &PrintGrade; }
}


sub CollectEssayGrades
{
	@essaynames = $query->param;
	%grades=();
	foreach $essayname (sort @essaynames)
	{
		($student,$qname,$num)=split("_",$essayname);
		if ($qname eq 'QGE') 
			{
				$essaygrade=$query->param($essayname);
				$essaytotal=$query->param($student."_QEG_".$num);
				$essaycomment=$query->param($student."_QEC_".$num);
				$essaycomment=~s/\r/\n/go;$essaycomment=~s/\n\n/\n/go;$essaycomment=~s/\n/<BR>/go;$essaycomment=~ s/\t/ - /go;
				$essayentry="QGE_$num\t$essaygrade\t$essaytotal\t$essaycomment\n";
				if ($essaytotal) {		$grades{$student}.=$essayentry; };
				#might want to allow zero grade in order to deliver comments, but that interferes with allowing grading of only some essays
			}
	}
	foreach $student (keys %grades)
	{
		if (grep($student eq $_,@rostermembers))
		{
			$answerfile="$filelocation$SL$student";$answerfile=~s|$SL$SL|$SL|go;
			if (open(ANSWERFILE,">>$answerfile"))
			{
				print ANSWERFILE $grades{$student};
				close(ANSWERFILE);
			} #else {print "no $answerfile";}
		}
	}
}


sub PrintGrade
{
	@grade=&Grade($username);
	&Heading;
	if (@grade[1]) { print $query->h1(sprintf("$username - @grade[0] / @grade[1] = %5.2f %",100.*@grade[0]/@grade[1])),"<BR>\n"; }
	print "<P><HR><P><H2 ALIGN=CENTER><A HREF=$URLreturn>done</A></H2>\n";
	print $query->end_html;
}

sub Administer
{
	&Heading;
	$queryfile="$filelocation$SL$filename";$queryfile=~s|$SL$SL|$SL|go;
	undef $/; open(TESTFILE,$queryfile) || die "Can't find $queryfile: $!";
	$filecontents=(<TESTFILE>); $/ = "\n";close(TESTFILE);
	$filecontents=~ s/\r/\n/go;$filecontents=~ s/\n\n/\n/go;
	@questions=split("\n",$filecontents);
	$numquestions=0;
	foreach (@questions) {$numquestions++ if ((substr($_,0,1) ne '#'))}
	$numquestions=$numquestions/2;
	($qn=sprintf("%2d",$numquestions)) =~ s/ /0/go;
	++$sectionnumber;
	print "\nThis assignment has $numsections section";if ($numsections>1) { print "s";};
	print ".	Section $sectionnumber has $numquestions questions.<BR>\n";
	print "Make sure you click the \"Submit\" button at the end.<BR>\n";
	print "You may not return to this section after submitting it.<BR>\n<BR>\n";
	print "<BR><font color=red>$announcement</font><BR>" if ($announcement);
	$formname="QF_" . $qn;
	print $query->startform(-method=>'POST',-name=>$formname,	-action=>$CGIName);

	open(ANSWERFILE,">>$answerfile") ||	 die "Error: couldn't write to ANSWERFILE:$answerfile: $!\n";
	#`chmod 660 $answerfile`; #use something like this if faculty cannot access files.
	$qnum=$lastqnum;
	while (@questions)
	{
		++$qnum;
		if ($randommethod eq 'person') {srand($qnum+&hashname($student))} else {srand($qnum)};
		$question=&eqn(shift(@questions));
		$commentary='';
		while (substr($question,0,1) eq '#') {$commentary.=substr($question,1,length $question);$question=&eqn(shift(@questions));}
		print $commentary."<BR>\n" if ($commentary);
		@answers=();
		@answers=split("\t",&eqn(shift(@questions)));
		($numanswers=sprintf("%2d",$anum=@answers)) =~ s/ /0/go;
		print "\n<BR>\n";#<HR>
		if ((substr($question,0,1) eq 'Q')) # && (substr($question,1,1) ne 'u') ?? make sure the question doesn't begin with "Question" or "Quantun" etc.
		{
				if (substr($question,1,1) eq 'B')	################# Fill-in-the-Blank(s)
				{
					$aname="QAB_$qnum";
					if ($question =~ m/<_>/)
					{
						$question =~ s/QB //;$question =~ s/<_>/ <_> /go;
						@parts=split('<_>',$question,2);
					}
					else
					{
						$question =~ s/QB //;$question =~ s/_/ _ /go; # allows blanks to be at the very beginning or end of a string
						@parts=split("_",$question,2); #only one blank allowed here
					}
					print "$qnum. " . @parts[0];
					print "\n<INPUT TEXT	SIZE=20 NAME='$aname'>\n";
					print @parts[1],"<P>\n";
					print ANSWERFILE "QKB_$qnum\t",join("\t",@answers),"\n";#this prints the key at the time, if randseed for <eqn> works, then this key is superfluous
				}
				if (substr($question,1,1) eq 'N')	################# Fill-in-the-Number(s)
				{
					$aname="QAN_$qnum";
					if ($question =~ m/<_>/)
					{
						$question =~ s/QN //;$question =~ s/<_>/ <_> /go;
						@parts=split('<_>',$question,2);
					}
					else
					{
						$question =~ s/QN //;$question =~ s/_/ _ /go; # allows blanks to be at the very beginning or end of a string
						@parts=split("_",$question,2); #only one blank allowed here
					}
					print "$qnum. " . @parts[0];
					print "\n<INPUT TEXT SIZE=20 NAME='$aname'>\n";
					print @parts[1],"<P>\n";
					print ANSWERFILE "QKN_$qnum\t",join("\t",@answers),"\n";#this prints the key at the time, if randseed for <eqn> works, then this key is superfluous
				}
				if (substr($question,1,1) eq 'P')	################# Proof-reading
				{
					$aname="QAP_$qnum";
					$question =~ s/QP //;
					($directions,$prooftext)=split("\t",$question);
					print "$qnum. $directions <P>\n";
					$rows=$height; if ($rows<=3) {		$rows=3; };#These defaults can be overridden with <eqn $height=yoursize;$width=yoursize;''> in the body of the question.
					$cols=$width; if ($cols<=30) {	 $cols=80; };
					print "<TEXTAREA NAME='$aname' ROWS='$rows' COLS='$cols' wrap=on>$prooftext</TEXTAREA>";
				}
				if (substr($question,1,1) eq 'E')	################# Essay
				{
					$aname="QAE_$qnum";
					$question =~ s/QE //;
					print "$qnum. $question <P>";#$query->h1();
					$rows=@answers[0]; if ($rows<=3) {		$rows=3; };
					$cols=@answers[1]; if ($cols<=30) {	 $cols=30; };
					print "<TEXTAREA NAME='$aname' ROWS='$rows' COLS='$cols' wrap=on></TEXTAREA>";
#					print $query->textarea(-name=>"$aname",-rows=>"$rows",-cols=>"$cols");
				}
		}
		else
		{
			$aname="QAC_$qnum";
			print "$qnum. $question <P>\n<DL>";#$query->h1()
			$numa=@answers;
			@ans=();@ans=ShuffleDeck($numa);
			for ($an=0;$an<$numa;$an++)
			{
				print "<DD><INPUT TYPE=RADIO	NAME='$aname' VALUE='$an'>";
				print " @answers[@ans[$an]]";
				print "<BR>\n";
			}
			print '</DL>';
			print ANSWERFILE "QKC_$qnum\t",join("\t",@ans),"\n";
		}
	}
	$lastqnum=$qnum;
	print $query->hidden(-name=>"AssignmentName",-value=>"$assignmentname"),"\n";
	#note: the values passed in $query are sticky, so print the hidden form literally when values need to change!
	print "<INPUT TYPE='hidden' NAME='StartTime' VALUE='$now_string'>\n";
	print "<INPUT TYPE='hidden' NAME='LastQnum' VALUE='$lastqnum'>\n";
	print "<INPUT TYPE='hidden' NAME='Start' VALUE='Next'>\n";
	print "<INPUT TYPE='hidden' NAME='SectionNumber' VALUE='$sectionnumber'>\n";
	print $query->hidden((-name=>"UserName",-value=>"$username")),"\n";
	print $query->hidden((-name=>"PassWord",-value=>"$passwd")),"\n";
	print "\n<HR><BR><CENTER>\n";
	if (($numsections-1) == $sectionnumber)
	{	print $query->submit(-name=>"Submit",-value=>"Submit Section $sectionnumber of $numsections");	}
	else
	{	print $query->submit(-name=>"Submit",-value=>"Submit Section"); }
	print "\n<HR><BR></CENTER>\n";
	print $query->endform,"\n";
	close(ANSWERFILE);

	print $query->end_html;
}

# sub AdministerSection = browser graded assignment where JavaScript takes the load of formatting and grading; removed in this version.

sub quote {
print <<ENDQUOTE;
<CENTER>\n
<TABLE BORDER=2 CELLSPACING=2 CELLPADDING=2 WIDTH="80%" BGCOLOR=$BGCOLOR >
<TR>
<TD><FONT COLOR=blue>&quot;You go to a great school not so much for 
knowledge as for arts and habits; for the habit of attention, for the art of entering into 
another person's thoughts, for the habit of submitting to censure and refutation,
for the art of indicating assent and dissent in graduated terms, for the
art of working out what is possible in a given time, for taste, for discrimination,
for mental courage and mental soberness.&quot; 
<I>William Johnson Cory</I></FONT></TD>
</TR>
</TABLE>\n</CENTER>\n<P><HR><P>\n
ENDQUOTE
}

sub ShuffleDeck
{	 local ($i,$r,$temp,@deck);
		@deck=();
		for($i=0;$i<@_[0];$i++) { @deck[$i]=$i;};
		for($i=0;$i<@_[0];$i++){
			$r=randint(@_[0])-1;
			$temp=@deck[$i];
			@deck[$i]=@deck[$r];
			@deck[$r]=$temp;
		}
		return @deck;
}

sub eqn
{
	local $result;
	while (@_[0] =~ /<eqn ([^>]*)>/)
	{	$result=eval($1);	@_[0] =~ s/<eqn ([^>]*)>/$result/;}
	@_[0];
}

sub randint { int(@_[0]*rand()+1);}
sub randint0 { int((@_[0]+1)*rand());}
sub randnum { int(@_[0]+@_[2]*randint0(int((@_[1]-@_[0])/@_[2])));}
sub pickone { @_[$PICKONE=int(@_*rand())];}

sub picksame { @_[$PICKONE];}

sub decform
{
		return sprintf("%.".@_[1]."f",@_[0]);
}

sub abs { (@_[0]<0)?@_[0]:-@_[0] }

sub sum { local $t=0; foreach (@_) {$t+=$_;} return $t;}

#argument of asin is [sin(angle)]
sub asin { atan2(@_[0],sqrt(1-@_[0]*@_[0])) }

#argument of acos is [cos(angle)]
sub acos { atan2(sqrt(1-@_[0]*@_[0]),@_[0]) }

#argument of tan is [angle]
sub tan { sin(@_[0])/cos(@_[0]) }

#argument of deg is [angle in rad]
sub deg { @_[0]*180/2/atan2(1,0) }

#argument of rad is [angle in deg]
sub rad { @_[0]*4*atan2(1,1)/180 }

sub hashname
{
		local $name=@_[0];
		if (!($hashedname{$name}))
		{
			local $t=0;
			foreach (split('',$name)) {$t+=ord $_;}
			$hashedname{$name}=$t;
		}
	return $hashedname{$name}
}

sub threefigs
{
	return eval(sprintf("%.2E",@_[0]));
}


