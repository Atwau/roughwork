#!/bin/bah

# steps in mapping the genome to reference
# 1. indexing the reference genome
bwa index MN908947.fasta

# 2. map target sequences to reference genome
bwa mem MN908947.fasta data/ERR5743893_1.fastq data/ERR5743893_2.fastq > mapping/ERR5743893.sam

# 3. converting .sam to .bam to save space using samtools
samtools view -@ 20 -S -b mapping/ERR5743893.sam > mapping/ERR5743893.bam

# 4. sort /order sequences by their location in the genome resulting from mapping
# by default sequences are ordered/sorted according to how they appeared during sequencing
samtools sort -@ 32 -o mapping/ERR5743893.sorted.bam mapping/ERR5743893.bam

# 5. indexing the sorted BAM file
# we need to index the sorted BAM file. Briefly, we index BAM files to speed access to specific 
# genomic regions and read data, allowing for effective variant calling, visualisation, and 
# genomics research.

samtools index mapping/ERR5743893.sorted.bam

# 6. You can now visualize your BAM file on Integrative Genomics Viewer (IGV)
