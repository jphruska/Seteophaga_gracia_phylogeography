#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset2_admixture_filtering
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

for i in $( ls *.g.vcf); do
vcftools --vcf $i --remove-indels --keep dataset1c.keep.txt --out $i.dataset2_admix.vcf --maf 0.03 --minDP 5 --max-meanDP 50 --recode --minGQ 20 --minQ 20 --max-missing 1 --min-alleles 2 --max-alleles 2 --max-maf 0.49 --thin 10000;
done
