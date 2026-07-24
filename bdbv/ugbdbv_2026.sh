#!/bin/bash

# This outputs a clean list of SRR numbers to your screen
esearch -db sra -query "PRJNA1472399" | efetch -format docsum | xtract -pattern DocumentSummary -element Run@acc

# To save that clean list directly to a text file
esearch -db sra -query "PRJNA1472399" | efetch -format docsum | xtract -pattern DocumentSummary -element Run@acc > srr_list.txt
