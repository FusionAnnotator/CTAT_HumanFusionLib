package Babiceanu_Normal;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";

    my %fusion_to_body_sites;
    
    open (my $fh, $fusions_file) or die "Error, cannot open file: $fusions_file";
    while(<$fh>) {
        chomp;
        if (/^\#/) { next; }
        unless (/\w/) { next; }

        my $fusion = $_;

        $annotations_href->{$fusion}->{SIMPLE}->{"Babiceanu_Normal"} = 1;
    }
    
    return;
}


1; #EOM


    
