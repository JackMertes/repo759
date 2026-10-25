#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task3
#SBATCH --output=Task3.out
#SBATCH --error=Task3.err
#SBATCH --time=0-00:10:00

g++ task3.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

./task3 100 10 8 
