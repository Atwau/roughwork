#!/usr/bin/env bash
# Fetch and Parse Metadata for the 7 classic Filoviridae species

MANIFEST_FILE="filoviridae_7_species_manifest.tsv"
rm -f "${MANIFEST_FILE}"

echo "[INFO] Fetching full SRA RunInfo metadata for Filoviridae (Tax ID 11266)..."
esearch -db sra -query "txid11266[Organism]" | efetch -format runinfo > filoviridae_full_runinfo.csv

echo "[INFO] Parsing metadata and building pipeline manifest..."

awk -F',' -v outfile="${MANIFEST_FILE}" '
BEGIN { 
    OFS="\t"
    print "Run_ID", "Abbreviation", "Scientific_Name" > outfile
}
# 1. Identify column indices from the CSV header
NR==1 {
    for(i=1; i<=NF; i++) {
        if($i == "Run") c_run = i
        if($i == "ScientificName") c_sci = i
    }
}
# 2. Process data rows
NR>1 {
    run = $c_run
    sci = $c_sci

    # Only process valid SRA Run IDs
    if (run ~ /^[SED]RR/) {
        
        species_abbr = "UNKNOWN"
        
        # 1-5: The 5 classic Ebolavirus species
        if (sci ~ /Zaire ebolavirus|Ebola virus/ && sci !~ /Sudan|Bundibugyo|Reston|Tai|Bombali/) species_abbr = "EBOV"
        else if (sci ~ /Sudan ebolavirus|Sudan virus/) species_abbr = "SUDV"
        else if (sci ~ /Bundibugyo ebolavirus|Bundibugyo virus/) species_abbr = "BDBV"
        else if (sci ~ /Taï Forest ebolavirus|Tai Forest ebolavirus|Cote d.Ivoire ebolavirus/) species_abbr = "TAFV"
        else if (sci ~ /Reston ebolavirus|Reston virus/) species_abbr = "RESTV"
        
        # 6: The Marburgvirus species (includes Marburg and Ravn)
        else if (sci ~ /Marburg marburgvirus|Marburg virus|Ravn virus/) species_abbr = "MARV"
        
        # 7: The Cuevavirus species
        else if (sci ~ /Lloviu cuevavirus|Lloviu virus/) species_abbr = "LLOV"

        # Export to manifest if it matches one of the 7 species
        if (species_abbr != "UNKNOWN") {
            print run, species_abbr, sci >> outfile
        }
    }
}' filoviridae_full_runinfo.csv

echo "[COMPLETE] Created ${MANIFEST_FILE}"
