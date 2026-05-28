#!/bin/bash

# script to run viralrecon
# you can adjust the directives to suit your computer

# Keep Nextflow's management memory low
export NXF_OPTS="-Xms512m -Xmx2g"

nextflow run nf-core/viralrecon \
  -profile conda \
  -c user_limits.config \
  --input samplessheet.csv \
  --outdir results/viralrecon \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --platform illumina \
  --max_memory '12.GB' \
  --max_cpus 4 \
  --skip_kraken2 \
  --skip_assembly \
  --skip_pangolin \
  --skip_nextclade \
  --skip_asciigenome \
  --skip_consensus_plots \
  -process.maxForks 1 \
  -resume
