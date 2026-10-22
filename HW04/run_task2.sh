#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task2
#SBATCH --output=Task2.out
#SBATCH --error=Task2.err
#SBATCH --time=0-00:10:00

g++ task2.cpp -Wall -O3 -std=c++17 -o task2

./task2 100 10