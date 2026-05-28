#!/bin/bash

# we shall use a for loop to iterate the text file
# samples.txt and download the data whose accession
# numbers are in the text file

for i in $(cat samples.txt);do fasterq-dump --split-files $i;done

# compressing files, its a good practice to compress the files
# to save disk space
gzip *.fastq

# Now create a directory called data and move the fastq files there:
mkdir data
mv *.fastq.gz data
