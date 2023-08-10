# list all input files in popmap
ind_list <- scan("msmc_per_individual_list.txt", what="character")



# define parameters
gen <- 2
mu <- c(3.44e-9)* gen # needs to be per generation
min_age <- 20000
max_age <- 500000
plotting_age_range <- 1000 # years for x axis


# loop through each output directory
output <- list()
for(a in 1:length(ind_list)) {
  
  # identify main output file
  a_main <- paste(ind_list[a], "_output.final.txt", sep="")
  
  
  # read in main file
  a_rep <- read.table(a_main, sep="\t", header=T)
  # rearrange main file for plotting lines
  for(d in 1:nrow(a_rep)) {
    if(d == 1) {
      a_rep2 <- rbind(c(a_rep[d,2], a_rep[d,4]), c(a_rep[d,3], a_rep[d,4]))
    } else {
      a_rep2 <- rbind(a_rep2, c(a_rep[d,2], a_rep[d,4]), c(a_rep[d,3], a_rep[d,4]))
    }
  }
  a_rep <- a_rep2
  # scale by mutation rate
  a_rep[,1] <- a_rep[,1] / mu * gen
  a_rep[,2] <- (1 / a_rep[,2]) / (2 * mu)
  # remove very young and old time frames prone to error
  a_rep <- a_rep[a_rep[,1] >= min_age & a_rep[,1] <= max_age,]
  # scale by plotting age range and pop size range
  a_rep <- a_rep / plotting_age_range
  # add to output list
  output[[a]] <- a_rep
  
  
}

# define current pop sizes 
current_pop <- c()
for(a in 1:length(output)) {
  current_pop <- c(current_pop, output[[a]][1,2])
}

# harmonic mean of pop sizes from most recent to 200k years ago
harmonic_pop <- c()
for(a in 1:length(output)) {
  out_rep <- output[[a]]
  
  # define time series
  time_series <- seq(from=as.integer(out_rep[2,1])+1, to=200, by=1)
  # time series pops
  time_pops <- c()
  for(b in 1:length(time_series)) {
    time_pops <- c(time_pops, out_rep[time_series[b] < out_rep[,1],][1,2])
  }
  # harmonic mean of this individual
  harm_rep <- length(time_pops) / sum((1 / time_pops))
  
  # add to output element
  harmonic_pop <- c(harmonic_pop, harm_rep)
}

# define output
output <- data.frame(individual=as.character(ind_list), current_pop=as.numeric(current_pop), harmonic_pop=as.numeric(harmonic_pop))

#write output
write.table(output, file="setophaga_ne_harmonic_pop_sizes.txt", sep="\t", row.names=F, quote=F)
