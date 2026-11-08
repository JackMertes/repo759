#!/usr/bin/env zsh
#SBATCH -p instruction
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task2
#SBATCH --output=Task2.out
#SBATCH --error=Task2.err
#SBATCH --time=0-00:10:00
#SBATCH --gpus-per-task=1

module load nvidia/cuda

nvcc task2.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2

./task2