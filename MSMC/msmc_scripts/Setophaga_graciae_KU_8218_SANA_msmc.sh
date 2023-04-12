#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Setophaga_graciae_KU_8218_SANA_msmc
#SBATCH --nodes=1 --ntasks=8
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=10G

/lustre/work/johruska/msmc_2.0.0_linux64bit -o ./Setophaga_graciae_KU_8218_SANA/msmc_output -t 8 -i 20  -p 1*2+20*1+1*2+1*3 ./Setophaga_graciae_KU_8218_SANA/multihetsep/*.txt -m 0.002410367 -I 0,1
