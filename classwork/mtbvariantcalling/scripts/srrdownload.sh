
#!/bin/bash

# Raw data download with prefetch
for i in $(cat $1); do
    prefetch "$i"
done

# Extraction with fasterq-dump
for i in $(cat $1); do
    fasterq-dump "$i" --split-files
done

echo "Download and extraction complete!"
