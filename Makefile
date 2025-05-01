CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Iinclude
SRC_DIR = src
BUILD_DIR = build
TEST_DIR = test

SRC = $(SRC_DIR)/main.c $(SRC_DIR)/scalar.c
TEST_SRC = $(TEST_DIR)/test_softmax.c $(SRC_DIR)/scalar.c

TARGET = $(BUILD_DIR)/main
TEST_TARGET = $(BUILD_DIR)/test_softmax

BENCHMARK_SRC = test/benchmark.c src/scalar.c
BENCHMARK_TARGET = build/benchmark

.PHONY: all clean test

all: $(TARGET) $(TEST_TARGET) $(BENCHMARK_TARGET)

$(TARGET): $(SRC)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lm

test: $(TEST_TARGET)
	$(TEST_TARGET)

$(TEST_TARGET): $(TEST_SRC)
	mkdir -p $(BUILD_DIR)
	$(CC) $(CFLAGS) $^ -o $@ -lm

benchmark: $(BENCHMARK_TARGET)
	$(BENCHMARK_TARGET)

$(BENCHMARK_TARGET): $(BENCHMARK_SRC)
	mkdir -p build data
	$(CC) $(CFLAGS) $^ -o $@ -lm

plot: benchmark
	gnuplot plot/plot.gp
	open plot/softmax_plot.png

clean:
	rm -rf $(BUILD_DIR)

