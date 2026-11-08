#!/usr/bin/env zsh
#SBATCH -p instruction
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task1
#SBATCH --output=Task1.out
#SBATCH --error=Task1.err
#SBATCH --time=0-00:10:00
#SBATCH --gpus-per-task=1

module load nvidia/cuda

nvcc task1.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1

./task1