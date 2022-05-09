# Collapse nodes with support < 5 %.
sumtrees.py --output=setophaga_summed_50kbp.tre --min-clade-freq=0.05 setophaga_total_50kbp.trees 

# Collapse nodes with support < 2.5 %. 

sumtrees.py --output=setophaga_summed_50kbp_2.5_min_clade.tre --min-clade-freq=0.025 setophaga_total_50kbp.trees
