package ConjoinG;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusion_info_file) = @_;
    
    print STDERR "-parsing $fusion_info_file\n";
    
    open (my $fh, $fusion_info_file) or die "Error, cannot open file: $fusion_info_file";
    while(<$fh>) {
        chomp;
        if (/^\#/) { next; }
        unless (/\w/) { next; }

        my ($geneA, $geneB) = split(/\s+/);
        if ($geneA && $geneB) {
            my $fusion = uc "$geneA--$geneB";

            $annotations_href->{$fusion}->{SIMPLE}->{"ConjoinG"} = 1;
        }
        else {
            print STDERR "-error, unable to parse fusion record $_ from $fusion_info_file\n";
        }
    }
    close $fh;
    
    
    return;
}


1; #EOM


    
