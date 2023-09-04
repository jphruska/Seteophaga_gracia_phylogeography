library(tidyr)
library(dplyr)
library(plyr)

## Input txt file of CDS content found on chromosomes of interest. 

x <- read.table("CDS_regions_chr_no_mito_mywagenomev2.1_reduced.gff", header=F)


## subtract cds start point from end point, and add difference as a column to data frame

x$V4 <- x$V3 - x$V2

# Turn off scientific notation for output with large numbers in sliding windows

options(scipen=999)


# sort, for each scaffold, the start and ends of the cds regions

x2 <-x %>% 
  arrange(V1,V3)

x2.colnames <- c("Chromosome", "CDS_start", "CDS_end", "length")

colnames(x2) <- x2.colnames


## Read in index file to get size of scaffolds 

require(GenomicRanges)


genome_index <- read.table("GCA_001746935.2_mywa_2.1_genomic.fna.fai", sep="\t", stringsAsFactors=F)

genome_index <- genome_index[1:31,]

genome_index <- genome_index[-28,]


scaffold_sizes <- genome_index[,2]

scaffold_sizes

## Subset x to include only scaffolds/chromosomes of interest. 

x.scaffolds.interest <- unique(x2$Chromosome)

# remove CMO27534.1

x.scaffolds.interest <- x.scaffolds.interest[-28]

## Determine window size 

window_size <- 50000

# Loop through each scaffold 
# output headers = scaffold, start, end, prop CDS 

output <- c()
num_windows <- c()
# For each scaffold
for(a in 1:length(x.scaffolds.interest)) {
  options(scipen=999)
  num_windows[a] <-floor(scaffold_sizes[a]/window_size)
  start <- 1 
  end <- window_size
  a_CDS <- x2[x2[,1] == x.scaffolds.interest[a],]
  # For each window
  for (b in 1:num_windows[a]){
    b_CDS <- a_CDS[a_CDS[,2] >= start & a_CDS[,2] <= end | a_CDS[,3] >= start & a_CDS[,3] <= end,]
    if(nrow(b_CDS) > 0) {
      b_CDS[b_CDS[,3] > end, 3] <- end
      b_CDS[b_CDS[,2] < start, 2] <- start
      b_seq <- c()
      for(c in 1:nrow(b_CDS)) {
        b_seq <- c(b_seq, b_CDS[c,2]:b_CDS[c,3])
      }
      b_CDS_count <- length(unique(b_seq)) / window_size
    } else {
      b_CDS_count <- 0
    }
    output <- rbind(output, c(x.scaffolds.interest[a], start, end, b_CDS_count))
    start <- start + window_size
    end <- end + window_size
  }
  print(x.scaffolds.interest[a]) 
}

output <- data.frame(Scaffold=as.character(output[,1]), Start=as.numeric(output[,2]), End=as.numeric(output[,3]), Prop_CDS = as.numeric(output[,4]))

write.table(output, "setophaga_cds_props.txt", sep = "\t", row.names = FALSE)


write.table(x2, "setophaga_cds_reordered.txt", sep = "\t", row.names = FALSE)




# CDS content per chromosome, regressed onto chromosome size 

# Read in fai file, which includes size of chromosomes 

fai <- read.table(file = "GCA_001746935.2_mywa_2.1_genomic.fna.fai", header = F, sep = "\t")

# proper chromosome order and associated names 

chromosome_order <- c("CM027507.1", "CM027508.1", "CM027509.1", 
                      "CM027510.1", "CM027511.1","CM027512.1", 
                      "CM027513.1","CM027514.1","CM027515.1", 
                      "CM027516.1","CM027517.1","CM027518.1", 
                      "CM027519.1", "CM027520.1","CM027521.1","CM027522.1",
                      "CM027523.1", "CM027524.1", "CM027525.1", "CM027526.1", 
                      "CM027527.1", "CM027528.1", "CM027529.1", "CM027530.1",
                      "CM027531.1", "CM027532.1", "CM027533.1", "CM027535.1", "CM027536.1", "CM027537.1")

# subset fai object to only include chromosomes of interest

fai_subset <-fai[1:31,]

fai_subset1 <- fai_subset[-28,]

chromosome_sizes <- fai_subset1[,1:2]

# Calculate average cds per chromosome. Here the idea is to average the estimates of cds over the number of
# windows in each chromosome. This will be done with a for loop. 


x3 <- as.data.frame(read.table("setophaga_cds_props.txt", sep = "\t"))

x3.colnames <- c("Chromosome", "CDS_start", "CDS_end", "Prop_CDS")

colnames(x3) <- x3.colnames 

chromosomes <- list()
windows <- c()
cds_averages <- c()

for (a in 1:length(chromosome_order)) {
  # subset windows by chromosome
  chromosomes[[a]] <- x3[x3$Chromosome==chromosome_order[a],]
  # count windows in each chromosome 
  windows[a] <- nrow(chromosomes[[a]])
  # average cds content
  cds_averages[a] <- sum(as.numeric(chromosomes[[a]]$Prop_CDS)) / windows[a]
  print(paste("Done with",chromosome_order[a]))
}

# add cds_averages as column to chromosome_sizes

chromosome_sizes <- cbind(chromosome_sizes, cds_averages)

# rename chromosome_sizes headers

colnames(chromosome_sizes)[1] = "chr"

colnames(chromosome_sizes)[2] = "size"

# convert chromosome size to Mb

chromosom_sizes_Mb <- chromosome_sizes$size/1000000

plot(log(chromosom_sizes_Mb), chromosome_sizes$cds_averages, xlab = "Log Chromosome Size (Mb)", ylab = "CDS proportion per 50 kb window", pch = 20)

abline(lm(chromosome_sizes$cds_averages ~ log(chromosom_sizes_Mb)), col = "black", lwd = 2)

# Do a spearman correlation

cor.test(chromosome_sizes$cds_averages, chromosom_sizes_Mb, method = "pearson")

# Taking a look at the distribution of CDS proportions

prop_CDS <- as.numeric(x3$Prop_CDS[-1])

hist(prop_CDS)



# Plotting CDS density along chromosomes 

# read cds proportion table

y.1 <- read.table("setophaga_cds_props.txt", sep="\t", stringsAsFactors = TRUE, header = TRUE)

# rename column names

colnames(y.1) <- c("chr", "start", "end", "prop_CDS")

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

# sort dataset by chromosome and within chromosome window order

y1 <- ddply(y.1, c('start'))

y2 <- ddply(y1, c('chr'))

y3 <- left_join(data.frame(chr = chromosome_order), y2, by = "chr")

y <- y3

# set up plotting dimensions
par(mfrow=c(1,1))
par(mar=c(2,5,1.5,0))

# Plot cds density

total_windows <- nrow(y)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
cds.density <- na.omit(y)

chr <- unique(y[,1])

chr_polygons_cds_density <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(y)[y[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[a]
  chr_polygons_cds_density[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 1), c(a1, 1), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot cds density 
plot(c(-1,-1), ylim=c(0.000,0.15), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab="CDS Density")
odd <- 0

for(a in 1:length(chr_polygons_cds_density)) {
  if(odd == 1) {
    polygon(chr_polygons_cds_density[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

# points(rownames(y), y$prop_CDS, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[y[b_rep,1] %in% y[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(y)))
  total_rep <- c(total_rep, mean(y$prop_CDS[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="goldenrod")

