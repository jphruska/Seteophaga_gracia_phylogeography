#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=step1
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --partition=quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-1782

module load singularity

chr_array=$( head -n${SLURM_ARRAY_TASK_ID} helper1.txt | tail -n1 )

ind_array=$( head -n${SLURM_ARRAY_TASK_ID} helper2.txt | tail -n1 )

name_array=$( head -n${SLURM_ARRAY_TASK_ID} helper1b.txt | tail -n1 )

export SINGULARITY_CACHEDIR="/lustre/work/johruska/singularity-cachedir"

singularity exec $SINGULARITY_CACHEDIR/gatk_4.2.3.0.sif gatk --java-options "-Xmx58g" HaplotypeCaller -R /lustre/scratch/johruska/central_america_pine_oak/parulidae_ref/GCA_001746935.2_mywa_2.1_genomic.fna -I /lustre/scratch/johruska/setophaga/01_bam_files/${ind_array}_final.bam -ERC GVCF -O /lustre/scratch/johruska/setophaga/02_vcf/${name_array}._${ind_array}_.g.vcf --QUIET --intervals ${chr_array}
