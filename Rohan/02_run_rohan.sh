#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_rohan_45_individuals
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks 8
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-45

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/jmanthey/anaconda2/envs/rohan/lib/

/lustre/work/jmanthey/rohan/src/rohan --tstv 1.971 --size 50000 --auto chromosomes.txt -t 8 -o ${SGE_TASK_ID} \
/home/jmanthey/denovo_genomes/camp_sp_genome_filtered.fasta \
/lustre/scratch/johruska/setophaga/01_bam_files/${SGE_TASK_ID}_final.bam
