#!/usr/bin/env bash
# Fetch Filoviridae metadata including Deposit Year

MANIFEST_FILE="filoviridae_7_species_manifest.tsv"
rm -f "${MANIFEST_FILE}"

echo "[INFO] Fetching full SRA RunInfo metadata..."
# Note: Using the batch-safe approach we discussed earlier
# (Replace this with your full fetch logic if you need to handle > 2000 records)
esearch -db sra -query "txid11266[Organism]" | efetch -format runinfo > filoviridae_full_runinfo.csv

echo "[INFO] Parsing metadata with release year..."

awk -F',' -v outfile="${MANIFEST_FILE}" '
BEGIN { 
    OFS="\t"
    print "Run_ID", "Abbreviation", "Year", "Scientific_Name" > outfile
}
# 1. Identify column indices
NR==1 {
    for(i=1; i<=NF; i++) {
        if($i == "Run") c_run = i
        if($i == "ScientificName") c_sci = i
        if($i == "ReleaseDate") c_date = i
    }
}
# 2. Process data rows
NR>1 {
    run = $c_run
    sci = $c_sci
    date = $c_date # Format is YYYY-MM-DD...

    if (run ~ /^[SED]RR/) {
        species_abbr = "UNKNOWN"
        
        # Classification logic
        if (sci ~ /Zaire ebolavirus|Ebola virus/ && sci !~ /Sudan|Bundibugyo|Reston|Tai|Bombali/) species_abbr = "EBOV"
        else if (sci ~ /Sudan ebolavirus|Sudan virus/) species_abbr = "SUDV"
        else if (sci ~ /Bundibugyo ebolavirus|Bundibugyo virus/) species_abbr = "BDBV"
        else if (sci ~ /Taï Forest ebolavirus|Tai Forest ebolavirus|Cote d.Ivoire ebolavirus/) species_abbr = "TAFV"
        else if (sci ~ /Reston ebolavirus|Reston virus/) species_abbr = "RESTV"
        else if (sci ~ /Marburg marburgvirus|Marburg virus|Ravn virus/) species_abbr = "MARV"
        else if (sci ~ /Lloviu cuevavirus|Lloviu virus/) species_abbr = "LLOV"

        # Extract Year (take the first 4 characters of YYYY-MM-DD)
        year = substr(date, 1, 4)

        if (species_abbr != "UNKNOWN") {
            print run, species_abbr, year, sci >> outfile
        }
    }
}' filoviridae_full_runinfo.csv

echo "[COMPLETE] Manifest created with release years."


# Filter for samples deposited from 2015 onwards
awk -F'\t' '$3 >= 2015' filoviridae_7_species_manifest.tsv > post_2015_manifest.tsv
