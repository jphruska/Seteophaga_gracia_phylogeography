#!/bin/bash
#SBATCH --chdir=./
#SBATCH --job-name=setophaga_phylogeny_astral
#SBATCH --partition quanah
#SBATCH --nodes=1 --ntasks=12
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=8G



java -jar /home/jmanthey/Astral/astral.5.6.3.jar -i setophaga_total.trees -o setophaga_astral.tre 2> setophaga_astral.log
