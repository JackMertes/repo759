#!/usr/bin/env zsh
#SBATCH -p instruction
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task3
#SBATCH --output=Task3.out
#SBATCH --error=Task3.err
#SBATCH --time=0-01:00:00
#SBATCH --gpus-per-task=1

module load nvidia/cuda

# Run with 512 threads
nvcc task3.cu vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3
for p in {10..29}; do
    n=$((2**p))
    echo "512 threads, n=$n"
    ./task3 $n
done

# Create a temporary 16 thread version
sed 's/int threads = 512;/int threads = 16;/' task3.cu > task3_temp.cu

# Run with 16 threads
nvcc task3_temp.cu vscale.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task3_16
for p in {10..29}; do
    n=$((2**p))
    echo "16 threads, n=$n"
    ./task3_16 $n
done

rm task3_temp.cu task3_16