# PCA workflow (Figure S3A-B) 

1. Using the admixture filtered dataset (obtained by filtering the per-chromosome vcfs with 01_dataset15a_admixture_filtering.sh and 01_dataset15b_admixture_filtering.sh),run 01_dataset15a_plink_pca.sh and 01_dataset15b_plink_pca.sh, respectively. 15a is the 10kb-thinned dataset and 15b is the 50kb-thinned dataset.

2. To plot, run pca_plot.R, which will reproduce Supplemental Figure S3A-B. This workflow was inspired heavily by https://speciationgenomics.github.io/pca/, and I recommend anyone interested to check the website for other useful information on the handling and intepretation of genomic data. 
