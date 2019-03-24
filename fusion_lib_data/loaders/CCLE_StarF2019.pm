package CCLE_fusions;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";
    
    open (my $fh, "gunzip -c $fusions_file | ") or die "Error, cannot open file: $fusions_file";
    while(<$fh>) {
        chomp;
        my ($fusion, $ccle_info) = split(/\t/);
        $annotations_href->{$fusion}->{COMPLEX}->{"CCLE_StarF2019"} = $ccle_info;
        $annotations_href->{$fusion}->{SIMPLE}->{"CCLE_StarF2019"} = 1;
    }
    
    return;
}


1; #EOM


    
