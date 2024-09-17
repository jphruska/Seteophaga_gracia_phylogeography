#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset6_tstv
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G



vcftools --vcf setophaga_6.vcf --TsTv 10000
