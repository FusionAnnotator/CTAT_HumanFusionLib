package HGNC;

use strict;
use warnings;
use Carp;


sub load_data {
    my ($annotations_href, $hgnc_file_gz) = @_;

    open(my $fh, "gunzip -c $hgnc_file_gz | ") or die "Error, cannot read from file: $hgnc_file_gz";
    my $header = <$fh>;
    while (<$fh>) {
        chomp;
        my @x = split(/\t/);
        my ($symbol, $name, $gene_type) = ($x[1], $x[2], $x[3]);

        my $annotation = "$name,[$gene_type]";
        $annotations_href->{$symbol}->{$annotation} = 1;
        
        my $alias_text = $x[8];
        if ($alias_text) {
            $alias_text =~ s/\"//g;
            my @aliases = split(/\|/, $alias_text);
            foreach my $alias (@aliases) {
                if (! exists $annotations_href->{$alias}) {
                    $annotations_href->{$alias}->{COMPLEX}->{HGNC} = "$alias: $annotation";
                }
            }
        }
    }
    close $fh;
    
}

1; #EOM

