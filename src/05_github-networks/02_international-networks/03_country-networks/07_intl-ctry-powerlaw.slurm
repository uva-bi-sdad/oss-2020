#!/bin/bash

#SBATCH -p bii
#SBATCH -A biocomplexity
#SBATCH --job-name=diversity_h2
#SBATCH --time=1-24:00:00
#SBATCH -c 32
#SBATCH --mem=200G

module purge
ml gcc/7.1.0 openmpi/3.1.4 R/4.0.0

Rscript 06_intl-ctry-powerlaw.R
