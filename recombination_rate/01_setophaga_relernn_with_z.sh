#!/bin/sh
#SBATCH --chdir=./
#SBATCH --job-name=relernn_setophaga_with_z
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=40
#SBATCH --partition matador
#SBATCH --time=48:00:00
#SBATCH --mem-per-cpu=9G
#SBATCH --gpus-per-node=2

source activate recomb

# used the Geospiza fortis mutation rate and generation time

SEED="42"
MU="3.44e-9"
DIR="./"
VCF="./setophaga_relernn_z.vcf"
GENOME="./setophaga.genome.with.z.bed"
GENTIME="2"

# Simulate data
ReLERNN_SIMULATE \
    --vcf ${VCF} \
    --genome ${GENOME} \
    --projectDir ${DIR} \
    --assumedMu ${MU} \
    --seed ${SEED} \
    --assumedGenTime ${GENTIME} \
    --unphased

# Training
ReLERNN_TRAIN \
    --projectDir ${DIR} \
    --seed ${SEED} \
    --nCPU 40

# Predict recombination rates
ReLERNN_PREDICT \
    --vcf ${VCF} \
    --projectDir ${DIR} \
    --seed ${SEED} \
    --unphased

# bootstrap and correct
ReLERNN_BSCORRECT \
    --projectDir ${DIR} \
    --seed ${SEED} \
    --nCPU 40 \
    --nSlice 100 \
    --nReps 100
