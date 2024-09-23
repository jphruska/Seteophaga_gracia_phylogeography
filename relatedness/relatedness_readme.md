# Relatedness Workflow  

1. Filter .g.vcfs with 01_dataset14_king_filtering.sh. No filtering for LD, and it is not recommend to carry out LD pruning for this method (https://www.kingrelatedness.com/manual.shtml).
2. Process output (out.relatedness2) of kingship coefficients (PHI) with relatedness.R, where self-to-self coefficients are removed. Coefficients are also ranked in decreasing order. This script will also generate a heatmap of pairwise coefficients, for visualization purposes. 
   
