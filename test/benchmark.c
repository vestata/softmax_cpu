#include "test_utils.h"

#define MAX_SIZE 300000
#define STEP 1000

#if SOFTMAX_VERSION == 0
#define FUNC softmax_scalar
#define OUT_FILE "data/softmax_time_scalar.csv"
#elif SOFTMAX_VERSION == 1
#define FUNC softmax_256
#define OUT_FILE "data/softmax_time_avx2.csv"
#else
#error "Invalid SOFTMAX_VERSION"
#endif

int main() {
    FILE *fp = fopen(OUT_FILE, "w");
    if (!fp) {
        perror("fopen failed");
        return 1;
    }

    fprintf(fp, "size,time_ms\n");

    for (int size = 1; size <= MAX_SIZE; size += STEP) {
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
    printf("Benchmark complete. Output saved to %s\n", OUT_FILE);
    return 0;
}
