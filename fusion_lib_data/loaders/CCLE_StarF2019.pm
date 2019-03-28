package CCLE_StarF2019;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";

    my %CCLE_fusions;
    
    open (my $fh, $fusions_file) or die "Error, cannot open file: $fusions_file";
    my $header = <$fh>;
    while(<$fh>) {
        unless (/\w/) { next; }
        chomp;
        my ($ccle, $cell_line, $fusion_name) = split(/\t/);

        unless ($fusion_name) {
            die "Error, $_";
        }
        
        push (@{$CCLE_fusions{$fusion_name}}, $cell_line);
    }
    close $fh;

    foreach my $fusion (keys %CCLE_fusions) {

        my @cell_lines = sort @{$CCLE_fusions{$fusion}};

        my $annot_str = join("|", @cell_lines);

        $annotations_href->{$fusion}->{COMPLEX}->{"CCLE_StarF2019"} = $annot_str;
        $annotations_href->{$fusion}->{SIMPLE}->{"CCLE_StarF2019"} = 1;
    }
    
    return;
}


1; #EOM


    
