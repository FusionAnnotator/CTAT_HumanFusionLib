package Oncogenes_Bushman;

use strict;
use warnings;
use Carp;


# oncogenes list from: http://www.bushmanlab.org/links/genelists

sub load_data {
    my ($annotations_href, $oncogenes_file) = @_;

    print STDERR "-parsing Oncogenes listing: $oncogenes_file\n";
    
    open (my $fh, $oncogenes_file) or confess "Error, cannot open file $oncogenes_file";
    my $header = <$fh>;

    while (<$fh>) {
        chomp;
        my @x = split(/\t/);
        my $gene_id = $x[0];

        my @gene_ids;
        push (@gene_ids, $gene_id);

        my @prev_symbols = split(/,/, $x[2]);
        push (@gene_ids, @prev_symbols) if @prev_symbols;

        my @synonyms = split(/,/, $x[3]);
        push (@gene_ids, @synonyms) if @synonyms;

        foreach my $gene_id (@gene_ids) {
            
            if ($gene_id =~ /\w/) {
                $annotations_href->{$gene_id}->{SIMPLE}->{"$gene_id:Oncogene"} = 1;
            }
        }
        
    }
    close $fh;
    
        
    return;
}


1; #EOM


    
