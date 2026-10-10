
#include "msort.h"
#include <algorithm>
#include <vector>

void serial_sort(int* arr, std::size_t n)
{
    for (std::size_t i = 1; i < n; i++) {
        int key = arr[i];
        std::size_t j = i;

        while (j > 0 && arr[j - 1] > key) {
            arr[j] = arr[j - 1];
            j--;
        }

        arr[j] = key;
    }
}

void merge(int* arr, int* temp, std::size_t left,
           std::size_t mid, std::size_t right)
{
    std::size_t i = left;
    std::size_t j = mid;
    std::size_t k = left;

    while (i < mid && j < right) {
        if (arr[i] <= arr[j]) {
            temp[k++] = arr[i++];
        } else {
            temp[k++] = arr[j++];
        }
    }

    while (i < mid) {
        temp[k++] = arr[i++];
    }

    while (j < right) {
        temp[k++] = arr[j++];
    }

    for (std::size_t p = left; p < right; p++) {
        arr[p] = temp[p];
    }
}

void parallel_merge_sort(int* arr, int* temp, std::size_t left,
                         std::size_t right, std::size_t threshold)
{
    const std::size_t n = right - left;

    if (n <= threshold) {
        serial_sort(arr + left, n);
        return;
    }

    const std::size_t mid = left + n / 2;

    #pragma omp task shared(arr, temp) firstprivate(left, mid, threshold)
    parallel_merge_sort(arr, temp, left, mid, threshold);

    #pragma omp task shared(arr, temp) firstprivate(mid, right, threshold)
    parallel_merge_sort(arr, temp, mid, right, threshold);

    #pragma omp taskwait

    merge(arr, temp, left, mid, right);
}

void msort(int* arr, const std::size_t n, const std::size_t threshold)
{
    if (n <= 1) {
        return;
    }

    if (threshold == 0) {
        serial_sort(arr, n);
        return;
    }

    std::vector<int> temp(n);

    #pragma omp parallel
    {
        #pragma omp single
        parallel_merge_sort(arr, temp.data(), 0, n, threshold);
    }
}
