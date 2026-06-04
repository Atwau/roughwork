#!/bin/bash

# Point this to your existing file containing the accession numbers
INPUT_FILE="srrlist.txt"

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: $INPUT_FILE not found in the current directory."
    exit 1
fi

OUTPUT_DIR="fastq_files"
mkdir -p "$OUTPUT_DIR"
cd "$OUTPUT_DIR"

echo "Starting download from ../$INPUT_FILE..."

while IFS= read -r SRR || [[ -n "$SRR" ]]; do
    
    # Strip carriage returns and skip empty lines
    SRR=$(echo "$SRR" | tr -d '\r')
    if [[ -z "$SRR" ]]; then
        continue
    fi

    echo "----------------------------------------"
    echo "Processing $SRR..."
    
    prefetch "$SRR"
    fasterq-dump --split-files "$SRR"

done < "../$INPUT_FILE"

echo "----------------------------------------"
echo "All downloads complete."
