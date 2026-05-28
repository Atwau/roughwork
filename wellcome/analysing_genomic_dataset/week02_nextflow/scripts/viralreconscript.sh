# script to run viralrecon
# you can adjust the directives to suit your computer

nextflow run nf-core/viralrecon -profile conda \
--max_memory '12.GB' --max_cpus 4 \
--input samplesheet.csv \
--outdir results/viralrecon \
--protocol amplicon \
--genome 'MN908947.3' \
--primer_set artic \
--primer_set_version 3 \
--skip_kraken2 \
--skip_assembly \
--skip_pangolin \
--skip_nextclade \
--skip_asciigenome \
--platform illumina \
-resume
