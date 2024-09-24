#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_dataset4_filtering
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=8:00:00
#SBATCH --mem-per-cpu=8G

for i in $( ls *.g.vcf); do
vcftools --vcf $i --remove-indels --keep dataset1b.keep.txt --out $i.dataset4.vcf --minDP 10 --max-meanDP 50 --recode --max-missing 0.80;
done

