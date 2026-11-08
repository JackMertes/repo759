#include "vscale.cuh"
#include <iostream>
#include <cstdlib>
#include <random>
#include <vector>
#include <cuda_runtime.h>

int main(int argc, char *argv[])
{
    if (argc != 2) {
        std::cerr << "Usage: ./task3 n\n";
        return 1;
    }

    int n = std::atoi(argv[1]);

    if (n <= 0) {
        std::cerr << "n must be positive\n";
        return 1;
    }

    // Allocate host arrays
    std::vector<float> a(n);
    std::vector<float> b(n);

    // Generate random numbers
    std::mt19937 generator(759);
    std::uniform_real_distribution<float> a_dist(-10.0f, 10.0f);
    std::uniform_real_distribution<float> b_dist(0.0f, 1.0f);

    for (int i = 0; i < n; i++) {
        a[i] = a_dist(generator);
        b[i] = b_dist(generator);
    }

    // Allocate device arrays
    float *dA, *dB;
    cudaMalloc((void **)&dA, n * sizeof(float));
    cudaMalloc((void **)&dB, n * sizeof(float));

    // Copy arrays from host to device
    cudaMemcpy(dA, a.data(), n * sizeof(float), cudaMemcpyHostToDevice);
    cudaMemcpy(dB, b.data(), n * sizeof(float), cudaMemcpyHostToDevice);

    // Configure kernel execution
    int threads = 512;
    int blocks = (n + threads - 1) / threads;

    // Create CUDA events for timing
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Time the kernel
    cudaEventRecord(start);

    vscale<<<blocks, threads>>>(dA, dB, n);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);

    // Copy results back to host
    cudaMemcpy(b.data(), dB, n * sizeof(float), cudaMemcpyDeviceToHost);

    // Print results
    std::cout << milliseconds << '\n';
    std::cout << b[0] << '\n';
    std::cout << b[n - 1] << '\n';

    // Free device memory and CUDA events
    cudaFree(dA);
    cudaFree(dB);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}