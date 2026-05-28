# Creating the samplesheet.csv file

# Like most nf-core pipelines, viralrecon requires a CSV file containing
# the sample names and location of the fastq files input. The format
# of the samplesheet we’re going to use should look like this:

sample,fastq_1,fastq_2

SAMPLE_1,fastq_1_location,fastq_2_location

# You can prepare this file in Excel or another spreadsheet program but 
# remember to save the file as a CSV file. Alternatively, nf-core provide 
# a useful python script that can be used to generate the samplesheet 
# automatically. First download the python script to your working directory:
 wget -L https://raw.githubusercontent.com/nf-core/viralrecon/master/bin/fastq_dir_to_samplesheet.py

# Now run the python script:

python3 fastq_dir_to_samplesheet.py data samplesheet.csv -r1 _1.fastq.gz -r2 _2.fastq.gz

# The name of the directory you moved the fastq files to (data) comes
# first followed by the name of the file we want to create (samplesheet.csv)
# then we specify the file suffixes of our fastq files
# (_1.fastq.gz and _2.fastq.gz) using -r1 and -r2 respectively.

# If you didn’t get an error, you should find the samplesheet.csv file in your
# working directory. To check what the script did, either print the file with cat on the command line:

cat samplesheet.csv

# Or else open samplesheet.csv in a text editor or Excel to check.
