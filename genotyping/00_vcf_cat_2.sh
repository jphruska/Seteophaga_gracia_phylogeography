# remove all partial chromosome vcfs
rm *__*

# combine those chromosomes that were split
grep -v "#" CM027507.1b.g.vcf >> CM027507.1.g.vcf
grep -v "#" CM027508.1b.g.vcf >> CM027508.1.g.vcf
grep -v "#" CM027509.1b.g.vcf >> CM027509.1.g.vcf

# remove 'b' vcf 
rm CM027507.1b.g.vcf
rm CM027508.1b.g.vcf
rm CM027509.1b.g.vcf



