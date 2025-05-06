#define _POSIX_C_SOURCE 199309L
#include <time.h>
#include "softmax.h"
#include "test_utils.h"

#define MAX_SIZE 300000
#define STEP 512

int main() {
    softmax_func FUNC = softmax_table[SOFTMAX_VERSION].a;
    const char *FUNC_NAME = softmax_table[SOFTMAX_VERSION].name;

    char out_filename[256];
    snprintf(out_filename, sizeof(out_filename), "data/time_%s.csv", FUNC_NAME);

    FILE *fp = fopen(out_filename, "w");
    if (!fp) {
        perror("fopen failed");
        return 1;
    }

    fprintf(fp, "size,time_ms\n");

    for (int size = 256; size <= MAX_SIZE; size += STEP) {
        float *input = generate_input(size);
        float *output = (float *) malloc(sizeof(float) * size);

        struct timespec start, end;
        clock_gettime(CLOCK_MONOTONIC, &start);

        FUNC(input, output, size);

        clock_gettime(CLOCK_MONOTONIC, &end);

        double ms = time_diff(start, end);
        printf("size: %d\t%f ms\n", size, ms);
        fprintf(fp, "%d,%.5f\n", size, ms);

        free(input);
        free(output);
    }

    fclose(fp);
    printf("Benchmark complete. Output saved to %s\n", out_filename);
    return 0;
}
