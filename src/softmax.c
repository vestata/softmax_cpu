#include "softmax.h"

struct softmax_entry softmax_table[] = {
    {"softmax_scalar", softmax_scalar},
    {"softmax_avx2", softmax_256},
    {"softmax_avx2_vexpf", softmax_256_vexpf},
};

const int softmax_table_size = sizeof(softmax_table) / sizeof(softmax_table[0]);
