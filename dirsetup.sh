#!/bin/bash

# If an argument is provided, use it as the parent directory. 
# Otherwise, default to the current directory (.).
OUT_DIR="${1:-.}"

# Ensure the parent directory exists
mkdir -p "$OUT_DIR"

# Create the directory structure inside the parent directory
mkdir -p \
    "$OUT_DIR/qc/raw" \
    "$OUT_DIR/qc/trimmed" \
    "$OUT_DIR/qc/raw/multiqc" \
    "$OUT_DIR/qc/raw/fastqc" \
    "$OUT_DIR/qc/trimmed/fastqc" \
    "$OUT_DIR/qc/trimmed/multiqc" \
    "$OUT_DIR/data/raw" \
    "$OUT_DIR/data/trimmed" \
    "$OUT_DIR/vcf" \
    "$OUT_DIR/logs" \
    "$OUT_DIR/bam" \
    "$OUT_DIR/ref" \
    "$OUT_DIR/sam" \
    "$OUT_DIR/annotation" \
    "$OUT_DIR/r_analysis"
