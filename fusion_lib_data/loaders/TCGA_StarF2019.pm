package TCGA_StarF2019;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";

        
    open (my $fh, "gunzip -c $fusions_file | ") or die "Error, cannot open file: $fusions_file";
    while(<$fh>) {
        chomp;
        if (/^\#/) { next; }
        unless (/\w/) { next; }

        my ($fusion, $tcga_annot) = split(/\t/);
        
        $annotations_href->{$fusion}->{SIMPLE}->{"TCGA_StarF2019"} = 1;
        $annotations_href->{$fusion}->{COMPLEX}->{"TCGA_StarF2019"} = $tcga_annot;
        
    }
    
    return;
}


1; #EOM


    
