#include "scan.h"
#include <iostream>
#include <cstdlib>
#include <chrono>
#include <random>

int main(int argc, char *argv[])
{    
    int n = atoi(argv[1]);
    float *array = new float[n];
    float *output = new float[n];

    std::mt19937 generator(759);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);
    for(int i = 0; i < n; i++){
        array[i] = dist(generator);
    }

    std::chrono::high_resolution_clock::time_point start;
    std::chrono::high_resolution_clock::time_point end;
    std::chrono::duration<double, std::milli> time;

    start = std::chrono::high_resolution_clock::now();
    scan (array, output, n);
    end = std::chrono::high_resolution_clock::now();

    time = end - start;

    std::cout << time.count() << "\n";
    std::cout << output[0] << "\n";
    std::cout << output[n-1] << "\n";

    delete[] array;
    delete[] output;

    return 0;



}