#!/usr/bin/perl

use strict;

my ($infile,$outfile) = $_;


# read the file
open my $INH, $infile or die "Unable to read input file\n";

chomp(my @lines = <$INH>);

close $INH;

# write the file
open my $OUTH, ">", $outfile or die "Unable to write output file";
print $OUTH, join("\n", @lines);

# done
print "Done!\n";