#!/bin/bash 

#SBATCH --ntasks=1
#SBATCH --mem=6000
#SBATCH --partition=standard
#SBATCH --time=1:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=6
#SBATCH --mem-per-cpu=4G

module purge
module load julia
module list

srun julia --proj test/runtests.jl
