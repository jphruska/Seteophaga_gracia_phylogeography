#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset1a_plink_PCA
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=4

source activate plink

vcf=./setophaga_1a_admix.vcf

plink --vcf $vcf --allow-extra-chr --double-id --pca 47 --out plink_out_dataset1a
