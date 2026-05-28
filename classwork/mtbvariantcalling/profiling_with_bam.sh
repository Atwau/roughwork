#!/bin/bash
mkdir -p tb_profiling_results tb_profiling_results/trimmed tb_profiling_results/bam

for bam_file in bam/*.sorted.bam; do
    # Extract sample ID (e.g., SRR28515580) from filepath
    sample=$(basename "$bam_file" .sorted.bam)
    
    echo "Processing lineage from BAM for sample: $sample"
    tb-profiler profile \
        -a "$bam_file" \
        -p tb_profiling_results/bam/$sample \
        -t 4 \
        --txt
done
