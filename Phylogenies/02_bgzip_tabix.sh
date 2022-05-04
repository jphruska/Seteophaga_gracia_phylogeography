#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_phylogeny_filtering
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-29

# define input files from helper file

input_array=$(head -n ${SLURM_ARRAY_TASK_ID} vcf_list.txt | tail -n 1)

# bgzip and tabix index files that will be subdivided into windows

bgzip ${input_array}.phylo.filtered.vcf.recode.vcf

tabix -p vcf ${input_array}.phylo.filtered.vcf.recode.vcf.gz
