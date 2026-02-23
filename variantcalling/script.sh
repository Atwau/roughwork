#!/bin/bash

# creating venv to work in, plust installing necessary 
# tools for variant calling

conda create -n variantcalling samtools python biopython bcftools bwa
