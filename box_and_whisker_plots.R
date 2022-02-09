## Script to make box and whisker and scatter plots for  whole genome heterozygosity estimates per individual). 

library(tidyverse)

## heterozygosity by species boxplot 

het <- read.csv(file = "setophaga_het.csv", header= T, sep = ,)

het$Location <- factor(het$Location, levels= c("NIC", "ELS", "HON", "BEL", "CHI", 
                                           "GUE", "DUR", "CHIH", "ARI", "NM", 
                                           "NEV", "COL"))

ggplot(het, aes(x=Location, y=Heterozygosity)) + 
  geom_point(aes(col = Location)) +
  geom_boxplot()

## heterozygosity by species scatter plot

ggplot(het, aes(x=Location, y=Heterozygosity)) + 
  geom_jitter(aes(col = Location), width = 0.05)
  
