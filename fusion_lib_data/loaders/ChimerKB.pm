package ChimerKB;

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
        
        my (@x) = split(/\s+/);
        unless ($x[0] eq '|' && $x[2] eq '|') {
            confess "Error, not parsing line: $_ of $fusion_info_file";
        }
        
        my $geneA = $x[1];
        my $geneB = $x[3];
        
        my $fusion = uc "$geneA--$geneB";
        $annotations_href->{$fusion}->{SIMPLE}->{"ChimerKB"} = 1;
    }
    close $fh;
        
    return;
}


1; #EOM


    
