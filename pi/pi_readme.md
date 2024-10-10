## Per-population estimates of pi (Figure 4, 5, 6, and S7, S8, and S9).

This workflow will generate windowed per-population pi values, using equation 2 from Carlson et al. (2005). See manuscript for reference. This workflow shares many similarities with the windowed Dxy and Fst workflows in this repository. 

Step 1. Run 01_dataset17_div_dff_dataset17.sh to filter VCFs. 

Step 2. Bgzip and index positions with tabix (02_bgzip_tabix.sh). 

Step 3. Run 03_phylo_50kbp.r to generate shell script will calculate pi. This script will also calculate how many array jobs need to be run, the number of tasks per job, and the helper files that will determine which windows are operated on by the different array jobs. An index file of the reference genome is needed as input. w

Step 4. Run phylo_50kb_array.sh and phylo_50kb_array_z.sh to generate windowed pi estimates (for autosome and Z chromosome, respectively). These scripts will also generate other population genetic metrics, including Fst, Dxy, heterozygosity, tajima's and theta. These scripts will invoke calculate_windows.r, which in turn invokes window_stat_calculations.r.  

Step 5. Run 00_pi_dxy_fst_summary.sh to concatenate estimates across all the window summary stat files. Here, the relevant section pertains to the concatentation of pi, but the basic premise also applies to Dxy and Fst. 

Step 6. Run pi_pop_plotting.R to generate Figures S7, S8, and S9. 

