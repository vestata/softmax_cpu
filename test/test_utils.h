#define _POSIX_C_SOURCE 199309L
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "softmax.h"

float *generate_input(int size);
double time_diff(struct timespec start, struct timespec end);
