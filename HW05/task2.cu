
#include <cstdio>
#include <random>
#include <cuda_runtime.h>

__global__ void slope(int *dA, int a)
{
    int x = threadIdx.x;
    int y = blockIdx.x;

    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    dA[idx] = a * x + y;
}

int main()
{
    std::mt19937 generator(759);
    std::uniform_int_distribution<int> dist(1, 100);
    int a = dist(generator);

    int *dA;
    cudaMalloc((void **)&dA, 16 * sizeof(int));

    slope<<<2, 8>>>(dA, a);

    cudaDeviceSynchronize();

    int hA[16];
    cudaMemcpy(hA, dA, 16 * sizeof(int), cudaMemcpyDeviceToHost);

    for (int i = 0; i < 16; i++)
    {
        printf("%d", hA[i]);

        if (i < 15)
            printf(" ");
    }
    printf("\n");

    cudaFree(dA);

    return 0;
}