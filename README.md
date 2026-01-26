# Rough Work Repository
The purpose of this repository is to serve as a rough work repository
The scope includes
1. Testing the functionality of the different software I install
2. developing modular shell scripts which can be compiled into pipelines

Each folder is a bioinformatics tool deep dive. For example testfastqc is a folder dedicated to
dissecting what fastqc tool does, shell script snippets for installing, testing and running fastqc

Each tool is described in detailed inside the readme files in each tool's folder

I hope you find this resources handy and useful. I believe learning is best done in small chunks

# List of Software (in chronological order)
1. sra-toolkit (for downloading seq data)
2. fastqc (for checking base read quality)
3. trimmomatic (for trimming off adapters and poor quality bases)

## Step by step pipeline activities
### preprocessing
1. download seq data
2. perform quality check
3. trim off adapters using trimmomatic (RNA-seq) or some other trimming software
4. perform quality check again to comfirm adapters and poor bases were removed

#### Note:
- Trimmomatic comes with adapter files because adapter sequences are standardized
by sequencing kit manufacturers, and most RNA-seq data uses a small, well-defined
set of adapters (especially Illumina TruSeq).
- So instead of making every user reinvent the wheel, Trimmomatic ships with the 
most commonly used adapter sequences.


# Best practices

## .gitignore file
It is very important to ignore tracking very large sequence data files
This is required by git to save space
git is primarily meant to track scripts, not data files
