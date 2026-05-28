#!/bin/bash

# Create the output directory
mkdir -p r_analysis/annotated

# Loop through all annotated VCF files in the annotation directory
for vcf in annotation/*.ann.vcf; do
    # Extract the base filename (e.g., SRR28515580)
    basename=$(basename "$vcf" .ann.vcf)
    
    echo "Extracting fields for $basename..."
    
    # Run SnpSift with -s directive
    # The -s ',' flag forces multiple values to stay in their assigned column
    # This is very useful as earlier on I had faced challenge of distorted output values
    # For example the affected genes were not visible anywhere in the output .tsv file
    SnpSift extractFields -s ',' "$vcf" \
        CHROM POS REF ALT "ANN[*].EFFECT" "ANN[*].IMPACT" "ANN[*].GENE" "ANN[*].HGVS_P" \
        > "r_analysis/annotated/${basename}_extracted.tsv"
        
    echo "Finished $basename"
done

echo "All extractions complete. Files are in r_analysis/annotated/"
