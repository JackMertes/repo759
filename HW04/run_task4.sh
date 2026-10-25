#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task4
#SBATCH --output=Task4.out
#SBATCH --error=Task4.err
#SBATCH --time=0-00:30:00

sed "s/#pragma omp parallel for.*/#pragma omp parallel for schedule(static)/" task3.cpp > task3_static.cpp
g++ task3_static.cpp -Wall -O3 -std=c++17 -o task3_static -fopenmp

echo "static" > task4_static.txt

for t in {1..8}
do
    output=$(./task3_static 100 100 $t)
    time=$(echo "$output" | tail -n 1 | sed 's/time: //')
    echo "$t $time" >> task4_static.txt
done