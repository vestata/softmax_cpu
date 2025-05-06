#include <immintrin.h>
#include "softmax.h"

/* The fast_exp() is inspired by
 * [link](https://hackmd.io/@sysprog/euler-number#%E5%BF%AB%E9%80%9F%E8%A8%88%E7%AE%97%E6%8C%87%E6%95%B8%E5%87%BD%E6%95%B8),
 * which will trade off with some precision. */

static inline __m256 fast_exp256(__m256 x)
{
    const __m256 LOG2_E = _mm256_set1_ps(1.442695041f);
    const __m256 A = _mm256_set1_ps(0.3371894346f);
    const __m256 B = _mm256_set1_ps(0.657636276f);
    const __m256 C = _mm256_set1_ps(1.00172476f);

    __m256 t = _mm256_mul_ps(x, LOG2_E);
    __m256 fi = _mm256_floor_ps(t);
    __m256 f = _mm256_sub_ps(t, fi);
    __m256i i = _mm256_cvttps_epi32(fi);

    __m256 exp2_frac = _mm256_add_ps(
        _mm256_mul_ps(_mm256_add_ps(_mm256_mul_ps(A, f), B), f), C);
    __m256i exp2_frac_bits = _mm256_castps_si256(exp2_frac);
    __m256i shift = _mm256_slli_epi32(i, 23);
    __m256i bits = _mm256_add_epi32(exp2_frac_bits, shift);
    return _mm256_castsi256_ps(bits);
}

void softmax_256_vexpf(const float *input, float *output, int size)
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
    __m256 sum_vec = _mm256_setzero_ps();
    for (int i = 0; i < size; i += 8) {
        __m256 x = _mm256_loadu_ps(input + i);
        x = _mm256_sub_ps(x, _mm256_set1_ps(max_val));
        x = fast_exp256(x);
        _mm256_storeu_ps(output + i, x);
        sum_vec = _mm256_add_ps(sum_vec, x);
    }

    float sum_array[8];
    _mm256_storeu_ps(sum_array, sum_vec);
    float sum = sum_array[0];
    for (int i = 1; i < 8; i++) {
        sum += sum_array[i];
    }

    // Divide with the sum
    __m256 sum_inv = _mm256_set1_ps(sum);
    for (int i = 0; i < size; i += 8) {
        __m256 x = _mm256_loadu_ps(output + i);
        x = _mm256_div_ps(x, sum_inv);
        _mm256_storeu_ps(output + i, x);
    }
}
