### Script to wrangle and plot ROH data ###

library(ggplot2)
library(dplyr)
library(plyr)
library(cowplot)
library(forcats)


# read in summary (containing information on ROH for the following size classes: greater than 10kb, 50kb, 100kb, 250kb, 500kb, 1mb and 5mb)

roh <- read.table("FROH_rohmu_2e-4_summary.csv", sep = ",", header = TRUE)

# convert roh to tibble 

roh <- as_tibble(roh)

# rename columns, convert to character type

as.character(colnames(roh)[1] <- "ID")
as.character(colnames(roh)[3] <- "10kb")
as.character(colnames(roh)[4] <- "50kb")
as.character(colnames(roh)[5] <- "100kb")
as.character(colnames(roh)[6] <- "250kb")
as.character(colnames(roh)[7] <- "500kb")
as.character(colnames(roh)[8] <- "1mb")
as.character(colnames(roh)[9] <- "5mb")


# convert percentages to fractions

# func <- function(x, na.rm = F) (x/100)

# roh <- roh %>% 
#  mutate_if(is.numeric, .funs = func)

# group by population 

roh %>% 
  group_by(Population)
  

# vector of population names 

pop_order <- c("Nicaragua", "El_Salvador", "Honduras", "Chiapas", "Guerrero", "Durango", "Chihuahua", "New_Mexico", "Arizona", "Nevada", "Colorado")


# arrange data frame by latitude (roughly) 

roh <- roh %>% 
  arrange(match(Population, pop_order))

# add second ID column to tibble 

roh[11] <- seq(1,45)

colnames(roh)[11] <- as.character("id")

roh$id <- as.character(roh$id)
          
# make scatter plot of 10kb ROHs 

a <- ggplot(roh, aes(x = fct_inorder(Population), y = `10kb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 10kb"])) + 
  theme(legend.position="none")
  

# make scatter plot of 50kb ROHs

b <- ggplot(roh, aes(x = fct_inorder(Population), y = `50kb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 50kb"])) + 
  theme(legend.position="none")


# make scatter plot of 100kb ROHs

c <- ggplot(roh, aes(x = fct_inorder(Population), y = `100kb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 100kb"])) + 
  theme(legend.position="none")

# make scatter plot of 250kb ROHs

d <- ggplot(roh, aes(x = fct_inorder(Population), y = `250kb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 250kb"])) + 
  theme(legend.position="none")

# make scatter plot of 500kb ROHs

e <- ggplot(roh, aes(x = fct_inorder(Population), y = `500kb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 500kb"])) + 
  theme(legend.position="none")


# make scatter plot of 1mb ROHs

f <- ggplot(roh, aes(x = fct_inorder(Population), y = `1mb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 1mb"])) + 
  theme(legend.position="none")

# make scatter plot of 5mb ROHs

g <- ggplot(roh, aes(x = fct_inorder(Population), y = `5mb`)) +
  geom_point(aes(color = Population)) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 5mb"])) + 
  theme(legend.position="none") 
 

pattern <- c("a", "b", "c", "d", "e", "f", "g")

t <- plot_grid(plotlist = mget(pattern), ncol = 2, labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G'))


ggsave("ROH.pdf", plot = t, width = 1920/72, height = 1080/72, dpi = 72)


# column plots 

# make column plot of 10kb ROHs


a.0 <- ggplot(roh, aes(x = fct_inorder(id), y = `10kb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 10kb"])) 

a.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `10kb`, fill = Population)) +
  geom_col(show.legend = F) +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 10kb"])) 
   
   
  
# make column plot of 50kb ROHs

b.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `50kb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 50kb"])) +
  theme(legend.position="none")
  


# make column plot of 100kb ROHs

c.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `100kb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 100kb"])) +
  theme(legend.position="none")
  

# make column plot of 250kb ROHs

d.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `250kb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 250kb"])) +
  theme(legend.position="none")
  

# make column plot of 500kb ROHs

e.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `500kb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 500kb"])) +
  theme(legend.position="none")
  


# make column plot of 1mb ROHs

f.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `1mb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 1mb"])) +
  theme(legend.position="none")
  

# make column plot of 5mb ROHs

g.1 <- ggplot(roh, aes(x = fct_inorder(id), y = `5mb`, fill = Population)) +
  geom_col() +
  theme_cowplot(12) +
  xlab("") +
  ylab(bquote(italic("F")["ROH 5mb"])) +
  theme(legend.position="none")
  

pattern <- c("a.1", "b.1", "c.1", "d.1", "e.1", "f.1", "g.1")

legend <- get_legend(a.0)

p <- plot_grid(plotlist = mget(pattern), ncol = 2, labels = c('A', 'B', 'C', 'D', 'E', 'F', 'G'))

p.1 <-  p + draw_grob(legend, 2/3, 0, 1/3, 0.3)

ggsave("ROH_per_individual.pdf", plot = p.1, width = 1920/72, height = 1080/72, dpi = 72)