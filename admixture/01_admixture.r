# vcf order (to be used for rearranging of individuals)

# Setophaga_graciae_CM_S10255_BEL	Setophaga_graciae_CM_S9116_BEL	
# etophaga_graciae_DMNS_52524_COL	Setophaga_graciae_KU_33633_RACN	
# Setophaga_graciae_KU_33634_RACN	Setophaga_graciae_KU_8199_SANA	
# Setophaga_graciae_KU_8218_SANA	Setophaga_graciae_UWBM_105736_ARI	
# Setophaga_graciae_UWBM_106758_NM	Setophaga_graciae_UWBM_106760_NM	
# Setophaga_graciae_UWBM_108714_NEV	Setophaga_graciae_UWBM_111891_NM	
# Setophaga_graciae_UWBM_111896_NM	Setophaga_graciae_UWBM_112576_GUE	
# Setophaga_graciae_UWBM_112587_GUE	Setophaga_graciae_UWBM_112592_GUE	
# Setophaga_graciae_UWBM_113059_CHI	Setophaga_graciae_UWBM_113126_CHI	
# Setophaga_graciae_UWBM_113970_DUR	Setophaga_graciae_UWBM_114011_DUR	
# Setophaga_graciae_UWBM_114012_DUR	Setophaga_graciae_UWBM_114019_DUR	
# Setophaga_graciae_UWBM_114038_DUR	Setophaga_graciae_UWBM_114046_DUR	
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

library(RColorBrewer)



# Dataset 15a (10 kb thinned dataset)


cols <- list()

cols[[3]] <- c("gray16", "lightsteelblue1")
cols[[4]] <- c("yellow2", "gray16", "lightsteelblue1")
cols[[5]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1")
cols[[6]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71")
cols[[7]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue")
cols[[8]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue", "red")

table_output <- list()
tbl.rearranged <- list()
x_files <- list.files(pattern = "*Q.15a")

# vectors of species for plot rearrangement 

#belize
belize <- c(1:2)
#nicaragua pine
nicaragua_pine <- c(4:5, 36)
#el salvador
el_salvador <- c(6:7)
#honduras
honduras <- c(40:44)
#chiapas 
chiapas <- c(17:18)
#guerrero
guerrero <- c(14:16, 35)
#durango
durango <- c(19:25)
#chihuahua 
chihuahua <- c(26:32)
#new mexico
new_mexico <- c(9:10, 12:13)
#arizona
arizona <- c(8, 37:39, 45)
#nevada
nevada <- c(11, 33:34)
#colorado
colorado <- c(3)



# set plot items 
par(mfrow=c(1,1))
par(mar=c(4,0.15,0.5,0.15))

# plot k of 2 first 
table_output[[2]] <- read.table(x_files[3])


tbl.belize <- table_output[[2]][belize,,drop = FALSE]
tbl.nicaragua_pine <- table_output[[2]][nicaragua_pine,,drop = FALSE]
tbl.el_salvador <- table_output[[2]][el_salvador,,drop = FALSE]
tbl.honduras <- table_output[[2]][honduras,,drop = FALSE]
tbl.chiapas <- table_output[[2]][chiapas,,drop = FALSE]
tbl.guerrero <- table_output[[2]][guerrero,,drop = FALSE]
tbl.durango <- table_output[[2]][durango,,drop = FALSE]
tbl.chihuahua <- table_output[[2]][chihuahua,,drop = FALSE]
tbl.new_mexico <- table_output[[2]][new_mexico,,drop = FALSE]
tbl.arizona <- table_output[[2]][arizona,,drop = FALSE]
tbl.nevada <- table_output[[2]][nevada,,drop = FALSE]
tbl.colorado <- table_output[[2]][colorado,,drop = FALSE]

#combine into new table 

tbl.rearranged[[2]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                             tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)

# write.csv(tbl.rearranged[[2]], file = "Q_prop_rearranged_K2.csv")
# plot rearranged barplot

colnames(tbl.rearranged[[2]])  <- NULL
row.names(tbl.rearranged[[2]])  <- NULL
barplot(t(as.matrix(tbl.rearranged[[2]])), col=cols[[3]], 
        border="black", axes = FALSE, width = 1.5, space = 0.05)

# set plot items 
par(mfrow=c(5,1))
par(mar=c(1,1,0.5,0.5))



# plot k 2 to 6 
for(a in 3:7) {
  table_output[[a]] <- read.table(x_files[a])
  
  # rearrange 
  tbl.belize <- table_output[[a]][belize,]
  tbl.nicaragua_pine <- table_output[[a]][nicaragua_pine,]
  tbl.el_salvador <- table_output[[a]][el_salvador,]
  tbl.honduras <- table_output[[a]][honduras,]
  tbl.chiapas <- table_output[[a]][chiapas,]
  tbl.guerrero <- table_output[[a]][guerrero,]
  tbl.durango <- table_output[[a]][durango,]
  tbl.chihuahua <- table_output[[a]][chihuahua,]
  tbl.new_mexico <- table_output[[a]][new_mexico,] 
  tbl.arizona <- table_output[[a]][arizona,]
  tbl.nevada <- table_output[[a]][nevada,]
  tbl.colorado <- table_output[[a]][colorado,]
  
  #combine into new table 
  
  tbl.rearranged[[a]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                               tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)
  
  # plot rearranged barplot
  
  colnames(tbl.rearranged[[a]])  <- NULL
  row.names(tbl.rearranged[[a]])  <- NULL
  barplot(t(as.matrix(tbl.rearranged[[a]])), col=cols[[a]], 
          border="black", ylab = "Ancestry")
  
  
}

a <- barplot(t(as.matrix(tbl.rearranged[[3]])), col=c("gray16", "lightsteelblue1"), 
             border="black", ylab = "Ancestry")

b <- barplot(t(as.matrix(tbl.rearranged[[4]])), col=c("lightsteelblue1", "yellow2", "gray16","red", "blue"), 
             border="black", ylab = "Ancestry")

c <- barplot(t(as.matrix(tbl.rearranged[[5]])), col=c("gray16", "azure1", "lightsteelblue1", "yellow2"), 
             border="black", ylab = "Ancestry")

d <- barplot(t(as.matrix(tbl.rearranged[[6]])), col=c("lightsteelblue1", "yellow2", "azure1","gray71", "gray16"), 
             border="black", ylab = "Ancestry")

e <- barplot(t(as.matrix(tbl.rearranged[[7]])), col=c("azure1", "yellow2", "gray71", "cornflowerblue","lightsteelblue1", "gray16"), 
             border="black", ylab = "Ancestry")




# Dataset 15a (10 kb thinned dataset)


cols <- list()

cols[[3]] <- c("gray16", "lightsteelblue1")
cols[[4]] <- c("yellow2", "gray16", "lightsteelblue1")
cols[[5]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1")
cols[[6]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71")
cols[[7]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue")
cols[[8]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue", "red")

table_output <- list()
tbl.rearranged <- list()
x_files <- list.files(pattern = "*Q.15a")

# vectors of species for plot rearrangement 

#belize
belize <- c(1:2)
#nicaragua pine
nicaragua_pine <- c(4:5, 36)
#el salvador
el_salvador <- c(6:7)
#honduras
honduras <- c(40:44)
#chiapas 
chiapas <- c(17:18)
#guerrero
guerrero <- c(14:16, 35)
#durango
durango <- c(19:25)
#chihuahua 
chihuahua <- c(26:32)
#new mexico
new_mexico <- c(9:10, 12:13)
#arizona
arizona <- c(8, 37:39, 45)
#nevada
nevada <- c(11, 33:34)
#colorado
colorado <- c(3)



# set plot items 
par(mfrow=c(1,1))
par(mar=c(4,0.15,0.5,0.15))

# plot k of 2 first 
table_output[[2]] <- read.table(x_files[3])


tbl.belize <- table_output[[2]][belize,,drop = FALSE]
tbl.nicaragua_pine <- table_output[[2]][nicaragua_pine,,drop = FALSE]
tbl.el_salvador <- table_output[[2]][el_salvador,,drop = FALSE]
tbl.honduras <- table_output[[2]][honduras,,drop = FALSE]
tbl.chiapas <- table_output[[2]][chiapas,,drop = FALSE]
tbl.guerrero <- table_output[[2]][guerrero,,drop = FALSE]
tbl.durango <- table_output[[2]][durango,,drop = FALSE]
tbl.chihuahua <- table_output[[2]][chihuahua,,drop = FALSE]
tbl.new_mexico <- table_output[[2]][new_mexico,,drop = FALSE]
tbl.arizona <- table_output[[2]][arizona,,drop = FALSE]
tbl.nevada <- table_output[[2]][nevada,,drop = FALSE]
tbl.colorado <- table_output[[2]][colorado,,drop = FALSE]

#combine into new table 

tbl.rearranged[[2]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                             tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)

# write.csv(tbl.rearranged[[2]], file = "Q_prop_rearranged_K2.csv")
# plot rearranged barplot

colnames(tbl.rearranged[[2]])  <- NULL
row.names(tbl.rearranged[[2]])  <- NULL
barplot(t(as.matrix(tbl.rearranged[[2]])), col=cols[[3]], 
        border="black", axes = FALSE, width = 1.5, space = 0.05)

# set plot items 
par(mfrow=c(5,1))
par(mar=c(1,1,0.5,0.5))



# plot k 2 to 6 
for(a in 3:7) {
  table_output[[a]] <- read.table(x_files[a])
  
  # rearrange 
  tbl.belize <- table_output[[a]][belize,]
  tbl.nicaragua_pine <- table_output[[a]][nicaragua_pine,]
  tbl.el_salvador <- table_output[[a]][el_salvador,]
  tbl.honduras <- table_output[[a]][honduras,]
  tbl.chiapas <- table_output[[a]][chiapas,]
  tbl.guerrero <- table_output[[a]][guerrero,]
  tbl.durango <- table_output[[a]][durango,]
  tbl.chihuahua <- table_output[[a]][chihuahua,]
  tbl.new_mexico <- table_output[[a]][new_mexico,] 
  tbl.arizona <- table_output[[a]][arizona,]
  tbl.nevada <- table_output[[a]][nevada,]
  tbl.colorado <- table_output[[a]][colorado,]
  
  #combine into new table 
  
  tbl.rearranged[[a]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                               tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)
  
  # plot rearranged barplot
  
  colnames(tbl.rearranged[[a]])  <- NULL
  row.names(tbl.rearranged[[a]])  <- NULL
  barplot(t(as.matrix(tbl.rearranged[[a]])), col=cols[[a]], 
          border="black", ylab = "Ancestry")
  
  
}

a <- barplot(t(as.matrix(tbl.rearranged[[3]])), col=c("gray16", "lightsteelblue1"), 
             border="black", ylab = "Ancestry")

b <- barplot(t(as.matrix(tbl.rearranged[[4]])), col=c("lightsteelblue1", "yellow2", "gray16","red", "blue"), 
             border="black", ylab = "Ancestry")

c <- barplot(t(as.matrix(tbl.rearranged[[5]])), col=c("gray16", "azure1", "lightsteelblue1", "yellow2"), 
             border="black", ylab = "Ancestry")

d <- barplot(t(as.matrix(tbl.rearranged[[6]])), col=c("lightsteelblue1", "yellow2", "azure1","gray71", "gray16"), 
             border="black", ylab = "Ancestry")

e <- barplot(t(as.matrix(tbl.rearranged[[7]])), col=c("azure1", "yellow2", "gray71", "cornflowerblue","lightsteelblue1", "gray16"), 
             border="black", ylab = "Ancestry")


# Dataset 15a (10 kb thinned dataset)


cols <- list()

cols[[3]] <- c("gray16", "lightsteelblue1")
cols[[4]] <- c("yellow2", "gray16", "lightsteelblue1")
cols[[5]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1")
cols[[6]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71")
cols[[7]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue")
cols[[8]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue", "red")

table_output <- list()
tbl.rearranged <- list()
x_files <- list.files(pattern = "*Q.15a")

# vectors of species for plot rearrangement 

#belize
belize <- c(1:2)
#nicaragua pine
nicaragua_pine <- c(4:5, 36)
#el salvador
el_salvador <- c(6:7)
#honduras
honduras <- c(40:44)
#chiapas 
chiapas <- c(17:18)
#guerrero
guerrero <- c(14:16, 35)
#durango
durango <- c(19:25)
#chihuahua 
chihuahua <- c(26:32)
#new mexico
new_mexico <- c(9:10, 12:13)
#arizona
arizona <- c(8, 37:39, 45)
#nevada
nevada <- c(11, 33:34)
#colorado
colorado <- c(3)



# set plot items 
par(mfrow=c(1,1))
par(mar=c(4,0.15,0.5,0.15))

# plot k of 2 first 
table_output[[2]] <- read.table(x_files[3])


tbl.belize <- table_output[[2]][belize,,drop = FALSE]
tbl.nicaragua_pine <- table_output[[2]][nicaragua_pine,,drop = FALSE]
tbl.el_salvador <- table_output[[2]][el_salvador,,drop = FALSE]
tbl.honduras <- table_output[[2]][honduras,,drop = FALSE]
tbl.chiapas <- table_output[[2]][chiapas,,drop = FALSE]
tbl.guerrero <- table_output[[2]][guerrero,,drop = FALSE]
tbl.durango <- table_output[[2]][durango,,drop = FALSE]
tbl.chihuahua <- table_output[[2]][chihuahua,,drop = FALSE]
tbl.new_mexico <- table_output[[2]][new_mexico,,drop = FALSE]
tbl.arizona <- table_output[[2]][arizona,,drop = FALSE]
tbl.nevada <- table_output[[2]][nevada,,drop = FALSE]
tbl.colorado <- table_output[[2]][colorado,,drop = FALSE]

#combine into new table 

tbl.rearranged[[2]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                             tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)

# write.csv(tbl.rearranged[[2]], file = "Q_prop_rearranged_K2.csv")
# plot rearranged barplot

colnames(tbl.rearranged[[2]])  <- NULL
row.names(tbl.rearranged[[2]])  <- NULL
barplot(t(as.matrix(tbl.rearranged[[2]])), col=cols[[3]], 
        border="black", axes = FALSE, width = 1.5, space = 0.05)

# set plot items 
par(mfrow=c(5,1))
par(mar=c(1,1,0.5,0.5))



# plot k 2 to 6 
for(a in 3:7) {
  table_output[[a]] <- read.table(x_files[a])
  
  # rearrange 
  tbl.belize <- table_output[[a]][belize,]
  tbl.nicaragua_pine <- table_output[[a]][nicaragua_pine,]
  tbl.el_salvador <- table_output[[a]][el_salvador,]
  tbl.honduras <- table_output[[a]][honduras,]
  tbl.chiapas <- table_output[[a]][chiapas,]
  tbl.guerrero <- table_output[[a]][guerrero,]
  tbl.durango <- table_output[[a]][durango,]
  tbl.chihuahua <- table_output[[a]][chihuahua,]
  tbl.new_mexico <- table_output[[a]][new_mexico,] 
  tbl.arizona <- table_output[[a]][arizona,]
  tbl.nevada <- table_output[[a]][nevada,]
  tbl.colorado <- table_output[[a]][colorado,]
  
  #combine into new table 
  
  tbl.rearranged[[a]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                               tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)
  
  # plot rearranged barplot
  
  colnames(tbl.rearranged[[a]])  <- NULL
  row.names(tbl.rearranged[[a]])  <- NULL
  barplot(t(as.matrix(tbl.rearranged[[a]])), col=cols[[a]], 
          border="black", ylab = "Ancestry")
  
  
}

a <- barplot(t(as.matrix(tbl.rearranged[[3]])), col=c("gray16", "lightsteelblue1"), 
             border="black", ylab = "Ancestry")

b <- barplot(t(as.matrix(tbl.rearranged[[4]])), col=c("lightsteelblue1", "yellow2", "gray16","red", "blue"), 
             border="black", ylab = "Ancestry")

c <- barplot(t(as.matrix(tbl.rearranged[[5]])), col=c("gray16", "azure1", "lightsteelblue1", "yellow2"), 
             border="black", ylab = "Ancestry")

d <- barplot(t(as.matrix(tbl.rearranged[[6]])), col=c("lightsteelblue1", "yellow2", "azure1","gray71", "gray16"), 
             border="black", ylab = "Ancestry")

e <- barplot(t(as.matrix(tbl.rearranged[[7]])), col=c("azure1", "yellow2", "gray71", "cornflowerblue","lightsteelblue1", "gray16"), 
             border="black", ylab = "Ancestry")



# Dataset 15b (50 kb thinned dataset)


cols <- list()

cols[[3]] <- c("gray16", "lightsteelblue1")
cols[[4]] <- c("yellow2", "gray16", "lightsteelblue1")
cols[[5]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1")
cols[[6]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71")
cols[[7]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue")
cols[[8]] <- c("lightsteelblue1", "gray16", "yellow2", "azure1", "gray71", "cornflowerblue", "red")

table_output <- list()
tbl.rearranged <- list()
x_files <- list.files(pattern = "*Q.15b")

# vectors of species for plot rearrangement 

#belize
belize <- c(1:2)
#nicaragua pine
nicaragua_pine <- c(4:5, 36)
#el salvador
el_salvador <- c(6:7)
#honduras
honduras <- c(40:44)
#chiapas 
chiapas <- c(17:18)
#guerrero
guerrero <- c(14:16, 35)
#durango
durango <- c(19:25)
#chihuahua 
chihuahua <- c(26:32)
#new mexico
new_mexico <- c(9:10, 12:13)
#arizona
arizona <- c(8, 37:39, 45)
#nevada
nevada <- c(11, 33:34)
#colorado
colorado <- c(3)



# set plot items 
par(mfrow=c(1,1))
par(mar=c(4,0.15,0.5,0.15))

# plot k of 2 first 
table_output[[2]] <- read.table(x_files[3])


tbl.belize <- table_output[[2]][belize,,drop = FALSE]
tbl.nicaragua_pine <- table_output[[2]][nicaragua_pine,,drop = FALSE]
tbl.el_salvador <- table_output[[2]][el_salvador,,drop = FALSE]
tbl.honduras <- table_output[[2]][honduras,,drop = FALSE]
tbl.chiapas <- table_output[[2]][chiapas,,drop = FALSE]
tbl.guerrero <- table_output[[2]][guerrero,,drop = FALSE]
tbl.durango <- table_output[[2]][durango,,drop = FALSE]
tbl.chihuahua <- table_output[[2]][chihuahua,,drop = FALSE]
tbl.new_mexico <- table_output[[2]][new_mexico,,drop = FALSE]
tbl.arizona <- table_output[[2]][arizona,,drop = FALSE]
tbl.nevada <- table_output[[2]][nevada,,drop = FALSE]
tbl.colorado <- table_output[[2]][colorado,,drop = FALSE]

#combine into new table 

tbl.rearranged[[2]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                             tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)

# write.csv(tbl.rearranged[[2]], file = "Q_prop_rearranged_K2.csv")
# plot rearranged barplot

colnames(tbl.rearranged[[2]])  <- NULL
row.names(tbl.rearranged[[2]])  <- NULL
barplot(t(as.matrix(tbl.rearranged[[2]])), col=cols[[3]], 
        border="black", axes = FALSE, width = 1.5, space = 0.05)

# set plot items 
par(mfrow=c(5,1))
par(mar=c(1,1,0.5,0.5))



# plot k 2 to 6 
for(a in 3:7) {
  table_output[[a]] <- read.table(x_files[a])
  
  # rearrange 
  tbl.belize <- table_output[[a]][belize,]
  tbl.nicaragua_pine <- table_output[[a]][nicaragua_pine,]
  tbl.el_salvador <- table_output[[a]][el_salvador,]
  tbl.honduras <- table_output[[a]][honduras,]
  tbl.chiapas <- table_output[[a]][chiapas,]
  tbl.guerrero <- table_output[[a]][guerrero,]
  tbl.durango <- table_output[[a]][durango,]
  tbl.chihuahua <- table_output[[a]][chihuahua,]
  tbl.new_mexico <- table_output[[a]][new_mexico,] 
  tbl.arizona <- table_output[[a]][arizona,]
  tbl.nevada <- table_output[[a]][nevada,]
  tbl.colorado <- table_output[[a]][colorado,]
  
  #combine into new table 
  
  tbl.rearranged[[a]] <- rbind(tbl.belize, tbl.nicaragua_pine, tbl.el_salvador, tbl.honduras, tbl.chiapas, 
                               tbl.guerrero,  tbl.durango, tbl.chihuahua, tbl.arizona, tbl.new_mexico, tbl.nevada,tbl.colorado)
  
  # plot rearranged barplot
  
  colnames(tbl.rearranged[[a]])  <- NULL
  row.names(tbl.rearranged[[a]])  <- NULL
  barplot(t(as.matrix(tbl.rearranged[[a]])), col=cols[[a]], 
          border="black", ylab = "Ancestry")
  
  
}

a <- barplot(t(as.matrix(tbl.rearranged[[3]])), col=c("gray16", "lightsteelblue1"), 
             border="black", ylab = "Ancestry")

b <- barplot(t(as.matrix(tbl.rearranged[[4]])), col=c("lightsteelblue1", "yellow2", "gray16","red", "blue"), 
             border="black", ylab = "Ancestry")

c <- barplot(t(as.matrix(tbl.rearranged[[5]])), col=c("gray16", "azure1", "lightsteelblue1", "yellow2"), 
             border="black", ylab = "Ancestry")

d <- barplot(t(as.matrix(tbl.rearranged[[6]])), col=c("lightsteelblue1", "yellow2", "azure1","gray71", "gray16"), 
             border="black", ylab = "Ancestry")

e <- barplot(t(as.matrix(tbl.rearranged[[7]])), col=c("azure1", "yellow2", "gray71", "cornflowerblue","lightsteelblue1", "gray16"), 
             border="black", ylab = "Ancestry")




