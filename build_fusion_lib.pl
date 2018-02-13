#!/usr/bin/env perl

use strict;
use warnings;
use Carp;
use FindBin;
use lib ("$FindBin::Bin/PerlLib");
use Getopt::Long qw(:config posix_default no_ignore_case bundling pass_through);
use File::Basename;
use JSON::XS;

my $fusion_annot_lib = "$FindBin::Bin/fusion_lib_data";


main: {
    
    &build_index($fusion_annot_lib);
    
    exit(0);
}

####
sub build_index {
    my ($fusion_annot_lib) = @_;

    my $build_info_file = "$fusion_annot_lib/__build_info.txt";
    if (! -s $build_info_file) {
        die "Error, cannot locate the build info file: $build_info_file";
    }

    
    my %annotations;

    my @build_info = &parse_build_info($build_info_file);


    # I might resurrect the custom import functionality later
    
    #if ($custom_import) {
    #    
    #    require $custom_import;
    #
    #    my $module_name = basename($custom_import);
    #    $module_name =~ s/\.pm$//;
    #    
    #    my $load_function = join("::", $module_name, "load_data");
    #    no strict 'refs';
    #    &$load_function(\%annotations);
    #}
    
    
    foreach my $info_aref (@build_info) {
        
        my ($dat_file, $module_file) = @$info_aref;

        ## load module, parse dat file
        my $module_file_path = "$fusion_annot_lib/$module_file";
        
        require $module_file_path;
        
        my $module_name = $module_file;
        $module_name =~ s/\.pm$//;
        
        my $load_function = join("::", $module_name, "load_data");

        my $dat_file_full_path = "$fusion_annot_lib/$dat_file";

        no strict 'refs';
        &$load_function(\%annotations, $dat_file_full_path);
        
    }

    print STDERR "-generating report.\n";
    
    ## build the index file
    {
        
        
        
        # generate tab file
                
        foreach my $gene_pair (sort keys %annotations) {

            my @simple_annots;
            if (exists $annotations{$gene_pair}->{SIMPLE}) {
                @simple_annots = keys %{$annotations{$gene_pair}->{SIMPLE}};
            }
            my $complex_annots_href = {};
            if (exists $annotations{$gene_pair}->{COMPLEX}) {
                $complex_annots_href = $annotations{$gene_pair}->{COMPLEX};
            }

            my ($geneA, $geneB) = split(/--/, $gene_pair);
            
            my $simple_json = ".";
            if (@simple_annots) {
                $simple_json = encode_json([@simple_annots]);
                $complex_annots_href->{ATTS} = [@simple_annots];
                
            }

            my $complex_json = ".";
            if (%$complex_annots_href)  {
                $complex_json = encode_json($complex_annots_href);
            }
            
            print join("\t", $gene_pair, $simple_json, $complex_json) . "\n";
        }
    }
    print STDERR "Done.\n\n";
    
    exit(0);

}


####
sub parse_build_info {
    my ($build_info_file) = @_;

    my @build_info;
    
    open (my $fh, $build_info_file) or die "Error, cannot open file $build_info_file";
    while (<$fh>) {
        chomp;
        if (/^\#/) { next; }
        unless (/\w/) { next; }
        my ($filename, $module) = split(/\s+/);
        push (@build_info, [$filename, $module]);
    }
    close $fh;

    return(@build_info);
}

