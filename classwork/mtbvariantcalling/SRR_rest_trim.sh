#!/bin/bash
for sample in SRR28515580 SRR35497378 SRR35891567
do
  echo "Processing $sample..."
  trimmomatic PE -threads 4 \
    data/raw/${sample}_1.fastq data/raw/${sample}_2.fastq \
    data/trimmed/${sample}_1_paired.fastq.gz data/trimmed/${sample}_1_unpaired.fastq.gz \
    data/trimmed/${sample}_2_paired.fastq.gz data/trimmed/${sample}_2_unpaired.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 \
    LEADING:3 \
    TRAILING:15 \
    SLIDINGWINDOW:4:20 \
    MINLEN:36
done
