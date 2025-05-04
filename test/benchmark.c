#define _POSIX_C_SOURCE 199309L
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>
#include "../include/softmax.h"

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

float* generate_input(int size) {
    float* arr = (float*)malloc(sizeof(float) * size);
    for (int i = 0; i < size; i++) {
        arr[i] = (float)rand() / RAND_MAX * 10.0f;
    }
    return arr;
}

double time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) * 1e3 +
           (end.tv_nsec - start.tv_nsec) / 1e6;
}

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

        FUNC(input, output, size);  // 呼叫指定版本

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
