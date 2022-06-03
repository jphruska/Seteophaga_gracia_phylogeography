#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_mappability_gen_mask
#SBATCH --nodes=6 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

perl /lustre/work/johruska/seqbility-20091110/gen_raw_mask.pl setophaga_split.35.sam > setophaga_rawMask.35.fa 

