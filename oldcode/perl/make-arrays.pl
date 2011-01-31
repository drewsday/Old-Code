#!/usr/bin/perl

# Read in the file and process it

if(@ARGV<2) {
	print "Usage is:\nmake-arrays.pl filename arrayname colnumber\n";
	exit 0;
}

$filename = @ARGV[0];

# $array_name = "Double_t x1[]";
$array_name = @ARGV[1];

$col = @ARGV[2];

$count = 0;

if(-e $filename) {

print "Double_t $array_name\[\] = {";

	open(FILE,"$filename");
	
	for $lines (<FILE>) {
		@sp = split(",",$lines);
		# print "$sp[0]\t$sp[1]\t$sp[2]";
		print "$sp[$col],"; $count+=1;
		if($count  == 4) { $count = 0; print "\n"; }
	}
	close(FILE);
print "}\;";
}

else {
	print "Error: $filename doesn't exit exist\n";
}

