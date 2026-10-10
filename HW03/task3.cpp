#include "msort.h"
#include <iostream>
#include <cstdlib>
#include <chrono>
#include <random>
#include <omp.h>

int main(int argc, char *argv[])
{
    if (argc != 4) {
        std::cerr << "Usage: ./task3 n t ts\n";
        return 1;
    }

    int n = std::atoi(argv[1]);
    int t = std::atoi(argv[2]);
    int ts = std::atoi(argv[3]);

    if (n <= 0 || t < 1 || t > 20 || ts <= 0) {
        std::cerr << "n and ts must be positive, and t must be between 1 and 20\n";
        return 1;
    }

    int *arr = new int[n];

    std::mt19937 generator(759);
    std::uniform_int_distribution<int> dist(-1000, 1000);

    for (int i = 0; i < n; i++) {
        arr[i] = dist(generator);
    }

    omp_set_num_threads(t);

    const auto start = std::chrono::high_resolution_clock::now();
    msort(arr, n, ts);
    const auto end = std::chrono::high_resolution_clock::now();

    const std::chrono::duration<double, std::milli> time = end - start;

    std::cout << arr[0] << '\n';
    std::cout << arr[n - 1] << '\n';
    std::cout << time.count() << '\n';

    delete[] arr;

    return 0;
}