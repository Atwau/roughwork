#!/bin/bash

#-----------------------------------------------
# STEP 0: Install Cell Ranger
#-----------------------------------------------
 
# Create a directory for Cell Ranger installation
mkdir -p ~/software
cd ~/software
 
# Download Cell Ranger (version 10.0.0)
# Note: Check https://www.10xgenomics.com/support/software/cell-ranger/downloads#download-links for the most current version
wget -O cellranger-10.0.0.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-10.0.0.tar.gz?Expires=1780618181&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=SfFmXOYah2h5R4p3bX0wxopoSaoLMkLkbH5c94MMjaWyuu02NwtkUFnJOFWcouHhTrOWdkaXwjeGObWoQ6foK5oJ8mrw-9D-8uIxKJPkt7vpXcZBjyZBDrqu5DumBFWSnF7aMyexm9-XgFjLeiXbcNantgVpDLirgATtNYWJ6R-TjY7ThhOwNo94OO7IG7-8sAiGSaawoQQ3PUyOa-ELzka6mnaQcOOtSM577lyVxqeqr78gBguP49rajpajDj2X3VlfKQiQYIFmJ-Ivc1QGNN~jhljHuo5tQ-xsPOnmTFrb7jjcPl0Efj-ARt~3PqJWYRRgp218cs7LzPNG1k7aZA__" 

# Add Cell Ranger to PATH (optional: add to ~/.bashrc for permanent access)
export PATH=$HOME/software/cellranger-10.0.0:$PATH
 
# To make this permanent, add to your ~/.bashrc:
# echo 'export PATH=$HOME/software/cellranger-10.0.0:$PATH' >> ~/.bashrc
# source ~/.bashrc
 
# Check Cell Ranger components
cellranger -h
