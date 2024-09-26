#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=div_diff_setophaga_z
#SBATCH --nodes=1 --ntasks=2
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-733

module load intel java bcftools 

module load intel R

# Set the number of runs that each SLURM task should do
PER_TASK=2

# Calculate the starting and ending values for this task based
# on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))

# Print the task and run range
echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM

# Run the loop of runs for this task.
for (( run=$START_NUM; run<=$END_NUM; run++ )); do
	echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run

	chrom_array=$( head -n${run} div_diff_helper_chrom.txt | tail -n1 )

	start_array=$( head -n${run} div_diff_helper_start.txt | tail -n1 )

	end_array=$( head -n${run} div_diff_helper_end.txt | tail -n1 )

	gunzip -cd /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/CM027507.1.g.vcf.phylo.filtered.vcf.recode.vcf.gz | grep "#" > /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/windows_setophaga_z/${chrom_array}__${start_array}__${end_array}.recode.vcf

	tabix /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/${chrom_array}.g.vcf.phylo.filtered.vcf.recode.vcf.gz ${chrom_array}:${start_array}-${end_array} >> /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/windows_setophaga_z/${chrom_array}__${start_array}__${end_array}.recode.vcf

	bcftools query -f '%POS\t%REF\t%ALT[\t%GT]\n' /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/windows_setophaga_z/${chrom_array}__${start_array}__${end_array}.recode.vcf > /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/windows_setophaga_z/${chrom_array}__${start_array}__${end_array}.simple.vcf

	Rscript calculate_windows_setophaga_z.r /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset1_div_diff/windows_setophaga_z/${chrom_array}__${start_array}__${end_array}.simple.vcf div_diff_popmap_setophaga.txt

done
