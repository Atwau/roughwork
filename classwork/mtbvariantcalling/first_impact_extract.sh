#!/bin/bash

# Create the output directory
mkdir -p r_analysis/annotated

# Loop through all annotated VCF files in the annotation directory
for vcf in annotation/*.ann.vcf; do
    # Extract the base filename (e.g., SRR28515580)
    basename=$(basename "$vcf" .ann.vcf)

    echo "Extracting primary fields for $basename..."

    # Changed ANN[*] to ANN[0] to isolate the single highest-impact consequence.
    # The -s flag is removed because we are no longer processing multi-value lists.
    SnpSift extractFields "$vcf" \
        CHROM POS REF ALT "ANN[0].EFFECT" "ANN[0].IMPACT" "ANN[0].GENE" "ANN[0].HGVS_P" \
        > "r_analysis/annotated/${basename}_extracted_1st_impact.tsv"

    echo "Finished $basename"
done

echo "All extractions complete. Files are in r_analysis/annotated/"
