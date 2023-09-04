# Read in FST window file

library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cowplot)
options(scipen = 999)

x <- as.data.frame(read.table("window_fst_all_pops.txt", sep="\t", stringsAsFactors = FALSE, header = TRUE))

x <- na.omit(x)


# proper chromosome order and associated names 

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

# subset stats per population comparison

fst_northern_guerrero <- x[x$pop1=="Northern" & x$pop2=="Guerrero",]
fst_northern_guerrero <- fst_northern_guerrero[fst_northern_guerrero$number_sites > 0,]

fst_northern_chiapas <- x[x$pop1=="Northern" & x$pop2=="Chiapas",]
fst_northern_chiapas <- fst_northern_chiapas[fst_northern_chiapas$number_sites > 0,]

fst_northern_central <- x[x$pop1=="Northern" & x$pop2=="Central",]
fst_northern_central<- fst_northern_central[fst_northern_central$number_sites > 0,]

fst_northern_nicaragua <- x[x$pop1=="Northern" & x$pop2=="Nicaragua",]
fst_northern_nicaragua <- fst_northern_nicaragua[fst_northern_nicaragua$number_sites > 0,]

fst_guerrero_chiapas <- x[x$pop1=="Guerrero" & x$pop2=="Chiapas",]
fst_guerrero_chiapas <- fst_guerrero_chiapas[fst_guerrero_chiapas$number_sites > 0,]

fst_guerrero_central <- x[x$pop1=="Central" & x$pop2=="Guerrero",]
fst_guerrero_central <- fst_guerrero_central[fst_guerrero_central$number_sites > 0,]

fst_guerrero_nicaragua <- x[x$pop1=="Nicaragua" & x$pop2=="Guerrero",]
fst_guerrero_nicaragua <- fst_guerrero_nicaragua[fst_guerrero_nicaragua$number_sites > 0,]

fst_central_chiapas <- x[x$pop1=="Central" & x$pop2=="Chiapas",]
fst_central_chiapas <- fst_central_chiapas[fst_central_chiapas$number_sites > 0,]

fst_nicaragua_chiapas <- x[x$pop1=="Nicaragua" & x$pop2=="Chiapas",]
fst_nicaragua_chiapas <- fst_nicaragua_chiapas[fst_nicaragua_chiapas$number_sites > 0,]

fst_nicaragua_central <- x[x$pop1=="Nicaragua" & x$pop2=="Central",]
fst_nicaragua_central <- fst_nicaragua_central[fst_nicaragua_central$number_sites > 0,]

## store all pairwise fsts in a list

pairwise.fst <- list(fst_northern_guerrero, fst_northern_chiapas, fst_northern_central, fst_northern_nicaragua, 
                     fst_guerrero_chiapas, fst_guerrero_central, fst_guerrero_nicaragua, fst_central_chiapas, 
                     fst_nicaragua_chiapas, fst_nicaragua_central)

# Average Pairwise Fst (per 50kbp window)

fst_northern_guerrero_mean <- mean(fst_northern_guerrero$calculated_stat)

fst_northern_central_mean <- mean(fst_northern_central$calculated_stat)

fst_northern_nicaragua_mean <- mean(fst_northern_nicaragua$calculated_stat)

fst_guerrero_central_mean <- mean(fst_guerrero_central$calculated_stat)

fst_guerrero_nicaragua_mean <- mean(fst_guerrero_nicaragua$calculated_stat)

fst_nicaragua_central_mean <- mean(fst_nicaragua_central$calculated_stat)

# SD Pairwise Fst (per 50kbp window)

fst_northern_guerrero_sd <- sd(fst_northern_guerrero$calculated_stat)
fst_northern_central_sd <- sd(fst_northern_central$calculated_stat)
fst_northern_nicaragua_sd <- sd(fst_northern_nicaragua$calculated_stat)
fst_guerrero_central_sd <- sd(fst_guerrero_central$calculated_stat)
fst_guerrero_nicaragua_sd <- sd(fst_guerrero_nicaragua$calculated_stat)
fst_nicaragua_central_sd <- sd(fst_nicaragua_central$calculated_stat)

# Var Pairwise Fst (per 50kbp window)

fst_northern_guerrero_var <- var(fst_northern_guerrero$calculated_stat)
fst_northern_central_var <- var(fst_northern_central$calculated_stat)
fst_northern_nicaragua_var <- var(fst_northern_nicaragua$calculated_stat)
fst_guerrero_central_var <- var(fst_guerrero_central$calculated_stat)
fst_guerrero_nicaragua_var <- var(fst_guerrero_nicaragua$calculated_stat)
fst_nicaragua_central_var <- var(fst_nicaragua_central$calculated_stat)


# set up plotting dimensions
par(mfrow=c(5,1))
par(mar=c(2,5,1.5,0))

# Plot Fst for Northern - Guerrero Comparison

total_windows <- nrow(fst_northern_guerrero)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_northern_guerrero <- na.omit(fst_northern_guerrero)

# sort dataset by chromosome and within chromosome window order

fst_northern_guerrero1 <- ddply(fst_northern_guerrero, c('start'))

fst_northern_guerrero2 <- ddply(fst_northern_guerrero1, c('chr'))

fst_northern_guerrero3 <- left_join(data.frame(chr = chromosome_order), fst_northern_guerrero2, by = "chr")

fst_northern_guerrero <- fst_northern_guerrero3

chr <- unique(fst_northern_guerrero[,1])

chr_polygons_fst_northern_guerrero <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_northern_guerrero)[fst_northern_guerrero[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_northern_guerrero[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst northern guerrero  
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Northern x Guerrero")
odd <- 0

for(a in 1:length(chr_polygons_fst_northern_guerrero)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_northern_guerrero[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_northern_guerrero), fst_northern_guerrero$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_northern_guerrero[b_rep,1] %in% fst_northern_guerrero[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_northern_guerrero)))
  total_rep <- c(total_rep, mean(fst_northern_guerrero$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")



# Plot Fst for Northern - chiapas Comparison

total_windows <- nrow(fst_northern_chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_northern_chiapas <- na.omit(fst_northern_chiapas)

# sort dataset by chromosome and within chromosome window order

fst_northern_chiapas1 <- ddply(fst_northern_chiapas, c('start'))

fst_northern_chiapas2 <- ddply(fst_northern_chiapas1, c('chr'))

fst_northern_chiapas3 <- left_join(data.frame(chr = chromosome_order), fst_northern_chiapas2, by = "chr")

fst_northern_chiapas <- fst_northern_chiapas3

chr <- unique(fst_northern_chiapas[,1])

chr_polygons_fst_northern_chiapas <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_northern_chiapas)[fst_northern_chiapas[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_northern_chiapas[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst northern chiapas 
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Northern x Chiapas")
odd <- 0

for(a in 1:length(chr_polygons_fst_northern_chiapas)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_northern_chiapas[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_northern_chiapas), fst_northern_chiapas$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_northern_chiapas[b_rep,1] %in% fst_northern_chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_northern_chiapas)))
  total_rep <- c(total_rep, mean(fst_northern_chiapas$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")



# Plot Fst for Northern - Central Comparison

total_windows <- nrow(fst_northern_central)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_northern_central <- na.omit(fst_northern_central)

# sort dataset by chromosome and within chromosome window order

fst_northern_central1 <- ddply(fst_northern_central, c('start'))

fst_northern_central2 <- ddply(fst_northern_central1, c('chr'))

fst_northern_central3 <- left_join(data.frame(chr = chromosome_order), fst_northern_central2, by = "chr")

fst_northern_central <- fst_northern_central3

chr <- unique(fst_northern_central[,1])

chr_polygons_fst_northern_central <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_northern_central)[fst_northern_central[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_northern_central[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot fst northern central  
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Northern x Central")
odd <- 0

for(a in 1:length(chr_polygons_fst_northern_central)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_northern_central[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_northern_central), fst_northern_central$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_northern_central[b_rep,1] %in% fst_northern_central[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_northern_central)))
  total_rep <- c(total_rep, mean(fst_northern_central$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")


# Plot Fst for Northern - Nicaragua Comparison

total_windows <- nrow(fst_northern_nicaragua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_northern_nicaragua <- na.omit(fst_northern_nicaragua)

# sort dataset by chromosome and within chromosome window order

fst_northern_nicaragua1 <- ddply(fst_northern_nicaragua, c('start'))

fst_northern_nicaragua2 <- ddply(fst_northern_nicaragua1, c('chr'))

fst_northern_nicaragua3 <- left_join(data.frame(chr = chromosome_order), fst_northern_nicaragua2, by = "chr")

fst_northern_nicaragua <- fst_northern_nicaragua3

chr <- unique(fst_northern_nicaragua[,1])

chr_polygons_fst_northern_nicaragua <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_northern_nicaragua)[fst_northern_nicaragua[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_northern_nicaragua[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot fst northern nicaragua  
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Northern x Nicaragua")
odd <- 0

for(a in 1:length(chr_polygons_fst_northern_nicaragua)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_northern_nicaragua[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_northern_nicaragua), fst_northern_nicaragua$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_northern_nicaragua[b_rep,1] %in% fst_northern_nicaragua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_northern_nicaragua)))
  total_rep <- c(total_rep, mean(fst_northern_nicaragua$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")


# Plot Fst for Guerrero - Chiapas Comparison

total_windows <- nrow(fst_guerrero_chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_guerrero_chiapas <- na.omit(fst_guerrero_chiapas)

# sort dataset by chromosome and within chromosome window order

fst_guerrero_chiapas1 <- ddply(fst_guerrero_chiapas, c('start'))

fst_guerrero_chiapas2 <- ddply(fst_guerrero_chiapas1, c('chr'))

fst_guerrero_chiapas3 <- left_join(data.frame(chr = chromosome_order), fst_guerrero_chiapas2, by = "chr")

fst_guerrero_chiapas <- fst_guerrero_chiapas3

chr <- unique(fst_guerrero_chiapas[,1])

chr_polygons_fst_guerrero_chiapas <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_guerrero_chiapas)[fst_guerrero_chiapas[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_guerrero_chiapas[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst guerrero chiapas
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Guerrero x Chiapas")
odd <- 0

for(a in 1:length(chr_polygons_fst_guerrero_chiapas)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_guerrero_chiapas[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_guerrero_chiapas), fst_guerrero_chiapas$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_guerrero_chiapas[b_rep,1] %in% fst_guerrero_chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_guerrero_chiapas)))
  total_rep <- c(total_rep, mean(fst_guerrero_chiapas$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")


# set up plotting dimensions
par(mfrow=c(5,1))
par(mar=c(2,5,1.5,0))


# Plot Fst for Guerrero - Central Comparison

total_windows <- nrow(fst_guerrero_central)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_guerrero_central <- na.omit(fst_guerrero_central)

# sort dataset by chromosome and within chromosome window order

fst_guerrero_central1 <- ddply(fst_guerrero_central, c('start'))

fst_guerrero_central2 <- ddply(fst_guerrero_central1, c('chr'))

fst_guerrero_central3 <- left_join(data.frame(chr = chromosome_order), fst_guerrero_central2, by = "chr")

fst_guerrero_central <- fst_guerrero_central3

chr <- unique(fst_guerrero_central[,1])

chr_polygons_fst_guerrero_central <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_guerrero_central)[fst_guerrero_central[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_guerrero_central[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst guerrero central 
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Guerrero x Central")
odd <- 0

for(a in 1:length(chr_polygons_fst_guerrero_central)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_guerrero_central[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_guerrero_central), fst_guerrero_central$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_guerrero_central[b_rep,1] %in% fst_guerrero_central[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_guerrero_central)))
  total_rep <- c(total_rep, mean(fst_guerrero_central$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")





# Plot Fst for Guerrero - Nicaragua Comparison

total_windows <- nrow(fst_guerrero_nicaragua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_guerrero_nicaragua <- na.omit(fst_guerrero_nicaragua)

# sort dataset by chromosome and within chromosome window order

fst_guerrero_nicaragua1 <- ddply(fst_guerrero_nicaragua, c('start'))

fst_guerrero_nicaragua2 <- ddply(fst_guerrero_nicaragua1, c('chr'))

fst_guerrero_nicaragua3 <- left_join(data.frame(chr = chromosome_order), fst_guerrero_nicaragua2, by = "chr")

fst_guerrero_nicaragua <- fst_guerrero_nicaragua3

chr <- unique(fst_guerrero_nicaragua[,1])

chr_polygons_fst_guerrero_nicaragua <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_guerrero_nicaragua)[fst_guerrero_nicaragua[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_guerrero_nicaragua[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst guerrero nicaragua 
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Guerrero x Nicaragua")
odd <- 0

for(a in 1:length(chr_polygons_fst_guerrero_nicaragua)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_guerrero_nicaragua[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_guerrero_nicaragua), fst_guerrero_nicaragua$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_guerrero_nicaragua[b_rep,1] %in% fst_guerrero_nicaragua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_guerrero_nicaragua)))
  total_rep <- c(total_rep, mean(fst_guerrero_nicaragua$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")


# Plot Fst for NCentral - Chiapas Comparison

total_windows <- nrow(fst_central_chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_central_chiapas <- na.omit(fst_central_chiapas)

# sort dataset by chromosome and within chromosome window order

fst_central_chiapas1 <- ddply(fst_central_chiapas, c('start'))

fst_central_chiapas2 <- ddply(fst_central_chiapas1, c('chr'))

fst_central_chiapas3 <- left_join(data.frame(chr = chromosome_order), fst_central_chiapas2, by = "chr")

fst_central_chiapas <- fst_central_chiapas3

chr <- unique(fst_central_chiapas[,1])

chr_polygons_fst_central_chiapas <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_central_chiapas)[fst_central_chiapas[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_central_chiapas[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst central chiapas 
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Central x Chiapas")
odd <- 0

for(a in 1:length(chr_polygons_fst_central_chiapas)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_central_chiapas[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_central_chiapas), fst_central_chiapas$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_central_chiapas[b_rep,1] %in% fst_central_chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_central_chiapas)))
  total_rep <- c(total_rep, mean(fst_central_chiapas$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")


# Plot Fst for Nicaragua - Chiapas Comparison

total_windows <- nrow(fst_nicaragua_chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_nicaragua_chiapas <- na.omit(fst_nicaragua_chiapas)

# sort dataset by chromosome and within chromosome window order

fst_nicaragua_chiapas1 <- ddply(fst_nicaragua_chiapas, c('start'))

fst_nicaragua_chiapas2 <- ddply(fst_nicaragua_chiapas1, c('chr'))

fst_nicaragua_chiapas3 <- left_join(data.frame(chr = chromosome_order), fst_nicaragua_chiapas2, by = "chr")

fst_nicaragua_chiapas <- fst_nicaragua_chiapas3

chr <- unique(fst_nicaragua_chiapas[,1])

chr_polygons_fst_nicaragua_chiapas <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_nicaragua_chiapas)[fst_nicaragua_chiapas[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_nicaragua_chiapas[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst gnicaragua chiapas 
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Nicaragua x Chiapas")
odd <- 0

for(a in 1:length(chr_polygons_fst_nicaragua_chiapas)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_nicaragua_chiapas[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_nicaragua_chiapas), fst_nicaragua_chiapas$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_nicaragua_chiapas[b_rep,1] %in% fst_nicaragua_chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_nicaragua_chiapas)))
  total_rep <- c(total_rep, mean(fst_nicaragua_chiapas$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")





# Plot Fst for Nicaragua - Central Comparison

total_windows <- nrow(fst_nicaragua_central)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
fst_nicaragua_central <- na.omit(fst_nicaragua_central)

# sort dataset by chromosome and within chromosome window order

fst_nicaragua_central1 <- ddply(fst_nicaragua_central, c('start'))

fst_nicaragua_central2 <- ddply(fst_nicaragua_central1, c('chr'))

fst_nicaragua_central3 <- left_join(data.frame(chr = chromosome_order), fst_nicaragua_central2, by = "chr")

fst_nicaragua_central <- fst_nicaragua_central3

chr <- unique(fst_nicaragua_central[,1])

chr_polygons_fst_nicaragua_central <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(fst_nicaragua_central)[fst_nicaragua_central[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_fst_nicaragua_central[[a]] <- rbind(c(a1, -3), c(a2, -3), c(a2, 3.0), c(a1, 3.0), c(a1, 0))
}


# plot fst guerrero nicaragua 
plot(c(-1,-1), ylim=c(0,0.6), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(bold(italic("F")["ST"])), main = "Nicaragua x Central")
odd <- 0

for(a in 1:length(chr_polygons_fst_nicaragua_central)) {
  if(odd == 1) {
    polygon(chr_polygons_fst_nicaragua_central[[a]], col="snow2", border="white")
    odd <- 0	
  } else {
    odd <- 1
  }
}

# plot

points(rownames(fst_nicaragua_central), fst_nicaragua_central$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[fst_nicaragua_central[b_rep,1] %in% fst_nicaragua_central[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(fst_nicaragua_central)))
  total_rep <- c(total_rep, mean(fst_nicaragua_central$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="black")






##### Examinations of differentiation landscapes between 'independent' population contrasts

# Regression of Fst between Guerrero-Central and Guererro-Nicaragua


# fst_guerrero_central_cor <- fst_guerrero_central$calculated_stat

# fst_guerrero_nicaragua_cor <- fst_guerrero_nicaragua$calculated_stat

# plot(fst_guerrero_nicaragua_cor, fst_guerrero_central_cor)

# Regression of Fst between Guerrero-Central and Central-Nicaragua

# fst_guerrero_central_cor <- fst_guerrero_central$calculated_stat

# fst_nicaragua_central_cor <- fst_nicaragua_central$calculated_stat

# plot(fst_guerrero_nicaragua_cor, fst_nicaragua_central_cor)


# Regression of Fst between Northern-Guerrero and Central-Nicaragua

# fst_northern_guerrero_cor <- fst_northern_guerrero$calculated_stat

# fst_nicaragua_central_cor <- fst_nicaragua_central$calculated_stat

# plot(fst_northern_guerrero_cor, fst_nicaragua_central_cor)

# cor(fst_northern_guerrero_cor, fst_nicaragua_central_cor)


# Regression of Fst between Northern-Central and Central-Nicaragua

# fst_northern_central_cor <- fst_northern_central$calculated_stat

# fst_nicaragua_central_cor <- fst_nicaragua_central$calculated_stat

# plot(fst_northern_central_cor, fst_nicaragua_central_cor)

# cor(fst_northern_central_cor, fst_nicaragua_central_cor)


# Regression of Fst between Northern-Guerrero and Guerrero-Central


# fst_northern_guerrero_cor <- fst_northern_guerrero$calculated_stat

# fst_guerrero_central_cor <- fst_guerrero_central$calculated_stat

# plot(fst_northern_guerrero_cor, fst_guerrero_central_cor)

# cor(fst_northern_guerrero_cor, fst_guerrero_central_cor)


## Pairwise Fst comparison plots


pairwise_fsts <- c("fst_northern_guerrero","fst_northern_chiapas", "fst_northern_central", "fst_northern_nicaragua", 
                   "fst_guerrero_chiapas", "fst_guerrero_central", "fst_guerrero_nicaragua", "fst_central_chiapas", 
                   "fst_nicaragua_chiapas", "fst_nicaragua_central")

pairwise_fsts_combine <- combn(pairwise_fsts,2)

names(pairwise.fst) <- pairwise_fsts

combined_dataframes <- list()

plots <- list()



for (i in 1:15) {
  ## combine pair of pairwise fsts, joined by chr, start, and end
  
  colnames_merge <- c("chr", "start", "end")
  
  combined_dataframes[[i]] <- merge(pairwise.fst[[as.name(pairwise_fsts_combine[,i][1])]], 
                                    pairwise.fst[[as.name(pairwise_fsts_combine[,i][2])]], 
                                    by = colnames_merge, all.y = TRUE, all.x = TRUE)
  
  
  ## Return rows with NAs 
  
  combined_dataframes[[i]] %>%
    filter(if_any(everything(), is.na))
  
  ## Filter out rows with NAs
  
  (combined_dataframes[[i]] <- combined_dataframes[[i]] %>%
      drop_na())
  
  
  ## filter out Z chromosome 
  
  combined_dataframes[[i]] <- combined_dataframes[[i]][!combined_dataframes[[i]]$chr == "CM027535.1",]
  
  # rename fst stats columns 
  
  colnames(combined_dataframes[[i]])[9] <- pairwise_fsts_combine[,i][1]
  colnames(combined_dataframes[[i]])[15] <- pairwise_fsts_combine[,i][2]
   
  # plot 
    plots[[i]] <- ggplot(combined_dataframes[[i]], aes_string(x=names(combined_dataframes[[i]])[9], y=names(combined_dataframes[[i]])[15])) +
    geom_point()+
    geom_smooth(method = 'lm', col = "yellow") +
    # annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.90", size =4) +
    # xlab(expression(italic("F")[ST] ~~ pairwise_fsts_combine[,1][1])) + 
    # ylab(expression(italic("F")[ST] ~~ excluding ~ "112575_GUE")) +
    theme_cowplot(12)
}




plot_grid(plotlist = plots, ncol = 4)


combined_dataframes <- list()

plots <- list()



for (i in 16:30) {
  ## combine pair of pairwise fsts, joined by chr, start, and end
  
  colnames_merge <- c("chr", "start", "end")
  
  combined_dataframes[[i]] <- merge(pairwise.fst[[as.name(pairwise_fsts_combine[,i][1])]], 
                                    pairwise.fst[[as.name(pairwise_fsts_combine[,i][2])]], 
                                    by = colnames_merge, all.y = TRUE, all.x = TRUE)
  
  
  ## Return rows with NAs 
  
  combined_dataframes[[i]] %>%
    filter(if_any(everything(), is.na))
  
  ## Filter out rows with NAs
  
  (combined_dataframes[[i]] <- combined_dataframes[[i]] %>%
      drop_na())
  
  
  ## filter out Z chromosome 
  
  combined_dataframes[[i]] <- combined_dataframes[[i]][!combined_dataframes[[i]]$chr == "CM027535.1",]
  
  # rename fst stats columns 
  
  colnames(combined_dataframes[[i]])[9] <- pairwise_fsts_combine[,i][1]
  colnames(combined_dataframes[[i]])[15] <- pairwise_fsts_combine[,i][2]
  
  # plot 
  plots[[i]] <- ggplot(combined_dataframes[[i]], aes_string(x=names(combined_dataframes[[i]])[9], y=names(combined_dataframes[[i]])[15])) +
    geom_point()+
    geom_smooth(method = 'lm', col = "yellow") +
    # annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.90", size =4) +
    # xlab(expression(italic("F")[ST] ~~ pairwise_fsts_combine[,1][1])) + 
    # ylab(expression(italic("F")[ST] ~~ excluding ~ "112575_GUE")) +
    theme_cowplot(12)
}


plots <- plots[16:30]

plot_grid(plotlist = plots, ncol = 4)




combined_dataframes <- list()

plots <- list()



for (i in 31:45) {
  ## combine pair of pairwise fsts, joined by chr, start, and end
  
  colnames_merge <- c("chr", "start", "end")
  
  combined_dataframes[[i]] <- merge(pairwise.fst[[as.name(pairwise_fsts_combine[,i][1])]], 
                                    pairwise.fst[[as.name(pairwise_fsts_combine[,i][2])]], 
                                    by = colnames_merge, all.y = TRUE, all.x = TRUE)
  
  
  ## Return rows with NAs 
  
  combined_dataframes[[i]] %>%
    filter(if_any(everything(), is.na))
  
  ## Filter out rows with NAs
  
  (combined_dataframes[[i]] <- combined_dataframes[[i]] %>%
      drop_na())
  
  
  ## filter out Z chromosome 
  
  combined_dataframes[[i]] <- combined_dataframes[[i]][!combined_dataframes[[i]]$chr == "CM027535.1",]
  
  # rename fst stats columns 
  
  colnames(combined_dataframes[[i]])[9] <- pairwise_fsts_combine[,i][1]
  colnames(combined_dataframes[[i]])[15] <- pairwise_fsts_combine[,i][2]
  
  # plot 
  plots[[i]] <- ggplot(combined_dataframes[[i]], aes_string(x=names(combined_dataframes[[i]])[9], y=names(combined_dataframes[[i]])[15])) +
    geom_point()+
    geom_smooth(method = 'lm', col = "yellow") +
    # annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.90", size =4) +
    # xlab(expression(italic("F")[ST] ~~ pairwise_fsts_combine[,1][1])) + 
    # ylab(expression(italic("F")[ST] ~~ excluding ~ "112575_GUE")) +
    theme_cowplot(12)
}


plots <- plots[31:45]

plot_grid(plotlist = plots, ncol = 4)



