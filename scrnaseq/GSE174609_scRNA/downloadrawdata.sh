#!/bin/bash

cd raw_data/

for i in {14575500..14575511}; do
    SRR="SRR$i"
    
    # Step 1: Download SRA file
    prefetch $SRR
    
    # Step 2: Convert to FASTQ
    fasterq-dump --split-files \
                 --include-technical \
                 --threads 8 \
                 --progress \
                 --outdir . \
                 $SRR/${SRR}.sra
    
    # Step 3: Compress FASTQ files
    gzip ${SRR}*.fastq
    
    # Step 4: Clean up SRA directory
    rm -rf $SRR
done
