CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Iinclude 
SRC_DIR = src
BUILD_DIR = build
DATA_DIR = data
TEST_DIR = test
PLOT_DIR = plot

SRC = $(SRC_DIR)/main.c $(SRC_DIR)/scalar.c
TEST_SRC = $(TEST_DIR)/test_softmax.c $(SRC_DIR)/scalar.c

TARGET = $(BUILD_DIR)/main
TEST_TARGET = $(BUILD_DIR)/test_softmax

BENCHMARK_SCALAR = $(BUILD_DIR)/benchmark_scalar
BENCHMARK_AVX2 = $(BUILD_DIR)/benchmark_avx2

PLOT_OUTPUT = $(PLOT_DIR)/softmax_plot.png

.PHONY: all clean test

all: $(TARGET) $(TEST_TARGET) benchmark

$(TARGET): $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lm

test: $(TEST_TARGET)
	$(TEST_TARGET)

$(TEST_TARGET): $(TEST_SRC)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lm

# Benchmark rule: build both scalar and avx2
benchmark: $(BENCHMARK_SCALAR) $(BENCHMARK_AVX2)

$(BENCHMARK_SCALAR): $(TEST_DIR)/benchmark.c $(SRC_DIR)/scalar.c
	@mkdir -p $(BUILD_DIR) $(DATA_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=0 $^ -o $@ -lm

$(BENCHMARK_AVX2): $(TEST_DIR)/benchmark.c $(SRC_DIR)/scalar.c $(SRC_DIR)/avx.c
	@mkdir -p $(BUILD_DIR) $(DATA_DIR)
	$(CC) $(CFLAGS) -mavx2 -DSOFTMAX_VERSION=1 $^ -o $@ -lm

plot: benchmark
	./$(BENCHMARK_SCALAR)
	./$(BENCHMARK_AVX2)
	gnuplot $(PLOT_DIR)/plot.gp
	@echo "Plot saved to $(PLOT_OUTPUT)"
	open $(PLOT_OUTPUT)

clean:
	rm -rf $(BUILD_DIR) $(DATA_DIR) $(PLOT_OUTPUT)

