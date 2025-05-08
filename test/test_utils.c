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

bool check_result(const float *output, const float *check, int size)
{
    for (int i = 0; i < size; i++) {
        if (fabsf(output[i] - check[i]) > 1e-3) {
            return 0;
        }
    }
    return 1;
}

float compute_max_error(const float *output, const float *baseline, int size)
{
    float max_error = 0.0f;
    for (int i = 0; i < size; i++) {
        float diff = fabsf(output[i] - baseline[i]);
        if (diff > max_error)
            max_error = diff;
    }
    return max_error;
}
