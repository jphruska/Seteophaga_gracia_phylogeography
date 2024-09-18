## Calculate pairwise Nei's genetic distances (Nei 1972) using StAMMP. This matrix will then be used to 
## create a phylogenetic network (neighbor net) in SplitsTree4. 

## Function to be used is called stamppNeisD, which takes as input a data in genlight format. 

## Workflow here based heavily on https://github.com/DevonDeRaad/aph.rad/blob/master/splitstree.prep.R. 


library(vcfR)
library(adegenet)
library(StAMPP)

#read in vcfR
vcfR <- read.vcfR("setophaga_15a_admixture.vcf")

# read in csv that contains individual IDs and population IDs 
inds <- read.csv("pop.ind.setophaga.csv")

#convert to gen
gen<-vcfR2genlight(vcfR)

#define populations (must be defined for stamppNeisD despite pop information not being used)
pop(gen) <- inds$popID

#calculate pairwise genetic distance matrix among all individuals
neid <- stamppNeisD(gen, pop = FALSE)

#export for splitstree
stamppPhylip(distance.mat=neid, file="./setophaga.dataset15a.splits.txt")
