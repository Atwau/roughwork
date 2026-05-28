#!/bin/bash

# Limit Nextflow's own memory to 2GB to save RAM for Conda
export NXF_OPTS="-Xms512m -Xmx2g"

nextflow run nf-core/viralrecon \
  -profile conda \
  -c user_limits.config \
  --download_only \
  --platform illumina \
  --input samplessheet.csv \
  --outdir results/viralrecon \
  --genome 'MN908947.3' \
  --skip_pangolin \
  --skip_nextclade \
  -process.maxForks 1 \
  -resume
