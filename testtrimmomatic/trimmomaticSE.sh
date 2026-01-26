#!/bin/bash

# Run Trimmomatic SE (single-end) using Java JAR
java -jar /usr/share/java/trimmomatic.jar SE \
  -threads 4 \
  ../data/SRR390728.fastq.gz \
  trimmed/SRR390728_trimmed.fastq.gz \
  ILLUMINACLIP:/usr/share/trimmomatic/TruSeq3-SE.fa:2:30:10 \
  LEADING:3 \
  TRAILING:3 \
  SLIDINGWINDOW:4:15 \
  MINLEN:36
