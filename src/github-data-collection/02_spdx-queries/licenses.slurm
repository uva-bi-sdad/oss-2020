#!/bin/bash 

#SBATCH --ntasks=1
#SBATCH --mem=6000
#SBATCH --partition=standard
#SBATCH --time=03:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=4G

module purge
module load julia
module list

srun julia --proj -e 'filter!(isequal(joinpath(homedir(), ".julia")), DEPOT_PATH);
                      using Pkg;
                      pkg"instantiate";
                      pkg"precompile";
                      Pkg.test();'
