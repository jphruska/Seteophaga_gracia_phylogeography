#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=Setophaga_graciae_UWBM_106760_NM_bamcaller
#SBATCH --nodes=1 --ntasks=8
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-29

module load intel samtools bcftools

input=$(head -n${SLURM_ARRAY_TASK_ID} msmc_chromosomes.txt  | tail -n1 )

depth=$(samtools depth -r ${input} /lustre/scratch/johruska/setophaga/01_bam_files/Setophaga_graciae_UWBM_106760_NM_final.bam | awk '{sum += $3} END {print sum / NR}')

samtools mpileup -q 20 -Q 20 -C 50 -u -r ${input} -f /lustre/scratch/johruska/central_america_pine_oak/setophaga_ref/GCA_001746935.2_mywa_2.1_genomic.fna /lustre/scratch/johruska/setophaga/01_bam_files/Setophaga_graciae_UWBM_106760_NM_final.bam | bcftools call -c -V indels | bcftools view -i 'INFO/DP>9' | /lustre/work/johruska/msmc-tools/bamCaller.py ${depth} ./Setophaga_graciae_UWBM_106760_NM/beds/${input}_mask.bed.gz | gzip -c > ./Setophaga_graciae_UWBM_106760_NM/vcfs/${input}.vcf.gz
