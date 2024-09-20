### Script to make shell scripts to be run on SLURM HPCC. Objective is to carry out MSMC2 runs per individual, 
### and this script will generate the hetsep text files MSMC2 uses as input.  


# Input required to run script includes a file of with individual names
# along with a list of the chromosomes. 


individual <- read.table("msmc_per_individual_list.txt")

chromosomes <- read.table("msmc_chromosomes.txt")

cluster <- "quanah"

reference_mask <- "/lustre/scratch/johruska/central_america_pine_oak/parulidae_ref/masks/"

# Run for loop to make multihetsep scripts per individual
a.script <- c()
for (i in 1:nrow(individual)) {
  
  a.script[i] <- paste(individual[i,], "_multihetsep.sh", sep="")
  write("#!/bin/sh", file=a.script[i])
  write("#SBATCH --chdir=./", file=a.script[i], append=T)
  write(paste("#SBATCH --job-name=", individual[i,], "_multihetsep", sep=""), file=a.script[i], append=T)
  write("#SBATCH --nodes=1 --ntasks=8", file=a.script[i], append=T)
  write(paste("#SBATCH --partition ", cluster, sep=""), file=a.script[i], append=T)
  write("#SBATCH --time=48:00:00", file=a.script[i], append=T)
  write("#SBATCH --mem-per-cpu=10G", file=a.script[i], append=T)
  write(paste("#SBATCH --array=1-", nrow(chromosomes), sep=""), file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  write("input=$(head -n${SLURM_ARRAY_TASK_ID} msmc_chromosomes.txt  | tail -n1 )", file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  
  write(paste("/lustre/work/johruska/msmc-tools/generate_multihetsep.py --mask=", reference_mask, "setophaga_${input}.mask.35.50.bed.gz --mask=./", individual[i,], "/beds/${input}_mask.bed.gz ",individual[i,], "/vcfs/${input}.vcf.gz > ./", individual[i,], "/multihetsep/${input}.txt", sep = ""), file=a.script[i], append=T)

  
}            