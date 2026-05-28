# Documentation: Optimizing nf-core/viralrecon for 16 GB RAM Systems

This guide documents the troubleshooting logic and technical architecture used to overcome hardware limitations during the execution of the **nf-core/viralrecon** pipeline.

---

## 1. Core Strategy: Decoupling and Resource Capping

Standard execution often fails on 16 GB systems because the pipeline attempts to download tools, index genomes, and process data simultaneously, leading to "Memory Starvation" and "Conda HTTP Errors."

### Phase 1: Environment Staging (`--download_only`)
We split the installation from the execution. By using the `--download_only` flag, we dedicated 100% of the system's RAM and network bandwidth to **Conda environment building**. This prevents Nextflow from starting heavy data-processing threads while Conda is still resolving complex dependency trees.

### Phase 2: Resource Interception (`user_limits.config`)
Nextflow pipelines are often pre-configured for high-performance clusters (HPC) with hundreds of gigabytes of RAM. We implemented a **Custom Configuration** to intercept these requests and cap them at 12 GB, forcing the pipeline to respect the local hardware limits.

---

## 2. Technical Troubleshooting Summary

| Issue | Technical Root Cause | Resolution |
| :--- | :--- | :--- |
| **CondaHTTPError (000)** | Network timeout during large metadata fetches. | Increased `remote_read_timeout_secs` to 1200. |
| **LockError** | "Ghost" lock files left by interrupted downloads. | Manual deletion of `.lock` files in `pkgs` directory. |
| **CondaVerificationError** | Corrupted package tarballs (e.g., `setuptools`). | Purged package cache using `conda clean --packages`. |
| **36 GB RAM Requirement** | Pipeline default exceeds physical RAM (16 GB). | Used `withName` selectors in config to cap RAM at 12 GB. |
| **Library Load Failure** | Broken R links (`libicui18n.so.58`) in QC steps. | Applied `errorStrategy = 'ignore'` to bypass non-essential plots. |

---

## 3. Working Codebase

### I. The Configuration: `user_limits.config`
Create this file in your project root. It is the "Hard Cap" that prevents system crashes.

```nextflow
// user_limits.config
process {
    // Global limits for every task in the pipeline
    withName: '.*' {
        cpus   = 2
        memory = '12 GB'
        maxForks = 1 // Forces sequential execution to protect RAM
    }
    
    // Specifically override high-default indexing tasks
    withName: 'BLAST_MAKEBLASTDB|SNPEFF_BUILD|BOWTIE2_BUILD' {
        memory = '12 GB'
        cpus = 2
    }

    // Bypass processes with known broken environment links
    withName: 'PLOT_BASE_DENSITY|MULTIQC' {
        errorStrategy = 'ignore'
    }
}

### II. The Pre-Setup Script: `env_pre_setup.sh`
Run this once to prepare all software environments.

```bash
#!/bin/bash
# Limit Nextflow's internal Java overhead
export NXF_OPTS="-Xms512m -Xmx2g"

nextflow run nf-core/viralrecon \
  -profile conda \
  -c user_limits.config \
  --download_only \
  --input samplessheet.csv \
  --outdir setup_results \
  --genome 'MN908947.3' \
  --platform illumina \
  -resume

### III. The Final Execution Script: `run_viralrecon.sh`
Use this for actual data processing.

```bash
#!/bin/bash
export NXF_OPTS="-Xms512m -Xmx2g"

nextflow run nf-core/viralrecon \
  -profile conda \
  -c user_limits.config \
  --input samplessheet.csv \
  --outdir results/final_analysis \
  --protocol amplicon \
  --genome 'MN908947.3' \
  --primer_set artic \
  --primer_set_version 3 \
  --platform illumina \
  --max_memory '12.GB' \
  --max_cpus 4 \
  --skip_pangolin \
  --skip_nextclade \
  -resume


### IV. Key Output Locations

| Output Type | File Path |
| :--- | :--- |
| **Consensus Sequences** | `results/final_analysis/consensus/bcftools/*.fasta` |
| **Variant Lists** | `results/final_analysis/variants/bcftools/*.vcf` |
| **Quality Summary** | `results/final_analysis/multiqc/multiqc_report.html` |
| **Intermediate Data** | Found in `work/`. **Do not delete** if you intend to use the `-resume` feature. |
