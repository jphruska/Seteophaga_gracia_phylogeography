## The objective of this script is to infer what might be the 'background' heterozygosity rate in the Setophaga graciae individuals, 
## in aims of using this information to set a more informed rohmu (heterozygosity rate tolerated in ROHs) parameter in ROHan. 
## A lot of this inspired by a conversation started by Jordan Bemmels on the ROHan github repo (https://github.com/grenaud/ROHan/issues/12). 

library(dplyr)
## read in estimates of heterozygosity (previously estimated)

het <- read.table("het_setophaga.txt", header = T, sep = "\t")

## read in het table (summarized per individual)

het1 <- read.table("setophaga_het.csv", header = T, sep = ",")

## sort het1 by heterozygosity, in decreasing order (to identify lowest ranking individuals, by heterozygosity)

het1.sorted <- het1[order(het1$Heterozygosity, decreasing = F),]

## five lowest ranking individuals (by heterozygosity)

lowest.ranking.het <- as.factor(het1.sorted$Individual[1:5])

# make empty lists 

het.lowest.ranking.individuals <- list()

het.lowest.ranking.individuals.1 <- df()

# subset het by lowest ranking individuals 
for (i in seq (1,5)) {
  #subset
  het.lowest.ranking.individuals[[i]] <- het[het$pop1 == het1.sorted$Individual[i],]
}

## combine lists 

combined.data.frame <- bind_rows(het.lowest.ranking.individuals[[1]], het.lowest.ranking.individuals[[2]], 
                                 het.lowest.ranking.individuals[[3]], het.lowest.ranking.individuals[[4]], 
                                 het.lowest.ranking.individuals[[5]])

# plot histogram 

hist(combined.data.frame$calculated_stat)

hist(log(combined.data.frame$calculated_stat))

## subset dataframe to only include values between  0.00 and 0.005

combined.data.frame.subset <- combined.data.frame[combined.data.frame$calculated_stat > 0.0000,]

combined.data.frame.subset1 <- combined.data.frame.subset[combined.data.frame.subset$calculated_stat < 0.01,]

combined.data.frame.subset2 <- combined.data.frame.subset1[combined.data.frame.subset1$calculated_stat < 0.002,]
  
hist(log(combined.data.frame.subset2$calculated_stat))


## histogram of windows across all individuals. Select only the bottom 15th percentile of windows 
hist(het$calculated_stat)
hist(log(het$calculated_stat))
abline(v=log(1e-3), col = "red")


filtered.hist.015 <- het[het$calculated_stat < quantile(het$calculated_stat, 0.15),]

hist(filtered.hist.015$calculated_stat, xlab = "Heterozygosity", main = "Heterozygosity Bottom 15% Quantile")

abline(v=2e-4, col = "red")

## 

hist(log(het.lowest.ranking.individuals[[1]]$calculated_stat))
hist(log(het.lowest.ranking.individuals[[2]]$calculated_stat))
hist(log(het.lowest.ranking.individuals[[3]]$calculated_stat))
hist(log(het.lowest.ranking.individuals[[4]]$calculated_stat))
hist(log(het.lowest.ranking.individuals[[5]]$calculated_stat))


# read in pi estimates (all individuals)

pi <- read.table("pi_setophaga.txt", sep = "\t", header = T)

hist(pi$calculated_stat)

filtered.pi.hist.005 <- pi[pi$calculated_stat < quantile(pi$calculated_stat, 0.05, na.rm = TRUE),]
abline(v=2e-4, col = "red")
