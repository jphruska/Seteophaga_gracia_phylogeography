# Read in Pi window file

library(plyr)
library(dplyr)
options(scipen = 999)

x <- read.table("pi_all_pops.txt", sep="\t", stringsAsFactors = TRUE, header = TRUE)

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

pi_northern <- x[x=="Northern",]
pi_northern <- pi_northern[pi_northern$number_variable_sites > 0,]
pi_nicaragua <- x[x=="Nicaragua",]
pi_nicaragua <- pi_nicaragua[pi_nicaragua$number_variable_sites > 0,]
pi_guerrero <- x[x=="Guerrero",]
pi_guerrero <- pi_guerrero[pi_guerrero$number_variable_sites > 0,]
pi_central <-x[x=="Central",]
pi_central <- pi_central[pi_central$number_variable_sites > 0,]
pi_chiapas <-x[x=="Chiapas",]
pi_chiapas <- pi_chiapas[pi_chiapas$number_variable_sites > 0,]

# pi's Plot of Five Populations

# Average pi's (per 50kbp window)

pi_nicaragua_mean <- mean(pi_nicaragua$calculated_stat)
pi_central_mean <- mean(pi_central$calculated_stat)
pi_guerrero_mean <- mean(pi_guerrero$calculated_stat)
pi_northern_mean <- mean(pi_northern$calculated_stat)
pi_chiapas_mean <- mean(pi_chiapas$calculated_stat)

# SD pi's (per 50kbp window)

pi_nicaragua_sd <- sd(pi_nicaragua$calculated_stat)
pi_central_sd <- sd(pi_central$calculated_stat)
pi_guerrero_sd <- sd(pi_guerrero$calculated_stat)
pi_northern_sd <- sd(pi_northern$calculated_stat)


# Var pi's (per 50kbp window)

pi_nicaragua_var <- var(pi_nicaragua$calculated_stat)
pi_central_var <- var(pi_central$calculated_stat)
pi_guerrero_var <- var(pi_guerrero$calculated_stat)
pi_northern_var <- var(pi_northern$calculated_stat)


# set up plotting dimensions
par(mfrow=c(5,1))
par(mar=c(2,5,1.5,0))

# Plot pi's for Nicaragua Pop

total_windows <- nrow(pi_nicaragua)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_nicaragua <- na.omit(pi_nicaragua)

# sort dataset by chromosome and within chromosome window order

pi_nicaragua1 <- ddply(pi_nicaragua, c('start'))

pi_nicaragua2 <- ddply(pi_nicaragua1, c('chr'))

pi_nicaragua3 <- left_join(data.frame(chr = chromosome_order), pi_nicaragua2, by = "chr")

pi_nicaragua <- pi_nicaragua3

chr <- unique(pi_nicaragua[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_nicaragua)[pi_nicaragua[,1] == chr[a]]
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

points(rownames(pi_nicaragua), pi_nicaragua$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_nicaragua[b_rep,1] %in% pi_nicaragua[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_nicaragua)))
  total_rep <- c(total_rep, mean(pi_nicaragua$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="azure2")

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))


# Plot pi's for Central Pop

total_windows <- nrow(pi_central)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_central <- na.omit(pi_central)

# sort dataset by chromosome and within chromosome window order

pi_central1 <- ddply(pi_central, c('start'))

pi_central2 <- ddply(pi_central1, c('chr'))

pi_central3 <- left_join(data.frame(chr = chromosome_order), pi_central2, by = "chr")

pi_central <- pi_central3

chr <- unique(pi_central[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_central)[pi_central[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi  
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Central")
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

points(rownames(pi_central), pi_central$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_central[b_rep,1] %in% pi_central[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_central)))
  total_rep <- c(total_rep, mean(pi_central$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="gray16")

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))


# Plot pi's for Chiapas Pop

total_windows <- nrow(pi_chiapas)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_chiapas <- na.omit(pi_chiapas)

# sort dataset by chromosome and within chromosome window order

pi_chiapas1 <- ddply(pi_chiapas, c('start'))

pi_chiapas2 <- ddply(pi_chiapas1, c('chr'))

pi_chiapas3 <- left_join(data.frame(chr = chromosome_order), pi_chiapas2, by = "chr")

pi_chiapas <- pi_chiapas3

chr <- unique(pi_chiapas[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_chiapas)[pi_chiapas[,1] == chr[a]]
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

points(rownames(pi_chiapas), pi_chiapas$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_chiapas[b_rep,1] %in% pi_chiapas[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_chiapas)))
  total_rep <- c(total_rep, mean(pi_chiapas$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="slateblue3")





# Plot pi's for Guerrero Pop

total_windows <- nrow(pi_guerrero)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_guerrero <- na.omit(pi_guerrero)

# sort dataset by chromosome and within chromosome window order

pi_guerrero1 <- ddply(pi_guerrero, c('start'))

pi_guerrero2 <- ddply(pi_guerrero1, c('chr'))

pi_guerrero3 <- left_join(data.frame(chr = chromosome_order), pi_guerrero2, by = "chr")

pi_guerrero <- pi_guerrero3

chr <- unique(pi_guerrero[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_guerrero)[pi_guerrero[,1] == chr[a]]
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

points(rownames(pi_guerrero), pi_guerrero$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_guerrero[b_rep,1] %in% pi_guerrero[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_guerrero)))
  total_rep <- c(total_rep, mean(pi_guerrero$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="yellow2")

# Plot pi for Northern Pop

total_windows <- nrow(pi_northern)

window_size <- 10

# what are the unique chromosomes and their bounding areas for plotting?
pi_northern <- na.omit(pi_northern)

# sort dataset by chromosome and within chromosome window order

pi_northern1 <- ddply(pi_northern, c('start'))

pi_northern2 <- ddply(pi_northern1, c('chr'))

pi_northern3 <- left_join(data.frame(chr = chromosome_order), pi_northern2, by = "chr")

pi_northern <- pi_northern3

chr <- unique(pi_northern[,1])

chr_polygons_pi <- list()

# make the plotting polygons
for(a in 1:length(chr)) {
  a1 <- rownames(pi_northern)[pi_northern[,1] == chr[a]]
  a2 <- a1[length(a1)]
  a1 <- a1[1]
  chr_polygons_pi[[a]] <- rbind(c(a1, 0), c(a2, 0), c(a2, 0.030), c(a1, 0.030), c(a1, 0))
}

# set up plotting dimensions
# par(mfrow=c(1,1))
# par(mar=c(0.5,5,1,0))

# plot pi d 
plot(c(-1,-1), ylim=c(0.000,0.020), xlim=c(1, total_windows), xaxt="n", col="white", bty="n", cex.axis=1.1, cex.lab=1.3, ylab=bquote(pi), main = "Northern")
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

points(rownames(pi_northern), pi_northern$calculated_stat, pch=19, cex=0.1, col="gray71")	

# sliding windows
total_rep <- c()
place_rep <- c()
sliding_windows <- ceiling(total_windows / window_size)
for(b in 0:sliding_windows) {
  b_rep <- seq(from=(b*window_size - (window_size/2 -1)), to=(b*window_size + (window_size/2)), by=1)
  b_rep <- b_rep[b_rep >= 1 & b_rep <= total_windows]
  b_rep <- b_rep[pi_northern[b_rep,1] %in% pi_northern[b*window_size,1]]
  b_rep <- na.omit(match(b_rep, rownames(pi_northern)))
  total_rep <- c(total_rep, mean(pi_northern$calculated_stat[b_rep]))
  place_rep <- c(place_rep, b*window_size)
}
lines(place_rep, total_rep, lwd=0.9, col="lightsteelblue1")



# Correlations of Pi across populations 


# plotting of pairwise pi (northern vs guerrero)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_northern_guerrero <- merge(pi_northern, pi_guerrero, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_northern_guerrero %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_northern_guerrero <- combined_dataframe_northern_guerrero %>%
    drop_na())

## filter out Z chromosome 


combined_dataframe_no_na_northern_guerrero <- combined_dataframe_no_na_northern_guerrero[!combined_dataframe_no_na_northern_guerrero$chr == "CM027535.1",]

a <- ggplot(combined_dataframe_no_na_northern_guerrero, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.015, x = 0.005, label = "\u03C1 = 0.97", size =4) +
  xlab(expression(pi ~ "Guerrero")) + 
  ylab(expression(pi ~ "Northern")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_northern_guerrero$calculated_stat.y, combined_dataframe_no_na_northern_guerrero$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (northern vs chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_northern_chiapas <- merge(pi_northern, pi_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_northern_chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_northern_chiapas <- combined_dataframe_northern_chiapas %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_northern_chiapas <- combined_dataframe_no_na_northern_chiapas[!combined_dataframe_no_na_northern_chiapas$chr == "CM027535.1",]


b <- ggplot(combined_dataframe_no_na_northern_chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.015, label = "\u03C1 = 0.90", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Northern")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_northern_chiapas$calculated_stat.y, combined_dataframe_no_na_northern_chiapas$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (northern vs central)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_northern_central <- merge(pi_northern, pi_central, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_northern_central %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_northern_central <- combined_dataframe_northern_central %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_northern_central <- combined_dataframe_no_na_northern_central[!combined_dataframe_no_na_northern_central$chr == "CM027535.1",]


c <- ggplot(combined_dataframe_no_na_northern_central, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.015, label = "\u03C1 = 0.96", size =4) +
  xlab(expression(pi ~ "Central")) + 
  ylab(expression(pi ~ "Northern")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_northern_central$calculated_stat.y, combined_dataframe_no_na_northern_central$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (northern vs nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_northern_nicaragua <- merge(pi_northern, pi_nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_northern_nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_northern_nicaragua <- combined_dataframe_northern_nicaragua %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_northern_nicaragua <- combined_dataframe_no_na_northern_nicaragua[!combined_dataframe_no_na_northern_nicaragua$chr == "CM027535.1",]


d <- ggplot(combined_dataframe_no_na_northern_nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.020, x = 0.012, label = "\u03C1 = 0.89", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Northern")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_northern_nicaragua$calculated_stat.y, combined_dataframe_no_na_northern_nicaragua$calculated_stat.x,
         method = "spearman")

# plotting of pi (guerrero vs chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_guerrero_chiapas <- merge(pi_guerrero, pi_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_guerrero_chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_guerrero_chiapas <- combined_dataframe_guerrero_chiapas %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_guerrero_chiapas <- combined_dataframe_no_na_guerrero_chiapas[!combined_dataframe_no_na_guerrero_chiapas$chr == "CM027535.1",]


e <- ggplot(combined_dataframe_no_na_guerrero_chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.012, label = "\u03C1 = 0.89", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_guerrero_chiapas$calculated_stat.y, combined_dataframe_no_na_guerrero_chiapas$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (guerrero vs central)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_guerrero_central<- merge(pi_guerrero, pi_central, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_guerrero_central %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_guerrero_central <- combined_dataframe_guerrero_central %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_guerrero_central <- combined_dataframe_no_na_guerrero_central[!combined_dataframe_no_na_guerrero_central$chr == "CM027535.1",]


f <- ggplot(combined_dataframe_no_na_guerrero_central, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.020, x = 0.012, label = "\u03C1 = 0.95", size =4) +
  xlab(expression(pi ~ "Central")) + 
  ylab(expression(pi ~ "Guerrero")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_guerrero_central$calculated_stat.y, combined_dataframe_no_na_guerrero_central$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (guerrero vs nicaragua)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_guerrero_nicaragua<- merge(pi_guerrero, pi_nicaragua, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_guerrero_nicaragua %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_guerrero_nicaragua <- combined_dataframe_guerrero_nicaragua %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_guerrero_nicaragua <- combined_dataframe_no_na_guerrero_nicaragua[!combined_dataframe_no_na_guerrero_nicaragua$chr == "CM027535.1",]


g <- ggplot(combined_dataframe_no_na_guerrero_nicaragua, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.020, x = 0.010, label = "\u03C1 = 0.88", size =4) +
  xlab(expression(pi ~ "Nicaragua")) + 
  ylab(expression(pi ~ "Guerrero")) +
  theme_cowplot(12)


cor.test(combined_dataframe_no_na_guerrero_nicaragua$calculated_stat.y, combined_dataframe_no_na_guerrero_nicaragua$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (central vs chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_central_chiapas <- merge(pi_central, pi_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_central_chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_central_chiapas <- combined_dataframe_central_chiapas %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_central_chiapas <- combined_dataframe_no_na_central_chiapas[!combined_dataframe_no_na_central_chiapas$chr == "CM027535.1",]


h <- ggplot(combined_dataframe_no_na_central_chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.91", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Central")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_central_chiapas$calculated_stat.y, combined_dataframe_no_na_central_chiapas$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (nicaragua vs chiapas)

## combine pi and joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_nicaragua_chiapas <- merge(pi_nicaragua, pi_chiapas, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_nicaragua_chiapas %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_nicaragua_chiapas <- combined_dataframe_nicaragua_chiapas %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_nicaragua_chiapas <- combined_dataframe_no_na_nicaragua_chiapas[!combined_dataframe_no_na_nicaragua_chiapas$chr == "CM027535.1",]


i <- ggplot(combined_dataframe_no_na_nicaragua_chiapas, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.83", size =4) +
  xlab(expression(pi ~ "Chiapas")) + 
  ylab(expression(pi ~ "Nicaragua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_nicaragua_chiapas$calculated_stat.y, combined_dataframe_no_na_nicaragua_chiapas$calculated_stat.x,
         method = "spearman")

# plotting of pairwise pi (nicaragua vs central)

## combine piand joined by chr, start, and end

colnames_merge <- c("chr", "start", "end")

combined_dataframe_nicaragua_central <- merge(pi_nicaragua, pi_central, by = colnames_merge, all.y = TRUE, all.x = TRUE)


## Return rows with NAs 

combined_dataframe_nicaragua_central %>%
  filter(if_any(everything(), is.na))

## Filter out rows with NAs

(combined_dataframe_no_na_nicaragua_central <- combined_dataframe_nicaragua_central %>%
    drop_na())


## filter out Z chromosome 

combined_dataframe_no_na_nicaragua_central <- combined_dataframe_no_na_nicaragua_central[!combined_dataframe_no_na_nicaragua_central$chr == "CM027535.1",]


j <- ggplot(combined_dataframe_no_na_nicaragua_central, aes(x=calculated_stat.y, y=calculated_stat.x)) +
  geom_point()+
  geom_smooth(method = 'lm', col = "yellow") +
  annotate("text", y = 0.025, x = 0.017, label = "\u03C1 = 0.90", size =4) +
  xlab(expression(pi ~ "Central")) + 
  ylab(expression(pi ~ "Nicaragua")) +
  theme_cowplot(12)

cor.test(combined_dataframe_no_na_nicaragua_central$calculated_stat.y, combined_dataframe_no_na_nicaragua_central$calculated_stat.x,
         method = "spearman")


pattern <- c("a","b","c","d", "e", "f", "g", "h", "i", "j")

plot_grid(plotlist = mget(pattern), ncol = 4, labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J'))

ggsave(filename = "pi_correlations.pdf")




