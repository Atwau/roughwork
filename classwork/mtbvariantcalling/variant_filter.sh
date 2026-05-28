#!/bin/bash

IN_DIR="vcf/raw"
OUT_DIR="vcf/filtered"

mkdir -p "$OUT_DIR"

for VCF in $IN_DIR/*.vcf; do
    SAMPLE=$(basename "$VCF" .vcf)
    echo "Filtering $SAMPLE"
    bcftools filter -i 'QUAL>20 && DP>5' "$VCF" > "$OUT_DIR/${SAMPLE}.filtered.vcf"
done

echo "Filtered VCFs in $OUT_DIR"
