#include "matmul.h"
#include <chrono>
#include <iostream>
#include <random>
#include <vector>
#include <omp.h>

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: ./task1 n(array size) t(number of threads)\n";
        return 1;
    }

    const std::size_t n = std::stoul(argv[1]);
    const int t = std::stoi(argv[2]);

    if (n == 0 || t < 1 || t > 20) {
        std::cerr << "n must be positive and t must be between 1 and 20\n";
        return 1;
    }

    std::vector<float> A(n * n);
    std::vector<float> B(n * n);
    std::vector<float> C(n * n, 0.0f);

    std::mt19937 generator(759);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);

    for (std::size_t i = 0; i < n * n; i++) {
        A[i] = dist(generator);
        B[i] = dist(generator);
    }

    omp_set_num_threads(t);

    const auto start = std::chrono::high_resolution_clock::now();
    mmul(A.data(), B.data(), C.data(), n);
    const auto end = std::chrono::high_resolution_clock::now();

    const std::chrono::duration<double, std::milli> time = end - start;

    std::cout << C[0] << '\n';
    std::cout << C[n * n - 1] << '\n';
    std::cout << time.count() << '\n';

    return 0;
}