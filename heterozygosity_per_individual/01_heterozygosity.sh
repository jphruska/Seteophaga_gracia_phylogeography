#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset4_heterozygosity
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

module load intel R 

Rscript calc_heterozygosity.R
