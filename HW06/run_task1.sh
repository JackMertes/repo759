#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task1
#SBATCH --output=Task1.out
#SBATCH --error=Task1.err
#SBATCH --time=0-00:30:00
#SBATCH --gpus-per-task=1

module load nvidia/cuda

nvcc task1.cu matmul.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task1

for threads in 1024 256
do
    echo "Threads per block: $threads"

    for exponent in {5..14}
    do
        n=$((2**exponent))

        echo "n = $n, threads = $threads"
        ./task1 $n $threads
    done
done