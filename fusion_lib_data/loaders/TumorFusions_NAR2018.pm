package TumorFusions_NAR2018;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing TCGA recurrent fusions from TumorFusions NAR 2018\n";
    
    open (my $fh, $fusions_file) or confess "Error, cannot open file $fusions_file";
    
    my $header = <$fh>;

    my %fusion_info;
    my %tissue_types;
    while (<$fh>) {
        chomp;
        my ($cancer_type, $sample_name, $geneA, $geneB) = split(/,/);
        my $fusion = "$geneA--$geneB";

        $fusion_info{$fusion}->{$cancer_type}->{$sample_name} = 1;

        $tissue_types{$cancer_type}->{$sample_name} = 1;
    }
    close $fh;
    
    
    foreach my $fusion (keys %fusion_info) {
        
        my $info_struct = $fusion_info{$fusion};
        my @cancer_types = keys %$info_struct;

        my %freq_info;
        foreach my $cancer_type (@cancer_types) {
            my $num_cancer_samples = scalar(keys %{$tissue_types{$cancer_type}});
            my $num_samples_with_this_fusion = scalar(keys %{$fusion_info{$fusion}->{$cancer_type}});

            my $freq = $num_samples_with_this_fusion / $num_cancer_samples;

            $freq_info{$cancer_type} = $freq;
        }
                
        @cancer_types = reverse sort { $freq_info{$a} <=> $freq_info{$b} } @cancer_types;
        
        my @str_tokens;
        foreach my $cancer_type (@cancer_types) {
            my $token = "$cancer_type:" . sprintf("%.2f%%", $freq_info{$cancer_type} * 100);
            push(@str_tokens, $token);
        }
        
        $annotations_href->{$fusion}->{COMPLEX}->{"TumorFusionsNAR2018"} = join("|", @str_tokens);
        $annotations_href->{$fusion}->{SIMPLE}->{"TumorFusionsNAR2018"} = 1;
        
    }
    
    
    
    return;
}


1; #EOM


    
