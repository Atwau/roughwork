#!/bin/bash
# re organizing project directory
mkdir -p qc/raw qc/trimmed qc/raw/multiqc qc/raw/fastqc qc/trimmed/fastqc qc/trimmed/multiqc data/raw data/trimmed vcf logs bam ref sam annotation r_analysis

# performing fastqc on raw data
fastqc data/raw/*.fastq -o qc/raw/fastqc/

# generating multiqc report
multiqc qc/raw/fastqc/ -o qc/raw/multiqc/

# trimming 
# Run Trimmomatic for sample SRR34502717 with directives that address the issues noted from the multiqc report
# this sample was contaminated with nextera adapters which necessitated seperate trimming
trimmomatic PE -threads 4 \
  data/raw/SRR34502717_1.fastq data/raw/SRR34502717_2.fastq \
  data/trimmed/SRR34502717_1_paired.fastq.gz data/trimmed/SRR34502717_1_unpaired.fastq.gz \
  data/trimmed/SRR34502717_2_paired.fastq.gz data/trimmed/SRR34502717_2_unpaired.fastq.gz \
  ILLUMINACLIP:NexteraPE-PE.fa:2:30:10 \
  LEADING:10 \
  TRAILING:3 \
  SLIDINGWINDOW:4:20 \
  MINLEN:36

# Trimming the rest of the samples which were contaminated with illumina universal adapters
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

# installing tools for alignment and variant calling
# BWA for indexing and alignment
# Samtools for file conversions and indexing to quicken file reading by variant caller
# BCFtools for the actual variant calling
conda install bioconda::bwa bioconda::samtools bioconda::bcftools

# indexing reference genome
bwa index -p ref/index/mtbgenome_bwa ref/GCF_000195955.2_ASM19595v2_genomic.fna

# alignment
# script for paired-end reads

REF_INDEX="ref/index/mtbgenome_bwa"
TRIMMED="data/trimmed"
OUTDIR="bam"

mkdir -p "$OUTDIR"

for R1 in $TRIMMED/*_1_paired.fastq.gz; do
    SAMPLE=$(basename "$R1" _1_paired.fastq.gz)
    R2="$TRIMMED/${SAMPLE}_2_paired.fastq.gz"
    
    echo "Aligning $SAMPLE"
    bwa mem -t 4 "$REF_INDEX" "$R1" "$R2" | \
        samtools sort -o "$OUTDIR/${SAMPLE}.sorted.bam"
    samtools index "$OUTDIR/${SAMPLE}.sorted.bam"
done

echo "Done. BAMs in $OUTDIR"


# calling variants
REF="ref/GCF_000195955.2_ASM19595v2_genomic.fna"
BAM_DIR="bam"
OUT_DIR="vcfs"

mkdir -p "$OUT_DIR"

for BAM in $BAM_DIR/*.sorted.bam; do
    SAMPLE=$(basename "$BAM" .sorted.bam)
    echo "Calling variants for $SAMPLE"
    bcftools mpileup -f "$REF" "$BAM" | \
        bcftools call -mv --ploidy -o "$OUT_DIR/${SAMPLE}.vcf"
done

echo "VCF files in $OUT_DIR"


# filtering variants with low quality
IN_DIR="vcf/raw"
OUT_DIR="vcf/filtered"

mkdir -p "$OUT_DIR"

for VCF in $IN_DIR/*.vcf; do
    SAMPLE=$(basename "$VCF" .vcf)
    echo "Filtering $SAMPLE"
    bcftools filter -i 'QUAL>20 && DP>5' "$VCF" > "$OUT_DIR/${SAMPLE}.filtered.vcf"
done

echo "Filtered VCFs in $OUT_DIR"
