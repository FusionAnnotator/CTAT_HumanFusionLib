package CCLE_fusions;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";
    
    open (my $fh, $fusions_file) or die "Error, cannot open file: $fusions_file";
    while(<$fh>) {
        chomp;
        my $fusion = $_;
        $annotations_href->{$fusion}->{SIMPLE}->{"CCLE"} = 1;
    }
    
    return;
}


1; #EOM


    
