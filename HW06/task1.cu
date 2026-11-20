
#include <iostream>
#include <cstdlib>
#include <random>
#include <vector>
#include <cuda_runtime.h>
#include "matmul.cuh"

int main(int argc, char *argv[])
{
    if (argc != 3) {
        std::cerr << "Usage: ./task1 n threads_per_block\n";
        return 1;
    }

    size_t n = std::strtoull(argv[1], nullptr, 10);
    unsigned int threads_per_block = std::strtoul(argv[2], nullptr, 10);

    if (n == 0 || threads_per_block == 0) {
        std::cerr << "n and threads_per_block must be positive\n";
        return 1;
    }

    size_t num_elements = n * n;

    // Allocate host arrays
    std::vector<float> A(num_elements);
    std::vector<float> B(num_elements);
    std::vector<float> C(num_elements);

    // Generate random numbers
    std::mt19937 generator(759);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);

    for (size_t i = 0; i < num_elements; i++) {
        A[i] = dist(generator);
        B[i] = dist(generator);
    }

    // Allocate device arrays
    float *dA, *dB, *dC;
    cudaMalloc((void **)&dA, num_elements * sizeof(float));
    cudaMalloc((void **)&dB, num_elements * sizeof(float));
    cudaMalloc((void **)&dC, num_elements * sizeof(float));

    // Copy input matrices from host to device
    cudaMemcpy(dA, A.data(), num_elements * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, B.data(), num_elements * sizeof(float), cudaMemcpyHostToDevice);

    // Create CUDA events for timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Time matrix multiplication
    cudaEventRecord(start);

    matmul(dA, dB, dC, n, threads_per_block);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0.0f;
    cudaEventElapsedTime(&milliseconds, start, stop);

    // Copy result back to host
    cudaMemcpy(C.data(), dC, num_elements * sizeof(float), cudaMemcpyDeviceToHost);

    // Print results
    std::cout << C[num_elements - 1] << '\n';
    std::cout << milliseconds << '\n';

    // Free device memory and CUDA events
    cudaFree(dA);
    cudaFree(dB);
    cudaFree(dC);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
