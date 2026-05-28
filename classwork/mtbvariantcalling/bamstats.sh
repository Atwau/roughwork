#!/bin/bash
for file in bam/*.sorted.bam; do
    echo "=== Statistics for $file ==="
    samtools flagstat "$file"
    echo ""
done
