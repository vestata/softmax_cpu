#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "softmax.h"

float *generate_input(int size);
double time_diff(struct timespec start, struct timespec end);
bool check_result(const float *output, const float *check, int size);
float compute_max_error(const float *output, const float *baseline, int size);
