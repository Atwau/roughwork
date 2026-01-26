#!/bin/bash

# installing trimmomatic

# first update
sudo apt update

# then install trimmomatic

sudo apt install trimmomatic

# To run Trimmomatic on compressed files (.gz), you need to specify 
# whether your data is Paired-End (PE) or Single-End (SE)

# first checking version of trimmomatic installed

TrimmomaticSE -version
TrimmomaticPE -version

# listing all the files that came along with trimmomatic installation
# this if for purposes of understanding 
dpkg -L trimmomatic

