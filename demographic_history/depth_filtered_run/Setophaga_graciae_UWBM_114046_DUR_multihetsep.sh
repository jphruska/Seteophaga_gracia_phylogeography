#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Setophaga_graciae_UWBM_114046_DUR_multihetsep
#SBATCH --nodes=1 --ntasks=8
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --array=1-29

input=$(head -n${SLURM_ARRAY_TASK_ID} msmc_chromosomes.txt  | tail -n1 )

/lustre/work/johruska/msmc-tools/generate_multihetsep.py --mask=/lustre/scratch/johruska/central_america_pine_oak/setophaga_ref/masks/setophaga_${input}.mask.35.50.bed.gz --mask=./Setophaga_graciae_UWBM_114046_DUR/beds/${input}_mask.bed.gz Setophaga_graciae_UWBM_114046_DUR/vcfs/${input}.vcf.gz > ./Setophaga_graciae_UWBM_114046_DUR/multihetsep/${input}.txt
