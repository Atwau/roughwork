#!/bin/bash

# installing necessary software for RNA seq read alignment

# STAR, HISAT2, Salmon, Kallisto

conda install -c bioconda -c conda-forge \
  star \
  hisat2 \
  salmon \
  kallisto

conda activate rnaseq

star --version
hisat2 --version
salmon --version
kallisto version

