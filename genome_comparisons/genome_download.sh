#!/bin/bash
# Author: Dr. Atwau Pius
# Purpose; Comparison of viral genomes
# Question at hand: Why different anealing temperatures for 
# different viral PCR protocols
# for example  for RVF protocol, the anealing temperature is
# at 53 degreee  celcius while the filoviridae (ebola & marburg)
# the anealing temperature is around 58 degrees celcius

# Downloading the viral genome

# Download Ebola virus complete genome (e.g., Zaire ebolavirus reference)
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_002549.1&rettype=fasta" > ebola.fasta

# Download Rift Valley fever virus segments (L, M, and S)
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=NC_014395.1,NC_014396.1,NC_014397.1&rettype=fasta" > rvf_all_segments.fasta
