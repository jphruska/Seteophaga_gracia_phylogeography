## Run ROHan to get estimates of runs of homozygosity per individual (Figures 3C, S2, S6).

This dataset excludes those with low sequencing depth < 10 x, including the Belizean samples, which are derived from skin samples. These are consistent with the recommendations of the authors. 

Step 1. Filter .g.vcfs using vcftools (01_dataset6_filtering.sh). Only biallelic sites are retained, with no missing data. These filtered VCFs will be used to estimate TS:TV ratio (Transition/Transversion) ratio, which ROHan requires as input. After filtering, sex chromosome (CM027535.1) will be removed, and the resulting VCFs will be concatenated into one file. Be sure to test this with different bin sizes, to ensure that TS:TV ratio is not sensitive to bin size. 

    A. remove sex chromosome

    rm CM027535.1.g.vcf.dataset6.vcf.recode.vcf

    B. concatenate VCF files

    grep "#" CM027513.1.g.vcf.dataset6.vcf.recode.vcf >> setophaga_6.vcf

    for i in `ls *.recode.vcf` ; do grep -v "#" $i >> setophaga_6.vcf ; done

    C. run VCFTools to estimate TS:TV ratio. Start with a bin size of 1000 bp. Then do a bin size of 10000 bp. 
  
    Both estimates of the TsTV ratio were congruent (1.971). 

Step 2. Use ROHan (on BAM files) to evaluate runs of homozygosity. First do a preliminary run (02_run_rohan.sh), to get a feel for how the HMM is categorizing roh vs non-roh regions. 

Step 3. Estimate 50kb windowed estimates of heterozygosity per individual. Use div_diff_array_setophaga[_z].sh scripts to calculate heterozygosity per individual in 50kb windows, across autosomes and the Z chromosome. These scripts will use calculate_windows_setophaga[_z].r scripts. 

Step 4. Use per-individual heterozygosity estimates to obtain a reasonable rohmu estimate. This is the maximum mutation rate estimate tolerated for a region to be classified as a roh. This will be done with background_het_ROHs_rohmu.R. Here, the five lowest ranking individuals in average heterozygosity (see heterozygosity_per_individual section), for which the heterozygosity of the lowest 15 % quantile windows are plotted. An elbow in the histogram (ideally the distribution would be bimodal to make the demarcation clear) is used to separate non-roh vs roh windows, based on heterozygosity rates (Figure S6). 

Step 5. Run ROHan with new rohmu estimate (2e-4), and for roh of different sizes (10kb, 50kb, 100kb, 250kb, 500kb, 1Mb, and 5 Mb). Use scripts 02_run_rohan_[10kb/50kb/100kb/250kb/500kb/1Mb/5Mb]_rohmu2e-4.sh to carry out this step. 

Step 6. Extract mean estimates from summary files (Segments in ROH(%)), and store them in a .csv file. 

Step 7. Run ROH_plotting.R to generate Figure S6. 
