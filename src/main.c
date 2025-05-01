#include <stdio.h>
#include "softmax.h"

int main() {
    float input[] = {1.0f, 2.0f, 3.0f};
    float output[3];
    int size = 3;

    softmax(input, output, size);

    printf("Softmax result:\n");
    for (int i = 0; i < size; i++) {
        printf("%.6f\n", output[i]);
    }

    return 0;
}
