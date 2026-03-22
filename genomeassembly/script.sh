#!/bin/bash

# gemone assembly 

# 1. Sequence quality checks using quast

conda install -c bioconda quast

# 2. running quast

quast.py my_assembly.fasta


# 3. intalling SPAdes genome assembly tool

conda install -c bioconda spades
