#!/usr/bin/perl

use strict;

# command line args
my ($infile,$outfile, $verbose) = @ARGV;

print "Input file: $infile\n Output file: $outfile\n" if $verbose;

# read the file
open my $INH, "<", $infile or die "Unable to read input file\n";

#$/ = "\r\n";
chomp(my @lines = <$INH>);

# process images
&processImages(\@lines);

# process tables
&processTables(\@lines);

close $INH;

# write the file
open my $OUTH, ">", $outfile or die "Unable to write output file";
print $OUTH join("\n", @lines) if $verbose;

# done
print "Done!\n" if $verbose;


# look for includegraphics and append .eps to filename
# e.g:
# \includegraphics[scale=0.51]{Figures/Experiment-outline_v0_3}\caption{\label{fig:Experiment-Overview}Experiment Overview}
# becomes:
# \includegraphics[scale=0.51]{Figures/Experiment-outline_v0.3.eps}\caption{\label{fig:Experiment-Overview}Experiment Overview}
sub processImages {
    my ($lines) = @_;

    print "Processing images\n" if $verbose;

    my $i = 1;
    foreach my $line(@$lines) {

        # look for a match
        if($line =~ /includegraphics.*?\{(.*?)\}/g) {
            print "Line $i: " . $0 . "\n found: [" . $1 . "]\n" if $verbose;
            my $newFilename = $1 . ".eps";
            $line =~ s/$1/$newFilename/g;
            print "Changed to: \n $line \n" if $verbose;
        }

        $i++;
    }
}

sub processTables {
    my ($lines) = @_;

    print "Processing tables\n" if $verbose;

    my $i = 0;
    my $tableStart = 0; my $tableEnd = 0;
    foreach my $line(@$lines) {

        # if not already in a table
        if(!$tableStart) {
            # look for table start
            if($line =~ /.*begin\{table\}.*/) {
                $tableStart = $i;   # rememeber index of the table
            
                print "Table start found at line " . ($i+1) . "\n" if $verbose;
            }
        } else {
            # look for table end
            if($line =~ /.*end\{table\}.*/) {
                $tableEnd = $i;

                print "Table end found at line " . ($i+1) . "\n" if $verbose;
            }
        }

        # if we have both parts of the table...
        if($tableStart && $tableEnd) {

            # build our replacement entry
            my @tableReplace = (
                "\\begin{figure}",
                "\\includegraphics[scale=0.05]{Table.eps}\\caption{Table Test}",
                "\\end{figure}"
            );

            # insert replacement
            my $tableLength = ($tableEnd - $tableStart) + 1;

            print "Replacing $tableLength lines from $tableStart\n" if $verbose;

            splice(@lines, $tableStart, $tableLength, @tableReplace);

            # reset start and end for finding the next table
            $tableStart = $tableEnd = 0;
        }

        $i++;
    }
}