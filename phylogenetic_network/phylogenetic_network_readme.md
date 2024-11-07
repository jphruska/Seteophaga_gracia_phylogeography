# Phylogenetic network workflow (Figure 1C) 

1. Run stampp_nei_distance.R to calculate pairwise Nei's D values, across individuals. 
   Export distance matrix that will be used as input for splitsTree. A VCF and pop file are used as inputs.
   Pop information is not incorporated (pop = FALSE), but must be read in in order for stamppNeisD to run.
   (Note: stamppPhylip will export matrix with sample names truncated). These need to be manually edited before
   the matrix is imported into SplitsTree. These names can be recapitulated by referencing the pop file (pop.ind.setophaga.csv).
   The order in which the individuals are listed corresponds to the order in which they appear in the VCF file. 

2. Import distance matrix file (setophaga.dataset15a.splits.txt) into SplitsTree4 v4.18.2 GUI.
   Under the 'Networks' tab make sure 'NeighborNet' option is selected. 
