#!/bin/bash
#SBATCH --job-name=sra_download
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=16G
#SBATCH --time=12:00:00
#SBATCH -e /mnt/roche/pius_roche_project/scrnaseq/logs/sra_download_%j.err
#SBATCH -o /mnt/roche/pius_roche_project/scrnaseq/logs/sra_download_%j.out

# Navigate to the project directory
cd /mnt/roche/pius_roche_project/scrnaseq

# Create the data directory if it does not exist
mkdir -p data

# Load conda and activate your specific environment
module load conda/4.11.0
source activate scrnaseq

# Loop through the SRR numbers listed in the file
while read SRR; do
    echo "Downloading and splitting $SRR into the data folder..."
    
    # Use --outdir to send the fastq files directly to the data folder
    fastq-dump $SRR --outdir data/raw/ --split-files
    
done < SRR_Acc_List.txt
