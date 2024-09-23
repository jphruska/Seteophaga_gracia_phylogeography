#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_phylogeny_astral_tip_map
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G



java -jar /home/jmanthey/Astral/astral.5.6.3.jar -i setophaga_total.trees -o setophaga_astral_tip_map.tre -a astral_map.txt 2> setophaga_astral_tip_map.log
