#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=lostruct_setup
#SBATCH --nodes=1 --ntasks=1
#SBATCH --partition quanah
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

module load intel bcftools 

for i in $( ls *recode.vcf ); do

	echo $i;
	
	# get the first genotypes line from the file
	grep -v "#" $i | head -n1 > temp2.vcf

	# replace any non-reference alleles with the 0/0
	sed 's/0\/1/0\/0/g' temp2.vcf > temp3.vcf
	sed 's/1\/1/0\/0/g' temp3.vcf > temp4.vcf

	# set the position of the row to 1
	awk '{$2=1 ; OFS="\t"; print ;}' temp4.vcf > temp5.vcf
	
	# replace whitespaces with tabs (OFS in awk didn't work and spaces replaced tabs in output for some reason)
	sed 's/ /\t/g' temp5.vcf > temp6.vcf

	# add the header to the new file
	grep "#" $i > ${i%recode.vcf}vcf

	# add the single line to the new file
	cat temp6.vcf >> ${i%recode.vcf}vcf

	# add the rest of the genotype information to the new file
	grep -v "#" $i >> ${i%recode.vcf}vcf

	# convert to bcf and index
	bcftools convert -O b ${i%recode.vcf}vcf > ${i%recode.vcf}bcf
	bcftools index ${i%recode.vcf}bcf

	# remove temp files
	rm temp2.vcf
	rm temp3.vcf
	rm temp4.vcf
	rm temp5.vcf
	rm temp6.vcf
	rm ${i%recode.vcf}vcf

done
