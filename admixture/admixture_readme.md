# Admixture workflow (Figure 1D, S4) 

1.  Filter .g.vcfs with 01_dataset15a_admixture_filtering.sh and 01_dataset15b_admixture_filtering.sh. 15a is 10kb thinned an 15b is 50kb thinned.
2.  Run admixture (in interactive mode), with the following steps:

        Step A. Remove Z chromosome filtered VCF (CM027535.1.g.vcf.dataset15[a/b]_admix.vcf.recode.vcf). 

        Step B. Combine VCFs into one. 
        
        grep "#" CM027507.1.g.vcf.dataset15[a/b]_admix.vcf.recode.vcf > setophaga_15[a/b]_admix.vcf

        for i in $(ls *recode.vcf) ; do grep -v "#" $i >> setophaga_1_admix.vcf; done

        Step C. Make chromosome map for the vcfs

        grep -v "#" setophaga_15[a/b]_admix.vcf | cut -f 1 | uniq | awk '{print $0"\t"$0}' > chrom_map.txt
        
        Step D. Run vcftools for vcf

        vcftools --vcf setophaga_15[a/b]_admix.vcf  --plink --chrom-map chrom_map.txt --out setophaga

        Step E. Convert with plink

        /home/jmanthey/plink --file setophaga --recode12 --out setophaga2 --noweb

        Step F. Run admixture K 1 - 10. 

        for K in 1 2 3 4 5 6 7 8 9 10; do /home/jmanthey/admixture --cv setophaga2.ped $K | tee log_setophaga_${K}.out; done 

        Step G. Check cross validation error (output included below). 

        grep -h CV log_setophaga_*.out

3. Plot admixture results with 01_admixture.r. This script will reproduce Figures 1D and S4. 

