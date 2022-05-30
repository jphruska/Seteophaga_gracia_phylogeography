#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset1b_plink_filtering
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=4

conda activate plink

vcf=./setophaga_1_admix.vcf

plink --vcf $vcf --allow-extra-chr --double-id --pca 47 --out plink_out_dataset1
