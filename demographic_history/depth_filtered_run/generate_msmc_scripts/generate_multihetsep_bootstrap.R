### Script to make shell scripts to be run on SLURM HPCC. Objective is to carry out MSMC2 runs per individual, 
### and this script will generate the hetsep bootstrap text files MSMC2 uses as input.  


# Input required to run this script includes a file of with individual names. 

individual <- read.table("msmc_per_individual_list.txt")

cluster <- "quanah"


# Run for loop to make multihetsep bootstrap scripts per individual
a.script <- c()
for (i in 1:nrow(individual)) {
  
  a.script[i] <- paste(individual[i,], "_multihetsep_bootstrap.sh", sep="")
  write("#!/bin/sh", file=a.script[i])
  write("#SBATCH --chdir=./", file=a.script[i], append=T)
  write(paste("#SBATCH --job-name=", individual[i,], "_multihetsep_bootstrap", sep=""), file=a.script[i], append=T)
  write("#SBATCH --nodes=1 --ntasks=8", file=a.script[i], append=T)
  write(paste("#SBATCH --partition ", cluster, sep=""), file=a.script[i], append=T)
  write("#SBATCH --time=48:00:00", file=a.script[i], append=T)
  write("#SBATCH --mem-per-cpu=10G", file=a.script[i], append=T)
  write("", file=a.script[i], append=T)
  write(paste("/lustre/work/johruska/msmc-tools/multihetsep_bootstrap.py -n 20 -s 1000000 --chunks_per_chromosome 30 --nr_chromosomes 29 --seed 324324 ./", individual[i,], "/multihetsep/bootstraps/bootstrap ./", individual[i,], "/multihetsep/*.txt", sep = ""), file=a.script[i], append=T)
  
  
}