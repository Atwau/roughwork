#!/bin/bash
trimmomatic PE -threads 4 \
  data/raw/SRR34502717_1.fastq data/raw/SRR34502717_2.fastq \
  data/trimmed/SRR34502717_1_paired.fq.gz data/trimmed/SRR34502717_1_unpaired.fq.gz \
  data/trimmed/SRR34502717_2_paired.fq.gz data/trimmed/SRR34502717_2_unpaired.fq.gz \
  ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 \
  LEADING:10 \
  TRAILING:3 \
  SLIDINGWINDOW:4:20 \
  MINLEN:36
