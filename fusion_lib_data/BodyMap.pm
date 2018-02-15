package BodyMap;

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
        my ($sample, $fusion) = split(/\s+/);
        $fusion_to_body_sites{$fusion}->{$sample} = 1;
    }
    close $fh;


    foreach my $fusion (keys %fusion_to_body_sites) {

        my @samples = keys %{$fusion_to_body_sites{$fusion}};

        $annotations_href->{$fusion}->{COMPLEX}->{"BodyMap"} = join(",", sort @samples);
        $annotations_href->{$fusion}->{SIMPLE}->{"BodyMap"} = 1;
    }

    return;
}


1; #EOM


    
