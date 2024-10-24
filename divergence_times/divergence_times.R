## This script will estimate divergence times between Setophaga populations, using pairwise Dxy values and ##
## per-population nucleotide diversity. The two equations will calculate divergence times in calendar years ##
## and coalescent units. This follows the methodology of Chase et al. 2021, and the equations therein are from ##
## Wiuf et al. 2004. ## 


# read in pi estimates 

pi <- read.table("window_pi.txt", sep="\t", stringsAsFactors = TRUE, header = TRUE)

pi <- na.omit(pi)

# subset stats per population

pi_southwest_usa <- pi[pi=="Southwest_USA",]
pi_southwest_usa <- pi_southwest_usa[pi_southwest_usa$number_variable_sites > 0,]
## filter out Z chromosome 
pi_southwest_usa <- pi_southwest_usa[!pi_southwest_usa$chr == "CM027535.1",]


pi_durango <- pi[pi=="Durango",]
pi_durango <- pi_durango[pi_durango$number_variable_sites > 0,]
## filter out Z chromosome 
pi_durango <- pi_durango[!pi_durango$chr == "CM027535.1",]


pi_chihuahua <- pi[pi=="Chihuahua",]
pi_chihuahua <- pi_chihuahua[pi_chihuahua$number_variable_sites > 0,]
## filter out Z chromosome 
pi_chihuahua <- pi_chihuahua[!pi_chihuahua$chr == "CM027535.1",]

pi_nicaragua <- pi[pi=="Nicaragua",]
pi_nicaragua <- pi_nicaragua[pi_nicaragua$number_variable_sites > 0,]
## filter out Z chromosome 
pi_nicaragua <- pi_nicaragua[!pi_nicaragua$chr == "CM027535.1",]

pi_guerrero <- pi[pi=="Guerrero",]
pi_guerrero <- pi_guerrero[pi_guerrero$number_variable_sites > 0,]
## filter out Z chromosome 
pi_guerrero <- pi_guerrero[!pi_guerrero$chr == "CM027535.1",]

pi_el_salvador_honduras <-pi[pi=="El_Salvador_Honduras",]
pi_el_salvador_honduras <- pi_el_salvador_honduras[pi_el_salvador_honduras$number_variable_sites > 0,]
## filter out Z chromosome 
pi_el_salvador_honduras <- pi_el_salvador_honduras[!pi_el_salvador_honduras$chr == "CM027535.1",]

pi_chiapas <-pi[pi=="Chiapas",]
pi_chiapas <- pi_chiapas[pi_chiapas$number_variable_sites > 0,]
## filter out Z chromosome 
pi_chiapas <- pi_chiapas[!pi_chiapas$chr == "CM027535.1",]

# read in dxy estimates 

dxy <- as.data.frame(read.table("window_dxy.txt", sep="\t", stringsAsFactors = FALSE, header = TRUE))

dxy <- na.omit(dxy)


# subset stats per population comparison

dxy_southwest_usa_chihuahua <- dxy[dxy$pop1=="Southwest_USA" & dxy$pop2=="Chihuahua",]
dxy_southwest_usa_chihuahua <- dxy_southwest_usa_chihuahua[dxy_southwest_usa_chihuahua$number_sites > 0,]
## filter out Z chromosome 
dxy_southwest_usa_chihuahua<- dxy_southwest_usa_chihuahua[!dxy_southwest_usa_chihuahua$chr == "CM027535.1",]



# subset stats per population comparison

dxy_southwest_usa_durango <- dxy[dxy$pop1=="Southwest_USA" & dxy$pop2=="Durango",]
dxy_southwest_usa_durango <- dxy_southwest_usa_durango[dxy_southwest_usa_durango$number_sites > 0,]
## filter out Z chromosome 
dxy_southwest_usa_durango<- dxy_southwest_usa_durango[!dxy_southwest_usa_durango$chr == "CM027535.1",]

# subset stats per population comparison

dxy_southwest_usa_guerrero <- dxy[dxy$pop1=="Southwest_USA" & dxy$pop2=="Guerrero",]
dxy_southwest_usa_guerrero <- dxy_southwest_usa_guerrero[dxy_southwest_usa_guerrero$number_sites > 0,]
## filter out Z chromosome 
dxy_southwest_usa_guerrero<- dxy_southwest_usa_guerrero[!dxy_southwest_usa_guerrero$chr == "CM027535.1",]

dxy_southwest_usa_chiapas <- dxy[dxy$pop1=="Southwest_USA" & dxy$pop2=="Chiapas",]
dxy_southwest_usa_chiapas <- dxy_southwest_usa_chiapas[dxy_southwest_usa_chiapas$number_sites > 0,]
## filter out Z chromosome 
dxy_southwest_usa_chiapas<- dxy_southwest_usa_chiapas[!dxy_southwest_usa_chiapas$chr == "CM027535.1",]

dxy_southwest_usa_el_salvador_honduras <- dxy[dxy$pop1=="Southwest_USA" & dxy$pop2=="El_Salvador_Honduras",]
dxy_southwest_usa_el_salvador_honduras<- dxy_southwest_usa_el_salvador_honduras[dxy_southwest_usa_el_salvador_honduras$number_sites > 0,]
## filter out Z chromosome 
dxy_southwest_usa_el_salvador_honduras<- dxy_southwest_usa_el_salvador_honduras[!dxy_southwest_usa_el_salvador_honduras$chr == "CM027535.1",]

dxy_southwest_usa_nicaragua <- dxy[dxy$pop1=="Southwest_USA" & dxy$pop2=="Nicaragua",]
dxy_southwest_usa_nicaragua <- dxy_southwest_usa_nicaragua[dxy_southwest_usa_nicaragua$number_sites > 0,]
## filter out Z chromosome 
dxy_southwest_usa_nicaragua<- dxy_southwest_usa_nicaragua[!dxy_southwest_usa_nicaragua$chr == "CM027535.1",]


# subset stats per population comparison

dxy_chihuahua_durango <- dxy[dxy$pop2=="Chihuahua" & dxy$pop1=="Durango",]
dxy_chihuahua_durango <- dxy_chihuahua_durango[dxy_chihuahua_durango$number_sites > 0,]
## filter out Z chromosome 
dxy_chihuahua_durango <- dxy_chihuahua_durango[!dxy_chihuahua_durango$chr == "CM027535.1",]



# subset stats per population comparison

dxy_chihuahua_guerrero <- dxy[dxy$pop2=="Chihuahua" & dxy$pop1=="Guerrero",]
dxy_chihuahua_guerrero <- dxy_chihuahua_guerrero[dxy_chihuahua_guerrero$number_sites > 0,]
## filter out Z chromosome 
dxy_chihuahua_guerrero <- dxy_chihuahua_guerrero[!dxy_chihuahua_guerrero$chr == "CM027535.1",]





# subset stats per population comparison

dxy_chihuahua_chiapas <- dxy[dxy$pop2=="Chihuahua" & dxy$pop1=="Chiapas",]
dxy_chihuahua_chiapas <- dxy_chihuahua_chiapas[dxy_chihuahua_chiapas$number_sites > 0,]
## filter out Z chromosome 
dxy_chihuahua_chiapas <- dxy_chihuahua_chiapas[!dxy_chihuahua_chiapas$chr == "CM027535.1",]


# subset stats per population comparison

dxy_chihuahua_el_salvador_honduras <- dxy[dxy$pop2=="Chihuahua" & dxy$pop1=="El_Salvador_Honduras",]
dxy_chihuahua_el_salvador_honduras <- dxy_chihuahua_el_salvador_honduras[dxy_chihuahua_el_salvador_honduras$number_sites > 0,]
## filter out Z chromosome 
dxy_chihuahua_el_salvador_honduras <- dxy_chihuahua_el_salvador_honduras[!dxy_chihuahua_el_salvador_honduras$chr == "CM027535.1",]



# subset stats per population comparison

dxy_chihuahua_nicaragua <- dxy[dxy$pop2=="Chihuahua" & dxy$pop1=="Nicaragua",]
dxy_chihuahua_nicaragua <- dxy_chihuahua_nicaragua[dxy_chihuahua_nicaragua$number_sites > 0,]
## filter out Z chromosome 
dxy_chihuahua_nicaragua <- dxy_chihuahua_nicaragua[!dxy_chihuahua_nicaragua$chr == "CM027535.1",]

# subset stats per population comparison

dxy_durango_guerrero <- dxy[dxy$pop2=="Durango" & dxy$pop1=="Guerrero",]
dxy_durango_guerrero <- dxy_durango_guerrero[dxy_durango_guerrero$number_sites > 0,]
## filter out Z chromosome 
dxy_durango_guerrero <- dxy_durango_guerrero[!dxy_durango_guerrero$chr == "CM027535.1",]


# subset stats per population comparison

dxy_durango_chiapas <- dxy[dxy$pop2=="Durango" & dxy$pop1=="Chiapas",]
dxy_durango_chiapas <- dxy_durango_chiapas[dxy_durango_chiapas$number_sites > 0,]
## filter out Z chromosome 
dxy_durango_chiapas <- dxy_durango_chiapas[!dxy_durango_chiapas$chr == "CM027535.1",]



# subset stats per population comparison

dxy_durango_el_salvador_honduras <- dxy[dxy$pop2=="Durango" & dxy$pop1=="El_Salvador_Honduras",]
dxy_durango_el_salvador_honduras <- dxy_durango_el_salvador_honduras[dxy_durango_el_salvador_honduras$number_sites > 0,]
## filter out Z chromosome 
dxy_durango_el_salvador_honduras <- dxy_durango_el_salvador_honduras[!dxy_durango_el_salvador_honduras$chr == "CM027535.1",]



# subset stats per population comparison

dxy_durango_nicaragua <- dxy[dxy$pop2=="Durango" & dxy$pop1=="Nicaragua",]
dxy_durango_nicaragua <- dxy_durango_nicaragua[dxy_durango_nicaragua$number_sites > 0,]
## filter out Z chromosome 
dxy_durango_nicaragua <- dxy_durango_nicaragua[!dxy_durango_nicaragua$chr == "CM027535.1",]



dxy_guerrero_chiapas <- dxy[dxy$pop1=="Guerrero" & dxy$pop2=="Chiapas",]
dxy_guerrero_chiapas <- dxy_guerrero_chiapas[dxy_guerrero_chiapas$number_sites > 0,]
## filter out Z chromosome 
dxy_guerrero_chiapas<- dxy_guerrero_chiapas[!dxy_guerrero_chiapas$chr == "CM027535.1",]

dxy_guerrero_el_salvador_honduras <- dxy[dxy$pop1=="El_Salvador_Honduras" & dxy$pop2=="Guerrero",]
dxy_guerrero_el_salvador_honduras <- dxy_guerrero_el_salvador_honduras[dxy_guerrero_el_salvador_honduras$number_sites > 0,]
## filter out Z chromosome 
dxy_guerrero_el_salvador_honduras<- dxy_guerrero_el_salvador_honduras[!dxy_guerrero_el_salvador_honduras$chr == "CM027535.1",]

dxy_guerrero_nicaragua <- dxy[dxy$pop1=="Nicaragua" & dxy$pop2=="Guerrero",]
dxy_guerrero_nicaragua <- dxy_guerrero_nicaragua[dxy_guerrero_nicaragua$number_sites > 0,]
## filter out Z chromosome 
dxy_guerrero_nicaragua <- dxy_guerrero_nicaragua[!dxy_guerrero_nicaragua$chr == "CM027535.1",]

dxy_el_salvador_honduras_chiapas <- dxy[dxy$pop1=="El_Salvador_Honduras" & dxy$pop2=="Chiapas",]
dxy_el_salvador_honduras_chiapas <- dxy_el_salvador_honduras_chiapas[dxy_el_salvador_honduras_chiapas$number_sites > 0,]
## filter out Z chromosome 
dxy_el_salvador_honduras_chiapas <- dxy_el_salvador_honduras_chiapas[!dxy_el_salvador_honduras_chiapas$chr == "CM027535.1",]

dxy_nicaragua_chiapas <- dxy[dxy$pop1=="Nicaragua" & dxy$pop2=="Chiapas",]
dxy_nicaragua_chiapas <- dxy_nicaragua_chiapas[dxy_nicaragua_chiapas$number_sites > 0,]
## filter out Z chromosome 
dxy_nicaragua_chiapas <- dxy_nicaragua_chiapas[!dxy_nicaragua_chiapas$chr == "CM027535.1",]

dxy_nicaragua_el_salvador_honduras <- dxy[dxy$pop1=="Nicaragua" & dxy$pop2=="El_Salvador_Honduras",]
dxy_nicaragua_el_salvador_honduras <- dxy_nicaragua_el_salvador_honduras[dxy_nicaragua_el_salvador_honduras$number_sites > 0,]
## filter out Z chromosome 
dxy_nicaragua_el_salvador_honduras <- dxy_nicaragua_el_salvador_honduras[!dxy_nicaragua_el_salvador_honduras$chr == "CM027535.1",]

## store all pairwise dxys in a list

pairwise.dxy <- list(dxy_southwest_usa_chihuahua$calculated_stat, dxy_southwest_usa_durango$calculated_stat, 
                     dxy_southwest_usa_guerrero$calculated_stat, dxy_southwest_usa_chiapas$calculated_stat, 
                     dxy_southwest_usa_el_salvador_honduras$calculated_stat, dxy_southwest_usa_nicaragua$calculated_stat, 
                     dxy_chihuahua_durango$calculated_stat, dxy_chihuahua_guerrero$calculated_stat, 
                     dxy_chihuahua_chiapas$calculated_stat, dxy_chihuahua_el_salvador_honduras$calculated_stat, 
                     dxy_chihuahua_nicaragua$calculated_stat, dxy_durango_guerrero$calculated_stat, 
                     dxy_durango_chiapas$calculated_stat, dxy_durango_el_salvador_honduras$calculated_stat, 
                     dxy_durango_nicaragua$calculated_stat, 
                     dxy_guerrero_chiapas$calculated_stat, dxy_guerrero_el_salvador_honduras$calculated_stat, 
                     dxy_guerrero_nicaragua$calculated_stat, dxy_el_salvador_honduras_chiapas$calculated_stat, 
                     dxy_nicaragua_chiapas$calculated_stat, dxy_nicaragua_el_salvador_honduras$calculated_stat)

## store all pairwise dxys in a list

pairwise.dxy.names <- c("dxy_southwest_usa_chihuahua", "dxy_southwest_usa_durango", "dxy_southwest_usa_guerrero", 
                                         "dxy_southwest_usa_chiapas", "dxy_southwest_usa_el_salvador_honduras", "dxy_southwest_usa_nicaragua", 
                                         "dxy_chihuahua_durango", "dxy_chihuahua_guerrero", "dxy_chihuahua_chiapas", "dxy_chihuahua_el_salvador_honduras", "dxy_chihuahua_nicaragua", 
                                         "dxy_durango_guerrero", "dxy_durango_chiapas", "dxy_durango_el_salvador_honduras", "dxy_durango_nicaragua", 
                                         "dxy_guerrero_chiapas", "dxy_guerrero_el_salvador_honduras", "dxy_guerrero_nicaragua", "dxy_el_salvador_honduras_chiapas", 
                                         "dxy_nicaragua_chiapas", "dxy_nicaragua_el_salvador_honduras")




## store all pis in a list

pairwise.pi.names <- c("pi_southwest_usa", "pi_chihuahua", "pi_durango", "pi_guerrero", "pi_chiapas",
                       "pi_el_salvador_honduras", "pi_nicaragua")
## store all pis in a list

pi_populations <- list(pi_southwest_usa$calculated_stat, pi_chihuahua$calculated_stat, pi_durango$calculated_stat, 
                       pi_guerrero$calculated_stat, pi_chiapas$calculated_stat, 
                       pi_el_salvador_honduras$calculated_stat, pi_nicaragua$calculated_stat)

tau <- function(dxy, pi_1, pi_2) {
  mean_dxy <- mean(dxy)
  mean_pi_1 <- mean(pi_1)
  mean_pi_2 <- mean(pi_2)
  # tau
  ((mean_dxy/((mean_pi_1 + mean_pi_2)/2)) - 1)
}

# mutation rate
muta <-  3.44e-9
  
  
divergence_time <- function (dxy, pi_1, pi_2, muta) {
  mean_dxy <- mean(dxy)
  mean_pi_1 <- mean(pi_1)
  mean_pi_2 <- mean(pi_2)
  # divergence time
  ((mean_dxy - ((mean_pi_1 + mean_pi_2)/2))/(2*muta))
}
  
# tau calculations 

# for loop through list of dxy comparisons (do comparisons with southwest_usa population) and calculate tau 

tau.1 <- c()

for (i in 1:6) {
    tau.1[i] <- tau(pairwise.dxy[[i]], pi_populations[[1]], pi_populations[[i + 1]])
    print(i)
}

# for loop through list of dxy comparisons (do comparisons with chihuahua population) and calculate tau 

tau.2 <- c()

for (i in 7:11) {
  if (i == 7) {
    tau.2[1] <- tau(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[3]])
  } else if (i == 8) {
    tau.2[2] <- tau(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[4]])
  } else if (i == 9)  {
    tau.2[3] <- tau(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[5]])
  } else if (i == 10)  {
    tau.2[4] <- tau(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[6]])
  } else {
    tau.2[5] <- tau(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[7]])
  }
  print(i)
}


# for loop through list of dxy comparisons (do comparisons with durango population) and calculate tau 

tau.3 <- c()

for (i in 12:15) {
  if (i == 12) {
    tau.3[1] <- tau(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[4]])
  } else if (i == 13) {
    tau.3[2] <- tau(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[5]])
  } else if (i == 14)  {
    tau.3[3] <- tau(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[6]])
  } else  {
    tau.3[4] <- tau(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[7]])
  } 
  print(i)
}


# for loop through list of dxy comparisons (do comparisons with guererro population) and calculate tau 

tau.4 <- c()

for (i in 16:18) {
    if (i == 16) {
    tau.4[1] <- tau(pairwise.dxy[[i]], pi_populations[[4]], pi_populations[[5]])
  } else if (i == 17) {
    tau.4[2] <- tau(pairwise.dxy[[i]], pi_populations[[4]], pi_populations[[6]])
  } else  {
    tau.4[3] <- tau(pairwise.dxy[[i]], pi_populations[[4]], pi_populations[[7]])
  }
  print(i)
}

# for loop through list of dxy comparisons (do el_salvador_honduras-chiapas comparison) and calculate tau 

tau.5 <- c()

for (i in 19) {
    tau.5[1] <- tau(pairwise.dxy[[i]], pi_populations[[6]], pi_populations[[5]])
  print(i)
}


# for loop through list of dxy comparisons (do comparisons with nicaragua) and calculate tau 

tau.6 <- c()

for (i in 20:21) {
  if (i == 20) {
    tau.6[1] <- tau(pairwise.dxy[[i]], pi_populations[[7]], pi_populations[[5]])
  } else {
    tau.6[2] <- tau(pairwise.dxy[[i]], pi_populations[[7]], pi_populations[[6]])
  }
  print(i)
  }
  
# divergence_time calculations 

# for loop through list of dxy comparisons (do comparisons with southwest_usa population) and calculate divergence_time 

divergence_time.1 <- c()

for (i in 1:6) {
  divergence_time.1[i] <- divergence_time(pairwise.dxy[[i]], pi_populations[[1]], pi_populations[[i + 1]], muta)
  print(i)
}

# for loop through list of dxy comparisons (do comparisons with chihuahua population) and calculate divergence_time 

divergence_time.2 <- c()

for (i in 7:11) {
  if (i == 7) {
    divergence_time.2[1] <- divergence_time(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[3]], muta)
  } else if (i == 8) {
    divergence_time.2[2] <- divergence_time(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[4]], muta)
  } else if (i == 9)  {
    divergence_time.2[3] <- divergence_time(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[5]], muta)
  } else if (i == 10)  {
    divergence_time.2[4] <- divergence_time(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[6]], muta)
  } else {
    divergence_time.2[5] <- divergence_time(pairwise.dxy[[i]], pi_populations[[2]], pi_populations[[7]], muta)
  }
  print(i)
}


# for loop through list of dxy comparisons (do comparisons with durango population) and calculate divergence_time 

divergence_time.3 <- c()

for (i in 12:15) {
  if (i == 12) {
    divergence_time.3[1] <- divergence_time(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[4]], muta)
  } else if (i == 13) {
    divergence_time.3[2] <- divergence_time(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[5]], muta)
  } else if (i == 14)  {
    divergence_time.3[3] <- divergence_time(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[6]], muta)
  } else  {
    divergence_time.3[4] <- divergence_time(pairwise.dxy[[i]], pi_populations[[3]], pi_populations[[7]], muta)
  } 
  print(i)
}


# for loop through list of dxy comparisons (do comparisons with guererro population) and calculate divergence_time 

divergence_time.4 <- c()

for (i in 16:18) {
  if (i == 16) {
    divergence_time.4[1] <- divergence_time(pairwise.dxy[[i]], pi_populations[[4]], pi_populations[[5]], muta)
  } else if (i == 17) {
    divergence_time.4[2] <- divergence_time(pairwise.dxy[[i]], pi_populations[[4]], pi_populations[[6]], muta)
  } else  {
    divergence_time.4[3] <- divergence_time(pairwise.dxy[[i]], pi_populations[[4]], pi_populations[[7]], muta)
  }
  print(i)
}

# for loop through list of dxy comparisons (do el_salvador_honduras-chiapas comparison) and calculate divergence_time 

divergence_time.5 <- c()

for (i in 19) {
  divergence_time.5[1] <- divergence_time(pairwise.dxy[[i]], pi_populations[[6]], pi_populations[[5]], muta)
  print(i)
}


# for loop through list of dxy comparisons (do comparisons with nicaragua) and calculate divergence_time 

divergence_time.6 <- c()

for (i in 20:21) {
  if (i == 20) {
    divergence_time.6[1] <- divergence_time(pairwise.dxy[[i]], pi_populations[[7]], pi_populations[[5]], muta)
  } else {
    divergence_time.6[2] <- divergence_time(pairwise.dxy[[i]], pi_populations[[7]], pi_populations[[6]], muta)
  }
  print(i)
}




# combine pairwise dxys, tau, and divergence time into dataframe

# combine (as one vector) all taus

tau_1 <- append(tau.1, tau.2)

tau_2 <- append(tau_1, tau.3)

tau_3 <- append(tau_2, tau.4)

tau_4 <- append(tau_3, tau.5)

tau_total <- append (tau_4, tau.6)



# combine (as one vector) all divergence times 

divergence_times_1 <- append(divergence_time.1, divergence_time.2)

divergence_times_2 <- append(divergence_times_1, divergence_time.3)

divergence_times_3 <- append(divergence_times_2, divergence_time.4)

divergence_times_4 <- append(divergence_times_3, divergence_time.5)

divergence_times_total <- append (divergence_times_4, divergence_time.6)

# make dataframe
tau_divergence_times <- as.data.frame(cbind(pairwise.dxy.names, tau_total, divergence_times_total))

tau_divergence_times$tau_total <- as.numeric(tau_divergence_times$tau_total)

tau_divergence_times$divergence_times_total <- as.numeric(tau_divergence_times$divergence_times_total)

tau_divergence_times[order(tau_divergence_times$tau_total, decreasing = FALSE),]

# export table 

write.table(tau_divergence_times, file = "tau_divergence_times.txt", sep = "\t")
