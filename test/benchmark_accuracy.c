#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "softmax.h"
#include "test_utils.h"

#define MAX_SIZE 10000
#define STEP 32
#define REPEAT 20

int main() {
    softmax_func FUNC = softmax_table[SOFTMAX_VERSION].a;
    const char *FUNC_NAME = softmax_table[SOFTMAX_VERSION].name;

    char out_filename[256];
    snprintf(out_filename, sizeof(out_filename), "data/error_%s.csv", FUNC_NAME);

    FILE *fp = fopen(out_filename, "w");
    if (!fp) {
        perror("fopen failed");
        return 1;
    }

    fprintf(fp, "size,max_error\n");

    for (int size = 0; size <= MAX_SIZE; size += STEP) {
        float *input = generate_input(size);
        float *output = (float *) malloc(sizeof(float) * size);
        float *baseline = (float *) malloc(sizeof(float) * size);

        /* Safe softmax as baseline */
        softmax_scalar(input, baseline, size);

        FUNC(input, output, size);
        float err = compute_max_error(output, baseline, size);

        fprintf(fp, "%d,%e\n", size, err);
        free(input);
        free(output);
        free(baseline);
    }

    fclose(fp);
    printf("Accuracy benchmark complete. Output saved to %s\n", out_filename);
    return 0;
}
