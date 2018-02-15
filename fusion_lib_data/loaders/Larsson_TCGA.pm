package Larsson_TCGA;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $Larsson_TCGA) = @_;
    
    print STDERR "-parsing Larsson_TCGA file: $Larsson_TCGA\n";
    
    open (my $fh, $Larsson_TCGA) or die "Error, cannot open file: $Larsson_TCGA";
    while(<$fh>) {
        chomp;
        if (/^\#/) { next; }
        unless (/\w/) { next; }

        if (/(\S+--\S+)/) {
            my $fusion = $1;
            
            $annotations_href->{$fusion}->{SIMPLE}->{"Larsson_TCGA"} = 1;
        }
        else {
            print STDERR "-error, unable to parse fusion record $_ from $Larsson_TCGA\n";
        }
    }
    close $fh;
    
    
    return;
}


1; #EOM


    
