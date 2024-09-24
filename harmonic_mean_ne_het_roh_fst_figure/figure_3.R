## Script to make Figure 3. 

library(ggpmisc)
library(ggplot2)
library(tidyverse)
library(cowplot)
library(dplyr)
library(tibble)
library(quantreg)
library(ggrepel)
library(broom)

## read in heterozygosity, ne, roh data 

het_ne_roh <- read.csv(file = "het_ne_roh.csv", header= T, sep = ",")

## read in pairwise fst data

pairwise_fst <- read.csv(file = "fst_average_lat.csv", header= T, sep = ",")

colnames(pairwise_fst) <- c("Comparison", "fst", "average.lat.1", "average.lat.2", "average.lat.1.2")

# Plots of harmonic_ne, heterozygosity, roh (10kb, 50kb, 100kb, 250kb), and fst 

pattern <- c("a1","b1", "a2", "b2")

# subset out belize individuals
het_ne_roh1 <- het_ne_roh[-1:-2,]

formula <- y ~ poly(x, 3, raw = TRUE)

# assessing third-degree polynomial model of harmonic_ne ~ latitude 

model2 <- lm(het_ne_roh1$harmonic_ne ~ poly(het_ne_roh1$latitude, 3, raw = TRUE))

str(summary(model2))

model2$coefficients[[2]]

summary(model2)$r.squared

summary(model2)

# plotting 
lb1 <- "italic(R)^2 == 0.82"
lb2 <- "italic(p) == 5.769^-15"

a1 <- ggplot(het_ne_roh1, aes(x=latitude, y=harmonic_ne)) + 
  stat_poly_line(formula = formula) + 
  #stat_poly_eq(formula = formula) +
  annotate("text",
           x = 15,
           y = 170, 
           label = lb1, parse = TRUE) +
  annotate("text",
           x = 18,
           y = 170, 
           label = lb2, parse = TRUE) +
  geom_point(aes(fill = Population), shape = 21, col = "black", size = 3) + 
  theme_cowplot(12)+
  ylab(expression(Harmonic ~ Mean ~ N[e] ~ (10^3))) +
  xlab("Latitude") + 
  theme(legend.position = "FALSE") +
  scale_fill_manual(values = c("gray16",  "lightslateblue",  "steelblue3", "turquoise2", 
                                 "yellow2", "azure3", "navy"))

# assessing third-degree polynomial model of heterozygosity ~ latitude 

model3 <- lm(het_ne_roh1$heterozygosity ~ poly(het_ne_roh1$latitude, 3, raw = TRUE))

str(summary(model3))

model3$coefficients[[2]]

summary(model3)$r.squared

summary(model3)

# plotting 
lb3 <- "italic(R)^2 == 0.71"
lb4 <- "italic(p) == 3.515^-11"

b1 <- ggplot(het_ne_roh, aes(x=latitude, y=heterozygosity)) +
  stat_poly_line(formula = formula) + 
  #stat_poly_eq(formula = formula) +
  annotate("text",
           x = 15,
           y = 0.0055, 
           label = lb3, parse = TRUE) +
  annotate("text",
           x = 18,
           y = 0.0055, 
           label = lb4, parse = TRUE) +
  ylab(bquote(Heterozygosity~ind.^-1~bp^-1)) +
  xlab("Latitude") +
  geom_point(aes(col = Population))+
  theme_cowplot(12) +
  scale_fill_manual(values = c("gray", "gray16",  "lightslateblue",  "steelblue3", "turquoise2", 
                               "yellow2", "azure3", "navy")) + 
  geom_point(aes(fill = Population), shape = 21, col = "black", size = 3) + 
  theme(legend.position = "FALSE")







kb_10 <- as.data.frame(cbind(het_ne_roh1$latitude, het_ne_roh1$roh_10kb))

colnames(kb_10) <- c("latitude", "roh_10kb")

kb_50 <- as.data.frame(cbind(het_ne_roh1$latitude, het_ne_roh1$roh_50kb))

colnames(kb_50) <- c("latitude", "roh_50kb")

kb_100 <- as.data.frame(cbind(het_ne_roh1$latitude, het_ne_roh1$roh_100kb))

colnames(kb_100) <- c("latitude", "roh_100kb")

kb_250 <- as.data.frame(cbind(het_ne_roh1$latitude, het_ne_roh1$roh_250kb))

colnames(kb_250) <- c("latitude", "roh_250kb")


a2 <- ggplot() +
  stat_poly_line(aes(x = latitude, y = roh_10kb), formula = formula, se = FALSE, data = kb_10) + 
  stat_poly_line(aes(x = latitude, y = roh_50kb), formula = formula, se = FALSE, data = kb_50, col = "gray") +
  stat_poly_line(aes(x = latitude, y = roh_100kb), formula = formula, se = FALSE, data = kb_100, col = "black") +
  stat_poly_line(aes(x = latitude, y = roh_250kb), formula = formula, se = FALSE, data = kb_250, col = "orange") +
  # geom_smooth(aes(x = latitude, y = roh_10kb), data = kb_10) + 
  ylab(bquote(italic("F")["ROH"])) + 
  xlab("Latitude") +
  # annotate("text", y = 4, x = 25, label = "\u03C1 = - 0.106 ; p = 0.4833", size =4) +
  theme_cowplot(12) 


b2 <- ggplot(pairwise_fst, aes(x=average.lat.1.2, y=fst)) +
  xlab("Mean Latitude") +
  # stat_poly_eq(aes(mapping = ("p.value.label"))) +
  geom_point(shape = 20, size = 3, col = "black") +
  geom_smooth(method='lm', se = FALSE) +
  # stat_poly_eq() +
  theme_cowplot(12) +
  ylab(bquote(italic("F")["ST"])) +
  theme(legend.position = "FALSE")

model4 <- cor.test(pairwise_fst$fst, pairwise_fst$average.lat.1.2, method = "spearman")

summary(model4)

plot_grid(plotlist = mget(pattern), ncol = 2, labels = c('A', 'B', 'C', 'D'))


          