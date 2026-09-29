#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --job-name=Task3
#SBATCH --output=Task3.out
#SBATCH --error=Task3.err
#SBATCH --time=0-00:30:00

g++ task3.cpp matmul.cpp -Wall -O3 -std=c++17 -o task3
./task3