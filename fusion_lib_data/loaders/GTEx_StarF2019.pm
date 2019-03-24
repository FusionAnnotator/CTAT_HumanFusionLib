package GTEx_StarF2019;

## bhaas - ran starF / FI on all of GTEx

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $gtex_normals) = @_;

    print STDERR "-parsing GTEx_Blacklist_Mar2019 $gtex_normals\n";
    
    open (my $fh, "gunzip -c $gtex_normals | ") or confess "Error, cannot open file $gtex_normals";

    while (<$fh>) {
        chomp;
        my ($fusion, $GTEx_annot) = split(/\t/);
        
        $annotations_href->{$fusion}->{COMPLEX}->{"GTEx_StarF2019"} = "GTEx_Recurrent:{$GTEx_annot}";
        
        $annotations_href->{$fusion}->{SIMPLE}->{"GTEx_StarF2019"} = 1;
        
    }
    close $fh;
    
    return;
}


1; #EOM


    
