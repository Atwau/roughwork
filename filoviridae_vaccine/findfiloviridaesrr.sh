#!/bin/bash

# Fetch all SRA run accessions for Filoviridae (Taxonomy ID 11266)
esearch -db sra -query "txid11266[Organism]" | efetch -format runinfo | cut -d ',' -f 1 | grep -E "^[S|E|D]RR" > filoviridae_sra_list.txt
