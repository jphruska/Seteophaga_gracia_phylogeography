#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=bam
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=2
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G


# define main working directory
workdir=/lustre/scratch/johruska/setophaga

# get mapping stats for each final bam file
for i in $( ls *final.bam ); do 
samtools flagstat ${workdir}/01_bam_files/${i} > ${workdir}/01_bam_files/${i%_final.bam}_flagstat.txt
done
