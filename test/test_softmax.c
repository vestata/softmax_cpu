#include <assert.h>
#include <math.h>
#include <stdio.h>
#include "softmax.h"

#define EPSILON 1e-5

void test_softmax_basic() {
    float input[] = {1.0f, 2.0f, 3.0f};
    float output[3];
    softmax_scalar(input, output, 3);

    float expected[] = {0.0900306f, 0.244728f, 0.665241f};

    for (int i = 0; i < 3; i++) {
        assert(fabs(output[i] - expected[i]) < EPSILON);
    }

    printf("test_softmax_basic passed!\n");
}

int main() {
    test_softmax_basic();
    return 0;
}
