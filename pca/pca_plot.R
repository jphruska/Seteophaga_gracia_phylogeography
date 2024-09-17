## This script will plot PCAs (PC1 vs PC2) in one single plot. 10 kb and 50 kb thinned datasets will be plotted. 

## Workflow influenced by https://speciationgenomics.github.io/pca/. 

library(tidyverse)
library(stringr)
library(colourpicker)
library(RColorBrewer)
library(cowplot)

# dataset15a
pop15a <- as.factor(c("Belize", "Belize", 
                      "Northern", "Nicaragua", 
                      "Nicaragua","Central", 
                      "Central", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Guerrero", 
                      "Guerrero", "Guerrero", 
                      "Chiapas", "Chiapas", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Guerrero", 
                      "Nicaragua", "Northern", 
                      "Northern", "Northern", 
                      "Central", "Central", 
                      "Central", "Central", 
                      "Central", "Northern")) 

# read in eigen vector and eigen value files 
pca15a <- read_table2( "plink_out_dataset15a.eigenvec", col_names = FALSE)
eigenval15a <- scan("plink_out_dataset15a.eigenval")

# sort out the pca data

# remove nuisance column (due to duplicate IDs introduced by plink)
pca15a <- pca15a[,-1]

# set names
names(pca15a)[1] <- "ind"
names(pca15a)[2:ncol(pca15a)] <- paste0("PC", 1:(ncol(pca15a)-1))
pca15a$Population <- pop15a
pca15a <- as_tibble(pca15a)

# first convert to percentage variance explained
pve15a <- data.frame(PC = 1:nrow(pca15a), pve = eigenval15a/sum(eigenval15a)*100)

# make plot
print(ggplot(pve15a, aes(PC, pve)) + geom_bar(stat = "identity")
      + ylab("Percentage variance explained") + theme_light()) 

# calculate the cumulative sum of the percentage variance explained
cumsum(pve15a$pve)

# store plot in object 
a <-ggplot(pca15a, aes(PC1, PC2, col = Population)) + 
  geom_point(size = 3, alpha = 0.75) +
  scale_colour_manual(values=c("gray71","gray16","slateblue3","yellow2", "azure2", "lightsteelblue1")) + 
  coord_equal() + theme_bw() +
  xlab(paste0("PC1 (", signif(pve15a$pve[1], 3), "%)")) + 
  theme(plot.margin = unit(c(0.25, 0.5, 0.5, 0.25), "cm"),) +
  xlim(c(-0.4, 0.4)) +
  ylim(c(-0.7, 0.7)) +
  annotate("text", y = 0.65, x = 0.2, label = "49,326 SNPs", size =5) +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab(paste0("PC2 (", signif(pve15a$pve[2], 3), "%)")) + 
  theme(legend.text=element_text(size=10)) 

plot(a)

# dataset15b

pop15b <- as.factor(c("Belize", "Belize", 
                      "Northern", "Nicaragua", 
                      "Nicaragua","Central", 
                      "Central", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Guerrero", 
                      "Guerrero", "Guerrero", 
                      "Chiapas", "Chiapas", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Northern", "Northern", 
                      "Guerrero", 
                      "Nicaragua", "Northern", 
                      "Northern", "Northern", 
                      "Central", "Central", 
                      "Central", "Central", 
                      "Central", "Northern")) 




# read in eigen vector and eigen value files 
pca15b <- read_table2( "plink_out_dataset15b.eigenvec", col_names = FALSE)
eigenval15b <- scan("plink_out_dataset15b.eigenval")

# sort out the pca data

# remove nuisance column (due to duplicate IDs introduced by plink)
pca15b <- pca15b[,-1]

# set names
names(pca15b)[1] <- "ind"
names(pca15b)[2:ncol(pca15b)] <- paste0("PC", 1:(ncol(pca15b)-1))
pca15b$Population <- pop15b
pca15b <- as_tibble(pca15b)

# first convert to percentage variance explained
pve15b <- data.frame(PC = 1:nrow(pca15b), pve = eigenval15b/sum(eigenval15b)*100)

# make plot
print(ggplot(pve15b, aes(PC, pve)) + geom_bar(stat = "identity")
      + ylab("Percentage variance explained") + theme_light()) 

# calculate the cumulative sum of the percentage variance explained
cumsum(pve15b$pve)

# store plot in object
b <-ggplot(pca15b, aes(PC1, PC2, col = Population)) + 
  geom_point(size = 3, alpha = 0.75) +
  scale_colour_manual(values=c("gray71","gray16","slateblue3","yellow2", "azure2", "lightsteelblue1")) + 
  coord_equal() + theme_bw() +
  xlab(paste0("PC1 (", signif(pve15b$pve[1], 3), "%)")) + 
  theme(plot.margin = unit(c(0.25, 0.5, 0.5, 0.25), "cm"),) +
  xlim(c(-0.4, 0.4)) +
  ylim(c(-0.7, 0.7)) +
  annotate("text", y = 0.65, x = 0.2, label = "15,735 SNPs", size =5) +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab(paste0("PC2 (", signif(pve15b$pve[2], 3), "%)")) + 
  theme(legend.text=element_text(size=10)) 

plot(b)

## Plot of 110 kb and 50 kb thinned datasets

pattern <- c("a", "b")

pdf()

r <- plot_grid(plotlist = mget(pattern), ncol = 2, labels = c('A', 'B'))

ggsave("combined_15a_15b.pdf", plot = r)

ggsave("combined_15a_15b.png", plot = r)

