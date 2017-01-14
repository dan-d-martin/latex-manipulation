#!/usr/bin/perl

use strict;

# command line args
my ($infile,$outfile) = @ARGV;

print "Input file: $infile\n Output file: $outfile\n";

# read the file
open my $INH, "<", $infile or die "Unable to read input file\n";

chomp(my @lines = <$INH>);

close $INH;

# write the file
open my $OUTH, ">", $outfile or die "Unable to write output file";
print $OUTH join("\n", @lines);

# done
print "Done!\n";