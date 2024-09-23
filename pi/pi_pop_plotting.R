# Read in Pi window file

library(plyr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(cowplot)
options(scipen = 999)

x <- read.table("window_pi.txt", sep="\t", stringsAsFactors = TRUE, header = TRUE)

x <- na.omit(x)

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

# subset stats per population

pi_Southwest_USA <- x[x=="Southwest_USA",]
pi_Southwest_USA <- pi_Southwest_USA[pi_Southwest_USA$number_variable_sites > 0,]
pi_Nicaragua <- x[x=="Nicaragua",]
pi_Nicaragua <- pi_Nicaragua[pi_Nicaragua$number_variable_sites > 0,]
pi_Guerrero <- x[x=="Guerrero",]
pi_Guerrero <- pi_Guerrero[pi_Guerrero$number_variable_sites > 0,]
pi_El_Salvador_Honduras <-x[x=="El_Salvador_Honduras",]
pi_El_Salvador_Honduras <- pi_El_Salvador_Honduras[pi_El_Salvador_Honduras$number_variable_sites > 0,]
pi_Chiapas <-x[x=="Chiapas",]
pi_Chiapas <- pi_Chiapas[pi_Chiapas$number_variable_sites > 0,]
pi_Durango <- x[x=="Durango",]
pi_Durango <- pi_Durango[pi_Durango$number_variable_sites > 0,]
pi_Chihuahua <- x[x=="Chihuahua",]
pi_Chihuahua <- pi_Chihuahua[pi_Chihuahua$number_variable_sites > 0,]

# pi Plot of Five Populations

# Average pi (per 50kbp window)

pi_Nicaragua_mean <- mean(pi_Nicaragua$calculated_stat)
pi_El_Salvador_Honduras_mean <- mean(pi_El_Salvador_Honduras$calculated_stat)
pi_Guerrero_mean <- mean(pi_Guerrero$calculated_stat)
pi_Southwest_USA_mean <- mean(pi_Southwest_USA$calculated_stat)
pi_Chiapas_mean <- mean(pi_Chiapas$calculated_stat)
pi_Durango_mean <- mean(pi_Durango$calculated_stat)
pi_Chihuahua_mean <- mean(pi_Chihuahua$calculated_stat)


# minimum pi (per 50kbp window)

pi_Nicaragua_min <- min(pi_Nicaragua$calculated_stat)
pi_El_Salvador_Honduras_min <- min(pi_El_Salvador_Honduras$calculated_stat)
pi_Guerrero_min <- min(pi_Guerrero$calculated_stat)
pi_Southwest_USA_min <- min(pi_Southwest_USA$calculated_stat)
pi_Chiapas_min <- min(pi_Chiapas$calculated_stat)
pi_Durango_min <- min(pi_Durango$calculated_stat)
pi_Chihuahua_min <- min(pi_Chihuahua$calculated_stat)


# maximum pi (per 50kbp window)

pi_Nicaragua_max <- max(pi_Nicaragua$calculated_stat)
pi_El_Salvador_Honduras_max <- max(pi_El_Salvador_Honduras$calculated_stat)
pi_Guerrero_max <- max(pi_Guerrero$calculated_stat)
pi_Southwest_USA_max <- max(pi_Southwest_USA$calculated_stat)
pi_Chiapas_max <- max(pi_Chiapas$calculated_stat)
pi_Durango_max <- max(pi_Durango$calculated_stat)
pi_Chihuahua_max <- max(pi_Chihuahua$calculated_stat)

# SD pi (per 50kbp window)

pi_Nicaragua_sd <- sd(pi_Nicaragua$calculated_stat)
pi_El_Salvador_Honduras_sd <- sd(pi_El_Salvador_Honduras$calculated_stat)
pi_Guerrero_sd <- sd(pi_Guerrero$calculated_stat)
pi_Southwest_USA_sd <- sd(pi_Southwest_USA$calculated_stat)
pi_Chiapas_sd <- sd(pi_Chiapas$calculated_stat)
pi_Durango_sd <- sd(pi_Durango$calculated_stat)
pi_Chihuahua_sd <- sd(pi_Chihuahua$calculated_stat)


# Var pi (per 50kbp window)

pi_Nicaragua_var <- var(pi_Nicaragua$calculated_stat)
pi_El_Salvador_Honduras_var <- var(pi_El_Salvador_Honduras$calculated_stat)
pi_Guerrero_var <- var(pi_Guerrero$calculated_stat)
pi_Southwest_USA_var <- var(pi_Southwest_USA$calculated_stat)
pi_Chiapas_var <- var(pi_Chiapas$calculated_stat)
pi_Durango_var <- var(pi_Durango$calculated_stat)
pi_Chihuahua_var <- var(pi_Chihuahua$calculated_stat)


# set up plotting dimensions
par(mfrow=c(7,1))
par(mar=c(2,5,1.5,0))

# Plot pi's for Nicaragua Pop

total_windows <- nrow(pi_Nicaragua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_Nicaragua <- na.omit(pi_Nicaragua)

# sort dataset by chromosome and within chromosome window order

pi_Nicaragua1 <- ddply(pi_Nicaragua, c('start'))

pi_Nicaragua2 <- ddply(pi_Nicaragua1, c('chr'))

pi_Nicaragua3 <- left_join(data.frame(chr = chromosome_order), pi_Nicaragua2, by = "chr")

pi_Nicaragua <- pi_Nicaragua3

chr <- unique(pi_Nicaragua[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_Nicaragua)[pi_Nicaragua[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi 
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Nicaragua")
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

points(rownames(pi_Nicaragua), pi_Nicaragua$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_Nicaragua[b_rep,1] %in% pi_Nicaragua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_Nicaragua)))
  total_rep <- c(total_rep, mean(pi_Nicaragua$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="azure3")

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))


# Plot pi's for El_Salvador_Honduras Pop

total_windows <- nrow(pi_El_Salvador_Honduras)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_El_Salvador_Honduras <- na.omit(pi_El_Salvador_Honduras)

# sort dataset by chromosome and within chromosome window order

pi_El_Salvador_Honduras1 <- ddply(pi_El_Salvador_Honduras, c('start'))

pi_El_Salvador_Honduras2 <- ddply(pi_El_Salvador_Honduras1, c('chr'))

pi_El_Salvador_Honduras3 <- left_join(data.frame(chr = chromosome_order), pi_El_Salvador_Honduras2, by = "chr")

pi_El_Salvador_Honduras <- pi_El_Salvador_Honduras3

chr <- unique(pi_El_Salvador_Honduras[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_El_Salvador_Honduras)[pi_El_Salvador_Honduras[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "El_Salvador_Honduras")
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

points(rownames(pi_El_Salvador_Honduras), pi_El_Salvador_Honduras$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_El_Salvador_Honduras[b_rep,1] %in% pi_El_Salvador_Honduras[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_El_Salvador_Honduras)))
  total_rep <- c(total_rep, mean(pi_El_Salvador_Honduras$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="gray16")

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))


# Plot pi's for Chiapas Pop

total_windows <- nrow(pi_Chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_Chiapas <- na.omit(pi_Chiapas)

# sort dataset by chromosome and within chromosome window order

pi_Chiapas1 <- ddply(pi_Chiapas, c('start'))

pi_Chiapas2 <- ddply(pi_Chiapas1, c('chr'))

pi_Chiapas3 <- left_join(data.frame(chr = chromosome_order), pi_Chiapas2, by = "chr")

pi_Chiapas <- pi_Chiapas3

chr <- unique(pi_Chiapas[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_Chiapas)[pi_Chiapas[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Chiapas")
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

points(rownames(pi_Chiapas), pi_Chiapas$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_Chiapas[b_rep,1] %in% pi_Chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_Chiapas)))
  total_rep <- c(total_rep, mean(pi_Chiapas$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="lightslateblue")


# Plot pi's for Guerrero Pop

total_windows <- nrow(pi_Guerrero)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_Guerrero <- na.omit(pi_Guerrero)

# sort dataset by chromosome and within chromosome window order

pi_Guerrero1 <- ddply(pi_Guerrero, c('start'))

pi_Guerrero2 <- ddply(pi_Guerrero1, c('chr'))

pi_Guerrero3 <- left_join(data.frame(chr = chromosome_order), pi_Guerrero2, by = "chr")

pi_Guerrero <- pi_Guerrero3

chr <- unique(pi_Guerrero[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_Guerrero)[pi_Guerrero[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Guerrero")
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

points(rownames(pi_Guerrero), pi_Guerrero$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_Guerrero[b_rep,1] %in% pi_Guerrero[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_Guerrero)))
  total_rep <- c(total_rep, mean(pi_Guerrero$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="yellow2")





# Plot pi for Durango Pop

total_windows <- nrow(pi_Durango)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_Durango <- na.omit(pi_Durango)

# sort dataset by chromosome and within chromosome window order

pi_Durango1 <- ddply(pi_Durango, c('start'))

pi_Durango2 <- ddply(pi_Durango1, c('chr'))

pi_Durango3 <- left_join(data.frame(chr = chromosome_order), pi_Durango2, by = "chr")

pi_Durango <- pi_Durango3

chr <- unique(pi_Durango[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_Durango)[pi_Durango[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Durango")
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

points(rownames(pi_Durango), pi_Durango$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_Durango[b_rep,1] %in% pi_Durango[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_Durango)))
  total_rep <- c(total_rep, mean(pi_Durango$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="turquoise2")



# Plot pi for Chihuahua Pop

total_windows <- nrow(pi_Chihuahua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_Chihuahua <- na.omit(pi_Chihuahua)

# sort dataset by chromosome and within chromosome window order

pi_Chihuahua1 <- ddply(pi_Chihuahua, c('start'))

pi_Chihuahua2 <- ddply(pi_Chihuahua1, c('chr'))

pi_Chihuahua3 <- left_join(data.frame(chr = chromosome_order), pi_Chihuahua2, by = "chr")

pi_Chihuahua <- pi_Chihuahua3

chr <- unique(pi_Chihuahua[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_Chihuahua)[pi_Chihuahua[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Chihuahua")
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

points(rownames(pi_Chihuahua), pi_Chihuahua$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_Chihuahua[b_rep,1] %in% pi_Chihuahua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_Chihuahua)))
  total_rep <- c(total_rep, mean(pi_Chihuahua$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="steelblue3")



# Plot pi for Southwest_USA Pop

total_windows <- nrow(pi_Southwest_USA)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_Southwest_USA <- na.omit(pi_Southwest_USA)

# sort dataset by chromosome and within chromosome window order

pi_Southwest_USA1 <- ddply(pi_Southwest_USA, c('start'))

pi_Southwest_USA2 <- ddply(pi_Southwest_USA1, c('chr'))

pi_Southwest_USA3 <- left_join(data.frame(chr = chromosome_order), pi_Southwest_USA2, by = "chr")

pi_Southwest_USA <- pi_Southwest_USA3

chr <- unique(pi_Southwest_USA[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_Southwest_USA)[pi_Southwest_USA[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Southwest_USA")
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

points(rownames(pi_Southwest_USA), pi_Southwest_USA$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_Southwest_USA[b_rep,1] %in% pi_Southwest_USA[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_Southwest_USA)))
  total_rep <- c(total_rep, mean(pi_Southwest_USA$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="navy")









































































# Correlations of Pi across populations 


# plotting of pairwise pi (Southwest_USA vs Chihuahua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Southwest_USA_Chihuahua <- merge(pi_Southwest_USA, pi_Chihuahua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Southwest_USA_Chihuahua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Southwest_USA_Chihuahua <- combined_dataframe_Southwest_USA_Chihuahua %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Southwest_USA_Chihuahua <- combined_dataframe_no_na_Southwest_USA_Chihuahua[!combined_dataframe_no_na_Southwest_USA_Chihuahua$chr == "CM027535.1",]

a <- ggplot(combined_dataframe_no_na_Southwest_USA_Chihuahua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.99", size =4) +
  xlab(expression(pi ~ "Chihuahua")) + 
  ylab(expression(pi ~ "Southwest_USA")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Southwest_USA_Chihuahua$calculated_stat.y, combined_dataframe_no_na_Southwest_USA_Chihuahua$calculated_stat.x,
         method = "spearman")



# plotting of pairwise pi (Southwest_USA vs Durango)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Southwest_USA_Durango <- merge(pi_Southwest_USA, pi_Durango, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Southwest_USA_Durango %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Southwest_USA_Durango <- combined_dataframe_Southwest_USA_Durango %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Southwest_USA_Durango <- combined_dataframe_no_na_Southwest_USA_Durango[!combined_dataframe_no_na_Southwest_USA_Durango$chr == "CM027535.1",]

b <- ggplot(combined_dataframe_no_na_Southwest_USA_Durango, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.98", size =4) +
  xlab(expression(pi ~ "Durango")) + 
  ylab(expression(pi ~ "Southwest_USA")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Southwest_USA_Durango$calculated_stat.y, combined_dataframe_no_na_Southwest_USA_Durango$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Southwest_USA vs Guerrero)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Southwest_USA_Guerrero <- merge(pi_Southwest_USA, pi_Guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Southwest_USA_Guerrero %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Southwest_USA_Guerrero <- combined_dataframe_Southwest_USA_Guerrero %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Southwest_USA_Guerrero <- combined_dataframe_no_na_Southwest_USA_Guerrero[!combined_dataframe_no_na_Southwest_USA_Guerrero$chr == "CM027535.1",]

c <- ggplot(combined_dataframe_no_na_Southwest_USA_Guerrero, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.97", size =4) +
  xlab(expression(pi ~ "Guerrero")) + 
  ylab(expression(pi ~ "Southwest_USA")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Southwest_USA_Guerrero$calculated_stat.y, combined_dataframe_no_na_Southwest_USA_Guerrero$calculated_stat.x,
         method = "spearman")





# plotting of pairwise pi (Southwest_USA vs Chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Southwest_USA_Chiapas <- merge(pi_Southwest_USA, pi_Chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Southwest_USA_Chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Southwest_USA_Chiapas <- combined_dataframe_Southwest_USA_Chiapas %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Southwest_USA_Chiapas <- combined_dataframe_no_na_Southwest_USA_Chiapas[!combined_dataframe_no_na_Southwest_USA_Chiapas$chr == "CM027535.1",]


d <- ggplot(combined_dataframe_no_na_Southwest_USA_Chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.015, label = "\u03C1 = 0.90", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Southwest_USA")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Southwest_USA_Chiapas$calculated_stat.y, combined_dataframe_no_na_Southwest_USA_Chiapas$calculated_stat.x,
         method = "spearman")






# plotting of pairwise pi (Southwest_USA vs El_Salvador_Honduras)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Southwest_USA_El_Salvador_Honduras <- merge(pi_Southwest_USA, pi_El_Salvador_Honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Southwest_USA_El_Salvador_Honduras %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras <- combined_dataframe_Southwest_USA_El_Salvador_Honduras %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras <- combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras[!combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras$chr == "CM027535.1",]


e <- ggplot(combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.015, label = "\u03C1 = 0.96", size =4) +
  xlab(expression(pi ~ "El_Salvador_Honduras")) + 
  ylab(expression(pi ~ "Southwest_USA")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras$calculated_stat.y, combined_dataframe_no_na_Southwest_USA_El_Salvador_Honduras$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Southwest_USA vs Nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Southwest_USA_Nicaragua <- merge(pi_Southwest_USA, pi_Nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Southwest_USA_Nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Southwest_USA_Nicaragua <- combined_dataframe_Southwest_USA_Nicaragua %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Southwest_USA_Nicaragua <- combined_dataframe_no_na_Southwest_USA_Nicaragua[!combined_dataframe_no_na_Southwest_USA_Nicaragua$chr == "CM027535.1",]


f <- ggplot(combined_dataframe_no_na_Southwest_USA_Nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.020, x = 0.012, label = "\u03C1 = 0.89", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Southwest_USA")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Southwest_USA_Nicaragua$calculated_stat.y, combined_dataframe_no_na_Southwest_USA_Nicaragua$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Chihuahua vs Durango)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chihuahua_Durango <- merge(pi_Chihuahua, pi_Durango, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chihuahua_Durango %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chihuahua_Durango <- combined_dataframe_Chihuahua_Durango %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Chihuahua_Durango <- combined_dataframe_no_na_Chihuahua_Durango[!combined_dataframe_no_na_Chihuahua_Durango$chr == "CM027535.1",]

g <- ggplot(combined_dataframe_no_na_Chihuahua_Durango, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.98", size =4) +
  xlab(expression(pi ~ "Durango")) + 
  ylab(expression(pi ~ "Chihuahua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chihuahua_Durango$calculated_stat.y, combined_dataframe_no_na_Chihuahua_Durango$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Chihuahua vs Guerrero)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chihuahua_Guerrero <- merge(pi_Chihuahua, pi_Guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chihuahua_Guerrero %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chihuahua_Guerrero <- combined_dataframe_Chihuahua_Guerrero %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Chihuahua_Guerrero <- combined_dataframe_no_na_Chihuahua_Guerrero[!combined_dataframe_no_na_Chihuahua_Guerrero$chr == "CM027535.1",]

h <- ggplot(combined_dataframe_no_na_Chihuahua_Guerrero, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.97", size =4) +
  xlab(expression(pi ~ "Guerrero")) + 
  ylab(expression(pi ~ "Chihuahua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chihuahua_Guerrero$calculated_stat.y, combined_dataframe_no_na_Chihuahua_Guerrero$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Chihuahua vs Chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chihuahua_Chiapas <- merge(pi_Chihuahua, pi_Chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chihuahua_Chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chihuahua_Chiapas <- combined_dataframe_Chihuahua_Chiapas %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Chihuahua_Chiapas <- combined_dataframe_no_na_Chihuahua_Chiapas[!combined_dataframe_no_na_Chihuahua_Chiapas$chr == "CM027535.1",]

i <- ggplot(combined_dataframe_no_na_Chihuahua_Chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.90", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Chihuahua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chihuahua_Chiapas$calculated_stat.y, combined_dataframe_no_na_Chihuahua_Chiapas$calculated_stat.x,
         method = "spearman")





# plotting of pairwise pi (Chihuahua vs El_Salvador_Honduras)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chihuahua_El_Salvador_Honduras <- merge(pi_Chihuahua, pi_El_Salvador_Honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chihuahua_El_Salvador_Honduras %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras <- combined_dataframe_Chihuahua_El_Salvador_Honduras %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras <- combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras[!combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras$chr == "CM027535.1",]

j <- ggplot(combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.96", size =4) +
  xlab(expression(pi ~ "El_Salvador_Honduras")) + 
  ylab(expression(pi ~ "Chihuahua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras$calculated_stat.y, combined_dataframe_no_na_Chihuahua_El_Salvador_Honduras$calculated_stat.x,
         method = "spearman")



# plotting of pairwise pi (Chihuahua vs Nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chihuahua_Nicaragua <- merge(pi_Chihuahua, pi_Nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chihuahua_Nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chihuahua_Nicaragua <- combined_dataframe_Chihuahua_Nicaragua %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Chihuahua_Nicaragua <- combined_dataframe_no_na_Chihuahua_Nicaragua[!combined_dataframe_no_na_Chihuahua_Nicaragua$chr == "CM027535.1",]

k <- ggplot(combined_dataframe_no_na_Chihuahua_Nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.88", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Chihuahua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chihuahua_Nicaragua$calculated_stat.y, combined_dataframe_no_na_Chihuahua_Nicaragua$calculated_stat.x,
         method = "spearman")





# plotting of pairwise pi (Durango vs Guerrero)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Durango_Guerrero <- merge(pi_Durango, pi_Guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Durango_Guerrero %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Durango_Guerrero <- combined_dataframe_Durango_Guerrero %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Durango_Guerrero <- combined_dataframe_no_na_Durango_Guerrero[!combined_dataframe_no_na_Durango_Guerrero$chr == "CM027535.1",]

l <- ggplot(combined_dataframe_no_na_Durango_Guerrero, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.97", size =4) +
  xlab(expression(pi ~ "Guerrero")) + 
  ylab(expression(pi ~ "Durango")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Durango_Guerrero$calculated_stat.y, combined_dataframe_no_na_Durango_Guerrero$calculated_stat.x,
         method = "spearman")






# plotting of pairwise pi (Durango vs Chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Durango_Chiapas <- merge(pi_Durango, pi_Chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Durango_Chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Durango_Chiapas <- combined_dataframe_Durango_Chiapas %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Durango_Chiapas <- combined_dataframe_no_na_Durango_Chiapas[!combined_dataframe_no_na_Durango_Chiapas$chr == "CM027535.1",]

m <- ggplot(combined_dataframe_no_na_Durango_Chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.90", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Durango")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Durango_Chiapas$calculated_stat.y, combined_dataframe_no_na_Durango_Chiapas$calculated_stat.x,
         method = "spearman")








# plotting of pairwise pi (Durango vs El_Salvador_Honduras)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Durango_El_Salvador_Honduras <- merge(pi_Durango, pi_El_Salvador_Honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Durango_El_Salvador_Honduras %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Durango_El_Salvador_Honduras <- combined_dataframe_Durango_El_Salvador_Honduras %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Durango_El_Salvador_Honduras <- combined_dataframe_no_na_Durango_El_Salvador_Honduras[!combined_dataframe_no_na_Durango_El_Salvador_Honduras$chr == "CM027535.1",]

n <- ggplot(combined_dataframe_no_na_Durango_El_Salvador_Honduras, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.96", size =4) +
  xlab(expression(pi ~ "El_Salvador_Honduras")) + 
  ylab(expression(pi ~ "Durango")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Durango_El_Salvador_Honduras$calculated_stat.y, combined_dataframe_no_na_Durango_El_Salvador_Honduras$calculated_stat.x,
         method = "spearman")






# plotting of pairwise pi (Durango vs Nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Durango_Nicaragua <- merge(pi_Durango, pi_Nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Durango_Nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Durango_Nicaragua <- combined_dataframe_Durango_Nicaragua %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_Durango_Nicaragua <- combined_dataframe_no_na_Durango_Nicaragua[!combined_dataframe_no_na_Durango_Nicaragua$chr == "CM027535.1",]

o <- ggplot(combined_dataframe_no_na_Durango_Nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.89", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Durango")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Durango_Nicaragua$calculated_stat.y, combined_dataframe_no_na_Durango_Nicaragua$calculated_stat.x,
         method = "spearman")





# plotting of pi (Guerrero vs Chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Guerrero_Chiapas <- merge(pi_Guerrero, pi_Chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Guerrero_Chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Guerrero_Chiapas <- combined_dataframe_Guerrero_Chiapas %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Guerrero_Chiapas <- combined_dataframe_no_na_Guerrero_Chiapas[!combined_dataframe_no_na_Guerrero_Chiapas$chr == "CM027535.1",]


p <- ggplot(combined_dataframe_no_na_Guerrero_Chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.012, label = "\u03C1 = 0.89", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Guerrero_Chiapas$calculated_stat.y, combined_dataframe_no_na_Guerrero_Chiapas$calculated_stat.x,
         method = "spearman")





# plotting of pairwise pi (Guerrero vs El_Salvador_Honduras)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Guerrero_El_Salvador_Honduras<- merge(pi_Guerrero, pi_El_Salvador_Honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Guerrero_El_Salvador_Honduras %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Guerrero_El_Salvador_Honduras <- combined_dataframe_Guerrero_El_Salvador_Honduras %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Guerrero_El_Salvador_Honduras <- combined_dataframe_no_na_Guerrero_El_Salvador_Honduras[!combined_dataframe_no_na_Guerrero_El_Salvador_Honduras$chr == "CM027535.1",]


q <- ggplot(combined_dataframe_no_na_Guerrero_El_Salvador_Honduras, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.020, x = 0.012, label = "\u03C1 = 0.95", size =4) +
  xlab(expression(pi ~ "El_Salvador_Honduras")) + 
  ylab(expression(pi ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Guerrero_El_Salvador_Honduras$calculated_stat.y, combined_dataframe_no_na_Guerrero_El_Salvador_Honduras$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Guerrero vs Nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Guerrero_Nicaragua<- merge(pi_Guerrero, pi_Nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Guerrero_Nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Guerrero_Nicaragua <- combined_dataframe_Guerrero_Nicaragua %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Guerrero_Nicaragua <- combined_dataframe_no_na_Guerrero_Nicaragua[!combined_dataframe_no_na_Guerrero_Nicaragua$chr == "CM027535.1",]


r <- ggplot(combined_dataframe_no_na_Guerrero_Nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.020, x = 0.010, label = "\u03C1 = 0.88", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Guerrero")) +
  theme_cowplot(12)


cor.test(combined_dataframe_no_na_Guerrero_Nicaragua$calculated_stat.y, combined_dataframe_no_na_Guerrero_Nicaragua$calculated_stat.x,
         method = "spearman")





# plotting of pairwise pi (Chiapas vs El_Salvador_Honduras)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chiapas_El_Salvador_Honduras <- merge(pi_Chiapas, pi_El_Salvador_Honduras, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chiapas_El_Salvador_Honduras %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chiapas_El_Salvador_Honduras <- combined_dataframe_Chiapas_El_Salvador_Honduras %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Chiapas_El_Salvador_Honduras <- combined_dataframe_no_na_Chiapas_El_Salvador_Honduras[!combined_dataframe_no_na_Chiapas_El_Salvador_Honduras$chr == "CM027535.1",]


s <- ggplot(combined_dataframe_no_na_Chiapas_El_Salvador_Honduras, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.91", size =4) +
  xlab(expression(pi ~ "El_Salvador_Honduras")) + 
  ylab(expression(pi ~ "Chiapas")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chiapas_El_Salvador_Honduras$calculated_stat.y, combined_dataframe_no_na_Chiapas_El_Salvador_Honduras$calculated_stat.x,
         method = "spearman")






# plotting of pairwise pi (Chiapas vs Nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_Chiapas_Nicaragua <- merge(pi_Chiapas, pi_Nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_Chiapas_Nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_Chiapas_Nicaragua <- combined_dataframe_Chiapas_Nicaragua %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_Chiapas_Nicaragua <- combined_dataframe_no_na_Chiapas_Nicaragua[!combined_dataframe_no_na_Chiapas_Nicaragua$chr == "CM027535.1",]


t <- ggplot(combined_dataframe_no_na_Chiapas_Nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.83", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Chiapas")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_Chiapas_Nicaragua$calculated_stat.y, combined_dataframe_no_na_Chiapas_Nicaragua$calculated_stat.x,
         method = "spearman")




# plotting of pairwise pi (Nicaragua vs El_Salvador_Honduras)

## combine piand joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_El_Salvador_Honduras_Nicaragua <- merge(pi_El_Salvador_Honduras, pi_Nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_El_Salvador_Honduras_Nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua <- combined_dataframe_El_Salvador_Honduras_Nicaragua %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua <- combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua[!combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua$chr == "CM027535.1",]


u <- ggplot(combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.90", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "El_Salvador_Honduras")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua$calculated_stat.y, combined_dataframe_no_na_El_Salvador_Honduras_Nicaragua$calculated_stat.x,
         method = "spearman")


pattern <- c("a","b","c","d", "e", "f", "g", "h", "i", "j", "k")

pattern1 <- c("l", "m", "n", "o", "p", "q", "r", "s", "t", "u")

plot_grid(plotlist = mget(pattern), ncol = 4, labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K'))

ggsave(filename = "pi_correlations.pdf")

plot_grid(plotlist = mget(pattern1), ncol = 4, labels = c('L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U'))

ggsave(filename = "pi_correlations1.pdf")







