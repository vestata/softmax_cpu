#define _POSIX_C_SOURCE 199309L
#include <time.h>
#include "softmax.h"
#include "test_utils.h"

#define MAX_SIZE 20000
#define STEP 32
#define REPEAT 20

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

    for (int size = 0; size <= MAX_SIZE; size += STEP) {
        float *input = generate_input(size);
        float *output = (float *) malloc(sizeof(float) * size);
        float *check = (float *) malloc(sizeof(float) * size);

        // Use safe softmax as accuracy baseline
        softmax_scalar(input, check, size);

        // Warmup
        FUNC(input, output, size);

        double time = 0;
        for (int i = 0; i < REPEAT; i++) {
            struct timespec start, end;
            clock_gettime(CLOCK_MONOTONIC, &start);

            FUNC(input, output, size);

            clock_gettime(CLOCK_MONOTONIC, &end);

            double ms = time_diff(start, end);
            time += ms;
        }
        if (!check_result(output, check, size))
            printf("%s, The accuracy error exceeds 1e-3.\n", FUNC_NAME);
        fprintf(fp, "%d,%e\n", size, time / REPEAT);

        free(input);
        free(output);
        free(check);
    }

    fclose(fp);
    printf("Benchmark complete. Output saved to %s\n", out_filename);
    return 0;
}
