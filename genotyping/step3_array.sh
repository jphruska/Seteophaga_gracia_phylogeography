#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=step3
#SBATCH --nodes=1
#SBATCH --ntasks=12
#SBATCH --partition=quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-119

module load singularity

chr_array=$( head -n${SLURM_ARRAY_TASK_ID} helper4.txt | tail -n1 )

interval_array=$( head -n${SLURM_ARRAY_TASK_ID} helper5.txt | tail -n1 )

name_array=$( head -n${SLURM_ARRAY_TASK_ID} helper6.txt | tail -n1 )

export SINGULARITY_CACHEDIR="/lustre/work/johruska/singularity-cachedir"

singularity exec $SINGULARITY_CACHEDIR/gatk_4.2.3.0.sif gatk --java-options "-Xmx87g" GenotypeGVCFs --genomicsdb-shared-posixfs-optimizations -R /lustre/scratch/johruska/central_america_pine_oak/parulidae_ref/GCA_001746935.2_mywa_2.1_genomic.fna -V gendb:///lustre/scratch/johruska/setophaga/02_vcf/${chr_array} --include-non-variant-sites -O /lustre/scratch/johruska/setophaga/03_vcf/${name_array}.g.vcf -L ${interval_array}
