#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_mappability_gen_mask_2
#SBATCH --nodes=6 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

gen_mask -l 35 -r 0.5 setophaga_rawMask.35.fa > setophaga_mask.35.50.fa 

