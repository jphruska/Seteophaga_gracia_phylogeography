#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset2a_plink_PCA
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=4

source activate plink

vcf=./setophaga_2a_admix.vcf

plink --vcf $vcf --allow-extra-chr --double-id --pca 45 --out plink_out_dataset2a

