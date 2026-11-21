
#include "stencil.cuh"

__global__ void stencil_kernel(const float* image, const float* mask,
                             float* output, unsigned int n, unsigned int R)
{
    extern __shared__ float shared_memory[];

    unsigned int threads = blockDim.x;
    unsigned int mask_size = 2 * R + 1;
    unsigned int image_tile_size = threads + 2 * R;

    // Partition dynamic shared memory
    float* shared_image = shared_memory;
    float* shared_mask = shared_image + image_tile_size;
    float* shared_output = shared_mask + mask_size;

    unsigned int block_start = blockIdx.x * threads;

    // Load image tile including halo elements
    for (unsigned int i = threadIdx.x; i < image_tile_size; i += threads)
    {
        int global_index = (int)block_start + (int)i - (int)R;

        if (global_index >= 0 && global_index < (int)n)
            shared_image[i] = image[global_index];
        else
            shared_image[i] = 1.0f;
    }

    // Load mask into shared memory
    for (unsigned int i = threadIdx.x; i < mask_size; i += threads)
    {
        shared_mask[i] = mask[i];
    }

    __syncthreads();

    // Calculate one output per thread
    unsigned int global_index = block_start + threadIdx.x;

    if (global_index < n)
    {
        float sum = 0.0f;

        for (unsigned int j = 0; j < mask_size; j++)
        {
            sum += shared_image[threadIdx.x + j] * shared_mask[j];
        }

        shared_output[threadIdx.x] = sum;
    }

    __syncthreads();

    // Write shared output back to global memory
    if (global_index < n)
    {
        output[global_index] = shared_output[threadIdx.x];
    }
}

__host__ void stencil(const float* image, const float* mask,
                      float* output, unsigned int n, unsigned int R,
                      unsigned int threads_per_block)
{
    unsigned int mask_size = 2 * R + 1;
    unsigned int image_tile_size = threads_per_block + 2 * R;

    size_t shared_memory_size =
        (image_tile_size + mask_size + threads_per_block) * sizeof(float);

    unsigned int num_blocks =
        (n + threads_per_block - 1) / threads_per_block;

    stencil_kernel<<<num_blocks, threads_per_block, shared_memory_size>>>(
        image, mask, output, n, R);
}
