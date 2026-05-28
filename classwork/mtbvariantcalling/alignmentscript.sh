#!/bin/bash

REF_INDEX="ref/index/mtbgenome_bwa"
TRIMMED="data/trimmed"
OUTDIR="bam"

mkdir -p "$OUTDIR"

# Try both patterns: *_1_paired.fastq.gz and *_1_paired.fq.gz
for R1 in $TRIMMED/*_1_paired.fastq.gz $TRIMMED/*_1_paired.fq.gz; do
    [ -f "$R1" ] || continue
    SAMPLE=$(basename "$R1" | sed 's/_1_paired\.\(fastq\|fq\)\.gz//')
    R2="$TRIMMED/${SAMPLE}_2_paired.$(basename "$R1" | grep -o 'fastq\|fq').gz"
    
    echo "Aligning $SAMPLE"
    bwa mem -t 4 "$REF_INDEX" "$R1" "$R2" | \
        samtools sort -o "$OUTDIR/${SAMPLE}.sorted.bam"
    samtools index "$OUTDIR/${SAMPLE}.sorted.bam"
done

echo "Done. BAMs in $OUTDIR"
