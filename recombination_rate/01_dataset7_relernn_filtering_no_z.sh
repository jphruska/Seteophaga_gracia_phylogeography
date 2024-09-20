#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_relernn_filtering_no_z
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-29

# define input files from helper file

input_array=$(head -n ${SLURM_ARRAY_TASK_ID} vcf_list.txt | tail -n 1)

# define main working directory
workdir=/lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs

# run vcftools with SNP output for ReLERNN for individuals from 'Northern' population (28), only biallelic SNPs with max missing = 0.8
vcftools --vcf ${workdir}/${input_array}.filtered.vcf --keep northern.txt --max-missing 0.8 --minDP 6 --max-meanDP 50 --min-alleles 2 --max-alleles 2 --mac 1 --max-maf 0.49 --remove-indels --recode --recode-INFO-all --out ${workdir}/${input_array}_northern_filtered


