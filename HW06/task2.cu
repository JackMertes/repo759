
#include <iostream>
#include <cstdlib>
#include <random>
#include <vector>
#include <cuda_runtime.h>
#include "stencil.cuh"

int main(int argc, char* argv[])
{
    if (argc != 4)
    {
        std::cerr << "Usage: ./task2 n R threads_per_block\n";
        return 1;
    }

    unsigned int n = std::strtoul(argv[1], nullptr, 10);
    unsigned int R = std::strtoul(argv[2], nullptr, 10);
    unsigned int threads_per_block = std::strtoul(argv[3], nullptr, 10);

    if (n == 0 || threads_per_block == 0 ||
        threads_per_block < 2 * R + 1)
    {
        std::cerr << "Invalid arguments\n";
        return 1;
    }

    unsigned int mask_size = 2 * R + 1;

    // Allocate host memory
    std::vector<float> image(n);
    std::vector<float> mask(mask_size);
    std::vector<float> output(n);

    // Generate random data
    std::mt19937 generator(759);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);

    for (unsigned int i = 0; i < n; i++)
        image[i] = dist(generator);

    for (unsigned int i = 0; i < mask_size; i++)
        mask[i] = dist(generator);

    // Allocate device memory
    float *d_image, *d_mask, *d_output;

    cudaMalloc((void**)&d_image, n * sizeof(float));
    cudaMalloc((void**)&d_mask, mask_size * sizeof(float));
    cudaMalloc((void**)&d_output, n * sizeof(float));

    // Copy inputs to device
    cudaMemcpy(d_image, image.data(), n * sizeof(float),
              cudaMemcpyHostToDevice);

    cudaMemcpy(d_mask, mask.data(), mask_size * sizeof(float),
              cudaMemcpyHostToDevice);

    // Create CUDA events
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    // Time stencil computation
    cudaEventRecord(start);

    stencil(d_image, d_mask, d_output, n, R, threads_per_block);

    cudaEventRecord(stop);
    cudaEventSynchronize(stop);

    float milliseconds = 0.0f;
    cudaEventElapsedTime(&milliseconds, start, stop);

    // Copy output back to host
    cudaMemcpy(output.data(), d_output, n * sizeof(float),
              cudaMemcpyDeviceToHost);

    // Print results
    std::cout << output[n - 1] << '\n';
    std::cout << milliseconds << '\n';

    // Free resources
    cudaFree(d_image);
    cudaFree(d_mask);
    cudaFree(d_output);

    cudaEventDestroy(start);
    cudaEventDestroy(stop);

    return 0;
}
