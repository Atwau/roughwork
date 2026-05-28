#!/bin/bash

REF="ref/GCF_000195955.2_ASM19595v2_genomic.fna"
BAM_DIR="bam"
VCF_OUT="vcf/combined/all_samples.vcf"
FILTERED_VCF="vcf/combined/all_samples.filtered.vcf"
CSV_OUT="vcf/combined/all_variants.csv"

# 1. Joint variant calling (haploid)
ls $BAM_DIR/*.sorted.bam > bam_list.txt
bcftools mpileup -f "$REF" -b bam_list.txt | \
    bcftools call -mv --ploidy 1 -o "$VCF_OUT"
rm bam_list.txt

# 2. Filter low-quality variants
echo "Filtering variants (QUAL>20, DP>5)..."
bcftools filter -i 'QUAL>20 && DP>5' "$VCF_OUT" -o "$FILTERED_VCF"

# 3. Convert filtered VCF to CSV (one column per sample)
# Get sample names from the VCF header
SAMPLE_NAMES=$(bcftools query -l "$FILTERED_VCF" | sed 's/^/GT_/' | paste -sd,)
echo "CHROM,POS,REF,ALT,QUAL,DP,$SAMPLE_NAMES" > "$CSV_OUT"

# Output tab‑separated fields including each genotype as a separate column,
# then replace tabs with commas and remove trailing comma
bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%DP\t[%GT\t]\n' "$FILTERED_VCF" | \
    sed 's/\t/,/g; s/,$//' >> "$CSV_OUT"
