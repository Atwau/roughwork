#!/bin/bash

# Calling variants using samtools

# 1. Index the reference genome using samtools
samtools faidx MN908947.fasta

# 2. Next is to call variants/identify variants in the test sample/target sample sequence
# freebayes will be used for this task. Other variant callers can be used as well
freebayes -f MN908947.fasta mapping/ERR5743893.sorted.bam  > ERR5743893.vcf

# 3. Compress the vcf file
# its good pratice to compress to save space

bgzip ERR5743893.vcf
tabix ERR5743893.vcf.gz
