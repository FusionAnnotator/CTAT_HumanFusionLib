#!/bin/bash

set -ev

if [ -z $CTAT_GENOME_LIB ]; then
    echo Error, must set env var CTAT_GENOME_LIB to ctat genome lib location
    exit 2
fi

echo "CTAT_GENOME_LIB: $CTAT_GENOME_LIB"
echo "... if not correct, reset and rerun this.  ... waiting 10 sec."
sleep 10

echo "Proceeding now."


./build_fusion_lib.pl > fusion_lib.dat

~/GITHUB/CTAT_FUSIONS/ctat-genome-lib-builder/util/build_fusion_annot_db_index.pl  --gene_spans $CTAT_GENOME_LIB/ref_annot.gtf.gene_spans --key_pairs fusion_lib.dat --out_db_file fusion_lib.dat.idx

cp fusion_lib.dat.idx $CTAT_GENOME_LIB/fusion_annot_lib.idx


