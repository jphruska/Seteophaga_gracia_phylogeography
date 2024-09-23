## This script will carry out standardized (pi/dxy) calculations, along with plotting of the genomic landscape
## across five populations of setophaga graciae (southwest_usa, Guerrero, Chiapas, nicaragua and Nicaragua)
## The objective of this analysis is to examine whether present day lineages are being acted upon by common 
## selective forces, in the same genomic regions. 
## This methodology is inspired by Irwin et al. 2016 and Van Doren et al. 2017. 

## Here standardized nucleotide diversity (pi/dxy) is calculated by dividing pi (per window) by the
## maximum pairwise dxy that involves that population. 


## Note when running these scripts: to create the correlations among standardized nucleotide diversity, exclude Z chromosome (for each pi/dxy calculation). 
## However, when making the landscape plots, we keep the Z chromosome. This can be achieved by commenting out, 
## for each population, the line of code that excludes the Z chromosome, and then running the landscape plots. 

# Load packages

library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cowplot)
library(tidyverse)
options(scipen = 999)


## Read in Pi estimates (including all five populations)

pi <- read.table("window_pi.txt", sep="\t", stringsAsFactors = TRUE, header = TRUE)

pi <- na.omit(pi)


# subset stats per population

standard_southwest_usa<- pi[pi=="Southwest_USA",]
standard_southwest_usa<- standard_southwest_usa[standard_southwest_usa$number_variable_sites > 0,]
standard_chihuahua <- pi[pi=="Chihuahua",]
standard_chihuahua <- standard_chihuahua[standard_chihuahua$number_variable_sites > 0,]
standard_durango <- pi[pi=="Durango",]
standard_durango <- standard_durango[standard_durango$number_variable_sites > 0,]
standard_nicaragua <- pi[pi=="Nicaragua",]
standard_nicaragua <- standard_nicaragua[standard_nicaragua$number_variable_sites > 0,]
standard_guerrero <- pi[pi=="Guerrero",]
standard_guerrero <- standard_guerrero[standard_guerrero$number_variable_sites > 0,]
standard_el_salvador_honduras <- pi[pi=="El_Salvador_Honduras",]
standard_el_salvador_honduras <- standard_el_salvador_honduras[standard_el_salvador_honduras$number_variable_sites > 0,]
standard_chiapas <-pi[pi=="Chiapas",]
standard_chiapas <- standard_chiapas[standard_chiapas$number_variable_sites > 0,]
  
## Read in pairwise Dxy estimates (between all five populations)
  
y <- as.data.frame(read.table("window_dxy.txt", sep="\t", stringsAsFactors = FALSE, header = TRUE))

y <- na.omit(y)


# subset stats per population comparison

dxy_southwest_usa_chihuahua <- y[y$pop1=="Southwest_USA" & y$pop2=="Chihuahua",]
dxy_southwest_usa_chihuahua <- dxy_southwest_usa_chihuahua[dxy_southwest_usa_chihuahua$number_sites > 0,]

dxy_southwest_usa_durango <- y[y$pop1=="Southwest_USA" & y$pop2=="Durango",]
dxy_southwest_usa_durango <- dxy_southwest_usa_durango[dxy_southwest_usa_durango$number_sites > 0,]

dxy_southwest_usa_guerrero <- y[y$pop1=="Southwest_USA" & y$pop2=="Guerrero",]
dxy_southwest_usa_guerrero <- dxy_southwest_usa_guerrero[dxy_southwest_usa_guerrero$number_sites > 0,]

dxy_southwest_usa_chiapas <- y[y$pop1=="Southwest_USA" & y$pop2=="Chiapas",]
dxy_southwest_usa_chiapas <- dxy_southwest_usa_chiapas[dxy_southwest_usa_chiapas$number_sites > 0,]

dxy_southwest_usa_el_salvador_honduras <- y[y$pop1=="Southwest_USA" & y$pop2=="El_Salvador_Honduras",]
dxy_southwest_usa_el_salvador_honduras<- dxy_southwest_usa_el_salvador_honduras[dxy_southwest_usa_el_salvador_honduras$number_sites > 0,]

dxy_southwest_usa_nicaragua <- y[y$pop1=="Southwest_USA" & y$pop2=="Nicaragua",]
dxy_southwest_usa_nicaragua <- dxy_southwest_usa_nicaragua[dxy_southwest_usa_nicaragua$number_sites > 0,]




dxy_chihuahua_durango <- y[y$pop2=="Chihuahua" & y$pop1=="Durango",]
dxy_chihuahua_durango <- dxy_chihuahua_durango[dxy_chihuahua_durango$number_sites > 0,]

dxy_chihuahua_guerrero <- y[y$pop2=="Chihuahua" & y$pop1=="Guerrero",]
dxy_chihuahua_guerrero <- dxy_chihuahua_guerrero[dxy_chihuahua_guerrero$number_sites > 0,]

dxy_chihuahua_chiapas <- y[y$pop2=="Chihuahua" & y$pop1=="Chiapas",]
dxy_chihuahua_chiapas <- dxy_chihuahua_chiapas[dxy_chihuahua_chiapas$number_sites > 0,]

dxy_chihuahua_el_salvador_honduras <- y[y$pop2=="Chihuahua" & y$pop1=="El_Salvador_Honduras",]
dxy_chihuahua_el_salvador_honduras <- dxy_chihuahua_el_salvador_honduras[dxy_chihuahua_el_salvador_honduras$number_sites > 0,]

dxy_chihuahua_nicaragua <- y[y$pop2=="Chihuahua" & y$pop1=="Nicaragua",]
dxy_chihuahua_nicaragua <- dxy_chihuahua_nicaragua[dxy_chihuahua_nicaragua$number_sites > 0,]



dxy_durango_guerrero <- y[y$pop2=="Durango" & y$pop1=="Guerrero",]
dxy_durango_guerrero <- dxy_durango_guerrero[dxy_durango_guerrero$number_sites > 0,]

dxy_durango_chiapas <- y[y$pop2=="Durango" & y$pop1=="Chiapas",]
dxy_durango_chiapas <- dxy_durango_chiapas[dxy_durango_chiapas$number_sites > 0,]

dxy_durango_el_salvador_honduras <- y[y$pop2=="Durango" & y$pop1=="El_Salvador_Honduras",]
dxy_durango_el_salvador_honduras <- dxy_durango_el_salvador_honduras[dxy_durango_el_salvador_honduras$number_sites > 0,]

dxy_durango_nicaragua <- y[y$pop2=="Durango" & y$pop1=="Nicaragua",]
dxy_durango_nicaragua <- dxy_durango_nicaragua[dxy_durango_nicaragua$number_sites > 0,]




dxy_guerrero_chiapas <- y[y$pop1=="Guerrero" & y$pop2=="Chiapas",]
dxy_guerrero_chiapas <- dxy_guerrero_chiapas[dxy_guerrero_chiapas$number_sites > 0,]

dxy_guerrero_el_salvador_honduras <- y[y$pop1=="El_Salvador_Honduras" & y$pop2=="Guerrero",]
dxy_guerrero_el_salvador_honduras <- dxy_guerrero_el_salvador_honduras[dxy_guerrero_el_salvador_honduras$number_sites > 0,]

dxy_guerrero_nicaragua <- y[y$pop1=="Nicaragua" & y$pop2=="Guerrero",]
dxy_guerrero_nicaragua <- dxy_guerrero_nicaragua[dxy_guerrero_nicaragua$number_sites > 0,]

dxy_el_salvador_honduras_chiapas <- y[y$pop1=="El_Salvador_Honduras" & y$pop2=="Chiapas",]
dxy_el_salvador_honduras_chiapas <- dxy_el_salvador_honduras_chiapas[dxy_el_salvador_honduras_chiapas$number_sites > 0,]

dxy_nicaragua_chiapas <- y[y$pop1=="Nicaragua" & y$pop2=="Chiapas",]
dxy_nicaragua_chiapas <- dxy_nicaragua_chiapas[dxy_nicaragua_chiapas$number_sites > 0,]

dxy_nicaragua_el_salvador_honduras <- y[y$pop1=="Nicaragua" & y$pop2=="El_Salvador_Honduras",]
dxy_nicaragua_el_salvador_honduras <- dxy_nicaragua_el_salvador_honduras[dxy_nicaragua_el_salvador_honduras$number_sites > 0,]


# For each population combined pi estimates with all dxy comparisons involving that population

# southwest_usa population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.southwest_usa<- list(standard_southwest_usa, dxy_southwest_usa_chihuahua, dxy_southwest_usa_durango,
                             dxy_southwest_usa_guerrero, dxy_southwest_usa_chiapas, dxy_southwest_usa_el_salvador_honduras, 
                         dxy_southwest_usa_nicaragua)

combined_dataframe_southwest_usa<- list_df.southwest_usa %>% reduce(inner_join, by = colnames_merge)

combined_dataframe_southwest_usa<- na.omit(combined_dataframe_southwest_usa)

# Remove Z chromosome 

combined_dataframe_southwest_usa<- combined_dataframe_southwest_usa[!combined_dataframe_southwest_usa$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1 <- c()
dxy.2 <- c()
dxy.3 <- c()
dxy.4 <- c()
dxy.5 <- c()
dxy.6 <- c()
max.dxy <- c()
standard.nucleotide <- c()
pi.southwest_usa<- c()
chr <- c()
start <- c()
end <- c()

for (i  in 1:nrow(combined_dataframe_southwest_usa)){
  # extract pi 
  pi.southwest_usa[i] <- combined_dataframe_southwest_usa$calculated_stat.x[i]
  # extract chromosome
  chr[i] <- combined_dataframe_southwest_usa$chr[i]
  # extract start of wiodow
  start[i] <- combined_dataframe_southwest_usa$start[i]
  # extract end of window 
  end[i] <- combined_dataframe_southwest_usa$end[i]
  # extract first dxy comparison 
  dxy.1[i] <- combined_dataframe_southwest_usa$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2[i] <- combined_dataframe_southwest_usa$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3[i] <- combined_dataframe_southwest_usa$calculated_stat.y.y[i]
  # extract fourth dxy comparion 
  dxy.4[i] <- combined_dataframe_southwest_usa$calculated_stat.x.x.x[i]
  # extract fifth dxy comparion 
  dxy.5[i] <- combined_dataframe_southwest_usa$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6[i] <- combined_dataframe_southwest_usa$calculated_stat[i]
  # calculate max dxy comparison
  max.dxy[i] <- max(combined_dataframe_southwest_usa$calculated_stat.y[i], 
                    combined_dataframe_southwest_usa$calculated_stat.x.x[i], 
                    combined_dataframe_southwest_usa$calculated_stat.y.y[i], 
                    combined_dataframe_southwest_usa$calculated_stat.x.x.x[i], 
                    combined_dataframe_southwest_usa$calculated_stat.y.y.y[i], 
                    combined_dataframe_southwest_usa$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide[i] <- pi.southwest_usa[i] / max.dxy[i]
}

standard_southwest_usa<- as.data.frame(cbind(chr, start, end, standard.nucleotide))



# For each population combined pi estimates with all dxy comparisons involving that population

# chihuahua population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.chihuahua<- list(standard_chihuahua, dxy_southwest_usa_chihuahua, dxy_chihuahua_durango, 
                         dxy_chihuahua_guerrero, dxy_chihuahua_chiapas, dxy_chihuahua_el_salvador_honduras, 
                             dxy_chihuahua_nicaragua)

combined_dataframe_chihuahua<- list_df.chihuahua%>% reduce(inner_join, by = colnames_merge)

combined_dataframe_chihuahua<- na.omit(combined_dataframe_chihuahua)

# Remove Z chromosome 

combined_dataframe_chihuahua<- combined_dataframe_chihuahua[!combined_dataframe_chihuahua$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1 <- c()
dxy.2 <- c()
dxy.3 <- c()
dxy.4 <- c()
dxy.5 <- c()
dxy.6 <- c()
max.dxy <- c()
standard.nucleotide <- c()
pi.chihuahua<- c()
chr <- c()
start <- c()
end <- c()

for (i  in 1:nrow(combined_dataframe_chihuahua)){
  # extract pi 
  pi.chihuahua[i] <- combined_dataframe_chihuahua$calculated_stat.x[i]
  # extract chromosome
  chr[i] <- combined_dataframe_chihuahua$chr[i]
  # extract start of wiodow
  start[i] <- combined_dataframe_chihuahua$start[i]
  # extract end of window 
  end[i] <- combined_dataframe_chihuahua$end[i]
  # extract first dxy comparison 
  dxy.1[i] <- combined_dataframe_chihuahua$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2[i] <- combined_dataframe_chihuahua$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3[i] <- combined_dataframe_chihuahua$calculated_stat.y.y[i]
  # extract fourth dxy comparison 
  dxy.4[i] <- combined_dataframe_chihuahua$calculated_stat.x.x.x[i]
  # extract fifth dxy comparison 
  dxy.5[i] <- combined_dataframe_chihuahua$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6[i] <- combined_dataframe_chihuahua$calculated_stat[i]

  # calculate max dxy comparison
  max.dxy[i] <- max(combined_dataframe_chihuahua$calculated_stat.y[i], 
                    combined_dataframe_chihuahua$calculated_stat.x.x[i], 
                    combined_dataframe_chihuahua$calculated_stat.y.y[i], 
                    combined_dataframe_chihuahua$calculated_stat.x.x.x[i], 
                    combined_dataframe_chihuahua$calculated_stat.y.y.y[i], 
                    combined_dataframe_chihuahua$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide[i] <- pi.chihuahua[i] / max.dxy[i]
}

standard_chihuahua<- as.data.frame(cbind(chr, start, end, standard.nucleotide))




# For each population combined pi estimates with all dxy comparisons involving that population

# durango population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.durango<- list(standard_durango, dxy_southwest_usa_durango, dxy_chihuahua_durango, 
                       dxy_durango_guerrero, dxy_durango_chiapas, dxy_durango_el_salvador_honduras, 
                         dxy_durango_nicaragua)

combined_dataframe_durango<- list_df.durango%>% reduce(inner_join, by = colnames_merge)

combined_dataframe_durango<- na.omit(combined_dataframe_durango)

# Remove Z chromosome 

combined_dataframe_durango<- combined_dataframe_durango[!combined_dataframe_durango$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1 <- c()
dxy.2 <- c()
dxy.3 <- c()
dxy.4 <- c()
dxy.5 <- c()
dxy.6 <- c()
max.dxy <- c()
standard.nucleotide <- c()
pi.durango<- c()
chr <- c()
start <- c()
end <- c()

for (i  in 1:nrow(combined_dataframe_durango)){
  # extract pi 
  pi.durango[i] <- combined_dataframe_durango$calculated_stat.x[i]
  # extract chromosome
  chr[i] <- combined_dataframe_durango$chr[i]
  # extract start of wiodow
  start[i] <- combined_dataframe_durango$start[i]
  # extract end of window 
  end[i] <- combined_dataframe_durango$end[i]
  # extract first dxy comparison 
  dxy.1[i] <- combined_dataframe_durango$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2[i] <- combined_dataframe_durango$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3[i] <- combined_dataframe_durango$calculated_stat.y.y[i]
  # extract fourth dxy comparison 
  dxy.4[i] <- combined_dataframe_durango$calculated_stat.x.x.x[i]
  # extract fifth dxy comparison 
  dxy.5[i] <- combined_dataframe_durango$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6[i] <- combined_dataframe_durango$calculated_stat[i]
  # calculate max dxy comparison
  max.dxy[i] <- max(combined_dataframe_durango$calculated_stat.y[i], 
                    combined_dataframe_durango$calculated_stat.x.x[i], 
                    combined_dataframe_durango$calculated_stat.y.y[i], 
                    combined_dataframe_durango$calculated_stat.x.x.x[i], 
                    combined_dataframe_durango$calculated_stat.y.y.y[i], 
                    combined_dataframe_durango$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide[i] <- pi.durango[i] / max.dxy[i]
}

standard_durango<- as.data.frame(cbind(chr, start, end, standard.nucleotide))




# guerrero population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.guerrero <- list(standard_guerrero, dxy_chihuahua_guerrero, dxy_durango_guerrero, 
                         dxy_southwest_usa_guerrero, dxy_guerrero_chiapas, dxy_guerrero_el_salvador_honduras, 
                         dxy_guerrero_nicaragua)

combined_dataframe_guerrero <- list_df.guerrero %>% reduce(inner_join, by = colnames_merge)

combined_dataframe_guerrero <- na.omit(combined_dataframe_guerrero)

# Remove Z chromosome 

combined_dataframe_guerrero <- combined_dataframe_guerrero[!combined_dataframe_guerrero$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1.1 <- c()
dxy.2.1 <- c()
dxy.3.1 <- c()
dxy.4.1 <- c()
dxy.5.1 <- c()
dxy.6.1 <- c()
max.dxy.1 <- c()
standard.nucleotide.1 <- c()
pi.guerrero <- c()
chr.1 <- c()
start.1 <- c()
end.1 <- c()

for (i  in 1:nrow(combined_dataframe_guerrero)){
  # extract pi 
  pi.guerrero[i] <- combined_dataframe_guerrero$calculated_stat.x[i]
  # extract chromosome
  chr.1[i] <- combined_dataframe_guerrero$chr[i]
  # extract start of wiodow
  start.1[i] <- combined_dataframe_guerrero$start[i]
  # extract end of window 
  end.1[i] <- combined_dataframe_guerrero$end[i]
  # extract first dxy comparison 
  dxy.1.1[i] <- combined_dataframe_guerrero$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2.1[i] <- combined_dataframe_guerrero$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3.1[i] <- combined_dataframe_guerrero$calculated_stat.y.y[i]
  # extract fourth dxy comparion 
  dxy.4.1[i] <- combined_dataframe_guerrero$calculated_stat.x.x.x[i]
  # extract fifth dxy comparion 
  dxy.5.1[i] <- combined_dataframe_guerrero$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6.1[i] <- combined_dataframe_guerrero$calculated_stat[i]
  # calculate max dxy comparison
  max.dxy.1[i] <- max(combined_dataframe_guerrero$calculated_stat.y[i], 
                    combined_dataframe_guerrero$calculated_stat.x.x[i], 
                    combined_dataframe_guerrero$calculated_stat.y.y[i], 
                    combined_dataframe_guerrero$calculated_stat.x.x.x[i], 
                    combined_dataframe_guerrero$calculated_stat.y.y.y[i], 
                    combined_dataframe_guerrero$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide.1[i] <- pi.guerrero[i] / max.dxy.1[i]
}

standard_guerrero <- as.data.frame(cbind(chr.1, start.1, end.1, standard.nucleotide.1))



# chiapas population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.chiapas <- list(standard_chiapas,dxy_southwest_usa_chiapas, dxy_chihuahua_chiapas, dxy_durango_chiapas, 
                        dxy_guerrero_chiapas, dxy_el_salvador_honduras_chiapas, 
                         dxy_nicaragua_chiapas)

combined_dataframe_chiapas <- list_df.chiapas %>% reduce(inner_join, by = colnames_merge)

combined_dataframe_chiapas <- na.omit(combined_dataframe_chiapas)

# Remove Z chromosome 

combined_dataframe_chiapas <- combined_dataframe_chiapas[!combined_dataframe_chiapas$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1.2 <- c()
dxy.2.2 <- c()
dxy.3.2 <- c()
dxy.4.2 <- c()
dxy.5.2 <- c()
dxy.6.2 <- c()
max.dxy.2 <- c()
standard.nucleotide.2 <- c()
pi.chiapas <- c()
chr.2 <- c()
start.2 <- c()
end.2 <- c()

for (i  in 1:nrow(combined_dataframe_chiapas)){
  # extract pi 
  pi.chiapas[i] <- combined_dataframe_chiapas$calculated_stat.x[i]
  # extract chromosome
  chr.2[i] <- combined_dataframe_chiapas$chr[i]
  # extract start of wiodow
  start.2[i] <- combined_dataframe_chiapas$start[i]
  # extract end of window 
  end.2[i] <- combined_dataframe_chiapas$end[i]
  # extract first dxy comparison 
  dxy.1.2[i] <- combined_dataframe_chiapas$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2.2[i] <- combined_dataframe_chiapas$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3.2[i] <- combined_dataframe_chiapas$calculated_stat.y.y[i]
  # extract fourth dxy comparison 
  dxy.4.2[i] <- combined_dataframe_chiapas$calculated_stat.x.x.x[i]
  # extract fifth dxy comparison 
  dxy.5.2[i] <- combined_dataframe_chiapas$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6.2[i] <- combined_dataframe_chiapas$calculated_stat[i]
  # calculate max dxy comparison
  max.dxy.2[i] <- max(combined_dataframe_chiapas$calculated_stat.y[i], 
                      combined_dataframe_chiapas$calculated_stat.x.x[i], 
                      combined_dataframe_chiapas$calculated_stat.y.y[i], 
                      combined_dataframe_chiapas$calculated_stat.x.x.x[i], 
                      combined_dataframe_chiapas$calculated_stat.y.y.y[i], 
                      combined_dataframe_chiapas$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide.2[i] <- pi.chiapas[i] / max.dxy.2[i]
}

standard_chiapas <- as.data.frame(cbind(chr.2, start.2, end.2, standard.nucleotide.2))



# el_salvador_honduras population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.el_salvador_honduras <- list(standard_el_salvador_honduras, dxy_southwest_usa_el_salvador_honduras, dxy_chihuahua_el_salvador_honduras, 
                                     dxy_durango_el_salvador_honduras, 
                                     dxy_guerrero_el_salvador_honduras, 
                                     dxy_el_salvador_honduras_chiapas, 
                                     dxy_nicaragua_el_salvador_honduras)

combined_dataframe_el_salvador_honduras <- list_df.el_salvador_honduras %>% reduce(inner_join, by = colnames_merge)

combined_dataframe_el_salvador_honduras <- na.omit(combined_dataframe_el_salvador_honduras)

# Remove Z chromosome 

combined_dataframe_el_salvador_honduras <- combined_dataframe_el_salvador_honduras[!combined_dataframe_el_salvador_honduras$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1.3 <- c()
dxy.2.3 <- c()
dxy.3.3 <- c()
dxy.4.3 <- c()
dxy.5.3 <- c()
dxy.6.3 <- c()
max.dxy.3 <- c()
standard.nucleotide.3 <- c()
pi.el_salvador_honduras <- c()
chr.3 <- c()
start.3 <- c()
end.3 <- c()

for (i  in 1:nrow(combined_dataframe_el_salvador_honduras)){
  # extract pi 
  pi.el_salvador_honduras[i] <- combined_dataframe_el_salvador_honduras$calculated_stat.x[i]
  # extract chromosome
  chr.3[i] <- combined_dataframe_el_salvador_honduras$chr[i]
  # extract start of wiodow
  start.3[i] <- combined_dataframe_el_salvador_honduras$start[i]
  # extract end of window 
  end.3[i] <- combined_dataframe_el_salvador_honduras$end[i]
  # extract first dxy comparison 
  dxy.1.3[i] <- combined_dataframe_el_salvador_honduras$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2.3[i] <- combined_dataframe_el_salvador_honduras$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3.3[i] <- combined_dataframe_el_salvador_honduras$calculated_stat.y.y[i]
  # extract fourth dxy comparison 
  dxy.4.3[i] <- combined_dataframe_el_salvador_honduras$calculated_stat.x.x.x[i]
  # extract fifth dxy comparison 
  dxy.5.3[i] <- combined_dataframe_el_salvador_honduras$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6.3[i] <- combined_dataframe_el_salvador_honduras$calculated_stat[i]
  # calculate max dxy comparison
  max.dxy.3[i] <- max(combined_dataframe_el_salvador_honduras$calculated_stat.y[i], 
                      combined_dataframe_el_salvador_honduras$calculated_stat.x.x[i], 
                      combined_dataframe_el_salvador_honduras$calculated_stat.y.y[i], 
                      combined_dataframe_el_salvador_honduras$calculated_stat.x.x.x[i], 
                      combined_dataframe_el_salvador_honduras$calculated_stat.y.y.y[i], 
                      combined_dataframe_el_salvador_honduras$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide.3[i] <- pi.el_salvador_honduras[i] / max.dxy.3[i]
}

standard_el_salvador_honduras <- as.data.frame(cbind(chr.3, start.3, end.3, standard.nucleotide.3))




# nicaragua population
## combine pi and dxy datasets, joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

list_df.nicaragua <- list(standard_nicaragua, dxy_southwest_usa_nicaragua, dxy_chihuahua_nicaragua, dxy_durango_nicaragua, 
                          dxy_guerrero_nicaragua, dxy_nicaragua_chiapas, 
                        dxy_nicaragua_el_salvador_honduras)

combined_dataframe_nicaragua <- list_df.nicaragua %>% reduce(inner_join, by = colnames_merge)

combined_dataframe_nicaragua <- na.omit(combined_dataframe_nicaragua)

# Remove Z chromosome 

combined_dataframe_nicaragua <- combined_dataframe_nicaragua[!combined_dataframe_nicaragua$chr == "CM027535.1",]

## loop through rows of dataframe and calculate standardized nucleotide diversity 

# set empty vectors for outputs 
dxy.1.4 <- c()
dxy.2.4 <- c()
dxy.3.4 <- c()
dxy.4.4 <- c()
dxy.5.4 <- c()
dxy.6.4 <- c()
max.dxy.4 <- c()
standard.nucleotide.4 <- c()
pi.nicaragua <- c()
chr.4 <- c()
start.4 <- c()
end.4 <- c()

for (i  in 1:nrow(combined_dataframe_nicaragua)){
  # extract pi 
  pi.nicaragua[i] <- combined_dataframe_nicaragua$calculated_stat.x[i]
  # extract chromosome
  chr.4[i] <- combined_dataframe_nicaragua$chr[i]
  # extract start of wiodow
  start.4[i] <- combined_dataframe_nicaragua$start[i]
  # extract end of window 
  end.4[i] <- combined_dataframe_nicaragua$end[i]
  # extract first dxy comparison 
  dxy.1.4[i] <- combined_dataframe_nicaragua$calculated_stat.y[i]
  # extract second dxy comparison
  dxy.2.4[i] <- combined_dataframe_nicaragua$calculated_stat.x.x[i]
  # extract third dxy comparison 
  dxy.3.4[i] <- combined_dataframe_nicaragua$calculated_stat.y.y[i]
  # extract fourth dxy comparison 
  dxy.4.4[i] <- combined_dataframe_nicaragua$calculated_stat.x.x.x[i]
  # extract fifth dxy comparison 
  dxy.5.4[i] <- combined_dataframe_nicaragua$calculated_stat.y.y.y[i]
  # extract sixth dxy comparion 
  dxy.6.4[i] <- combined_dataframe_nicaragua$calculated_stat[i]
  # calculate max dxy comparison
  max.dxy.4[i] <- max(combined_dataframe_nicaragua$calculated_stat.y[i], 
                      combined_dataframe_nicaragua$calculated_stat.x.x[i], 
                      combined_dataframe_nicaragua$calculated_stat.y.y[i], 
                      combined_dataframe_nicaragua$calculated_stat.x.x.x[i], 
                      combined_dataframe_nicaragua$calculated_stat.y.y.y[i], 
                      combined_dataframe_nicaragua$calculated_stat[i])
  # calculate standardized nucleotide diversity 
  standard.nucleotide.4[i] <- pi.nicaragua[i] / max.dxy.4[i]
}

standard_nicaragua <- as.data.frame(cbind(chr.4, start.4, end.4, standard.nucleotide.4))


# Merge Dataframes

colnames(standard_southwest_usa)[1] <- "chr"
colnames(standard_southwest_usa)[2] <- "start"
colnames(standard_southwest_usa)[3] <- "end"
colnames(standard_southwest_usa)[4] <- "standard.southwest_usa"

colnames(standard_chihuahua)[1] <- "chr"
colnames(standard_chihuahua)[2] <- "start"
colnames(standard_chihuahua)[3] <- "end"
colnames(standard_chihuahua)[4] <- "standard.chihuahua"

colnames(standard_durango)[1] <- "chr"
colnames(standard_durango)[2] <- "start"
colnames(standard_durango)[3] <- "end"
colnames(standard_durango)[4] <- "standard.durango"

colnames(standard_guerrero)[1] <- "chr"
colnames(standard_guerrero)[2] <- "start"
colnames(standard_guerrero)[3] <- "end"
colnames(standard_guerrero)[4] <- "standard.guerrero"

colnames(standard_chiapas)[1] <- "chr"
colnames(standard_chiapas)[2] <- "start"
colnames(standard_chiapas)[3] <- "end"
colnames(standard_chiapas)[4] <- "standard.chiapas"

colnames(standard_el_salvador_honduras)[1] <- "chr"
colnames(standard_el_salvador_honduras)[2] <- "start"
colnames(standard_el_salvador_honduras)[3] <- "end"
colnames(standard_el_salvador_honduras)[4] <- "standard.el_salvador_honduras"

colnames(standard_nicaragua)[1] <- "chr"
colnames(standard_nicaragua)[2] <- "start"
colnames(standard_nicaragua)[3] <- "end"
colnames(standard_nicaragua)[4] <- "standard.nicaragua"

# southwest_usa chihuahua (a)
southwest_usa_chihuahua_merged <- merge(standard_southwest_usa, standard_chihuahua, by = colnames_merge, all.y = TRUE, all.x = TRUE)
southwest_usa_chihuahua_merged$standard.southwest_usa<- as.numeric(southwest_usa_chihuahua_merged$standard.southwest_usa)
southwest_usa_chihuahua_merged$standard.chihuahua <- as.numeric(southwest_usa_chihuahua_merged$standard.chihuahua)

# southwest_usa durango (b)
southwest_usa_durango_merged <- merge(standard_southwest_usa, standard_durango, by = colnames_merge, all.y = TRUE, all.x = TRUE)
southwest_usa_durango_merged$standard.southwest_usa<- as.numeric(southwest_usa_durango_merged$standard.southwest_usa)
southwest_usa_durango_merged$standard.durango <- as.numeric(southwest_usa_durango_merged$standard.durango)


# southwest_usa guerrero (c)
southwest_usa_guerrero_merged <- merge(standard_southwest_usa, standard_guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)
southwest_usa_guerrero_merged$standard.southwest_usa<- as.numeric(southwest_usa_guerrero_merged$standard.southwest_usa)
southwest_usa_guerrero_merged$standard.guerrero <- as.numeric(southwest_usa_guerrero_merged$standard.guerrero)

# southwest_usa chiapas (d)
southwest_usa_chiapas_merged <- merge(standard_southwest_usa, standard_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)
southwest_usa_chiapas_merged$standard.southwest_usa<- as.numeric(southwest_usa_chiapas_merged$standard.southwest_usa)
southwest_usa_chiapas_merged$standard.chiapas <- as.numeric(southwest_usa_chiapas_merged$standard.chiapas)


# southwest_usa el_salvador_honduras (e)
southwest_usa_el_salvador_honduras_merged <- merge(standard_southwest_usa, standard_el_salvador_honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)
southwest_usa_el_salvador_honduras_merged$standard.southwest_usa<- as.numeric(southwest_usa_el_salvador_honduras_merged$standard.southwest_usa)
southwest_usa_el_salvador_honduras_merged$standard.el_salvador_honduras <- as.numeric(southwest_usa_el_salvador_honduras_merged$standard.el_salvador_honduras)


# southwest_usa nicaragua (f)
southwest_usa_nicaragua_merged <- merge(standard_southwest_usa, standard_nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)
southwest_usa_nicaragua_merged$standard.southwest_usa<- as.numeric(southwest_usa_nicaragua_merged$standard.southwest_usa)
southwest_usa_nicaragua_merged$standard.nicaragua <- as.numeric(southwest_usa_nicaragua_merged$standard.nicaragua)

# chihuahua durango (g)
chihuahua_durango_merged <- merge(standard_chihuahua, standard_durango, by = colnames_merge, all.y = TRUE, all.x = TRUE)
chihuahua_durango_merged$standard.chihuahua<- as.numeric(chihuahua_durango_merged$standard.chihuahua)
chihuahua_durango_merged$standard.durango <- as.numeric(chihuahua_durango_merged$standard.durango)

# chihuahua guerrero (h)
chihuahua_guerrero_merged <- merge(standard_chihuahua, standard_guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)
chihuahua_guerrero_merged$standard.chihuahua<- as.numeric(chihuahua_guerrero_merged$standard.chihuahua)
chihuahua_guerrero_merged$standard.guerrero <- as.numeric(chihuahua_guerrero_merged$standard.guerrero)


# chihuahua chiapas (i)
chihuahua_chiapas_merged <- merge(standard_chihuahua, standard_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)
chihuahua_chiapas_merged$standard.chihuahua<- as.numeric(chihuahua_chiapas_merged$standard.chihuahua)
chihuahua_chiapas_merged$standard.chiapas <- as.numeric(chihuahua_chiapas_merged$standard.chiapas)


# chihuahua el_salvador_honduras (j)
chihuahua_el_salvador_honduras_merged <- merge(standard_chihuahua, standard_el_salvador_honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)
chihuahua_el_salvador_honduras_merged$standard.chihuahua<- as.numeric(chihuahua_el_salvador_honduras_merged$standard.chihuahua)
chihuahua_el_salvador_honduras_merged$standard.el_salvador_honduras <- as.numeric(chihuahua_el_salvador_honduras_merged$standard.el_salvador_honduras)


# chihuahua nicaragua (k)
chihuahua_nicaragua_merged <- merge(standard_chihuahua, standard_nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)
chihuahua_nicaragua_merged$standard.chihuahua<- as.numeric(chihuahua_nicaragua_merged$standard.chihuahua)
chihuahua_nicaragua_merged$standard.nicaragua <- as.numeric(chihuahua_nicaragua_merged$standard.nicaragua)


# durango guerrero (l)
durango_guerrero_merged <- merge(standard_durango, standard_guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)
durango_guerrero_merged$standard.durango<- as.numeric(durango_guerrero_merged$standard.durango)
durango_guerrero_merged$standard.guerrero <- as.numeric(durango_guerrero_merged$standard.guerrero)


# durango chiapas (m)
durango_chiapas_merged <- merge(standard_durango, standard_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)
durango_chiapas_merged$standard.durango<- as.numeric(durango_chiapas_merged$standard.durango)
durango_chiapas_merged$standard.chiapas <- as.numeric(durango_chiapas_merged$standard.chiapas)


# durango el_salvador_honduras (n)
durango_el_salvador_honduras_merged <- merge(standard_durango, standard_el_salvador_honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)
durango_el_salvador_honduras_merged$standard.durango<- as.numeric(durango_el_salvador_honduras_merged$standard.durango)
durango_el_salvador_honduras_merged$standard.el_salvador_honduras <- as.numeric(durango_el_salvador_honduras_merged$standard.el_salvador_honduras)


# durango nicaragua (o)
durango_nicaragua_merged <- merge(standard_durango, standard_nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)
durango_nicaragua_merged$standard.durango<- as.numeric(durango_nicaragua_merged$standard.durango)
durango_nicaragua_merged$standard.nicaragua <- as.numeric(durango_nicaragua_merged$standard.nicaragua)

# guerrero chiapas (p)
guerrero_chiapas_merged <- merge(standard_guerrero, standard_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)
guerrero_chiapas_merged$standard.guerrero <- as.numeric(guerrero_chiapas_merged$standard.guerrero)
guerrero_chiapas_merged$standard.chiapas <- as.numeric(guerrero_chiapas_merged$standard.chiapas)

# guerrero el_salvador_honduras (q)
guerrero_el_salvador_honduras_merged <- merge(standard_guerrero, standard_el_salvador_honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)
guerrero_el_salvador_honduras_merged$standard.guerrero <- as.numeric(guerrero_el_salvador_honduras_merged$standard.guerrero)
guerrero_el_salvador_honduras_merged$standard.el_salvador_honduras <- as.numeric(guerrero_el_salvador_honduras_merged$standard.el_salvador_honduras)

# guerrero nicaragua (r)
guerrero_nicaragua_merged <- merge(standard_guerrero, standard_nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)
guerrero_nicaragua_merged$standard.guerrero <- as.numeric(guerrero_nicaragua_merged$standard.guerrero)
guerrero_nicaragua_merged$standard.nicaragua <- as.numeric(guerrero_nicaragua_merged$standard.nicaragua)

# el_salvador_honduras chiapas (s)
el_salvador_honduras_chiapas_merged <- merge(standard_el_salvador_honduras, standard_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)
el_salvador_honduras_chiapas_merged$standard.el_salvador_honduras <- as.numeric(el_salvador_honduras_chiapas_merged$standard.el_salvador_honduras)
el_salvador_honduras_chiapas_merged$standard.chiapas <- as.numeric(el_salvador_honduras_chiapas_merged$standard.chiapas)

# nicaragua chiapas (t)
nicaragua_chiapas_merged <- merge(standard_nicaragua, standard_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)
nicaragua_chiapas_merged$standard.nicaragua <- as.numeric(nicaragua_chiapas_merged$standard.nicaragua)
nicaragua_chiapas_merged$standard.chiapas <- as.numeric(nicaragua_chiapas_merged$standard.chiapas)

# nicaragua el_salvador_honduras (u)
nicaragua_el_salvador_honduras_merged <- merge(standard_nicaragua, standard_el_salvador_honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)
nicaragua_el_salvador_honduras_merged$standard.nicaragua <- as.numeric(nicaragua_el_salvador_honduras_merged$standard.nicaragua)
nicaragua_el_salvador_honduras_merged$standard.el_salvador_honduras <- as.numeric(nicaragua_el_salvador_honduras_merged$standard.el_salvador_honduras)


standardized_spearman <- c()

# southwest_usa chihuahua plot 

## Return rows with NAs 

southwest_usa_chihuahua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_chihuahua_merged <- southwest_usa_chihuahua_merged %>%
    drop_na())

a <- ggplot(southwest_usa_chihuahua_merged, aes(x=standard.chihuahua, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.62", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chihuahua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Southwest USA")) +
  theme_cowplot(12)

standardized_spearman.a <- cor.test(southwest_usa_chihuahua_merged$standard.chihuahua, 
         southwest_usa_chihuahua_merged$standard.southwest_usa,
         method = "spearman")


standardized_spearman[1] <- as.numeric(standardized_spearman.a$estimate)

# southwest_usa durango plot 

## Return rows with NAs 

southwest_usa_durango_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_durango_merged <- southwest_usa_durango_merged %>%
    drop_na())

b <- ggplot(southwest_usa_durango_merged, aes(x=standard.durango, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.60", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Durango")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Southwest USA")) +
  theme_cowplot(12)

standardized_spearman.b <- cor.test(southwest_usa_durango_merged$standard.durango, 
         southwest_usa_durango_merged$standard.southwest_usa,
         method = "spearman")

standardized_spearman[2] <- as.numeric(standardized_spearman.b$estimate) 


# southwest_usa guerrero plot 

## Return rows with NAs 

southwest_usa_guerrero_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_guerrero_merged <- southwest_usa_guerrero_merged %>%
    drop_na())

c <- ggplot(southwest_usa_guerrero_merged, aes(x=standard.guerrero, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.32", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Southwest USA")) +
  theme_cowplot(12)

standardized_spearman.c <- cor.test(southwest_usa_guerrero_merged$standard.guerrero, 
         southwest_usa_guerrero_merged$standard.southwest_usa,
         method = "spearman")

standardized_spearman[3] <- as.numeric(standardized_spearman.c$estimate)


# southwest_usa chiapas plot 

## Return rows with NAs 

southwest_usa_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_chiapas_merged <- southwest_usa_chiapas_merged %>%
    drop_na())

d <- ggplot(southwest_usa_chiapas_merged, aes(x=standard.chiapas, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = -0.02", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Southwest USA")) +
  theme_cowplot(12)


standardized_spearman.d <- cor.test(southwest_usa_chiapas_merged$standard.chiapas, 
         southwest_usa_chiapas_merged$standard.southwest_usa,
         method = "spearman")


standardized_spearman[4] <- as.numeric(standardized_spearman.d$estimate)

# southwest_usa el_salvador_honduras plot 

## Return rows with NAs 

southwest_usa_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_el_salvador_honduras_merged <- southwest_usa_el_salvador_honduras_merged %>%
    drop_na())

e <- ggplot(southwest_usa_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.15, x = 1.20, label = "\u03C1 = -0.02", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "El Salvador Honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Southwest USA")) +
  theme_cowplot(12)

standardized_spearman.e <- cor.test(southwest_usa_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         southwest_usa_el_salvador_honduras_merged$standard.southwest_usa,
         method = "spearman")


standardized_spearman[5] <- as.numeric(standardized_spearman.e$estimate)

# southwest_usa nicaragua plot 

## Return rows with NAs 

southwest_usa_nicaragua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_nicaragua_merged <- southwest_usa_nicaragua_merged %>%
    drop_na())

f <- ggplot(southwest_usa_nicaragua_merged, aes(x=standard.nicaragua, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.0, x = 1.20, label = "\u03C1 = -0.04", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Southwest USA")) +
  theme_cowplot(12)

standardized_spearman.f <- cor.test(southwest_usa_nicaragua_merged$standard.nicaragua, 
         southwest_usa_nicaragua_merged$standard.southwest_usa,
         method = "spearman")


standardized_spearman[6] <- as.numeric(standardized_spearman.f$estimate)

# chihuahua durango plot 

## Return rows with NAs 

chihuahua_durango_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(chihuahua_durango_merged <- chihuahua_durango_merged %>%
    drop_na())

g <- ggplot(chihuahua_durango_merged, aes(x=standard.durango, y=standard.chihuahua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.58", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Durango")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chihuahua")) +
  theme_cowplot(12)

standardized_spearman.g <- cor.test(chihuahua_durango_merged$standard.durango, 
         chihuahua_durango_merged$standard.chihuahua,
         method = "spearman")

standardized_spearman[7] <- as.numeric(standardized_spearman.g$estimate)

# chihuahua guerrero plot 

## Return rows with NAs 

chihuahua_guerrero_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(chihuahua_guerrero_merged <- chihuahua_guerrero_merged %>%
    drop_na())

h <- ggplot(chihuahua_guerrero_merged, aes(x=standard.guerrero, y=standard.chihuahua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.30", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chihuahua")) +
  theme_cowplot(12)

standardized_spearman.h <- cor.test(chihuahua_guerrero_merged$standard.guerrero, 
         chihuahua_guerrero_merged$standard.chihuahua,
         method = "spearman")


standardized_spearman[8] <- as.numeric(standardized_spearman.h$estimate)
# chihuahua chiapas plot 

## Return rows with NAs 

chihuahua_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(chihuahua_chiapas_merged <- chihuahua_chiapas_merged %>%
    drop_na())

i <- ggplot(chihuahua_chiapas_merged, aes(x=standard.chiapas, y=standard.chihuahua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = -0.01", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chihuahua")) +
  theme_cowplot(12)



standardized_spearman.i <- cor.test(chihuahua_chiapas_merged$standard.chiapas, 
         chihuahua_chiapas_merged$standard.chihuahua,
         method = "spearman")


standardized_spearman[9] <- as.numeric(standardized_spearman.i$estimate)
# chihuahua el_salvador_honduras plot 

## Return rows with NAs 

chihuahua_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(chihuahua_el_salvador_honduras_merged <- chihuahua_el_salvador_honduras_merged %>%
    drop_na())

j <- ggplot(chihuahua_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.chihuahua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.15, x = 1.20, label = "\u03C1 = -0.03", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "El Salvador Honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chihuahua")) +
  theme_cowplot(12)

standardized_spearman.j <- cor.test(chihuahua_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         chihuahua_el_salvador_honduras_merged$standard.chihuahua,
         method = "spearman")

standardized_spearman[10] <- as.numeric(standardized_spearman.j$estimate)

# chihuahua nicaragua plot 

## Return rows with NAs 

chihuahua_nicaragua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(chihuahua_nicaragua_merged <- chihuahua_nicaragua_merged %>%
    drop_na())

k <- ggplot(chihuahua_nicaragua_merged, aes(x=standard.nicaragua, y=standard.chihuahua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.0, x = 1.20, label = "\u03C1 = -0.02", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chihuahua")) +
  theme_cowplot(12)

standardized_spearman.k <- cor.test(chihuahua_nicaragua_merged$standard.nicaragua, 
         chihuahua_nicaragua_merged$standard.chihuahua,
         method = "spearman")

standardized_spearman[11] <- as.numeric(standardized_spearman.k$estimate)

# durango guerrero plot 

## Return rows with NAs 

durango_guerrero_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(durango_guerrero_merged <- durango_guerrero_merged %>%
    drop_na())

l <- ggplot(durango_guerrero_merged, aes(x=standard.guerrero, y=standard.durango)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.29", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Durango")) +
  theme_cowplot(12)

standardized_spearman.l <- cor.test(durango_guerrero_merged$standard.guerrero, 
         durango_guerrero_merged$standard.durango,
         method = "spearman")


standardized_spearman[12] <- as.numeric(standardized_spearman.l$estimate)

# durango chiapas plot 

## Return rows with NAs 

durango_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(durango_chiapas_merged <- durango_chiapas_merged %>%
    drop_na())

m <- ggplot(durango_chiapas_merged, aes(x=standard.chiapas, y=standard.durango)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = -0.03", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Durango")) +
  theme_cowplot(12)


standardized_spearman.m <- cor.test(durango_chiapas_merged$standard.chiapas, 
         durango_chiapas_merged$standard.durango,
         method = "spearman")

standardized_spearman[13] <- as.numeric(standardized_spearman.m$estimate)

# durango el_salvador_honduras plot 

## Return rows with NAs 

durango_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(durango_el_salvador_honduras_merged <- durango_el_salvador_honduras_merged %>%
    drop_na())

n <- ggplot(durango_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.durango)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.15, x = 1.20, label = "\u03C1 = -0.04", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "El Salvador Honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Durango")) +
  theme_cowplot(12)

standardized_spearman.n <- cor.test(durango_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         durango_el_salvador_honduras_merged$standard.durango,
         method = "spearman")

standardized_spearman[14] <- as.numeric(standardized_spearman.n$estimate)
# durango nicaragua plot 

## Return rows with NAs 

durango_nicaragua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(durango_nicaragua_merged <- durango_nicaragua_merged %>%
    drop_na())

o <- ggplot(durango_nicaragua_merged, aes(x=standard.nicaragua, y=standard.durango)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.0, x = 1.20, label = "\u03C1 = -0.03", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Durango")) +
  theme_cowplot(12)

standardized_spearman.o <- cor.test(durango_nicaragua_merged$standard.nicaragua, 
         durango_nicaragua_merged$standard.durango,
         method = "spearman")

standardized_spearman[15] <- as.numeric(standardized_spearman.o$estimate)

# guerrero chiapas plot 

## Return rows with NAs 

guerrero_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(guerrero_chiapas_merged <- guerrero_chiapas_merged %>%
    drop_na())

p <- ggplot(guerrero_chiapas_merged, aes(x=standard.chiapas, y=standard.guerrero)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.009", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) +
  theme_cowplot(12)

standardized_spearman.p <- cor.test(guerrero_chiapas_merged$standard.chiapas, 
         guerrero_chiapas_merged$standard.guerrero,
         method = "spearman")

standardized_spearman[16] <- as.numeric(standardized_spearman.p$estimate)

# guerrero el_salvador_honduras plot 

## Return rows with NAs 

guerrero_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(guerrero_el_salvador_honduras_merged <- guerrero_el_salvador_honduras_merged %>%
    drop_na())

q <- ggplot(guerrero_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.guerrero)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.017", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "El Salvador Honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) +
  theme_cowplot(12)

standardized_spearman.q <- cor.test(guerrero_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         guerrero_el_salvador_honduras_merged$standard.guerrero,
         method = "spearman")

standardized_spearman[17] <- as.numeric(standardized_spearman.q$estimate)

# guerrero nicaragua plot 

## Return rows with NAs 

guerrero_nicaragua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(guerrero_nicaragua_merged <- guerrero_nicaragua_merged %>%
    drop_na())

r <- ggplot(guerrero_nicaragua_merged, aes(x=standard.nicaragua, y=standard.guerrero)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = -0.005", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) +
  theme_cowplot(12)

standardized_spearman.r <- cor.test(guerrero_nicaragua_merged$standard.nicaragua, 
         guerrero_nicaragua_merged$standard.guerrero,
         method = "spearman")


standardized_spearman[18] <- as.numeric(standardized_spearman.r$estimate)


# el_salvador_honduras chiapas plot 

## Return rows with NAs 

el_salvador_honduras_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(el_salvador_honduras_chiapas_merged <- el_salvador_honduras_chiapas_merged %>%
    drop_na())

s <- ggplot(el_salvador_honduras_chiapas_merged, aes(x=standard.chiapas, y=standard.el_salvador_honduras)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 0.5, label = "\u03C1 = 0.20", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "El Salvador Honduras")) +
  theme_cowplot(12)

standardized_spearman.s <- cor.test(el_salvador_honduras_chiapas_merged$standard.chiapas, 
         el_salvador_honduras_chiapas_merged$standard.el_salvador_honduras,
         method = "spearman")

standardized_spearman[19] <- as.numeric(standardized_spearman.s$estimate)

# nicaragua chiapas plot 

## Return rows with NAs 

nicaragua_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(nicaragua_chiapas_merged <- nicaragua_chiapas_merged %>%
    drop_na())

t <- ggplot(nicaragua_chiapas_merged, aes(x=standard.chiapas, y=standard.nicaragua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.07", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) +
  theme_cowplot(12)

standardized_spearman.t <- cor.test(nicaragua_chiapas_merged$standard.chiapas, 
         nicaragua_chiapas_merged$standard.nicaragua,
         method = "spearman")

standardized_spearman[20] <- as.numeric(standardized_spearman.t$estimate)


# nicaragua el_salvador_honduras plot 

## Return rows with NAs 

nicaragua_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(nicaragua_el_salvador_honduras_merged <- nicaragua_el_salvador_honduras_merged %>%
    drop_na())

u <- ggplot(nicaragua_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.nicaragua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.22", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "El Salvador Honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) +
  theme_cowplot(12)

standardized_spearman.u <- cor.test(nicaragua_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         nicaragua_el_salvador_honduras_merged$standard.nicaragua,
         method = "spearman")

standardized_spearman[21] <- as.numeric(standardized_spearman.u$estimate) 


pairwise_comps <- c("southwest_usa_chihuahua","southwest_usa_durango", "southwest_usa_guerrero", 
                    "southwest_usa_chiapas", "southwest_usa_el_salvador_honduras","southwest_usa_nicaragua", 
                    "chihuahua_durango", "chihuahua_guerrero", "chihuahua_chiapas", 
                    "chihuahua_el_salvador_honduras", "chihuahua_nicaragua", "durango_guerrero", 
                    "durango_chiapas", "durango_el_salvador_honduras", "durango_nicaragua",  
                    "guerrero_chiapas", "guerrero_el_salvador_honduras", "guerrero_nicaragua", 
                    "el_salvador_honduras_chiapas", "nicaragua_chiapas", "nicaragua_el_salvador_honduras")

pairwise_standardized_spearman <- as.data.frame(cbind(pairwise_comps, standardized_spearman))

write.table(pairwise_standardized_spearman, file = "standardized_spearman_pairwise_comps.txt", sep = "\t")


divergence_times <- read.table(file = "tau_divergence_times.txt")

delta_effective_population_sizes <- c(7.86,
                                2.63, 
                                15.576,
                                7.07,
                                28.532,
                                32.24,
                                5.23,
                                23.436,
                                14.93,
                                36.392,
                                40.1,
                                18.206,
                                9.7,
                                31.162,
                                34.87,
                                8.506,
                                12.956,
                                16.664,
                                21.462,
                                25.17,
                                3.708)

plot(standardized_spearman, divergence_times$divergence_times_total)

plot(standardized_spearman, delta_effective_population_sizes)

cor.test(standardized_spearman, delta_effective_population_sizes)

plot(divergence_times$divergence_times_total, delta_effective_population_sizes)

cor.test(divergence_times$divergence_times_total, delta_effective_population_sizes)

pattern <- c("a","b","c","d", "e", "f", "g", "h", "i", "j", "k")

pattern1 <- c("l", "m", "n", "o", "p", "q", "r", "s", "t", "u")

plot_grid(plotlist = mget(pattern), ncol = 4, labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'))

ggsave(filename = "standardized_pi_correlations.pdf")

plot_grid(plotlist = mget(pattern1), ncol = 4, labels = c('L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U'))

ggsave(filename = "standardized_pi_correlations1.pdf")






# standardized nucleotide plots, ranked by tau (divergence estimate)


# southwest_usaguerrero plot 

## Return rows with NAs 

southwest_usa_guerrero_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_guerrero_merged <- southwest_usa_guerrero_merged %>%
    drop_na())

a <- ggplot(southwest_usa_guerrero_merged, aes(x=standard.guerrero, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = 0.31", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "southwest_usa")) +
  theme_cowplot(12)

cor.test(southwest_usa_guerrero_merged$standard.guerrero, 
         southwest_usa_guerrero_merged$standard.southwest_usa,
         method = "spearman")

# southwest_usachiapas plot 

## Return rows with NAs 

southwest_usa_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_chiapas_merged <- southwest_usa_chiapas_merged %>%
    drop_na())

f <- ggplot(southwest_usa_chiapas_merged, aes(x=standard.chiapas, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.25, label = "\u03C1 = - 0.02", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "southwest_usa")) +
  theme_cowplot(12)


cor.test(southwest_usa_chiapas_merged$standard.chiapas, 
         southwest_usa_chiapas_merged$standard.southwest_usa,
         method = "spearman")

# southwest_usael_salvador_honduras plot 

## Return rows with NAs 

southwest_usa_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_el_salvador_honduras_merged <- southwest_usa_el_salvador_honduras_merged %>%
    drop_na())

b <- ggplot(southwest_usa_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.15, x = 1.20, label = "\u03C1 = 0.001", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "el_salvador_honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "southwest_usa")) +
  theme_cowplot(12)

cor.test(southwest_usa_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         southwest_usa_el_salvador_honduras_merged$standard.southwest_usa,
         method = "spearman")


# southwest_usanicaragua plot 

## Return rows with NAs 

southwest_usa_nicaragua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(southwest_usa_nicaragua_merged <- southwest_usa_nicaragua_merged %>%
    drop_na())

h <- ggplot(southwest_usa_nicaragua_merged, aes(x=standard.nicaragua, y=standard.southwest_usa)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.0, x = 1.20, label = "\u03C1 = - 0.04", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "southwest_usa")) +
  theme_cowplot(12)

cor.test(southwest_usa_nicaragua_merged$standard.nicaragua, 
         southwest_usa_nicaragua_merged$standard.southwest_usa,
         method = "spearman")

# guerrero chiapas plot 

## Return rows with NAs 

guerrero_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(guerrero_chiapas_merged <- guerrero_chiapas_merged %>%
    drop_na())

g <- ggplot(guerrero_chiapas_merged, aes(x=standard.chiapas, y=standard.guerrero)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = - 0.0008", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(guerrero_chiapas_merged$standard.chiapas, 
         guerrero_chiapas_merged$standard.guerrero,
         method = "spearman")

# guerrero el_salvador_honduras plot 

## Return rows with NAs 

guerrero_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(guerrero_el_salvador_honduras_merged <- guerrero_el_salvador_honduras_merged %>%
    drop_na())

c <- ggplot(guerrero_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.guerrero)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.00007", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "el_salvador_honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(guerrero_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         guerrero_el_salvador_honduras_merged$standard.guerrero,
         method = "spearman")

# guerrero nicargua plot 

## Return rows with NAs 

guerrero_nicaragua_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(guerrero_nicaragua_merged <- guerrero_nicaragua_merged %>%
    drop_na())

i <- ggplot(guerrero_nicaragua_merged, aes(x=standard.nicaragua, y=standard.guerrero)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = - 0.01", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(guerrero_nicaragua_merged$standard.nicaragua, 
         guerrero_nicaragua_merged$standard.guerrero,
         method = "spearman")



# el_salvador_honduras chiapas plot 

## Return rows with NAs 

el_salvador_honduras_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(el_salvador_honduras_chiapas_merged <- el_salvador_honduras_chiapas_merged %>%
    drop_na())

e <- ggplot(el_salvador_honduras_chiapas_merged, aes(x=standard.chiapas, y=standard.el_salvador_honduras)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 0.5, label = "\u03C1 = 0.19", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "el_salvador_honduras")) +
  theme_cowplot(12)

cor.test(el_salvador_honduras_chiapas_merged$standard.chiapas, 
         el_salvador_honduras_chiapas_merged$standard.el_salvador_honduras,
         method = "spearman")

# nicaragua chiapas plot 

## Return rows with NAs 

nicaragua_chiapas_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(nicaragua_chiapas_merged <- nicaragua_chiapas_merged %>%
    drop_na())

j <- ggplot(nicaragua_chiapas_merged, aes(x=standard.chiapas, y=standard.nicaragua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.06", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Chiapas")) +
  theme_cowplot(12)

cor.test(nicaragua_chiapas_merged$standard.chiapas, 
         nicaragua_chiapas_merged$standard.nicaragua,
         method = "spearman")


# nicaragua el_salvador_honduras plot 

## Return rows with NAs 

nicaragua_el_salvador_honduras_merged %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(nicaragua_el_salvador_honduras_merged <- nicaragua_el_salvador_honduras_merged %>%
    drop_na())

d <- ggplot(nicaragua_el_salvador_honduras_merged, aes(x=standard.el_salvador_honduras, y=standard.nicaragua)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 1.20, x = 1.15, label = "\u03C1 = 0.21", size =4) +
  xlab(expression(italic(pi)/italic(D)[XY] ~ "el_salvador_honduras")) + 
  ylab(expression(italic(pi)/italic(D)[XY] ~ "Nicaragua")) +
  theme_cowplot(12)

cor.test(nicaragua_el_salvador_honduras_merged$standard.el_salvador_honduras, 
         nicaragua_el_salvador_honduras_merged$standard.nicaragua,
         method = "spearman")






pattern <- c("a","b","c","d", "e", "f", "g", "h", "i", "j")

plot_grid(plotlist = mget(pattern), ncol = 4, labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'))


ggsave("standardized_diversity_pairwise_tau_ranked.pdf")


## Landscapes of standardized diversity, including Z chromosome 


# proper chromosome order 

chromosome_order <- c("CM027507.1", "CM027536.1", "CM027508.1", "CM027509.1", 
                      "CM027510.1", "CM027537.1", "CM027511.1","CM027512.1", 
                      "CM027513.1","CM027514.1","CM027515.1", 
                      "CM027516.1","CM027517.1","CM027518.1", 
                      "CM027519.1", "CM027520.1","CM027521.1","CM027522.1",
                      "CM027523.1", "CM027524.1", "CM027525.1", "CM027526.1", 
                      "CM027527.1", "CM027528.1", "CM027529.1", "CM027530.1",
                      "CM027531.1", "CM027532.1", "CM027533.1", "CM027535.1")

chromosome_names <- c("1", "1A", "2", "3", "4", "4A", "5", "6", "7", 
                      "8", "9", "10", "11", "12", "13", "14", "15", 
                      "17", "18", "19", "20", "21", "22", "23", "24", "25", 
                      "26", "27", "28", "Z")







# set up plotting dimensions
par(mfrow=c(7,1))
par(mar=c(2,5,1.5,0))

# Plot pi's for Nicaragua Pop

total_windows <- nrow(standard_nicaragua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_nicaragua <- na.omit(standard_nicaragua)

# sort dataset by chromosome and within chromosome window order

standard_nicaragua1 <- ddply(standard_nicaragua, c('start'))

standard_nicaragua2 <- ddply(standard_nicaragua1, c('chr'))

standard_nicaragua3 <- left_join(data.frame(chr = chromosome_order), standard_nicaragua2, by = "chr")

standard_nicaragua <- standard_nicaragua3

chr <- unique(standard_nicaragua[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_nicaragua)[standard_nicaragua[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi 
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, 
     ylab=expression(italic(pi)/italic(D)[XY]), main = "Nicaragua")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_nicaragua), standard_nicaragua$standard.nicaragua, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_nicaragua[b_rep,1] %in% standard_nicaragua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_nicaragua)))
  total_rep <- c(total_rep, mean(as.numeric(standard_nicaragua$standard.nicaragua[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))


# Plot pi's for el_salvador_honduras Pop

total_windows <- nrow(standard_el_salvador_honduras)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_el_salvador_honduras <- na.omit(standard_el_salvador_honduras)

# sort dataset by chromosome and within chromosome window order

standard_el_salvador_honduras1 <- ddply(standard_el_salvador_honduras, c('start'))

standard_el_salvador_honduras2 <- ddply(standard_el_salvador_honduras1, c('chr'))

standard_el_salvador_honduras3 <- left_join(data.frame(chr = chromosome_order), standard_el_salvador_honduras2, by = "chr")

standard_el_salvador_honduras <- standard_el_salvador_honduras3

chr <- unique(standard_el_salvador_honduras[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_el_salvador_honduras)[standard_el_salvador_honduras[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3,
     ylab=expression(italic(pi)/italic(D)[XY]), main = "El Salvador Honduras")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_el_salvador_honduras), standard_el_salvador_honduras$standard.el_salvador_honduras, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_el_salvador_honduras[b_rep,1] %in% standard_el_salvador_honduras[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_el_salvador_honduras)))
  total_rep <- c(total_rep, mean(as.numeric(standard_el_salvador_honduras$standard.el_salvador_honduras[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))


# Plot pi's for Chiapas Pop

total_windows <- nrow(standard_chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_chiapas <- na.omit(standard_chiapas)

# sort dataset by chromosome and within chromosome window order

standard_chiapas1 <- ddply(standard_chiapas, c('start'))

standard_chiapas2 <- ddply(standard_chiapas1, c('chr'))

standard_chiapas3 <- left_join(data.frame(chr = chromosome_order), standard_chiapas2, by = "chr")

standard_chiapas <- standard_chiapas3

chr <- unique(standard_chiapas[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_chiapas)[standard_chiapas[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, 
     ylab=expression(italic(pi)/italic(D)[XY]), main = "Chiapas")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_chiapas), standard_chiapas$standard.chiapas, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_chiapas[b_rep,1] %in% standard_chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_chiapas)))
  total_rep <- c(total_rep, mean(as.numeric(standard_chiapas$standard.chiapas[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")





# Plot pi's for Guerrero Pop

total_windows <- nrow(standard_guerrero)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_guerrero <- na.omit(standard_guerrero)

# sort dataset by chromosome and within chromosome window order

standard_guerrero1 <- ddply(standard_guerrero, c('start'))

standard_guerrero2 <- ddply(standard_guerrero1, c('chr'))

standard_guerrero3 <- left_join(data.frame(chr = chromosome_order), standard_guerrero2, by = "chr")

standard_guerrero <- standard_guerrero3

chr <- unique(standard_guerrero[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_guerrero)[standard_guerrero[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, 
     cex.lab=1.3, ylab=expression(italic(pi)/italic(D)[XY]), main = "Guerrero")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_guerrero), standard_guerrero$standard.guerrero, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_guerrero[b_rep,1] %in% standard_guerrero[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_guerrero)))
  total_rep <- c(total_rep, mean(as.numeric(standard_guerrero$standard.guerrero[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")



# Plot pi for durango Pop

total_windows <- nrow(standard_durango)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_durango<- na.omit(standard_durango)

# sort dataset by chromosome and within chromosome window order

standard_durango1 <- ddply(standard_durango, c('start'))

standard_durango2 <- ddply(standard_durango1, c('chr'))

standard_durango3 <- left_join(data.frame(chr = chromosome_order), standard_durango2, by = "chr")

standard_durango<- standard_durango3

chr <- unique(standard_durango[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_durango)[standard_durango[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", 
     cex.axis=1.1, cex.lab=1.3, ylab=expression(italic(pi)/italic(D)[XY]), main = "Durango")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_durango), standard_durango$standard.durango, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_durango[b_rep,1] %in% standard_durango[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_durango)))
  total_rep <- c(total_rep, mean(as.numeric(standard_durango$standard.durango[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")




# Plot pi for chihuahua Pop

total_windows <- nrow(standard_chihuahua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_chihuahua<- na.omit(standard_chihuahua)

# sort dataset by chromosome and within chromosome window order

standard_chihuahua1 <- ddply(standard_chihuahua, c('start'))

standard_chihuahua2 <- ddply(standard_chihuahua1, c('chr'))

standard_chihuahua3 <- left_join(data.frame(chr = chromosome_order), standard_chihuahua2, by = "chr")

standard_chihuahua<- standard_chihuahua3

chr <- unique(standard_chihuahua[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_chihuahua)[standard_chihuahua[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", 
     cex.axis=1.1, cex.lab=1.3, ylab=expression(italic(pi)/italic(D)[XY]), main = "Chihuahua")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_chihuahua), standard_chihuahua$standard.chihuahua, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_chihuahua[b_rep,1] %in% standard_chihuahua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_chihuahua)))
  total_rep <- c(total_rep, mean(as.numeric(standard_chihuahua$standard.chihuahua[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")


# Plot pi for southwest_usa Pop

total_windows <- nrow(standard_southwest_usa)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
standard_southwest_usa<- na.omit(standard_southwest_usa)

# sort dataset by chromosome and within chromosome window order

standard_southwest_usa1 <- ddply(standard_southwest_usa, c('start'))

standard_southwest_usa2 <- ddply(standard_southwest_usa1, c('chr'))

standard_southwest_usa3 <- left_join(data.frame(chr = chromosome_order), standard_southwest_usa2, by = "chr")

standard_southwest_usa<- standard_southwest_usa3

chr <- unique(standard_southwest_usa[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(standard_southwest_usa)[standard_southwest_usa[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1.2), c(a1, 1.2), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,1.2), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", 
     cex.axis=1.1, cex.lab=1.3, ylab=expression(italic(pi)/italic(D)[XY]), main = "Southwest USA")
odd <- 0

for(a in 1:length(chr_polygons_pi)) {
  if(odd == 1) {
    polygon(chr_polygons_pi[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}
# plot

points(rownames(standard_southwest_usa), standard_southwest_usa$standard.southwest_usa, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[standard_southwest_usa[b_rep,1] %in% standard_southwest_usa[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(standard_southwest_usa)))
  total_rep <- c(total_rep, mean(as.numeric(standard_southwest_usa$standard.southwest_usa[b_rep])))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")
