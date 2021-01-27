#!/bin/bash

#SBATCH -p bii
#SBATCH -A biocomplexity
#SBATCH --job-name=oss_gh_nets_botcomp
#SBATCH --time=1-100:00:00
#SBATCH -c 2
#SBATCH --mem=250G

module purge
ml gcc/7.1.0 openmpi/3.1.4 R/4.0.0

Rscript 01_intl-ctr-nets-cum-analysis-withoutbots.R
