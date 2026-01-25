#!/bin/bash

# installing necessary software

sudo apt install sra-toolkit
sudo apt install fastqc

# checking versions of installed software

fastqc --version
prefetch --version

# downloading RNA-seq data
prefetch SRR390728

# converting to fastq format

fastq-dump --gzip SRR390728

# running fastqc

fastqc SRR390728.fastq.gz

# opening quality check report using browser

xdg-open SRR390728_fastqc.html
