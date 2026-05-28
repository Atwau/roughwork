#!/bin/bash

REF="ref/GCF_000195955.2_ASM19595v2_genomic.fna"
BAM_DIR="bam"
OUT_DIR="vcf"

mkdir -p "$OUT_DIR"

for BAM in $BAM_DIR/*.sorted.bam; do
    SAMPLE=$(basename "$BAM" .sorted.bam)
    echo "Calling variants for $SAMPLE"
    bcftools mpileup -f "$REF" "$BAM" | \
        bcftools call -mv --ploidy 1 -o "$OUT_DIR/${SAMPLE}.vcf"
done

echo "VCF files in $OUT_DIR"
