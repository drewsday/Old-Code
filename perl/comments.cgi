#!/usr/local/bin/perl

#######################################################################
##                                        				   ##
##                              WebBBS           			   ##
##                        by Darryl Burgdorf           		   ##
##                     (e-mail burgdorf@awsd.com)       		   ##
##                                        				   ##
##        		      last modified:  12/13/97        		   ##
##                         copyright (c) 1997           		   ##
##                                        				   ##
##                   latest version is available from    		   ##
##                       http://awsd.com/scripts/        		   ##
##                                        				   ##
#######################################################################
# COPYRIGHT NOTICE:								    #
#											    #
# Copyright 1997 Darryl C. Burgdorf.  All Rights Reserved.		    #
#											    #
# This program may be used and modified free of charge by anyone, so  #
# long as this copyright notice and the header above remain intact.   #
# By using this program you agree to indemnify Darryl C. Burgdorf     #
# from any liability.								    #
#											    #
# Selling the code for this program without prior written consent is  #
# expressly forbidden.  Obtain permission before redistributing this  #
# program over the Internet or in any other medium.  In all cases     #
# copyright and header must remain intact.				    #
#######################################################################
# 	                    Modifications for 				    #
#             Comment System Version 1.02 for News Publisher 	    #
#                              made by                                #
#	                      Grant Williams                            #
#	                           and                                  #
#	            Copyright 1999 - 2000 Grant Williams                #
#######################################################################
# COPYRIGHT NOTICE FOR MODIFICATIONS:					    #
#											    #
# News Publisher's copyright notice applies to all portions of this   #
# code that are for the modifications I made to WebBBS.	          #
#										          #
# A special thanks to Darryl C. Burgdorf for allowing me to make	    #
# these modifications and allowing me to redistribute it to the       #
# public.									          #
#######################################################################
# Define Variables

require "config.cgi";
require "np-lib.cgi";

#######################################################################
# 											    #
#    DO NOT EDIT BELOW THIS LINE						    #

&parse_query;
&parse_form;
&getdata;

$viewing = $query{'view'};
$command = $ENV{QUERY_STRING};

print "Content-Type: text/html\n\n";

if($viewing){
	&show;
}
elsif($command eq "admin"){
	&admin;
}
elsif($FORM{'post'}){
	&new_message;
	&message_added;
}
elsif($FORM{'delete'}){
	&delete_msg_now;
	&report_del;
}
else{
	print "That message was not found.";
}

sub show {
	&pageheader;

	print "<hr size=2 width=75\%>\n";
	print "<center>[ <a href=\"#followups\">Follow Ups</a> ] [ <a href=\"#postfp\">Post Followup</a> ] [ <a href=\"$mainpage\">News Page</a> ]</center>\n";
	print "<hr size=2 width=75\%><p>\n";

	print "<b>$subject{$viewing}</b>\n";
	print "<P>\n";

	print "Posted by ";
	print "<b><a href=\"mailto:";
	print "$email{$viewing}";
	print "\">";
	print "$author{$viewing}";
	print "</a></b>";
	print " ($ip{$viewing}) ";

	print "on $date{$viewing}";

	print " at $time{$viewing}\:<p>\n";

	print "$story{$viewing}\n";

	print "<br><hr size=2 width=75\%><p><b>\n";
	print "<a name=\"followups\">Follow Ups:</a></b><p>\n";

	&allthread($viewing);
	&responses($currentresponse);

	&post_followup($viewing);
	&pagefooter;
}

sub getdata {
	open(DIR,"$commentsdir/comments.txt");
		@data = <DIR>;
	close(DIR);

	foreach $line (@data) {
		chop($line);
		($message, $author, $email, $subject, $prev, $next, $date, $time, $ip, $story) = split(/\|/, $line);
			$author{$message} = $author;
			$email{$message} = $email;
			$subject{$message} = $subject;
			$prev{$message} = $prev;
			$next{$message} = $next;
			$date{$message} = $date;
			$time{$message} = $time;
			$ip{$message} = $ip;
			$story{$message} = $story;
	}
}

sub responses {
	local (@sortmessages);
	local (@newsortmessages);

	$nextresponse = $_[0];

	print "<ul>\n";
	&printthread($nextresponse);

	@sortmessages = split((/\,/),$next{$nextresponse});
	@newsortmessages = reverse(@sortmessages);

	foreach $response (@newsortmessages) {
		if($subject{$response}){
			&responses($response);
		}
	}
	print "</ul>\n";
}

sub allthread {
	$currentresponse = $_[0];

	if($prev{$currentresponse}){
		if($subject{$currentresponse}){
			&allthread($prev{$currentresponse});
		}
	}
}

sub printthread {
	$print_response = $_[0];

	print "<li>";

	if($viewing != $print_response){
		print "<a href=\"$CommentsScriptUrl\?view=$print_response\">";
	}
	print "$subject{$print_response}";

	if($viewing != $print_response){
		print "</a>";
	}

	print " - ";

	print "<b><a href=\"mailto:";
	print "$email{$print_response}";
	print "\">";
	print "$author{$print_response}";
	print "</a></b>";

	print " at <i>$time{$print_response}</i>";
	print " on $date{$print_response}";
	
}

sub new_message {
	if ($FORM{'name'} eq ""){
		print "Please go back and enter a NAME. The required fields are NAME,";
		if($email_rq == 2){
			print " EMAIL,";
		}
		print " SUBJECT and COMMENTS.";
		exit(0);
	}
	elsif ((($FORM{'email'} eq "") || ($FORM{'email'} !~ /.*\@.*\..*/)) && ($email_rq == 2)){
		print "Please go back and enter an valid EMAIL address. The required fields are NAME, EMAIL, SUBJECT and COMMENTS.";
		exit(0);
	}
	elsif ($FORM{'subject'} eq ""){
		print "Please go back and enter a SUBJECT. The required fields are NAME,";
		if($email_rq == 2){
			print " EMAIL,";
		}
		print " SUBJECT and COMMENTS.";
		exit(0);
	}
	elsif ($FORM{'comments'} eq ""){
		print "Please go back and enter some COMMENTS. The required fields are NAME,";
		if($email_rq == 2){
			print " EMAIL,";
		}
		print " SUBJECT and COMMENTS.";
		exit(0);
	}
	else{
		&get_access;	
		($secC,$minC,$hourC,$mdayC,$monC,$yearC,$wdayC,$ydayC,$isdstC) = localtime(time);

   		if ($minC < 10) { $minC = "0$minC"; }
   		if ($hourC < 10) { $hourC = "0$hourC"; }
		if ($secC < 10) { $secC = "0$secC"; }	
   		if ($mdayC < 10) { $mdayC = "0$mdayC"; }
		if ($monC < 10) { $monC = "0$monC"; }

   		$monthC = ($monC + 1);

		$real_yearC = $yearC % 100;
		$real_yearC = "0$real_yearC" if($real_yearC < 10);
		$dateC = "$monthC/$mdayC/$real_yearC";
		$timeC = "$hourC\:$minC\:$secC";

		#####
		$nameC = "$FORM{'name'}";
		$nameC =~ s/"//g;
		$nameC =~ s/<([^>]|\n)*>//g;
		$nameC =~ s/\|//g;

		if ($nameC =~ /(.*)--(.*)/) {
			$sname = "$1";
			$password = "$2";
			if ($password =~ /$passwd/) {
				$nameC = "<font color=$admin_color>$sname</font>";
			}
			else{
				$nameC = "$sname";
			}
		}
		else {
		  		$nameC = "$nameC";
		}
		#######

		$subjectC = "$FORM{'subject'}";
		$subjectC =~ s/\|//g;
	
	     if ($FORM{'email'} =~ /.*\@.*\..*/) {		
		$emailC = "$FORM{'email'}";
		$emailC =~ s/\|//g;
	     }	

		$comments = "$FORM{'comments'}";
		$comments =~ s/\cM//g;
		$comments =~ s/\n/<br>/g;
		$comments =~ s/\n\n/<p>/g;
      
		$comments =~ s/\|//g;

		$followup = "$FORM{'followup'}";
		$ip = $ENV{'REMOTE_ADDR'};

		&get_number;
		&edit_previous("$followup","$num");

		$write_n = join("\|",$num, $nameC, $emailC, $subjectC, $followup,"", $dateC, $timeC, $ip, $comments);
		$write_n .= "\n";
		open (FILEc,">>$commentsdir/comments.txt");
			flock(FILEc, 2);   	
   				print FILEc "$write_n";	
			flock(FILEc, 8);
      	close(FILEc);

		&allthread($followup);
		&count($currentresponse);
	}
}

sub message_added {
	print "<html><head><title>Message Added: $subjectC</title></head>\n";
   	print "<!--VirtualAvenueBanner-->\n";
	print "<center><font face=\"Arial\"><h1>Message Added: $subjectC</h1></font></center>\n";
   	print "<font size=2 face=\"Arial\">\n";
   	print "The following information was added to the message board:<p>\n";
	print "<b>Name:</b> $nameC<br>\n";
   	print "<b>E-Mail:</b> $emailC<br>\n";
   	print "<b>Subject:</b> $subjectC<br>\n";
   	print "<b>Comments:</b><p>\n";
   	print "$comments<p>\n";
   	print "<b>Added on Date:</b> $dateC<br>\n";
	print "<b>Host:</b> $ip<p>\n";
   	print "<center>[ <a href=\"$CommentsScriptUrl\?view=$num\">Go to Your Message</a> ] [ <a href=\"$mainpage\">News Page</a> ]</center>\n";
   	print "</font></body></html>\n";

	&get_general_configuration;
	&get_individual_configuration;
	@cat_data = ();
	if(! -e "$datadir/categories.file"){
		push (@cat_data, "1|:|Default\n");
	}
	else {
		open(DIR,"$datadir/categories.file");
  			@cat_data = <DIR>;
      	close(DIR);
	}

	foreach $cat_data_line (@cat_data){
		chomp($cat_data_line);                    
   		($cat_data_Id_msg, $cat_data_Name) = split(/\|:\|/,$cat_data_line);

		&updateHeadlinefile("$cat_data_Id_msg");
		&updateNewsfile("$cat_data_Id_msg");
		&updateArchives("$cat_data_Id_msg");
	}

	if($cg_use_categories == 2){
		&updateHeadlinefile("all");
		&updateNewsfile("all");
	}
}

sub post_followup {
	$followup = $_[0];
	print "<br><hr size=2 width=75\%><p>\n";
	print "<b><a name=\"postfp\">Post a Followup:</a></b><p>\n";
	print "<form method=POST action=\"$CommentsScriptUrl\">\n";
	print "<input type=hidden name=\"followup\" value=\"$followup\">\n";
	print "Name: <input type=text name=\"name\" size=30><br>\n";
	print "E-Mail: <input type=text name=\"email\" size=30><p>\n";
	print "Subject: <input type=text name=\"subject\" value=\"";
    if ($subject{$followup} =~ /^Re:/) {
	print "$subject{$followup}";
    }
    else {
	print "Re: $subject{$followup}";
    }
	print "\" size=30><p>\n";
	print "Comments:<br>\n";

	print "<textarea name=\"comments\" COLS=$colswidth ROWS=$rowswidth>\n";
	
	@quote_text = split(/<p>/,$story{$followup});
      foreach $quote_text (@quote_text) {
         @lines = split(/<br>/,$quote_text);
         foreach $line (@lines) {
            print ": $line\n";
         }
	   print "\n";
      }

	print "</textarea>\n";
	print "<p>\n";
	print "<input type=submit name=\"post\" value=\"Submit Follow Up\"> <input type=reset>\n";
	print "</form>\n";

}

sub edit_previous {
	$edit = $_[0];
	$editnext = $_[1];

	open(READ_C,"$commentsdir/comments.txt");
  	flock(READ_C, 2);	
   		@pComments = <READ_C>;
   	flock(READ_C, 8);
  	close(READ_C);

  	open(WRITE_E,">$commentsdir/comments.txt");
  	flock(WRITE_E, 2);	

	foreach $line_e (@pComments) {
		chop($line_e);                    
		($message1, $author1, $email1, $subject1, $prev1, $next1, $date1, $time1, $ip1, $story1) = split(/\|/, $line_e);

		if ("$edit" eq "$message1"){
			$next1 .= "$editnext\,";

			$write_e = join("\|",$message1, $author1, $email1, $subject1, $prev1, $next1, $date1, $time1, $ip1, $story1);
  			print WRITE_E "$write_e\n";
		}
		else{
			print WRITE_E "$line_e\n";
		}
}

  flock(WRITE_E, 8);
  close(WRITE_E);

}

sub count {
	$msgnum = $_[0];

	open(READ_CT,"$commentsdir/data.txt");
  	flock(READ_CT, 2);	
   		@data_ct = <READ_CT>;
   	flock(READ_CT, 8);
  	close(READ_CT);

  	open(WRITE_CT,">$commentsdir/data.txt");
  	flock(WRITE_CT, 2);	

	foreach $line1 (@data_ct) {
		chop($line1);                    
		($storyid, $messagenum, $count) = split(/\|/, $line1);

		if ("$msgnum" eq "$messagenum"){
			$count += 1;

			$write1 = join("\|",$storyid, $messagenum, $count);
  			print WRITE_CT "$write1\n";
		}
		else{
			print WRITE_CT "$line1\n";
		}
}

  flock(WRITE_CT, 8);
  close(WRITE_CT);

}

sub get_access {
  open(FILENOA,"$noaccess");
    $access = <FILENOA>;
  close(FILENOA);
  if ($access =~ $ENV{'REMOTE_ADDR'}) {    #REMOTE_ADDR
	print "You have been banned. If you believe this is an error\, please email the webmaster.";
	exit(0);
  }
}

####################################################

sub admin {
	print "<html>\n";
	print "<head><title>Remove Comments for News Publisher</title></head>\n";
	print "<body>\n";
	print "<center><b><h2>Remove Comments</h2></b></center>\n";
	print "<center>You may delete any of the comments that have been posted.\n";
	print "To delete a comment you check the box on the left side of the table.\n";
	print "The (Thread) under the box in the delete column indicates the entire thread is deleted if the box is selected.</center>\n";

	print "<form method=POST action=\"$CommentsScriptUrl\">\n";

	print "<center><b>Password:</b> <input type=\"password\" name=\"adminpass\" size=20></center><br>\n";
	print "<center>\n";
	print "<table border=\"1\" cellspacing=\"1\" cellpadding=\"5\">\n";
	print "<tr>\n";
	print "<td align=\"center\"><b>Delete</b></td>\n";
	print "<td align=\"center\"><b>Post \#</b></td>\n";
	print "<td align=\"center\"><b>Subject</b></td>\n";
	print "<td align=\"center\"><b>Author</b></td>\n";
	print "<td align=\"center\"><b>Date Posted</b></td>\n";
	print "</tr>\n";

	open(DIR,"$commentsdir/comments.txt");
		@admin_data = <DIR>;
	close(DIR);

	@admin_data = reverse(@admin_data);
 
	foreach $admin_line (@admin_data) {
		chop($admin_line);
		($admin_message, $admin_author, $admin_email, $admin_subject, $admin_prev, $admin_next, $admin_date, $admin_time, $admin_ip, $admin_story) = split(/\|/, $admin_line);
			push(@sorted_data,$admin_message);
			print "<tr>\n";
			print "<td align=\"center\"><input type=\"checkbox\" name=\"$admin_message\" value=\"yes\">";
			print "<br>(Thread)" if($admin_prev eq "");
			print "</td>\n";
			print "<td align=\"center\"><b>$admin_message</b></td>\n";
			print "<td align=\"left\"><a href=\"$CommentsScriptUrl\?view=$admin_message\">$admin_subject</a></td>\n";
			print "<td align=\"left\">$admin_author</td>\n";
			print "<td align=\"left\">$admin_date - $admin_time</td>\n";
			print "</tr>\n";
	}

	print "</table>\n";
	print "</center>\n";

	@sorted_data = (sort { $a <=> $b } @sorted_data);
	$max = pop(@sorted_data);
	$min = shift(@sorted_data);

	print "<input type=hidden name=\"min\" value=\"$min\">\n";
	print "<input type=hidden name=\"max\" value=\"$max\">\n";

	print "<center>\n";
	print "<br><input type=submit name=\"delete\" value=\"Delete Comments\"> <input type=reset>\n";
	print "</center>\n";

	print "</form>\n";

	print "</body>\n";
	print "</html>\n";
}

sub delete_msg_now {
	if ($FORM{'adminpass'} ne $passwd) {
		print "Sorry, the password you have entered is incorrect. Try again.";
		exit(0);
	}
	
	local (@DeletedMsgs);
	for($i=$FORM{'min'}; $i<=$FORM{'max'}; $i++){
		if($FORM{$i} eq 'yes'){
			push(@delete,$i);
		}
	}

	foreach $msg_del (@delete){
		if ($prev{$msg_del} eq ""){
			&remove_data("$msg_del");
			&remove_thread("$msg_del");
		}
		else {
			&remove_msg_data("$msg_del");
			&remove_msg("$msg_del");
		}
	}

	print "<html>\n";
	print "<head><title>Remove Comments for News Publisher</title></head>\n";
	print "<body>\n";
	print "<center><b><h2>Results of Remove Comments</h2></b></center>\n";
	print "<center>\n";
	print "The following comments have been deleted:<p>\n";

	$PrevMsgDel = 0;
	@DeletedMsgs = (sort { $a <=> $b } @DeletedMsgs);
	foreach $DelMsgs (@DeletedMsgs){
		if($DelMsgs != $PrevMsgDel){
			print "$DelMsgs ";
		}
		$PrevMsgDel = $DelMsgs;
	}

	print "</center>\n";

	print "<hr>\n";
	print "<center>\n";
	print "<a href=\"$CommentsScriptUrl?admin\">Back to Remove Comments</a>\n";
	print "</center>\n";
	print "</body>\n";
	print "</html>\n";
	
	&get_general_configuration;
	&get_individual_configuration;
	@cat_data = ();
	if(! -e "$datadir/categories.file"){
		push (@cat_data, "1|:|Default\n");
	}
	else {
		open(DIR,"$datadir/categories.file");
  			@cat_data = <DIR>;
      	close(DIR);
	}

	foreach $cat_data_line (@cat_data){
		chomp($cat_data_line);                    
   		($cat_data_Id_msg, $cat_data_Name) = split(/\|:\|/,$cat_data_line);

		&updateHeadlinefile("$cat_data_Id_msg");
		&updateNewsfile("$cat_data_Id_msg");
		&updateArchives("$cat_data_Id_msg");
	}

	if($cg_use_categories == 2){
		&updateHeadlinefile("all");
		&updateNewsfile("all");
	}
}

sub remove_msg {
	$msg_del = $_[0];
	open(DIR,"$commentsdir/comments.txt");
		@remove_data = <DIR>;
	close(DIR);

	#################### Edit Previous ####################
	open(DIR_WRITE,">$commentsdir/comments.txt");
	foreach $line (@remove_data) {
		chomp($line);
		($RmMessage, $RmAuthor, $RmEmail, $RmSubject, $RmPrev, $RmNext, $RmDate, $RmTime, $RmIp, $RmStory) = split(/\|/, $line);
		if ($RmMessage eq $prev{$msg_del}){
			$NewRmNext = $RmNext;
			$NewRmNext =~ s/($msg_del,)/$next{$msg_del}/;
			$writePrev = join("\|",$RmMessage, $RmAuthor, $RmEmail, $RmSubject, $RmPrev, $NewRmNext, $RmDate, $RmTime, $RmIp, $RmStory);
  			print DIR_WRITE "$writePrev\n";
		}
		else{
			print DIR_WRITE "$line\n"; 
		}
	}
	close(DIR_WRITE);

	#################### Edit Next ####################
	@nextMsgs = split(/\,/, $next{$msg_del});
	undef @checkNextMsgs;
	for (@nextMsgs) { $checkNextMsgs[$_] = 1; }

	open(DIR,"$commentsdir/comments.txt");
		@remove_data_one = <DIR>;
	close(DIR);

	open(DIR_WRITE,">$commentsdir/comments.txt");
	foreach $line (@remove_data_one) {
		chomp($line);
		($RmMessage, $RmAuthor, $RmEmail, $RmSubject, $RmPrev, $RmNext, $RmDate, $RmTime, $RmIp, $RmStory) = split(/\|/, $line);
			if ($checkNextMsgs[$RmMessage]){
				$NewRmPrev = $prev{$msg_del};
				$writeNext = join("\|",$RmMessage, $RmAuthor, $RmEmail, $RmSubject, $NewRmPrev, $RmNext, $RmDate, $RmTime, $RmIp, $RmStory);
  				print DIR_WRITE "$writeNext\n";
			}
			else{
				print DIR_WRITE "$line\n";
			}
	}
	close(DIR_WRITE);

	#################### Remove Message ####################
	open(DIR,"$commentsdir/comments.txt");
		@remove_data_two = <DIR>;
	close(DIR);

	open(DIR_WRITE,">$commentsdir/comments.txt");
	foreach $line (@remove_data_two) {
		chomp($line);
		($RmMessage, $RmAuthor, $RmEmail, $RmSubject, $RmPrev, $RmNext, $RmDate, $RmTime, $RmIp, $RmStory) = split(/\|/, $line);
			if ($RmMessage eq $msg_del){
				# Remove
			}
			else{
				print DIR_WRITE "$line\n";
			}
	}
	close(DIR_WRITE);

	push (@DeletedMsgs, $msg_del);
}

sub remove_thread {
	local (@sortmessagesRmv);
	local (@newsortmessagesRmv);
	$msg_delete = $_[0];

	push (@DeletedMsgs, $msg_delete);

	open(DIR,"$commentsdir/comments.txt");
		@remove_thread = <DIR>;
	close(DIR);

	#################### Delete Thread ####################
	open(DIR_WRITE,">$commentsdir/comments.txt");
	foreach $line (@remove_thread) {
		chomp($line);
		($RmMessage, $RmAuthor, $RmEmail, $RmSubject, $RmPrev, $RmNext, $RmDate, $RmTime, $RmIp, $RmStory) = split(/\|/, $line);
		if ($RmMessage eq $msg_delete){
			# Remove
		}
		else{
			print DIR_WRITE "$line\n"; 
		}
	}
	close(DIR_WRITE);

	@sortmessagesRmv = split((/\,/),$next{$msg_delete});
	@newsortmessagesRmv = reverse(@sortmessagesRmv);

	foreach $msg_thread (@newsortmessagesRmv) {
		if($subject{$msg_thread}){
			&remove_thread($msg_thread);
		}
	}
}

##### Remove Count and Link for Thread #####
sub remove_data {
	$msg_del_now = $_[0];

	open(READDATA,"$commentsdir/data.txt");	
   		@data_read = <READDATA>;
  	close(READDATA);

  	open(WRITEDATA,">$commentsdir/data.txt");
	foreach $line (@data_read) {
		chomp($line);                    
		($storyid, $messagenum, $count) = split(/\|/, $line);
		if ("$msg_del_now" eq "$messagenum"){
			# Delete
		}
		else{
			print WRITEDATA "$line\n";
		}
	}
	close(WRITEDATA);
}

##### Remove One From Count #####
sub remove_msg_data {
	$msg_dl_now = $_[0];

	&FindFirstThread("$msg_dl_now");

	open(READDATA,"$commentsdir/data.txt");	
   		@data_read = <READDATA>;
  	close(READDATA);

  	open(WRITEDATA,">$commentsdir/data.txt");
	foreach $line (@data_read) {
		chomp($line);                    
		($storyid, $messagenum, $count) = split(/\|/, $line);
		if ("$FirstInThread" eq "$messagenum"){
			$count -= 1;

			$write1 = join("\|",$storyid, $messagenum, $count);
  			print WRITEDATA "$write1\n";
		}
		else{
			print WRITEDATA "$line\n";
		}
	}
	close(WRITEDATA);

}

sub FindFirstThread {
	$FirstInThread = $_[0];

	if($prev{$FirstInThread}){
		if($subject{$FirstInThread}){
			&FindFirstThread($prev{$FirstInThread});
		}
	}
}