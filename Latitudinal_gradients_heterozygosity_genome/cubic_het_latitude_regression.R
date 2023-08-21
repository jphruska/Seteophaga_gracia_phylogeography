#### Iterative cubic regression of heterozygosity and latitude for each window 
### Extract R2 squared values (to evaluate fit to cubic) and multiply it times the first coefficient (which indicates direction of cubic function)


# library(parallel)
# library(foreach)
library(dplyr)

# specifications for running in parallel

# cores <- detectCores()
# cl <- makeCluster(3, type = "FORK")
# doParallel::registerDoParallel(cl = cl)
# foreach::getDoParRegistered()
# foreach::getDoParWorkers()
# print(cl)

## read in heterozygosity estimates

het <- read.table("het_setophaga.txt", sep= "\t", header = T)

## read in latitudes 

latitude <- as.data.frame(read.csv("setophaga_het.csv", sep = ","))

# remove individuals not included in per-individual heterozygosity analysis (Belizean samples)

latitude1 <- latitude[-1:-2,]

windows <- list()

model_vector <- list()

coefficient_vector <- c()

cubic_r2_squared <- c()

Latitude <- rep(x =latitude1$Latitude, 20234)

het_latitude <- cbind(het, Latitude)

# convert to tibble

het_latitude <- as_tibble(het_latitude)

# obtain data frame of unique windows
unique_windows <- unique(het_latitude[,c(4:6)])

# iterate through windows and regress latitude and per-individual heterozygosity (cubic regression)
  for (a  in 1:20234) {
  # subset out window to average over 
  windows[[a]] <- merge(het_latitude, unique_windows[a,])
  # does cubic fit, store in list 
  model_vector[[a]] <- lm(windows[[a]]$calculated_stat ~ poly(windows[[a]]$Latitude, 3, raw = TRUE))
  # subset second coefficient and store in vector 
  coefficient_vector[a] <- as.numeric(model_vector[[a]]$coefficients[[2]])
  # subset rsquared and store in vector
  cubic_r2_squared[a] <-as.numeric(summary(model_vector[[a]])$r.squared)
  # print location
  print(paste("Done with",a))
}

cubic_first_coefficient_r2 <- cbind(unique_windows, coefficient_vector)

cubic_first_coefficient_r2.1 <- cbind(cubic_first_coefficient_r2, cubic_r2_squared)

max(cubic_first_coefficient_r2.1$cubic_r2_squared)

max(cubic_first_coefficient_r2.1$coefficient_vector)

write.table(cubic_first_coefficient_r2.1, file = "cubic_first_coefficient_r2_het_lat.txt", sep = "\t")

#stop cluster
# stopCluster(cl)


## if else loop that will assign first coefficient to either -1 or 1 (based on whether it is negative or positive), and then multiply the 
## assigned value by r2 squared. 

# read in table with first coefficient and r2 values 

cubic_first_coefficient_r2_squared <- read.table("cubic_first_coefficient_r2_het_lat.txt", sep = "\t")

# make empty vector for assigned values (positive or negative 1, based on whether the first coefficient is positive or negative)

assigned_coefficient_values <- c()

for (i in 1:nrow(cubic_first_coefficient_r2_squared)){
    if (cubic_first_coefficient_r2_squared$coefficient_vector[i] > 0){
       assigned_coefficient_values[i] = 1
    } else {
      assigned_coefficient_values[i] = -1
    }
}

# multiply assigned coefficient values to r2 squared 


# make empty vector to store multiplication of assigned coefficient values and r2 squared 

r_squared_multiplied <- c()


for (a in 1:nrow(cubic_first_coefficient_r2_squared)) {
  r_squared_multiplied[a] <- (assigned_coefficient_values[a]*cubic_first_coefficient_r2_squared$cubic_r2_squared[a])
}


# cbind assigned_coefficient_values and r_squared_multiplied values to cubic_first_coefficient_r2_squared

cubic_first_coefficient_r2_squared.2 <- cbind(cubic_first_coefficient_r2_squared,assigned_coefficient_values,r_squared_multiplied )
    
# export updated table

write.table(cubic_first_coefficient_r2_squared.2, file = "cubic_first_coefficient_r2_squared_assigned_coefficient_values_r_squared_multiplied.txt", sep ="\t")
