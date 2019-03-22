package Guo2018_TCGA_fusions;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $tcga_fusions_file) = @_;
    
    print STDERR "-parsing TCGA recurrent fusions from Guo et al. Cell Reports 2018\n";
    
    open (my $fh, $tcga_fusions_file) or confess "Error, cannot open file $tcga_fusions_file";
    
    my $topline = <$fh>;
    my $header = <$fh>;

    my %fusion_info;
    while (<$fh>) {
        chomp;
        my ($cancer_type, $fusion, $count, $frequency) = split(/\,/);

        $fusion_info{$fusion}->{$cancer_type} = { count => $count,
                                                  freq => $frequency };
    }
    close $fh;


    foreach my $fusion (keys %fusion_info) {
        chomp;
        my $info_struct = $fusion_info{$fusion};
        my @cancer_types = keys %$info_struct;

        @cancer_types = reverse sort { $info_struct->{$a}->{freq} <=> $info_struct->{$b}->{freq} } @cancer_types;

        my @str_tokens;
        foreach my $cancer_type (@cancer_types) {
            my $token = "$cancer_type:" . $info_struct->{$cancer_token};
            push(@str_tokens, $token);
        }
                
        $annotations_href->{$fusion}->{COMPLEX}->{"GUO2018CR_TCGA"} = join("|", @str_tokens);
        $annotations_href->{$fusion}->{SIMPLE}->{"GUO2018CR_TCGA"} = 1;
        
    }
    
    
    
    return;
}


1; #EOM


    
