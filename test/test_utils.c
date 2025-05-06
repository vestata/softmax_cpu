#include "test_utils.h"

float* generate_input(int size) {
    srand(42);
    float* arr = (float*)malloc(sizeof(float) * size);
    for (int i = 0; i < size; i++) {
        arr[i] = (float)rand() / RAND_MAX * 10.0f;
    }
    return arr;
}

double time_diff(struct timespec start, struct timespec end)
{
    return (end.tv_sec - start.tv_sec) * 1e3 +
           (end.tv_nsec - start.tv_nsec) / 1e6;
}
