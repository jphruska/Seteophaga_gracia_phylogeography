## Read in plink genome output and relatdness2 output (executed in Vcftools), to get a sense of what patterns of IBD are between samples. 

library(tidyverse)

# Read in plink genome output 

plink_genome <- read.table("plink.genome", header = T)

# rank by PI_HAT (proportion of IBD between two individuals)

plink_genome_sorted <- plink_genome[order(plink_genome$PI_HAT, decreasing = TRUE),]

extract <- c(1,3,10)

# extract only columns 1,3, and 10

plink_genome_sorted1 <- as.data.frame(plink_genome_sorted[,extract])

#export table of sorted by decreasing PI_HAT values 

write.table(plink_genome_sorted1, file = "relatedness_ranked.txt", sep = "\t")

# Read in relatedness2 output

relatedness2 <- read.table("out.relatedness2", header = T)

# rank by relatedness_phi (proportion of IBD between two individuals)

relatedness2_sorted <- relatedness2[order(relatedness2$RELATEDNESS_PHI, decreasing = TRUE),]

# extract only columns 1,2, and 7

extract1 <- c(1,2,7)

relatedness2_sorted1 <- as.data.frame(relatedness2_sorted[,extract1])

#export table of sorted by decreasing relatedness PHI

write.table(relatedness2_sorted1, file = "relatedness2_ranked.txt", sep = "\t")

# remove all within individual pairwise comparisons (relatedness PHI = 0.5)

relatedness3_sorted <- relatedness2_sorted1[!relatedness2_sorted1$RELATEDNESS_PHI == 0.5,]


# rename entries in columns 1 and 2 to just show ID and location (e.g., "106760_NM")

id_1 <- c()
id_2 <- c()

for (i in 1:2756){
  # rename IDs in INDIV 1 column
 id_1[i] <- str_split(relatedness3_sorted$INDV1[i], "_", 4)[[1]][4]
 # rename IDs in INDIV 2 column
 id_2[i] <- str_split(relatedness3_sorted$INDV2[i], "_", 4)[[1]][4]
 # echo 
 print(i)
}

# cbind vectors 

relatedness_4 <- as.data.frame(cbind(id_1,id_2, as.numeric(relatedness3_sorted$RELATEDNESS_PHI)))

relatedness_4$RELATEDNESS_PHI <- as.numeric(relatedness_4$RELATEDNESS_PHI)
colnames(relatedness_4)[3] <- "RELATEDNESS_PHI"


# make heatmap

ggplot(relatedness_4, aes(id_1, id_2, fill = RELATEDNESS_PHI)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low="white", high = "red") + 
  theme(axis.text.x=element_text(angle = 90, hjust = 0)) +
  xlab("") +
  ylab("")
 


