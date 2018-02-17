package AnnotFilterRule;

## This is a boilerplate for AnnotFilterRule
##   which should implement rules for filtering CTAT Fusion predictions on a per-result (row) basis
##   ideally based on the annotation field, but can be customized to liking.

use strict;
use warnings;


####
sub examine_fusion_prediction {
    my ($fusion_result_row) = @_;

    #
    #  $fusion_result_row has format:
    #
    #
    #  (todo: include example struct)
    #
    #
    
    
    ## return(0) if the prediction is acceptable.

    ## return("reason for rejection")  if to be rejected.

    return(0);  # boilerplate just accepts everything.
}


1; #EOM
