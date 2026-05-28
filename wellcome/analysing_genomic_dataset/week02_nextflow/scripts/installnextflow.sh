# set up your conda channels:

conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Now create an environment called nextflow and install Nextflow in it:

conda create --name nextflow nextflow

# Before you can use Nextflow, you will need to activate the nextflow environment:

conda activate nextflow

# To check it’s working, run the following command:

nextflow help
