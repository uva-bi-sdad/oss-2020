#!/bin/bash

#SBATCH -p bii
#SBATCH -A biocomplexity
#SBATCH --job-name=oss_nets_wisos_lchn_nbots
#SBATCH --time=1-100:00:00
#SBATCH -c 32
#SBATCH --mem=200G

module purge
ml gcc/7.1.0 openmpi/3.1.4 R/4.0.0

Rscript 01_intl-ctry-nets-cum-analysis-wisos-lchn-nbots.R
