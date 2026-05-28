#!/bin/bash

# Loop through samples
for sample in SRR28515580 SRR35497378 SRR35891567; do
    echo "Processing lineage for sample: $sample"
    tb-profiler lineage \
        -1 data/trimmed/${sample}_1_paired.fastq.gz \
        -2 data/trimmed/${sample}_2_paired.fastq.gz \
        --dir tb_profiling_results/trimmed_lineage \
        -p $sample \
        -t 4
done

# Explicitly process SRR34502717
echo "Processing lineage for sample: SRR34502717"
tb-profiler lineage \
    -1 data/trimmed/SRR34502717_1_paired.fq.gz \
    -2 data/trimmed/SRR34502717_2_paired.fq.gz \
    --dir tb_profiling_results/trimmed_lineage \
    -p SRR34502717 \
    -t 4
