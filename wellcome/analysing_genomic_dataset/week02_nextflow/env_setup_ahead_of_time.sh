#!/bin/bash

nextflow run nf-core/viralrecon \
  -profile conda \
  --download_only \
  --platform illumina \
  --input samplessheet.csv \
  --outdir results/viralrecon \
  --genome 'MN908947.3'
