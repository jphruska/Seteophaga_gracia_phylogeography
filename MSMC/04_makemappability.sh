#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_mappability_makemappability
#SBATCH --nodes=6 --ntasks=12
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G


python /lustre/work/johruska/msmc-tools/makeMappabilityMask.py 
