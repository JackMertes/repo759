
#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=8G
#SBATCH --job-name=Task2
#SBATCH --output=Task2.out
#SBATCH --error=Task2.err
#SBATCH --time=0-01:00:00
#SBATCH --gpus-per-task=1

module load nvidia/cuda

nvcc task2.cu stencil.cu -Xcompiler -O3 -Xcompiler -Wall -Xptxas -O3 -std=c++17 -o task2

for threads in 1024 512
do
    echo "Threads per block: $threads"

    for exponent in {10..29}
    do
        n=$((2**exponent))

        echo "n = $n, R = 128, threads = $threads"
        ./task2 $n 128 $threads
    done
done
