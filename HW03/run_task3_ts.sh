#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=20
#SBATCH --mem=10G
#SBATCH --job-name=Task3TS
#SBATCH --output=task3_ts.out
#SBATCH --error=task3_ts.err
#SBATCH --time=0-01:00:00

g++ task3.cpp msort.cpp -Wall -O3 -std=c++17 -o task3 -fopenmp

rm -f task3_ts_data.txt

for p in {1..10}
do
    ts=$((2 ** p))
    output=$(./task3 1000000 8 $ts)
    time=$(echo "$output" | tail -n 1)
    echo "$ts $time" >> task3_ts_data.txt
done