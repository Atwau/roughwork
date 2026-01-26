#!/bin/bash

fastqc trimmed/SRR390728_trimmed.fastq.gz -o trimmed/

# viewing result
xdg-open trimmed/SRR390728_trimmed_fastqc.html
