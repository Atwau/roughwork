#!/usr/bin/env bash
# ==============================================================================
# PAN-FILOVIRIDAE GENOMIC ANALYSIS ENGINE: HIGH-THROUGHPUT PROCESSING SCRIPT
# ==============================================================================
set -euo pipefail

# 1. Environment Configurations & Directory Initialization
BASE_DIR="${HOME}/filov_broad_mcm"
DATA_DIR="${BASE_DIR}/raw_data"
QC_DIR="${BASE_DIR}/qc/trimmed"
ALIGN_DIR="${BASE_DIR}/alignment"
VCF_DIR="${BASE_DIR}/vcf/raw"
CONS_DIR="${BASE_DIR}/consensus"
REF_DIR="${BASE_DIR}/ref"

mkdir -p "${DATA_DIR}" "${QC_DIR}" "${ALIGN_DIR}" "${VCF_DIR}" "${CONS_DIR}" "${REF_DIR}"

# Define Reference Identifiers
REF_BDBV="NC_014373.1"
REF_EBOV="NC_002549.1"
REF_MARV="NC_001608.3"

echo "[INFO]: Downloading Genus-Specific Filoviridae Reference Templates..."
wget -q -O "${REF_DIR}/BDBV_ref.fna" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${REF_BDBV}&rettype=fasta"
wget -q -O "${REF_DIR}/EBOV_ref.fna" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${REF_EBOV}&rettype=fasta"
wget -q -O "${REF_DIR}/MARV_ref.fna" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${REF_MARV}&rettype=fasta"

# Index Reference Sequences using Bowtie2
for ref in BDBV EBOV MARV; do
    echo "[INFO]: Building Alignment Mapping Index for ${ref} Reference Matrix..."
    bowtie2-build -q "${REF_DIR}/${ref}_ref.fna" "${REF_DIR}/${ref}_index"
done

# 2. Automated Sample Processing Loop
# Expects raw paired-end files named as: SAMPLE_ID_R1.fastq and SAMPLE_ID_R2.fastq
cat "${BASE_DIR}/srr_sample_manifest.txt" | while read -r SAMPLE_ID VIRAL_GENUS; do
    echo "========================================================================"
    echo "[PROCESSING]: Launching Pipeline Analysis Engine for Sample: ${SAMPLE_ID}"
    echo "========================================================================"
    
    # Quality Control and Adapter Trimming via Trimmomatic
    trimmomatic PE -threads 16 -phred33 \
        "${DATA_DIR}/${SAMPLE_ID}_R1.fastq" "${DATA_DIR}/${SAMPLE_ID}_R2.fastq" \
        "└─" "${QC_DIR}/${SAMPLE_ID}_1_paired.fq" "${QC_DIR}/${SAMPLE_ID}_1_unpaired.fq" \
        "${QC_DIR}/${SAMPLE_ID}_2_paired.fq" "${QC_DIR}/${SAMPLE_ID}_2_unpaired.fq" \
        ILLUMINACLIP:adapters/TruSeq3-PE.fa:2:30:10 LEADING:30 TRAILING:30 SLIDINGWINDOW:4:30 MINLEN:50
        
    # Reference Guided Alignment Initialization
    SELECT_INDEX="${REF_DIR}/${VIRAL_GENUS}_index"
    SELECT_REF="${REF_DIR}/${VIRAL_GENUS}_ref.fna"
    
    echo "[ALIGNMENT]: Mapping Cleaned Reads to Targeted Index File Layer..."
    bowtie2 -p 16 --local -x "${SELECT_INDEX}" \
        -1 "${QC_DIR}/${SAMPLE_ID}_1_paired.fq" -2 "${QC_DIR}/${SAMPLE_ID}_2_paired.fq" | \
        samtools view -bS -q 30 - | \
        samtools sort -o "${ALIGN_DIR}/${SAMPLE_ID}.sorted.bam"
        
    samtools index "${ALIGN_DIR}/${SAMPLE_ID}.sorted.bam"
    
    # Deep Low-Frequency Intra-host Variant Calling Process
    echo "[VARIANT CALLING]: Extracting Sub-Clonal High-Quality Variants via iVar Platform..."
    ivar variants -p "${VCF_DIR}/${SAMPLE_ID}_variants" \
        -r "${SELECT_REF}" -g "${SELECT_DIR_GFF}" \
        -m 30 -q 30 -t 0.01 <(samtools mpileup -A -d 50000 -Q 0 "${ALIGN_DIR}/${SAMPLE_ID}.sorted.bam")

    # High-Confidence Micro-Consensus Block Derivation
    echo "[CONSENSUS]: Extracting Verified Micro-Consensus Genomic Footprint..."
    samtools mpileup -A -d 50000 -Q 30 "${ALIGN_DIR}/${SAMPLE_ID}.sorted.bam" | \
        ivar consensus -p "${CONS_DIR}/${SAMPLE_ID}_consensus" -q 30 -t 0.5 -m 10
        
    echo "[COMPLETE]: Finished Processing Operations for Sample Node: ${SAMPLE_ID}"
done
