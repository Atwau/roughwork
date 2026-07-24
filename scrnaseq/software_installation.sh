#-----------------------------------------------
# STEP 1: Install supporting software using Conda
#-----------------------------------------------
 
# Create a dedicated conda environment for single-cell analysis
conda create -p ~/Env_scRNA python=3.10
 
# Activate the environment
conda activate ~/Env_scRNA
 
# Configure conda channels
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
 
# Install required tools
conda install -y \
    sra-tools \          # For downloading data from SRA
    fastqc \             # For quality control
    multiqc \            # For aggregating QC reports
    wget \               # For downloading files
    samtools             # For BAM file manipulation
 
# Verify installations
fastqc --version         # FastQC v0.12.1
multiqc --version        # multiqc, version 1.19
prefetch --version       # prefetch : 3.0.10

# Note
# the configuration of conda channels is important especially for new environments 
# when you are working on HPC where you don't have much control over software installation
# what you will rely on mostly is the virtual environments that you create for the different
# projects that you are working on
