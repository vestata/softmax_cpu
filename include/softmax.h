#ifndef SOFTMAX_H
#define SOFTMAX_H

#include <float.h>
#include <math.h>

typedef void (*softmax_func_t)(const float *input, float *output, int size);

void softmax_scalar(const float *input, float *output, int size);
void softmax_256(const float *input, float *output, int size);

#endif
