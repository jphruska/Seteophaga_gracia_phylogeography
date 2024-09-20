# Calculating Reich FST (pairwise) for populations across the range of Setophaga graciae. 


# load required packages 
library(adegenet)
library(dartR)
library(SNPRelate)
library(beepr)
library(dplyr)
library(matrixStats)
library(reshape2)

## reich fst estimator (copied from Jessica Rick GitHub Repo: https://github.com/jessicarick/reich-fst)
## vectorized version
## input=genlight object
## FST will be calculated between pops in genlight object
## specify number of bootstraps using "bootstrap=100"

reich.fst <- function(gl, bootstrap=FALSE, plot=FALSE, verbose=TRUE) { 
  if (!require("matrixStats",character.only=T, quietly=T)) {
    install.packages("matrixStats")
    library(matrixStats, character.only=T)
  }
  if (!require("dplyr",character.only=T, quietly=T)) {
    install.packages("dplyr")
    library(dplyr, character.only=T)
  }
  
  nloc <- gl@n.loc
  npop <- length(levels(gl@pop))
  
  fsts <- matrix(nrow=npop,
                 ncol=npop,
                 dimnames=list(levels(gl@pop),levels(gl@pop)))
  
  if (bootstrap != FALSE){
    n.bs <- bootstrap
    bs <- data.frame(matrix(nrow=nrow(combinat::combn2(levels(gl@pop))),
                            ncol=n.bs+5))
  }
  
  k <- 0
  
  for (p1 in levels(gl@pop)){
    for (p2 in levels(gl@pop)){          
      if (which(levels(gl@pop) == p1) < which(levels(gl@pop) == p2)) {
        k <- 1+k
        
        pop1 <- gl.keep.pop(gl, p1, mono.rm=FALSE, v=0)
        pop2 <- gl.keep.pop(gl, p2, mono.rm=FALSE, v=0)
        
        a1 <- colSums2(as.matrix(pop1),na.rm=T)
        a2 <- colSums2(as.matrix(pop2),na.rm=T)
        n1 <- apply(as.matrix(pop1),2,function(x) 2*sum(!is.na(x)))
        n2 <- apply(as.matrix(pop2),2,function(x) 2*sum(!is.na(x)))
        
        h1 <- (a1*(n1-a1))/(n1*(n1-1))
        h2 <- (a2*(n2-a2))/(n2*(n2-1))
        
        N <- (a1/n1 - a2/n2)^2 - h1/n1 - h2/n2
        D <- N + h1 + h2
        
        F <- sum(N, na.rm=T)/sum(D, na.rm=T)
        fsts[p2,p1] <- F
        if (verbose == TRUE) {
          print(paste("Pop1: ",p1,", Pop2: ",p2,", Reich FST: ",F,sep=""))
        }
        
        if (bootstrap != FALSE) {
          if (verbose == TRUE) {
            print("beginning bootstrapping")
          }
          
          bs[k,1:3] <- c(p2,p1,as.numeric(F))
          
          for (i in 1:n.bs){
            loci <- sample((1:nloc), nloc, replace=TRUE)
            
            pop1.bs <- matrix(as.matrix(pop1)[,loci],
                              ncol=length(loci))
            pop2.bs <- matrix(as.matrix(pop2)[,loci],
                              ncol=length(loci))
            
            a1 <- colSums2(as.matrix(pop1.bs),na.rm=T)
            a2 <- colSums2(as.matrix(pop2.bs),na.rm=T)
            n1 <- apply(as.matrix(pop1.bs),2,function(x) 2*sum(!is.na(x)))
            n2 <- apply(as.matrix(pop2.bs),2,function(x) 2*sum(!is.na(x)))
            
            h1 <- (a1*(n1-a1))/(n1*(n1-1))
            h2 <- (a2*(n2-a2))/(n2*(n2-1))
            
            N <- (a1/n1 - a2/n2)^2 - h1/n1 - h2/n2
            D <- N + h1 + h2
            
            F.bs <- sum(N, na.rm=T)/sum(D, na.rm=T)
            bs[k,i+5] <- F.bs
          }
          if (verbose == TRUE){
            print(paste("bootstrapping 95% CI: ",
                        quantile(bs[k,6:(n.bs+5)],0.025,na.rm=T),"-",
                        quantile(bs[k,6:(n.bs+5)],0.975,na.rm=T)))
          }
          
          bs[k,4:5] <- c(quantile(bs[k,6:(n.bs+5)],0.025,na.rm=T),
                         quantile(bs[k,6:(n.bs+5)],0.975,na.rm=T))
        }
        
      }
    }
  }
  
  fsts[fsts < 0] <- 0
  
  if (bootstrap != FALSE){
    colnames(bs)[1:5] <- c("pop1","pop2","fst_estimate","min_CI","max_CI")
    fst.list <- list(fsts,bs)
    names(fst.list) <- c("fsts","bootstraps")
    
    if (plot == TRUE){
      print("drawing plot with bootstraps")
      
      if (!require("ggplot2",character.only=T, quietly=T)) {
        install.packages("ggplot2")
        library(ggplot2, character.only=T)
      }
      
      plot.data <- bs[,1:5]
      plot.data$fst_estimate <- as.numeric(plot.data$fst_estimate)
      plot.data$min_CI <- as.numeric(plot.data$min_CI)
      plot.data$max_CI <- as.numeric(plot.data$max_CI)
      plot.data$pop_pair <- paste(plot.data$pop1,plot.data$pop2,sep="_")
      plot.data$signif <- case_when(plot.data$min_CI > 0 ~ TRUE,
                                    TRUE ~ FALSE)
      
      
      bs.plot <- ggplot(plot.data, aes(x=pop_pair,y=fst_estimate,col=signif)) + 
        geom_point(size=2) + 
        coord_flip() + 
        geom_errorbar(aes(ymin=min_CI,ymax=max_CI),width=0.1,size=1) + 
        geom_hline(yintercept=0, lty=2, lwd=1, col="gray50") + 
        theme_minimal() + 
        theme(legend.position="none")
      
      print(bs.plot)
    }
  } else {
    fst.list <- list(fsts)
    names(fst.list) <- "fsts"
    
    if (plot == TRUE){
      print("drawing plot without bootstraps")
      
      if (!require("ggplot2",character.only=T, quietly=T)) {
        install.packages("ggplot2")
        library(ggplot2, character.only=T)
      }
      
      plot.data <- data.frame(combinat::combn2(row.names(fsts)),
                              fst_estimate=fsts[lower.tri(fsts)])
      plot.data$pop_pair <- paste(plot.data$X1,plot.data$X2,sep="_")
      
      fst.plot <- ggplot(plot.data, aes(x=pop_pair,y=fst_estimate)) + 
        geom_point(size=2) + 
        coord_flip() + 
        geom_hline(yintercept=0, lty=2, lwd=1, col="gray50") + 
        theme_minimal() + 
        theme(legend.position="none")
      
      print(fst.plot)
    }
  }
  
  return(fst.list)
  
  beepr::beep()
}

# read in vcf and convert to genlight object 

setophaga_genlight_Fst <- gl.read.vcf("setophaga_15a_admixture.vcf", verbose = 2)

# Order of individuals in setophaga_15a_admix.vcf 
#Setophaga_graciae_CM_S10255 BEL Setophaga_graciae_CM_S9116_BEL
#Setophaga_graciae_DMNS_52524_COL	Setophaga_graciae_KU_33633_RACN	
#Setophaga_graciae_KU_33634_RACN	Setophaga_graciae_KU_8199_SANA	
#Setophaga_graciae_KU_8218_SANA	Setophaga_graciae_UWBM_105736_ARI	
#Setophaga_graciae_UWBM_106758_NM	Setophaga_graciae_UWBM_106760_NM	
#Setophaga_graciae_UWBM_108714_NEV	Setophaga_graciae_UWBM_111891_NM	
#Setophaga_graciae_UWBM_111896_NM		
#Setophaga_graciae_UWBM_112576_GUE	Setophaga_graciae_UWBM_112587_GUE	
#Setophaga_graciae_UWBM_112592_GUE	Setophaga_graciae_UWBM_113059_CHI	
#Setophaga_graciae_UWBM_113126_CHI	Setophaga_graciae_UWBM_113970_DUR	
#Setophaga_graciae_UWBM_114011_DUR	Setophaga_graciae_UWBM_114012_DUR	
#Setophaga_graciae_UWBM_114019_DUR	Setophaga_graciae_UWBM_114038_DUR	
#Setophaga_graciae_UWBM_114046_DUR	
#Setophaga_graciae_UWBM_114047_DUR	Setophaga_graciae_UWBM_114087_CHIH	
#Setophaga_graciae_UWBM_114088_CHIH	Setophaga_graciae_UWBM_114090_CHIH	
#Setophaga_graciae_UWBM_114091_CHIH	Setophaga_graciae_UWBM_114126_CHIH	
#Setophaga_graciae_UWBM_114127_CHIH	Setophaga_graciae_UWBM_114128_CHIH	
#Setophaga_graciae_UWBM_114282_NEV	Setophaga_graciae_UWBM_114424_NEV	
#Setophaga_graciae_UWBM_115308_GUE	Setophaga_graciae_UWBM_69981_PCA	
#Setophaga_graciae_UWBM_77653_ARI	Setophaga_graciae_UWBM_77735_ARI	
#Setophaga_graciae_UWBM_84639_ARI	Setophaga_graciae_UWBM_93801_CPN	
#Setophaga_graciae_UWBM_93805_CPN	Setophaga_graciae_UWBM_93806_CPN	
#Setophaga_graciae_UWBM_93807_CPN	Setophaga_graciae_UWBM_93808_CPN	
# Setophaga_graciae_UWBM_95850_ARI


# Set Populations in Genlight Object 
pop(setophaga_genlight_Fst)<- as.factor(c("Belize", "Belize", 
                                          "Ari_NM_Nev_Col", "Nicaragua", 
                                          "Nicaragua","El_Salvador_Honduras", 
                                          "El_Salvador_Honduras", "Ari_NM_Nev_Col", 
                                          "Ari_NM_Nev_Col", "Ari_NM_Nev_Col", 
                                          "Ari_NM_Nev_Col", "Ari_NM_Nev_Col", 
                                          "Ari_NM_Nev_Col", 
                                          "Guerrero", "Guerrero", 
                                          "Guerrero", "Chiapas", 
                                          "Chiapas", "Durango", 
                                          "Durango", "Durango", 
                                          "Durango", "Durango", 
                                          "Durango", "Durango", 
                                          "Chihuahua", 
                                          "Chihuahua", "Chihuahua", 
                                          "Chihuahua", "Chihuahua", 
                                          "Chihuahua", "Chihuahua", 
                                          "Ari_NM_Nev_Col", "Ari_NM_Nev_Col", 
                                          "Guerrero", "Nicaragua", 
                                          "Ari_NM_Nev_Col", "Ari_NM_Nev_Col", 
                                          "Ari_NM_Nev_Col", "El_Salvador_Honduras", 
                                          "El_Salvador_Honduras", "El_Salvador_Honduras",
                                          "El_Salvador_Honduras", "El_Salvador_Honduras", 
                                          "Ari_NM_Nev_Col")) 
ploidy(setophaga_genlight_Fst) <- 2

# Run Reich's Fst for Genlights
setophaga_FST <- reich.fst(setophaga_genlight_Fst, bootstrap = 100, plot = TRUE)

# FST heat map (this next section is heavily influenced by the following script:
# https://github.com/ksil91/Scripts/blob/master/heatmap_FST.md)

fst_matrix <- as.matrix(setophaga_FST$fsts)

# Rearrange matrix so it is south-north 

n_s <- c("Ari_NM_Nev_Col", "Chihuahua", "Durango", "Guerrero", "Chiapas", "Belize", "El_Salvador_Honduras", "Nicaragua")


fst_matrix_rearranged <- fst_matrix[n_s,n_s]

fst_matrix_rearranged_tri <- fst_matrix_rearranged

# manually rearrange fst values 

fst_matrix_rearranged_tri[6,2] <- fst_matrix_rearranged[2,6]
fst_matrix_rearranged_tri[6,3] <- fst_matrix_rearranged[3,6]
fst_matrix_rearranged_tri[6,4] <- fst_matrix_rearranged[4,6]
fst_matrix_rearranged_tri[6,5] <- fst_matrix_rearranged[5,6]
fst_matrix_rearranged_tri[5,2] <- fst_matrix_rearranged[2,5]
fst_matrix_rearranged_tri[5,3] <- fst_matrix_rearranged[3,5]
fst_matrix_rearranged_tri[5,4] <- fst_matrix_rearranged[4,5]
fst_matrix_rearranged_tri[7,4] <- fst_matrix_rearranged[4,7]


fst_matrix_rearranged_tri[2,6] <- NA
fst_matrix_rearranged_tri[3,6] <- NA
fst_matrix_rearranged_tri[4,6] <- NA
fst_matrix_rearranged_tri[5,6] <- NA
fst_matrix_rearranged_tri[2,5] <- NA
fst_matrix_rearranged_tri[3,5] <- NA
fst_matrix_rearranged_tri[4,5] <- NA
fst_matrix_rearranged_tri[4,7] <- NA

# fst_matrix_rearranged_tri[lower.tri(fst_matrix_rearranged, diag = TRUE)] <- NA

fst_melted <- melt(fst_matrix_rearranged_tri, na.rm =TRUE)

# Plot
ggplot(data = fst_melted, aes(Var2, Var1, fill = value))+ geom_tile(color = "white") + 
  scale_fill_gradient(low = "white", high = "red", name="Fst") + 
  geom_text(aes(label = round(value,3)), size = 4) +
  # ggtitle("Pairwise Reich's FST") +
  labs( x = "Population", y = "Population") + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 11, hjust = 1),axis.text.y = element_text(size = 12)) + 
  coord_fixed()










