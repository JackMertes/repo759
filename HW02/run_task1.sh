#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=1
#SBATCH --mem=10G
#SBATCH --job-name=Task1
#SBATCH --output=Task1.out
#SBATCH --error=Task1.err
#SBATCH --time=0-00:30:00

rm -f task1_data.txt

for p in {10..30}
do
    n=$((2**p))
    time=$(./task1 $n | head -n 1)
    echo "$n $time" >> task1_data.txt
done