#!/bin/bash
#SBATCH --time=00:05:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --output=task3_output.txt

g++ task3.cpp matmul.cpp -Wall -O3 -std=c++17 -o task3
./task3