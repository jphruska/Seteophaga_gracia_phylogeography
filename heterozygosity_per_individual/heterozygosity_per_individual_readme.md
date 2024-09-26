# Heterozygosity estimates per individual 

1. Filter .g.vcf (including Z chromosome) with 01_dataset4_filtering.sh. This is done for a reduced dataset of 47 individuals.
2. Run 01_heterozygosity.sh, which will call calc_heterozygosity.R. This script will calculate the total number of sites (while excluding missing data) and the number of heterozygous sites.
3. Run heterozygosity_process.R to calculate heterozygosity estimates (ratio of heterozygous sites/total sites) per individual. This script also compares estimates calculated originally in excel, to confirm they were estimated correctly. It also will calculate estimates while excluding regions that map to the Z chromosome (CM027535.1), to quantify the effect of the Z chromosome on these estimates. There isn't much of an effect, which is scatter of points displayed by heterozygosity_with_and_without_z.pdf. 
