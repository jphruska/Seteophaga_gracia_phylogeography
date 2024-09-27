#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_div_diff_pi_dxy_fst_summary
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G

# Fst

touch  window_fst.txt

cd windows

# Add header 

grep 'pop1' CM027510.1__10250001__10300000__stats.txt > ../window_fst.txt

# Combine Fst output in one file.  

for i in `ls *.txt` ; do grep "Fst" $i >> ../window_fst.txt ; done

cd ../

# dxy 

touch window_dxy.txt 

cd windows

# Add header 

grep 'pop1' CM027510.1__10250001__10300000__stats.txt > ../window_dxy.txt

# Combine dxy output in one file.  

for i in `ls *.txt` ; do grep "Dxy" $i >> ../window_dxy.txt ; done

cd ../

# Pi 

touch window_pi.txt 

cd windows 

# Add header 

grep 'pop1' CM027510.1__10250001__10300000__stats.txt > ../window_pi.txt

# Combine pi output in one file.  

for i in `ls *.txt` ; do grep "pi" $i >> ../window_pi.txt ; done

cd ../
