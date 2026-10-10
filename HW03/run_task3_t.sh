#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=20
#SBATCH --mem=10G
#SBATCH --job-name=Task3T
#SBATCH --output=task3_t.out
#SBATCH --error=task3_t.err
#SBATCH --time=0-00:30:00

g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

rm -f task3_t_data.txt

for t in {1..20}
do
    output=$(./task3 1000000 $t 256)
    time=$(echo "$output" | tail -n 1)
    echo "$t $time" >> task3_t_data.txt
done
