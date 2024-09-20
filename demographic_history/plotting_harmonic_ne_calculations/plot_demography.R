library(ggplot2)

# list all setophaga output directories
x_files <- list.files(pattern="Setophaga_*")

# paste msmc_output directory name to x_files
for(i in 1:44) {
  x_files[i] <- paste(x_files[i], "/msmc_output", sep = "")
}
 
  
# define parameters
mu <- 3.44e-9
gen <- 2
min_age <- 20000
max_age <- 2500000
plotting_age_range <- 1000 # years for x axis

# loop through each output directory
output <- list()
output_bootstraps <- list()
for(a in 1:length(x_files)) {
  # identify bootstrap directories
  a_files <- list.files(x_files[a], pattern="bootstrap*", full.names=T)
  # identify main output file
  a_main <- list.files(x_files[a], pattern="*final.txt", full.names=T)
  # get names of all bootstrap replicates
  a_list <- c()
  a_bootstraps <- list.files(a_files, pattern="*final.txt", full.names=T)
  
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
  
  # output for each bootstrap
  output_bootstraps[[a]] <- list()
  for(b in 1:length(a_bootstraps)) {
    b_rep <- read.table(a_bootstraps[b], sep="\t", header=T)
    # rearrange main file for plotting lines
    for(d in 1:nrow(b_rep)) {
      if(d == 1) {
        b_rep2 <- rbind(c(b_rep[d,2], b_rep[d,4]), c(b_rep[d,3], b_rep[d,4]))
      } else {
        b_rep2 <- rbind(b_rep2, c(b_rep[d,2], b_rep[d,4]), c(b_rep[d,3], b_rep[d,4]))
      }
    }
    b_rep <- b_rep2
    # scale by mutation rate
    b_rep[,1] <- b_rep[,1] / mu * gen
    b_rep[,2] <- (1 / b_rep[,2]) / (2 * mu)
    # remove very young and old time frames prone to error
    b_rep <- b_rep[b_rep[,1] >= min_age & b_rep[,1] <= max_age,]
    # scale by plotting age range and pop size range
    b_rep <- b_rep / plotting_age_range
    # add to output list
    output_bootstraps[[a]][[b]] <- b_rep		
  }
}

# set plot items
a_col <- "lightsteelblue1"
par(mfrow=c(9,5))
par(mar=c(1,1,2,0.2))
for(a in 1:length(output)) {
  plot_name1 <- paste("S_", sapply(strsplit(x_files[a], "_"), "[[", 2), sep = "")
  plot_name2 <- sapply(strsplit(x_files[a], "_"), "[[", 3)
  plot_name3 <- sapply(strsplit(x_files[a], "_"), "[[", 4)
  plot_name4 <- paste(plot_name2, "_", plot_name3, sep = "")
  plot(c(-1,1), xlim=c(10, 2500), ylim=c(0,2500), pch=19, cex=0.01, log="x", xlab="", ylab="", main="", xaxt="n", yaxt="n")
  title(main=bquote(italic(.(plot_name1)) ~ .(plot_name4)), adj=0,line=0.5)
  if(a == 1 | a == 6 | a == 11) {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  } else {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  }
  if(a == 11 | a == 12 | a == 13 | a == 14 | a == 15) {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)		
  } else {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
  }
  
  # plot bootstraps
  for(b in 1:length(output_bootstraps[[a]])) {
    lines(output_bootstraps[[a]][[b]][,1], output_bootstraps[[a]][[b]][,2], col=a_col, lwd=0.2)
  }
  lines(output[[a]][,1], output[[a]][,2], col=a_col, lwd=3)
}


## Make a plot of all individuals (using main msmc output, and color the different populations by locality or population)

# set plot items 

# par(mfrow=c(1,1))
plot(c(-1,1), xlim=c(20, 2500), ylim=c(0,1000), pch=19, cex=0.01, log="x", xlab= expression(YBP ~(10^3)), ylab= expression(N[e] ~ (10^3)), main="", xaxt="n", yaxt="n")
axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
axis(side=1, at=c(20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
#par(bg="gray")

# insert gray block to denote LGP (11.9 - 115.0 KYA)
y <- c(0,0,1000,1000)
x <- c(20,115,115,20)
polygon(x,y,col = "gray")


# Plot Northern Population
# Subset northern individuals (1,6,7,8,9,10,11,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,36,37,38,44) from output list 
northern_list <- c(1,6:11,17:33,36:38,44)
output_northern <- output[northern_list]

for(a in 1:28) {
  # plot effective_pop_size
  for(b in 1:length(output[[a]])) {
  }
  lines(output[[northern_list[a]]][,1], output[[northern_list[a]]][,2], col="lightsteelblue1", lwd=3)
}

# Plot Guerrero Population
# Subset guerrero individuals (12,13,14,34) from output list 

guerrero_list <- c(12:14,34)
output_guerrero <- output[guerrero_list]

for(a in 1:4) {
  # plot effective_pop_size
  for(b in 1:length(output_guerrero[[a]])) {
  }
  lines(output_guerrero[[a]][,1], output_guerrero[[a]][,2], col="yellow2", lwd=3)
}

# Plot Central Population
# Subset southern individuals (3,4,39,40,41,42,43,44) from output list 
central_list <- c(4:5,39:44)
output_central <- output[central_list]

for(a in 1:6) {
  # plot effective_pop_size
  for(b in 1:length(output[[a]])) {
  }
  lines(output_central[[a]][,1], output_central[[a]][,2], col="gray16", lwd=3)
}

# Plot Chiapas Population
# Subset Chiapas individuals (15,16) from output list 
chiapas_list <- c(15:16)
output_chiapas <- output[chiapas_list]

for(a in 1:2) {
  # plot effective_pop_size
  for(b in 1:length(output[[a]])) {
  }
  lines(output_chiapas[[a]][,1], output_chiapas[[a]][,2], col="lightslateblue", lwd=3)
}

# Plot Nicaragua Population
# Subset nicaragua individuals (2,3,35) from output list 
nicaragua_list <- c(2:3,35)
output_nicaragua <- output[nicaragua_list]

for(a in 1:3) {
  # plot effective_pop_size
  for(b in 1:length(output[[a]])) {
  }
  lines(output_nicaragua[[a]][,1], output_nicaragua[[a]][,2], col="azure3", lwd=3)
}



## Make a plot of all individuals (using main msmc output, and color the different populations by locality or population). 

## Here all individual plots will be joined in one, with color denoting population. Also, they will be grouped by population 
## and locality. 

# set plot items

par(mfrow=c(9,5))
par(mar=c(1,1,2,0.2))
# par(bg ="gray71")

# Plot Nicaragua Population
# Subset nicaragua individuals (2,3,35) from output list 
nicaragua_list <- c(2:3,35)
output_nicaragua <- output[nicaragua_list]
output_nicaragua_bootstraps <- output_bootstraps[nicaragua_list]
nicaragua_names <- x_files[nicaragua_list]


for(a in 1:length(output_nicaragua)) {
  plot_name1 <- paste("S_", sapply(strsplit(nicaragua_names[a], "_"), "[[", 2), sep = "")
  plot_name2 <- sapply(strsplit(nicaragua_names[a], "_"), "[[", 3)
  plot_name3 <- sapply(strsplit(nicaragua_names[a], "_"), "[[", 4)
  plot_name4 <- paste(plot_name2, "_", plot_name3, sep = "")
  plot(c(-1,1), xlim=c(20, 2500), ylim=c(0,1000), pch=19, cex=0.01, log="x", xlab="", ylab="", main="", xaxt="n", yaxt="n")
  title(main=bquote(italic(.(plot_name1)) ~ .(plot_name4)), adj=0,line=0.5)
  if(a == 1 | a == 6 | a == 11) {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  } else {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  }
  if(a == 11 | a == 12 | a == 13 | a == 14 | a == 15) {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)		
  } else {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
  }
  
  # plot bootstraps
  for(b in 1:length(output_nicaragua_bootstraps[[a]])) {
    lines(output_nicaragua_bootstraps[[a]][[b]][,1], output_nicaragua_bootstraps[[a]][[b]][,2], col="azure1", lwd=0.2)
  }
  lines(output_nicaragua[[a]][,1], output_nicaragua[[a]][,2], col="azure3", lwd=3)
}

# Plot Central Population
# Subset Central individuals (4,5,39,40,41,42,43) from output list 
southern_list <- c(4:5,39:43)
output_southern <- output[southern_list]
output_southern_bootstraps <- output_bootstraps[southern_list]
southern_names <- x_files[southern_list]


for(a in 1:length(output_southern)) {
  plot_name1 <- paste("S_", sapply(strsplit(southern_names[a], "_"), "[[", 2), sep = "")
  plot_name2 <- sapply(strsplit(southern_names[a], "_"), "[[", 3)
  plot_name3 <- sapply(strsplit(southern_names[a], "_"), "[[", 4)
  plot_name4 <- paste(plot_name2, "_", plot_name3, sep = "")
  plot(c(-1,1), xlim=c(10, 2500), ylim=c(0,1000), pch=19, cex=0.01, log="x", xlab="", ylab="", main="", xaxt="n", yaxt="n")
  title(main=bquote(italic(.(plot_name1)) ~ .(plot_name4)), adj=0,line=0.5)
  if(a == 1 | a == 6 | a == 11) {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  } else {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  }
  if(a == 11 | a == 12 | a == 13 | a == 14 | a == 15) {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)		
  } else {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
  }
  
  # plot bootstraps
  for(b in 1:length(output_southern_bootstraps[[a]])) {
    lines(output_southern_bootstraps[[a]][[b]][,1], output_southern_bootstraps[[a]][[b]][,2], col="gray16", lwd=0.2)
  }
  lines(output_southern[[a]][,1], output_southern[[a]][,2], col="gray16", lwd=3)
}

# Plot Chiapas Population
# Subset nicaragua individuals (15,16) from output list 
chiapas_list <- c(15:16)
output_chiapas <- output[chiapas_list]
output_chiapas_bootstraps <- output_bootstraps[chiapas_list]
chiapas_names <- x_files[chiapas_list]


for(a in 1:length(output_chiapas)) {
  plot_name1 <- paste("S_", sapply(strsplit(chiapas_names[a], "_"), "[[", 2), sep = "")
  plot_name2 <- sapply(strsplit(chiapas_names[a], "_"), "[[", 3)
  plot_name3 <- sapply(strsplit(chiapas_names[a], "_"), "[[", 4)
  plot_name4 <- paste(plot_name2, "_", plot_name3, sep = "")
  plot(c(-1,1), xlim=c(20, 2500), ylim=c(0,1000), pch=19, cex=0.01, log="x", xlab="", ylab="", main="", xaxt="n", yaxt="n")
  title(main=bquote(italic(.(plot_name1)) ~ .(plot_name4)), adj=0,line=0.5)
  if(a == 1 | a == 6 | a == 11) {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  } else {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  }
  if(a == 11 | a == 12 | a == 13 | a == 14 | a == 15) {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)		
  } else {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
  }
  
  # plot bootstraps
  for(b in 1:length(output_chiapas_bootstraps[[a]])) {
    lines(output_chiapas_bootstraps[[a]][[b]][,1], output_chiapas_bootstraps[[a]][[b]][,2], col="lightslateblue", lwd=0.2)
  }
  lines(output_chiapas[[a]][,1], output_chiapas[[a]][,2], col="lightslateblue", lwd=3)
}

# Plot Guerrero Population
# Subset guerrero individuals (12,13,14,34) from output list 

guerrero_list <- c(12:14, 34)
output_guerrero <- output[guerrero_list]
output_guerrero_bootstraps <- output_guerrero[guerrero_list]
guerrero_names <- x_files[guerrero_list]

for(a in 1:length(output_guerrero)) {
  plot_name1 <- paste("S_", sapply(strsplit(guerrero_names[a], "_"), "[[", 2), sep = "")
  plot_name2 <- sapply(strsplit(guerrero_names[a], "_"), "[[", 3)
  plot_name3 <- sapply(strsplit(guerrero_names[a], "_"), "[[", 4)
  plot_name4 <- paste(plot_name2, "_", plot_name3, sep = "")
  plot(c(-1,1), xlim=c(10, 2500), ylim=c(0,1000), pch=19, cex=0.01, log="x", xlab="", ylab="", main="", xaxt="n", yaxt="n")
  title(main=bquote(italic(.(plot_name1)) ~ .(plot_name4)), adj=0,line=0.5)
  if(a == 1 | a == 6 | a == 11) {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  } else {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  }
  if(a == 11 | a == 12 | a == 13 | a == 14 | a == 15) {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)		
  } else {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
  }
  
  # plot bootstraps
  for(b in 1:length(output_guerrero_bootstraps[[a]])) {
    lines(output_guerrero_bootstraps[[a]][[b]][,1], output_guerrero_bootstraps[[a]][[b]][,2], col="yellow2", lwd=0.2)
  }
  lines(output_guerrero[[a]][,1], output_guerrero[[a]][,2], col="yellow2", lwd=3)
}



# Plot Northern Population
# Subset northern individuals (1,6,7,8,9,10,11,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,36,37,38,44) from output list 
northern_list <- c(17:31, 6, 36:38, 44, 7:8, 10:11, 9, 32:33, 1)
output_northern <- output[northern_list]
output_northern_bootstraps <- output_bootstraps[northern_list]
northern_names <- x_files[northern_list]


for(a in 1:length(output_northern)) {
  plot_name1 <- paste("S_", sapply(strsplit(northern_names[a], "_"), "[[", 2), sep = "")
  plot_name2 <- sapply(strsplit(northern_names[a], "_"), "[[", 3)
  plot_name3 <- sapply(strsplit(northern_names[a], "_"), "[[", 4)
  plot_name4 <- paste(plot_name2, "_", plot_name3, sep = "")
  plot(c(-1,1), xlim=c(10, 2500), ylim=c(0,1000), pch=19, cex=0.01, log="x", xlab="", ylab="", main="", xaxt="n", yaxt="n")
  title(main=bquote(italic(.(plot_name1)) ~ .(plot_name4)), adj=0,line=0.5)
  if(a == 1 | a == 6 | a == 11) {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  } else {
    axis(side=2, at=c(0, 500, 1000, 1500, 2000, 2500, 3000, 5000, 8000, 11000), labels=TRUE)
  }
  if(a == 11 | a == 12 | a == 13 | a == 14 | a == 15) {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)		
  } else {
    axis(side=1, at=c(10, 20, 50, 100, 200, 500, 1000, 2000, 2500), labels=T)
  }
  
  # plot bootstraps
  for(b in 1:length(output_northern_bootstraps[[a]])) {
    lines(output_northern_bootstraps[[a]][[b]][,1], output_northern_bootstraps[[a]][[b]][,2], col="lightsteelblue1", lwd=0.2)
  }
  lines(output_northern[[a]][,1], output_northern[[a]][,2], col="lightsteelblue1", lwd=3)
}

ggsave(filename = "msmc_5_pop_individuals", device = "pdf", )
