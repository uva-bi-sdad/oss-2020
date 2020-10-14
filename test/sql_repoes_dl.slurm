#!/bin/bash

#SBATCH --ntasks=1
#SBATCH --mem=128G
#SBATCH --partition=standard
#SBATCH --account=behnaz_lab
#SBATCH --time=1-20:00:00


module load anaconda/2019.10-py3.7

python repo-lang.py 

