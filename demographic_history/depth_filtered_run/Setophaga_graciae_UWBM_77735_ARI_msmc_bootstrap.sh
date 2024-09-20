#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Setophaga_graciae_UWBM_77735_ARI_msmc_bootstrap
#SBATCH --nodes=1 --ntasks=8
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=10G
#SBATCH --array=1-20

/lustre/work/johruska/msmc_2.0.0_linux64bit -o ./Setophaga_graciae_UWBM_77735_ARI/msmc_output/bootstraps/bootstrap_${SLURM_ARRAY_TASK_ID} -t 8 -i 20  -p 1*2+20*1+1*2+1*3 ./Setophaga_graciae_UWBM_77735_ARI/multihetsep/bootstraps/bootstrap_${SLURM_ARRAY_TASK_ID}/*.txt -m 0.002545158 -I 0,1
