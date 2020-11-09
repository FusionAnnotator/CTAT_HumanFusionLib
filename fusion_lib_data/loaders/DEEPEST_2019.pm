package DEEPEST_2019;

use strict;
use warnings;
use Carp;
use DelimParser;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";
        
    my %fusion_to_samples;

    open (my $fh, $fusions_file) or die "Error, cannot open file: $fusions_file";
    while(<$fh>) {
        chomp;
        if (/^\#/) { next; }
        my @x = split(/\t/);
        if ($x[0] eq "TCGA_Project") { next; }
        
        my $tcga_proj = $x[0];
        $tcga_proj =~ s/^TCGA_//;
        my $sample = $x[1];
        my $fusion = $x[3];
        
        my $sample_fusion = join("::", $tcga_proj, $sample, $fusion);
        $fusion_to_samples{$fusion}->{$sample_fusion} = 1;
    }
    close $fh;

    
    foreach my $fusion (keys %fusion_to_samples) {
        my @samples_found = keys %{$fusion_to_samples{$fusion}};
        
        my %tcga_class_counter;
        my %fusion_samples;

        foreach my $sample_fusion (@samples_found) {
            my ($tcga_class, $sample_name, $fusion_name) = split(/::/, $sample_fusion);
            $tcga_class_counter{$tcga_class} += 1;
            
            $sample_name =~ s/TCGA/$tcga_class/;
            $fusion_samples{$sample_name} = 1 ;
        }
        
        my @samples = sort keys %fusion_samples;
        my $num_occurrenes = scalar(@samples);
        
        my @tcga_counts;
        for my $tcga_class (reverse sort {$tcga_class_counter{$a}<=>$tcga_class_counter{$b}} keys %tcga_class_counter) {
            push (@tcga_counts, join(":", $tcga_class, $tcga_class_counter{$tcga_class}));
        }
        my $tcga_occurrence_text = join(",", @tcga_counts);
        
        $annotations_href->{$fusion}->{SIMPLE}->{"DEEPEST2019"} = 1;
        $annotations_href->{$fusion}->{COMPLEX}->{"DEEPEST2019"} = $tcga_occurrence_text;
        
    }
    
    return;
}


1; #EOM


    
