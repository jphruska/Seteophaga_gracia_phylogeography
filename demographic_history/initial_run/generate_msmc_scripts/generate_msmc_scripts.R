### Script to make shell scripts to be run on SLURM HPCC. Objective is to carry out MSMC2 runs per individual, 
### and this script will generate scripts that run MSMC2 (with the multihetsep files as input).  


# Input required to run script includes a file of with individual names and a file with mutation scaled rates. Make sure order of these two 
# files is exactly the same, otherwise the mutation scaled rates will not correspond to the right individuals. 

individual <- read.table("msmc_per_individual_list.txt")

mutation_scaled_rate <-read.table("msmc_per_individual_scaled_mutation_rate.txt")

cluster <- "quanah"

# Run for loop to make multihetsep scripts per individual
a.script <- c()
for (i in 1:nrow(individual)) {
  
  a.script[i] <- paste(individual[i,], "_msmc.sh", sep="")
  write("#!/bin/sh", file=a.script[i])
  write("#SBATCH --chdir=./", file=a.script[i], append=T)
  write(paste("#SBATCH --job-name=", individual[i,], "_msmc", sep=""), file=a.script[i], append=T)
  write("#SBATCH --nodes=1 --ntasks=8", file=a.script[i], append=T)
  write(paste("#SBATCH --partition ", cluster, sep=""), file=a.script[i], append=T)
  write("#SBATCH --time=48:00:00", file=a.script[i], append=T)
  write("#SBATCH --mem-per-cpu=10G", file=a.script[i], append=T)
  write("", file=a.script[i], append=T)

  write(paste("/lustre/work/johruska/msmc_2.0.0_linux64bit -o ./", individual[i,], "/msmc_output -t 8 -i 20  -p 1*2+20*1+1*2+1*3 ./", individual[i,], "/multihetsep/*.txt -m ", mutation_scaled_rate[i,], " -I 0,1", sep = ""), file=a.script[i], append=T)
  
  
}            