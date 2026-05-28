#!/bin/bash

# Ensure the output directory exists
mkdir -p annotation

# Loop through all filtered VCF files
for vcf in vcf/filtered/*.filtered.vcf; do
    # Extract the base filename
    basename=$(basename "$vcf" .filtered.vcf)
    
    echo "Annotating $basename..."
    
    # Replace the chromosome name and pipe to snpEff
    sed 's/NC_000962.3/Chromosome/g' "$vcf" | \
    snpEff eff Mycobacterium_tuberculosis_h37rv - \
    > "annotation/${basename}.ann.vcf"
        
    echo "Finished $basename"
done

echo "All files successfully annotated."
