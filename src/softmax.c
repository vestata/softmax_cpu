#include "softmax.h"

struct softmax_entry softmax_table[] = {
    {"softmax_scalar", softmax_scalar},
    {"safe_softmax_fastexp", safe_softmax_fastexp},
    {"softmax_avx2", softmax_256},
    {"softmax_avx2_vexpf", softmax_256_vexpf},
    {"softmax_online_scalar", softmax_online_scalar},
};

const int softmax_table_size = sizeof(softmax_table) / sizeof(softmax_table[0]);

float fast_exp(float x)
{
    const float LOG2_E = 1.442695041f;
    const float A = 0.3371894346f;
    const float B = 0.657636276f;
    const float C = 1.00172476f;

    float t = x * LOG2_E;
    float fi = floorf(t);
    float f = t - fi;
    int32_t i = (int32_t) fi;

    /* Polynomial approximation for 2^f */
    float exp2_frac = (A * f + B) * f + C;

    union {
        float f;
        uint32_t u;
    } v;

    v.f = exp2_frac;
    v.u += ((uint32_t) i << 23);
    return v.f;
}
