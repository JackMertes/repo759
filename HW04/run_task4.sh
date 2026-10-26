#!/usr/bin/env zsh

#SBATCH -p instruction
#SBATCH --cpus-per-task=8
#SBATCH --mem=4G
#SBATCH --job-name=Task4
#SBATCH --output=Task4.out
#SBATCH --error=Task4.err
#SBATCH --time=0-00:40:00

# threads sleep at barriers instead of spinning, so one delayed thread
# doesn't stall the others when all 8 cores are in use
export OMP_WAIT_POLICY=passive

N=500
TEND=100

for policy in static dynamic guided
do
    # temporary copy of task3.cpp with the schedule clause set to this policy
    sed "s/#pragma omp parallel for.*/#pragma omp parallel for schedule($policy)/" task3.cpp > task3_$policy.cpp
    g++ task3_$policy.cpp -Wall -O3 -std=c++17 -o task3_$policy -fopenmp

    echo "Scheduling: $policy" > task4_$policy.txt

    for t in {1..8}
    do
        output=$(./task3_$policy $N $TEND $t)
        time=$(echo "$output" | tail -n 1 | sed 's/time: //')
        echo "$t $time" >> task4_$policy.txt
    done

    rm -f task3_$policy.cpp task3_$policy
done
