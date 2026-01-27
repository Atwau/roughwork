# Rough Work Repository

## Overview
This repository serves as a **rough work and learning space** for bioinformatics tooling and pipeline development.

## Purpose
The goals of this repository are to:
1. Test the functionality of installed bioinformatics software
2. Develop **modular shell scripts** that can later be composed into full pipelines

## Repository Structure
Each folder represents a **deep dive into a single bioinformatics tool**.

For example:
- `testfastqc/` is dedicated to understanding the **FastQC** tool
  - What the tool does
  - Installation snippets
  - Testing commands
  - Usage examples and shell script fragments

Each tool is documented in detail within its **own `README.md` file**.

> Learning is most effective when done in **small, focused chunks**.



## Software Stack (Chronological Order)
1. **sra-toolkit** — Download sequencing data
2. **FastQC** — Assess base and read quality
3. **Trimmomatic** — Remove adapters and low-quality bases

---

## Pipeline Workflow

### 1. Preprocessing
1. Download sequencing data
2. Perform initial quality control
3. Trim adapters and poor-quality bases  
   - Trimmomatic for RNA-seq  
   - Other trimmers as applicable
4. Perform post-trimming quality control to confirm improvements

#### Notes on Trimmomatic
- Trimmomatic ships with **predefined adapter sequences**
- Adapter sequences are standardized by sequencing kit manufacturers
- Most RNA-seq data uses a small, well-defined set (e.g. Illumina TruSeq)
- This prevents users from repeatedly recreating the same adapter files

---

### 2. Downstream Analysis  
Choose a pipeline based on the **type of sequencing data**

---

## A. DNA-seq / Whole Genome / Exome

### Step 1: Read Alignment
Map reads to a reference genome.

**Common tools:**
- BWA-MEM
- Bowtie2

**Output:** SAM → BAM



### Step 2: Post-alignment Processing
Prepare alignments for downstream analysis.

**Typical steps:**
- Convert SAM → BAM (`samtools view`)
- Sort BAM (`samtools sort`)
- Mark/remove duplicates (`Picard MarkDuplicates`)
- Index BAM (`samtools index`)



### Step 3: Variant Calling
Identify SNPs and indels.

**Tools:**
- GATK HaplotypeCaller
- FreeBayes

**Output:** VCF



### Step 4: Variant Annotation
Interpret biological significance.

**Tools:**
- ANNOVAR
- SnpEff
- VEP



## B. RNA-seq

### Step 1: Read Alignment or Pseudo-alignment

**Alignment-based (Reads are fully aligned base-by-base to a reference genome or transcriptome):**
- STAR
- HISAT2

**Alignment-free; faster - (Reads are not aligned base-by-base):**
- Salmon
- Kallisto



### Step 2: Quantification
Count reads per gene or transcript.

**Tools:**
- featureCounts
- HTSeq-count
- Salmon / Kallisto (native quantification)



### Step 3: Differential Expression Analysis
Statistical comparison between conditions.

**R packages:**
- DESeq2
- edgeR
- limma



### Step 4: Functional Analysis
Biological interpretation of results.

**Examples:**
- Gene Ontology (GO) enrichment
- Pathway analysis (KEGG, Reactome)



## C. 16S rRNA / Metagenomics

### Typical Workflow
- Quality-filtered reads → Denoising or clustering
- Taxonomic assignment
- Diversity analysis

**Tools:**
- QIIME2
- DADA2
- Kraken2

---

## Best Practices

### `.gitignore`
- Large sequencing files **must not** be tracked by Git
- Git is designed for **scripts and configuration**, not raw data
- Ignoring data files helps:
  - Reduce repository size
  - Improve performance
  - Keep version control clean
