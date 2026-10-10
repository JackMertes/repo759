#include "convolution.h"
#include <iostream>
#include <cstdlib>
#include <chrono>
#include <random>
#include <omp.h>

int main(int argc, char *argv[])
{
    if (argc != 3) {
        std::cerr << "Usage: ./task2 n t\n";
        return 1;
    }

    int n = std::atoi(argv[1]);
    int t = std::atoi(argv[2]);

    if (n <= 0 || t < 1 || t > 20) {
        std::cerr << "n must be positive and t must be between 1 and 20\n";
        return 1;
    }

    const int m = 3;

    float *image = new float[n * n];
    float *output = new float[n * n];
    float *mask = new float[m * m];

    std::mt19937 generator(759);
    std::uniform_real_distribution<float> image_dist(-10.0f, 10.0f);
    std::uniform_real_distribution<float> mask_dist(-1.0f, 1.0f);

    for (int i = 0; i < n * n; i++) {
        image[i] = image_dist(generator);
    }

    for (int i = 0; i < m * m; i++) {
        mask[i] = mask_dist(generator);
    }

    omp_set_num_threads(t);

    const auto start = std::chrono::high_resolution_clock::now();
    convolve(image, output, n, mask, m);
    const auto end = std::chrono::high_resolution_clock::now();

    const std::chrono::duration<double, std::milli> time = end - start;

    std::cout << output[0] << '\n';
    std::cout << output[n * n - 1] << '\n';
    std::cout << time.count() << '\n';

    delete[] image;
    delete[] output;
    delete[] mask;

    return 0;
}