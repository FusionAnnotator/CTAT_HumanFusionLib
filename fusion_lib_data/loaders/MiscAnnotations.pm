package MiscAnnotations;

use strict;
use warnings;
use Carp;

sub load_data {
    my ($annotations_href, $annots_file) = @_;

    print STDERR "-parsing misc annotations: $annots_file\n";
    
    open (my $fh, $annots_file) or confess "Error, cannot open file $annots_file";
    my $header = <$fh>;

    my %panels;
    
    while (<$fh>) {
        chomp;
        if (/^\#/) { next; }
        my ($target, $annot) = split(/\s+/, $_, 2);

        $panels{$target}->{$annot} = 1;

        my $target_panel = "$target:$annot";
        $annotations_href->{$target}->{SIMPLE}->{$target_panel} = 1;
    }
    close $fh;
    
    foreach my $target (keys %panels) {
        my @p = sort keys %{$panels{$target}};
        
        my $panel_text = join(",", @p);

        $annotations_href->{$target}->{COMPLEX}->{"PANELS"} = $panel_text;
    }
                
    return;
}


1; #EOM


    
