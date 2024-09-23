# Phylogeny workflow (Figure 2A) 

1. Run 01_phylogeny_filtering.sh on g.vcf files output by GATK. Filtering all chromosomes greater than 1 Mb, excluding the Z chromosome. 
2. Bgzip and index filtered vcf files with 02_bgzip_tabix.sh. 
3. Run phylo50kbp_array.sh to create FASTA files, estimate gene trees with raxml. This script will call create_fasta.R, which uses popmap_phylo.txt as an input. create_fasta.R sources create_fasta_from_vcf.R.
4. Combine resulting RAXML_bipartition files into one file (setophaga_total.trees).This file is quite large, and if you'd like a copy please reach out to me at jackphruska@gmail.com. 
5. Run 01_astral.sh with to generate species tree from gene trees. This run will keep all individuals as tips.
6. Since most individuals fell within expected monophyletic groups (see manuscript), we ran astral once more, using 01a_astral_tip_map.sh, this time forcing individuals into groups expected based on geographic location (using -a flag and the astral_map.txt file).
7. Import setophaga_astral_tip_map.tre into FigTree v1.4.4 to reproduce Figure 2A. 
