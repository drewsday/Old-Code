#!/usr/bin/perl

open(INPUT,  "aprilsched");
open(OUTPUT, ">outaprilsched");   # The > means open for write, 
                                 #  over original if existed.

#  my($line) = $_;  #preserve $_, the line just read, nomatter what


while($line ne MAY)
{
while (<INPUT>)
  {
  my($line) = $_;  #preserve $_, the line just read, nomatter what
  chomp $line;     #blow off trailing newline

    print OUTPUT "$line\n";      #write the non-remmed autoexec command
  }
}
close(INPUT);
close(OUTPUT);
