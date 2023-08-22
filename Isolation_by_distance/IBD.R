# Isolation by distance analysis using Mantel correlation test between genetic and geographical distances. 
# Both of these distances are calcualated at the individual level. 


# load required libraries

library(adegenet)
library(ade4)
library(MASS)
library(dartR)
library(vcfR)
library(StAMPP)

# order of individuals in the vcf 

# Setophaga_graciae_CM_S10255_BEL	Setophaga_graciae_CM_S9116_BEL	
# Setophaga_graciae_DMNS_52524_COL	Setophaga_graciae_KU_33633_RACN	
# Setophaga_graciae_KU_33634_RACN	Setophaga_graciae_KU_8199_SANA	
# Setophaga_graciae_KU_8218_SANA	Setophaga_graciae_UWBM_105736_ARI	
# Setophaga_graciae_UWBM_106758_NM	Setophaga_graciae_UWBM_106760_NM	
# Setophaga_graciae_UWBM_108714_NEV	Setophaga_graciae_UWBM_111891_NM	
# Setophaga_graciae_UWBM_111896_NM		
# Setophaga_graciae_UWBM_112576_GUE	Setophaga_graciae_UWBM_112587_GUE	
# Setophaga_graciae_UWBM_112592_GUE	Setophaga_graciae_UWBM_113059_CHI	
# Setophaga_graciae_UWBM_113126_CHI	Setophaga_graciae_UWBM_113970_DUR	
# Setophaga_graciae_UWBM_114011_DUR	Setophaga_graciae_UWBM_114012_DUR	
# Setophaga_graciae_UWBM_114019_DUR	Setophaga_graciae_UWBM_114038_DUR	
#	Setophaga_graciae_UWBM_114046_DUR	
# Setophaga_graciae_UWBM_114047_DUR	Setophaga_graciae_UWBM_114087_CHIH	
# Setophaga_graciae_UWBM_114088_CHIH	Setophaga_graciae_UWBM_114090_CHIH	
# Setophaga_graciae_UWBM_114091_CHIH	Setophaga_graciae_UWBM_114126_CHIH	
# Setophaga_graciae_UWBM_114127_CHIH	Setophaga_graciae_UWBM_114128_CHIH	
# Setophaga_graciae_UWBM_114282_NEV	Setophaga_graciae_UWBM_114424_NEV	
# Setophaga_graciae_UWBM_115308_GUE	Setophaga_graciae_UWBM_69981_PCA	
# Setophaga_graciae_UWBM_77653_ARI	Setophaga_graciae_UWBM_77735_ARI	
# Setophaga_graciae_UWBM_84639_ARI	Setophaga_graciae_UWBM_93801_CPN	
# Setophaga_graciae_UWBM_93805_CPN	Setophaga_graciae_UWBM_93806_CPN	
# Setophaga_graciae_UWBM_93807_CPN	Setophaga_graciae_UWBM_93808_CPN	
# Setophaga_graciae_UWBM_95850_ARI


# import coordinates file (two columns: lat and long)

coords <- read.csv("setophaga_lat_long.csv", header = T)

coords <- coords[,-4]

coords <- coords[,-1]

# calculate euclidean (geographic) distance between points 

dgeo <- dist(coords)

# read in vcf and caclulate nei's distance 

#read in vcfR
vcfR <- read.vcfR("setophaga_15a_admixture.vcf")

# read in csv that contains individual IDs and population IDs 
inds <- read.csv("pop.ind.setophaga.csv")

#convert to gen
gen<-vcfR2genlight(vcfR)

#define populations
pop(gen) <- inds$popID

#calculate pairwise genetic distance matrix among all individuals
neid <- stamppNeisD(gen, pop = FALSE)

### create the dist objects
colnames(neid) <- rownames(neid) 
neid.dist<-as.dist(neid, diag=T)
attr(neid.dist, "Labels")<-rownames(neid) # name the rows of a matrix  

# IBD 

IBD <- mantel.randtest(dgeo,neid.dist, nrepet = 999)

par(mfrow=c(1,2))

#plot(dgeo,neid.dist, pch=20,cex=1, col="black")

#abline(lm(neid.dist~dgeo), col = "blue")

IBD

#plot and check for denser areas in the plot indicating sub-groups
dens <- kde2d(dgeo,neid.dist, n = 300) 
myPal <- colorRampPalette(c("white","blue","gold", "orange", "red"))
plot(dgeo, neid.dist, pch=20,cex=1.8, ylab = "Genetic Distance (Nei)", xlab = "Geographical Distance (Euclidean)")
image(dens, col=transp(myPal(300),.4), add=TRUE)

abline(lm(neid.dist~dgeo), col = "blue")

# plot the histogram of permutations for significance

plot(IBD, main = "", xlab = "Simulated Values (Mantel's r)")

# isolation by distance mantel test by population 


#read in vcfR
# vcfR1 <- read.vcfR("setophaga_1a_admix.vcf")

#convert to genind
# gen1<-vcfR2genind(vcfR1)

# read in csv that contains individual IDs and population IDs 
# inds1 <- read.csv("pop.ind.setophaga.csv")

#define populations
# pop(gen1) <- inds1$popID

# convert genind to genpop

#gen1.1 <- genind2genpop(gen1)

# Dgen <- dist.genpop(gen1.1, method = 2)

# import coordinates file (two columns: lat and long)

# coords1 <- read.csv("setophaga_lat_long.csv", header = T)

# coords1 <- coords1[,-4]

# coords1 <- coords1[,-1]

# add population labels to coords1

# coords1$pop <- inds1$popID


# calculate average latitude and longitude per population 


# pops <- c('belize', 'northern', 'nicaragua', 'central', 'guerrero', 'durango', 'chihuahua')
# coord1.1 <- list()
# mean.lat <- c()
# mean.lon <- c()

# for (i in 1:length(pops)) {
  # subset out population
  # coord1.1[[i]] <- coords1[coords1$pop==pops[i],]
  # remove header 
  # colnames(coord1.1[[i]]) <- ""
  # calculate mean lat 
   #mean.lat[i] <- mean((coord1.1[[i]][,1]))
  # calculate mean lon
  # mean.lon[i] <- mean((coord1.1[[i]][,2]))
  # print(i)
# }

#lat.long.pop <- as.data.frame(cbind(mean.lat,mean.lon,pops))

#lat.long.pop$mean.lat <- as.numeric(lat.long.pop$mean.lat)

#lat.long.pop$mean.lon <- as.numeric(lat.long.pop$mean.lon)

#lat.long.pop <- lat.long.pop[,-3]

# calculate euclidean (geographic) distance between populations 

#dgeo1 <- dist(lat.long.pop)

#ibd1 <- mantel.randtest(Dgen, dgeo1)

#plot(dgeo1, Dgen, pch=20,cex=1.8, ylab = "Genetic Distance (Nei)", xlab = "Geographical Distance (Euclidean)")

