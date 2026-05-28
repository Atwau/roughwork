#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Optional: print each command before executing it (for debugging)
#set -x

# Define paths and variables
INPUT="samplesheet.csv"
OUTDIR="results/viralrecon"
GENOME="MN908947.3"
MAX_MEMORY="7.GB"
MAX_CPUS=4
PRIMER_SET="artic"
PRIMER_SET_VERSION=3
PLATFORM="illumina"

# Step 1: Create a custom Nextflow config to override high memory requests
cat > nextflow.config <<'EOF'
process {
  withName: 'COLLAPSE_PRIMERS' {
    memory = 2.GB
  }
  withName: 'BOWTIE2_BUILD' {
    memory = 4.GB
  }
  withName: 'SNPEFF_BUILD' {
    memory = 4.GB
  }
}
EOF

# Step 2: Run the pipeline
nextflow run nf-core/viralrecon -profile conda \
    --max_memory "$MAX_MEMORY" \
    --max_cpus "$MAX_CPUS" \
    --input "$INPUT" \
    --outdir "$OUTDIR" \
    --protocol amplicon \
    --genome "$GENOME" \
    --primer_set "$PRIMER_SET" \
    --primer_set_version "$PRIMER_SET_VERSION" \
    --skip_kraken2 \
    --skip_assembly \
    --skip_pangolin \
    --skip_nextclade \
    --skip_asciigenome \
    --platform "$PLATFORM" \
    -resume
