#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=20
#SBATCH --mem=10G
#SBATCH --job-name=Task1
#SBATCH --output=Task1.out
#SBATCH --error=Task1.err
#SBATCH --time=0-00:30:00

g++ task1.cpp matmul.cpp -Wall -O3 -std=c++17 -o task1 -fopenmp

rm -f task1_data.txt

for t in {1..20}
do
    output=$(./task1 1024 $t)
    time=$(echo "$output" | tail -n 1)
    echo "$t $time" >> task1_data.txt
done