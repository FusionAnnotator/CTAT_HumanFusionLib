package TCGA_StarF2019;

use strict;
use warnings;
use Carp;
use DelimParser;

sub load_data {
    my ($annotations_href, $fusions_file) = @_;
    
    print STDERR "-parsing $fusions_file\n";
        
    open (my $fh, $fusions_file) or die "Error, cannot open file: $fusions_file";
    my $delim_parser = new DelimParser::Reader($fh, "\t");

    my @column_names = $delim_parser->get_column_headers();

    my @samples = grep {/TCGA/} @column_names;
      
    
    
    
    while(my $row = $delim_parser->get_row()) {
        my @vals;

        my $fusion = $delim_parser->get_row_val($row, "Fusion");
        
        foreach my $sample (@samples) {
            my $val = $delim_parser->get_row_val($row, $sample);
            if ($val =~ /;/) {
                my ($pct, $count_info) = split(/;/, $val);
                $count_info =~ s/n=//;
                push (@vals, { string => $val,
                               count => $count_info,
                               sample => $sample } );
            }
        }
        @vals = reverse sort {$a->{count}<=>$b->{count}} @vals;
        
        my @annot_strings;
        foreach my $val (@vals) {
            push (@annot_strings, $val->{sample} . ":" . $val->{string});
        }

        my $annot_str = join("|", @annot_strings);

        $annotations_href->{$fusion}->{SIMPLE}->{"TCGA_StarF2019"} = 1;
        $annotations_href->{$fusion}->{COMPLEX}->{"TCGA_StarF2019"} = $annot_str;
        
    }
    
    return;
}


1; #EOM


    
