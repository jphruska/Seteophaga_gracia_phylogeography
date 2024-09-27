#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_div_diff_dataset17
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-30

# define input files from helper file

input_array=$(head -n ${SLURM_ARRAY_TASK_ID} vcf_list_all.txt | tail -n 1)

# pull out header and add to filtered vcf file

grep "#" ${input_array} > ${input_array}.filtered.vcf

# filter out rows that have low quality filters, genotyped sites with quality less than 20, and null alleles (* in col 4)

grep -v "#" ${input_array} | grep -v "LowQual" | awk '$6 >= 20 || $6 ~ /^\./' | awk '$5 !~ /*/' >> ${input_array}.filtered.vcf

# do additional filter of the initially filtered vcfs with vcftools

vcftools --vcf ${input_array}.filtered.vcf --max-missing 0.6 --keep dataset17.keep.txt --minDP 6 --max-meanDP 50 --max-alleles 2 --remove-indels --recode --recode-INFO-all --out ${input_array}.dataset17.diff.div.filtered.vcf
