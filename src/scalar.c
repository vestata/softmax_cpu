#include "softmax.h"

void softmax(const float* input, float* output, int size) {
    float max = -FLT_MAX;
    for (int i = 0; i < size; i++) {
        if (input[i] > max) max = input[i];
    }

    float sum = 0.0f;
    for (int i = 0; i < size; i++) {
        output[i] = expf(input[i] - max);
        sum += output[i];
    }

    for (int i = 0; i < size; i++) {
        output[i] /= sum;
    }
}
