#!/bin/bash

# creating venv to work in, plust installing necessary 
# tools for variant calling

conda create -n variantcalling samtools python biopython bcftools bwa

# next you have to download your datasets of interest
# example mycobacterium ulcerans (https://pmc.ncbi.nlm.nih.gov/articles/PMC6639603/)
# Link to sra database (https://trace.ncbi.nlm.nih.gov/Traces/index.html?run=ERR3335404)

wget -c http://ftp.sra.ebi.ac.uk/vol1/run/ERR333/ERR3335404/P7741_R2.fastq.gz
wget -c http://ftp.sra.ebi.ac.uk/vol1/run/ERR333/ERR3335404/P7741_R1.fastq.gz

# Download reference genome
# reference genome (https://www.ncbi.nlm.nih.gov/nuccore/CP000325.1)

efetch -db nuccore -id CP000325.1 -format fasta > CP000325.1.fasta

# perform quality checks on the downladed data
# first creat qc_reports folder

fastqc *.fastq.gz -o qc_reports/
multiqc qc_reports/ # to combine multiple qc reports

# read the files using xdg-open
# xdg-open is a wrapper that uses your default computer
# application to open files, it automatically chooses which apllication to launch
# based on the file type you have asked it to open
xdg-open P7741_R2.fastq.html

# perform trimming to improve read quality
# for this trimming I will use sickle
sickle pe -f P7741_R1.fastq.gz -r P7741_R2.fastq.gz -t sanger -q 20 -l 20 -g -o trimmed_R1.fastq.gz -p trimmed_R2.fastq.gz -s trimmed_S.fastq.gz

# next we will perfomr genome mapping
# aligning the sample genome to the reference genome
# but first we index the reference genome

# indexing referece genome
bwa index refgenome/agy99refgenome.fasta

# next we perform the alignment/mapping
bwa -t 8 refgenome/agy99refgenome.fasta trimmed_R1.fastq.gz trimmed_R2.fastq.gz > output.sam

# convert .sam to .bam
samtools view -S -b output.sam > output.bam

# after we have to sort the bam file
samtools sort -o output.sorted.bam output.bam

# we can now generate the mapping statistics to know how well the genome
# was mapped to the reference
# for this we se samtools still
samtools flagstats output.sorted.bam
