#!/bin/bash
# check_sra.sh

EMAIL="atwaup7@gmail.com"
BIOPROJECT="PRJNA1472399"

echo "Starting SRA monitoring loop for $BIOPROJECT..."

while true; do
    # Run the search tool
    RESULT=$(esearch -db sra -query "$BIOPROJECT" | efetch -format docsum)
    
    # If the result is not empty, the data is live
    if [ -n "$RESULT" ]; then
        echo "🚨 DATA IS NOW PUBLIC! 🚨"
        echo "$RESULT" > live_metadata.xml
        
        # Send email notification
        echo -e "The BioProject $BIOPROJECT is now public on NCBI SRA.\n\nMetadata has been saved to live_metadata.xml on your server." | mail -s "NCBI Alert: $BIOPROJECT is Live" "$EMAIL"
        
        break
    else
        echo "$(date): Still private. Checking again in 12 hours..."
        sleep 43200 # 12 hours
    fi
done
