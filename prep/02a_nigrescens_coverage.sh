#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=nigrescens_coverage
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

module load intel samtools

samtools depth -a  > setophaga_nigrescens_coverage.txt
