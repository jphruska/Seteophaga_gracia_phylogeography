#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=mapdamage_KU33633
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

source activate mapdamage

/lustre/work/johruska/miniconda2/envs/mapdamage/bin/mapDamage -i Setophaga_graciae_KU_33633_RACN_final.bam -r /lustre/scratch/johruska/central_america_pine_oak/parulidae_ref/GCA_001746935.2_mywa_2.1_genomic.fna --rescale
