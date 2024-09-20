### Script to make shell scripts to be run on SLURM HPCC. Objective is to carry out MSMC2 runs per individual, 
### and this script will generate the VCF files to be used as input, along with the bed files that mask low coverage 
### regions. 


# Input required to run script includes a file of with individual names, and that correspond to the BAM files, 
# along with a list of the chromosomes that will be used for the analysis. 


individual <- read.table("msmc_per_individual_list.txt")

chromosomes <- read.table("msmc_chromosomes.txt")

directory_name <- "bamcaller_scripts"

cluster <- "quanah"

reference_genome <- "/lustre/scratch/johruska/central_america_pine_oak/setophaga_ref/GCA_001746935.2_mywa_2.1_genomic.fna"

bams <- "/lustre/scratch/johruska/setophaga/01_bam_files/"

dir.create(directory_name)

# Run for loop to make bamcaller scripts per individual
a.script <- c()
for (i in 1:nrow(individual)) {
  
  a.script[i] <- paste(individual[i,], "_bamcaller.sh", sep="")
  write("#!/bin/sh", file=a.script[i])
  write("#SBATCH --chdir=./", file=a.script[i], append=T)
  write(paste("#SBATCH --job-name=", individual[i,], "_bamcaller", sep=""), file=a.script[i], append=T)
  write("#SBATCH --nodes=1 --ntasks=8", file=a.script[i], append=T)
  write(paste("#SBATCH --partition ", cluster, sep=""), file=a.script[i], append=T)
  write("#SBATCH --time=48:00:00", file=a.script[i], append=T)
  write("#SBATCH --mem-per-cpu=8G", file=a.script[i], append=T)
  write(paste("#SBATCH --array=1-", nrow(chromosomes), sep=""), file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  write("module load intel samtools bcftools", file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  write("input=$(head -n${SLURM_ARRAY_TASK_ID} msmc_chromosomes.txt  | tail -n1 )", file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  write(paste("depth=$(samtools depth -r ${input} ", bams, individual[i,], "_final.bam | awk '{sum += $3} END {print sum / NR}')", sep = ""), file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  write(paste("samtools mpileup -q 20 -Q 20 -C 50 -u -r ${input} -f ", reference_genome," ", bams, individual[i,], "_final.bam | bcftools call -c -V indels | bcftools view -i 'INFO/DP>9' | /lustre/work/johruska/msmc-tools/bamCaller.py ${depth} ./", individual[i,], "/beds/${input}_mask.bed.gz | gzip -c > ./", individual[i,], "/vcfs/${input}.vcf.gz", sep=""), file=a.script[i], append=T)
}            