#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=20
#SBATCH --mem=10G
#SBATCH --job-name=Task2
#SBATCH --output=Task2.out
#SBATCH --error=Task2.err
#SBATCH --time=0-00:30:00

g++ task2.cpp convolution.cpp -Wall -O3 -std=c++17 -o task2 -fopenmp

rm -f task2_data.txt

for t in {1..20}
do
    output=$(./task2 1024 $t)
    time=$(echo "$output" | tail -n 1)
    echo "$t $time" >> task2_data.txt
done