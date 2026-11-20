
#include "matmul.cuh"

__global__ void matmul_kernel(const float* A, const float* B, float* C, size_t n)
{
    size_t index = blockIdx.x * blockDim.x + threadIdx.x;

    if (index >= n * n)
        return;

    size_t row = index / n;
    size_t col = index % n;

    float sum = 0.0f;

    for (size_t k = 0; k < n; k++)
    {
        sum += A[row * n + k] * B[k * n + col];
    }

    C[row * n + col] = sum;
}

void matmul(const float* A, const float* B, float* C, size_t n, unsigned int threads_per_block)
{
    size_t total_elements = n * n;
    unsigned int num_blocks = (total_elements + threads_per_block - 1) / threads_per_block;

    matmul_kernel<<<num_blocks, threads_per_block>>>(A, B, C, n);
}
