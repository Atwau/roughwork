#!/bin/bash

# Exit script if any command fails
set -e

echo "Starting phylogenetic tree construction pipeline..."

# 1. Create output directory
mkdir -p phylogeny

# 2. Extract SNPs from the combined filtered VCF
echo "Extracting SNPs from VCF..."
bcftools view -v snps vcf/combined/all_samples.filtered.vcf > phylogeny/all_samples_snps.vcf

# 3. Download vcf2phylip.py if it doesn't already exist in the directory
if [ ! -f "vcf2phylip.py" ]; then
    echo "Downloading vcf2phylip.py..."
    wget -q https://raw.githubusercontent.com/edgardomortiz/vcf2phylip/master/vcf2phylip.py
fi

# 4. Convert VCF to FASTA alignment
echo "Converting VCF to FASTA..."
python3 vcf2phylip.py -i phylogeny/all_samples_snps.vcf -f

# Move the generated files into the phylogeny folder (vcf2phylip saves to the current working directory)
mv all_samples_snps.min* phylogeny/

# 5. Build the phylogenetic tree
echo "Running IQ-TREE..."

# We temporarily disable 'set -e' because the first IQ-TREE command will intentionally fail 
# if it detects constant sites across your specific samples.
set +e 

# Initial run to trigger the creation of the .varsites.phy file if constant sites exist
iqtree2 -s phylogeny/all_samples_snps.min*.fasta -m TEST+ASC -bb 1000 -nt AUTO -redo > /dev/null 2>&1

# Re-enable exit on error
set -e

# Check if IQ-TREE generated the variable-sites-only file
if [ -f phylogeny/all_samples_snps.min*.fasta.varsites.phy ]; then
    echo "Constant sites detected and removed. Running IQ-TREE on strict variable sites..."
    iqtree2 -s phylogeny/all_samples_snps.min*.fasta.varsites.phy -m TEST+ASC -bb 1000 -nt AUTO -redo
else
    echo "No constant sites detected. Tree was successfully built on the first pass."
fi

echo "Pipeline complete. Consensus tree is located in the phylogeny/ directory (.contree)."
