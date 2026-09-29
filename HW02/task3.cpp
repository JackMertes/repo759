#include "matmul.h"
#include <iostream>
#include <chrono>
#include <random>
#include <vector>

int main()
{
    const unsigned int n = 1024;

    std::vector<double> A(n * n);
    std::vector<double> B(n * n);
    std::vector<double> C(n * n);

    std::mt19937 generator(759);
    std::uniform_real_distribution<double> dist(-1.0, 1.0);

    for (unsigned int i = 0; i < n * n; i++) {
        A[i] = dist(generator);
        B[i] = dist(generator);
    }

    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> time;

    std::cout << n << "\n";

    std::fill(C.begin(), C.end(), 0.0);
    start = std::chrono::high_resolution_clock::now();
    mmul1(A.data(), B.data(), C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    time = end - start;
    std::cout << time.count() << "\n";
    std::cout << C[n * n - 1] << "\n";

    std::fill(C.begin(), C.end(), 0.0);
    start = std::chrono::high_resolution_clock::now();
    mmul2(A.data(), B.data(), C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    time = end - start;
    std::cout << time.count() << "\n";
    std::cout << C[n * n - 1] << "\n";

    std::fill(C.begin(), C.end(), 0.0);
    start = std::chrono::high_resolution_clock::now();
    mmul3(A.data(), B.data(), C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    time = end - start;
    std::cout << time.count() << "\n";
    std::cout << C[n * n - 1] << "\n";

    std::fill(C.begin(), C.end(), 0.0);
    start = std::chrono::high_resolution_clock::now();
    mmul4(A, B, C.data(), n);
    end = std::chrono::high_resolution_clock::now();
    time = end - start;
    std::cout << time.count() << "\n";
    std::cout << C[n * n - 1] << "\n";

    return 0;
}