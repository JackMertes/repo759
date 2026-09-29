#include "convolution.h"
#include <iostream>
#include <cstdlib>
#include <chrono>
#include <random>

int main(int argc, char *argv[])
{
    int n = atoi(argv[1]);
    int m = atoi(argv[2]);

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

    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> time;

    start = std::chrono::high_resolution_clock::now();
    convolve(image, output, n, mask, m);
    end = std::chrono::high_resolution_clock::now();

    time = end - start;

    std::cout << time.count() << "\n";
    std::cout << output[0] << "\n";
    std::cout << output[n * n - 1] << "\n";

    delete[] image;
    delete[] output;
    delete[] mask;

    return 0;
}