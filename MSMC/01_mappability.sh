#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_mappability
#SBATCH --nodes=6 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

splitfa GCA_001746935.2_mywa_2.1_genomic.fna 35 | split -l 20000000

cat x* >> setophaga_split.35

bwa aln -t 8 -R 1000000 -O 3 -E 3 GCA_001746935.2_mywa_2.1_genomic.fna setophaga_split.35 > setophaga_split.35.sai  
 
bwa samse -f setophaga_split.35.sam GCA_001746935.2_mywa_2.1_genomic.fna setophaga_split.35.sai setophaga_split.35

