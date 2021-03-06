package genefam;

use strict;
use warnings;
use Carp;

# uses file: dgd_Hsa_all_v71.tsv   Downloaded from ftp://ftp.ebi.ac.uk/pub/databases/genenames/genefam_list.txt.gz on July 25, 2016

sub load_data {
    my ($annotations_href, $prot_clusters_dat_file) = @_;

    print STDERR "-parsing gene family clusters: $prot_clusters_dat_file\n";
    
    
    open (my $fh, "$prot_clusters_dat_file") or confess "Error, cannot read file: $prot_clusters_dat_file";
    my $header = <$fh>;

    my %group_id_to_gene_list;
    
    while (<$fh>) {
        chomp;
        my @x = split(/\t/);
        my $group_id = $x[1];
        my $gene_symbol = $x[3];
        push (@{$group_id_to_gene_list{$group_id}}, $gene_symbol);
    }
    close $fh;
    
    foreach my $group_aref (values %group_id_to_gene_list) {
        
        my @genes = @$group_aref;
        for (my $i = 0; $i < $#genes; $i++) {
            my $gene_i = $genes[$i];
            
            for (my $j = $i + 1; $j <= $#genes; $j++) {
                my $gene_j = $genes[$j];
                
                $annotations_href->{"$gene_i--$gene_j"}->{SIMPLE}->{"HGNC_GENEFAM"} = 1;
                $annotations_href->{"$gene_j--$gene_i"}->{SIMPLE}->{"HGNC_GENEFAM"} = 1;
            }
        }
    }
    
    
    return;
}


1; #EOM


    
