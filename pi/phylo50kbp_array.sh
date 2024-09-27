#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=phylo
#SBATCH --nodes=1 --ntasks=2
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G
#SBATCH --array=1-988

module load intel R

# Set the number of runs that each SLURM task should do
PER_TASK=19

# Calculate the starting and ending values for this task based
# on the SLURM task and the number of runs per task.
START_NUM=$(( ($SLURM_ARRAY_TASK_ID - 1) * $PER_TASK + 1 ))
END_NUM=$(( $SLURM_ARRAY_TASK_ID * $PER_TASK ))

# Print the task and run range
echo This is task $SLURM_ARRAY_TASK_ID, which will do runs $START_NUM to $END_NUM

# Run the loop of runs for this task.
for (( run=$START_NUM; run<=$END_NUM; run++ )); do
	echo This is SLURM task $SLURM_ARRAY_TASK_ID, run number $run

	chrom_array=$( head -n${run} tree_helper_chrom.txt | tail -n1 )

	start_array=$( head -n${run} tree_helper_start.txt | tail -n1 )

	end_array=$( head -n${run} tree_helper_end.txt | tail -n1 )

	gunzip -cd /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/CM027507.1.g.vcf.dataset17.diff.div.filtered.vcf.recode.vcf.gz | grep "#" > /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

	tabix /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/${chrom_array}.recode.vcf.gz ${chrom_array}:${start_array}-${end_array} >> /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf

	bcftools query -f '%POS\t%REF\t%ALT[\t%GT]\n' /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf > /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf

	Rscript calculate_windows.r /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf popmap_phylo.txt

	rm /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.recode.vcf
	rm /lustre/scratch/johruska/setophaga/03_vcf/combined_vcfs/dataset17_div_diff/windows/${chrom_array}__${start_array}__${end_array}.simple.vcf

done
