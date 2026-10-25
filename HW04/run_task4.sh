#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task4
#SBATCH --output=Task4.out
#SBATCH --error=Task4.err
#SBATCH --time=0-00:30:00

N=100
TEND=100

for policy in static dynamic guided
do
    # temporary copy of task3.cpp with the schedule clause set to this policy
    sed "s/#pragma omp parallel for.*/#pragma omp parallel for schedule($policy)/" task3.cpp > task3_$policy.cpp
    g++ task3_$policy.cpp -Wall -O3 -std=c++17 -o task3_$policy -fopenmp

    outfile=task4_$policy.txt
    echo "Scheduling: $policy" > $outfile
    echo "Particles: $N, End time: $TEND" >> $outfile
    printf "%-10s %s\n" "Threads" "Time (ms)" >> $outfile

    for t in {1..8}
    do
        output=$(./task3_$policy $N $TEND $t)
        # last line looks like "time: 123.4ms"; keep only the number
        time=$(echo "$output" | tail -n 1 | sed 's/time: //; s/ms//')
        printf "%-10s %s\n" "$t" "$time" >> $outfile
    done

    rm -f task3_$policy.cpp task3_$policy
done