## Pairwise Divergence Times (Figure 7C, Table S6).

This script (divergence_times.R) will calculate pairwise divergence times between populations, using equations from Wiuf et al. 2004. The use of these equations was inspired by Chase et al. 2021. Here, divergence can be calculated in calendar years and coalescent units (tau). These equations are coded as functions, which are included in for loops. The mutation rate used here is estimated from *Geospiza fortis*, and is the same mutation rate that was used for recombination rate and historical effective population size estimation.

Included as input are text files of windowed Dxy and Pi estimates. Estimates from the Z chromosome are excluded. 
