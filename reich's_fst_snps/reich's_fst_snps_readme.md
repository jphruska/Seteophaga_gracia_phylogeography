# SNP-based pairwise FST (Figure 2B and S5) 

1. Filter .g.vcf files with 01_dataset15a_admixture_filtering.sh. Exclude Z chromosome.
2. Calculate mean FST estiamtes (and 95 % confidence intervals via bootstrapping) with setophaga_FST.R. This code and workflow is copied from Jessica Rick's GitHub (https://github.com/jessicarick/reich-fst). Will also reproduce Figure S5. 
3. Generate heatmap with setophaga_FST.R, once mean values are calculated. This will reproduce Figure 2B. Heatmap code and workflow was inspired by https://github.com/ksil91/Scripts/blob/master/heatmap_FST.md. 
