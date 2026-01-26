# Rough Work Repository
The purpose of this repository is to serve as a rough work repository
The scope includes
1. Testing the functionality of the different software I install
2. developing modular shell scripts which can be compiled into pipelines

# List of Software
1. fastqc
2. sra-toolkit

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
