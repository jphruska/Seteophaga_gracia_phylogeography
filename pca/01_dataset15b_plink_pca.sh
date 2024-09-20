#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset15b_plink_PCA
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=4

source activate plink

vcf=./setophaga_dataset15b.vcf 

plink --vcf $vcf --allow-extra-chr --double-id --pca 45 --out plink_out_dataset15b 

