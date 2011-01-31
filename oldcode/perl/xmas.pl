#!/usr/bin/perl

sub symbol    {
    my $r = rand;
    return '|' if $r < .07;
    return 'o' if $r < .15;
    '*';
}

my $width = shift || 30;
for my $cnt (1..$width/2)    {
    print "\n", ' ' x ($width/2 - $cnt);
    print symbol for 1..2*$cnt;
}

print "\n", ' ' x ($width/2 - 2) . "_||_\n\n\n";
