package HaasMedCancer;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";
    
    open (my $fh, $fusions_file) or die "Error, cannot open file: $fusions_file";
    while(<$fh>) {
        chomp;
        if (/^\#/) { next; }
        unless (/\w/) { next; }

        my ($fusion_listing, $pmid, $title) = split(/\t/, $_, 3);

        foreach my $fusion (split(/,/, $fusion_listing)) {

            unless ($fusion =~ /\S+--\S+/) {
                die "Error, not parsing fusion $fusion as a proper fusion, from: $_";
            }
            unless ($pmid =~ /^PMID/) {
                die "Error, pmid: $pmid not a PMID, from line: $_";
            }
            
            $annotations_href->{$fusion}->{SIMPLE}->{"HaasMedCancer"} = 1;
            
            $annotations_href->{$fusion}->{COMPLEX}->{"HaasMedCancer"}->{$pmid} = $title;
        }
        
    }
    
    return;
}


1; #EOM


    
