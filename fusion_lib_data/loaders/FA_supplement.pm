package FA_supplement;

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
        my $fusion = $_;
        
        $annotations_href->{$fusion}->{SIMPLE}->{"FA_CancerSupp"} = 1;
    }
    
    return;
}


1; #EOM


    
