#include <immintrin.h>
#include "softmax.h"

void softmax_256(const float *input, float *output, int size)
{
    // Get the max of the vector, stored in vector register
    __m256 max_vec = _mm256_set1_ps(-FLT_MAX);
    for (int i = 0; i < size; i += 8) {
        __m256 x = _mm256_loadu_ps(input + i);
        max_vec = _mm256_max_ps(max_vec, x);
    }

    // Get the max in the vector register
    float max_array[8];
    _mm256_storeu_ps(max_array, max_vec);
    float max_val = max_array[0];
    for (int i = 1; i < 8; i++) {
        if (max_array[i] > max_val) max_val = max_array[i];
    }

    // Apply expf()
    float sum = 0.0f;
    for (int i = 0; i < size; i += 8) {
        __m256 x = _mm256_loadu_ps(input + i);
        x = _mm256_sub_ps(x, _mm256_set1_ps(max_val));

        float tmp[8];
        _mm256_storeu_ps(tmp, x);
        for (int j = 0; j < 8 && i + j < size; j++) {
            tmp[j] = expf(tmp[j]);
            output[i + j] = tmp[j];
            sum += tmp[j];
        }
    }

    // Divide with the sum
    __m256 sum_vec = _mm256_set1_ps(sum);
    for (int i = 0; i < size; i += 8) {
        __m256 x = _mm256_loadu_ps(output + i);
        x = _mm256_div_ps(x, sum_vec);
        _mm256_storeu_ps(output + i, x);
    }
}
