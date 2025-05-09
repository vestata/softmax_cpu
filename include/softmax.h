#ifndef SOFTMAX_H
#define SOFTMAX_H

#include <float.h>
#include <math.h>
#include <stdint.h>
#include <string.h>

typedef void (*softmax_func)(const float *input, float *output, int size);

struct softmax_entry {
    const char *name;
    softmax_func a;
};

extern struct softmax_entry softmax_table[];
extern const int softmax_table_size;

float fast_exp(float x);

void softmax_scalar(const float *input, float *output, int size);
void safe_softmax_fastexp(const float *input, float *output, int size);
void softmax_256(const float *input, float *output, int size);
void softmax_256_vexpf(const float *input, float *output, int size);
void softmax_online_scalar(const float *input, float *output, int size);

#endif
