#include "softmax.h"

struct softmax_entry softmax_table[] = {
    {"softmax_scalar", softmax_scalar},
    {"softmax_avx2", softmax_256},
};

const int softmax_table_size = sizeof(softmax_table) / sizeof(softmax_table[0]);
