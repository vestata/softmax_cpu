CC = gcc
CFLAGS = -Wall -Wextra -std=c11 -Iinclude
SRC_DIR = src
BUILD_DIR = build
DATA_DIR = data
TEST_DIR = test
PLOT_DIR = plot

# Objext files
SCALAR_OBJ = $(BUILD_DIR)/scalar.o
AVX_OBJ = $(BUILD_DIR)/avx.o
AVX_VEXPF_OBJ = $(BUILD_DIR)/avx_vexpf.o
ONLINE_SCALAR_OBJ = $(BUILD_DIR)/online_scalar.o
TABLE_OBJ = $(BUILD_DIR)/softmax.o
MAIN_OBJ = $(BUILD_DIR)/main.o
TEST_UTILS_OBJ = $(BUILD_DIR)/test_utils.o
TEST_SOFTMAX_OBJ = $(BUILD_DIR)/test_softmax.o

BENCHMARK_OBJ_SCALAR  = $(BUILD_DIR)/benchmark_scalar.o
BENCHMARK_OBJ_AVX2    = $(BUILD_DIR)/benchmark_avx2.o
BENCHMARK_OBJ_AVX2_VEXPF = $(BUILD_DIR)/benchmark_avx2_vexpf.o
BENCHMARK_OBJ_ONLINE_SCALAR = $(BUILD_DIR)/benchmark_online_scalar.o

# Executables
TARGET = $(BUILD_DIR)/main
TEST_TARGET = $(BUILD_DIR)/test_softmax
BENCHMARK_SCALAR = $(BUILD_DIR)/benchmark_scalar
BENCHMARK_AVX2 = $(BUILD_DIR)/benchmark_avx2
BENCHMARK_AVX2_VEXPF = $(BUILD_DIR)/benchmark_avx2_vexpf
BENCHMARK_ONLINE_SCALAR = $(BUILD_DIR)/benchmark_online_scalar
PLOT_OUTPUT = $(PLOT_DIR)/softmax_plot.png

.PHONY: all clean test benchmark plot

# Build directories
all: | $(BUILD_DIR) $(DATA_DIR) $(TARGET) $(TEST_TARGET) benchmark

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(DATA_DIR):
	@mkdir -p $(DATA_DIR)

# === Object Rules ===
$(SCALAR_OBJ): $(SRC_DIR)/scalar.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(ONLINE_SCALAR_OBJ): $(SRC_DIR)/online_scalar.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@ -O2

$(AVX_OBJ): $(SRC_DIR)/avx.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -mavx2 -c $< -o $@

$(AVX_VEXPF_OBJ): $(SRC_DIR)/avx_vexpf.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -mavx2 -c $< -o $@

$(TABLE_OBJ): $(SRC_DIR)/softmax.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(MAIN_OBJ): $(SRC_DIR)/main.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST_UTILS_OBJ): $(TEST_DIR)/test_utils.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST_SOFTMAX_OBJ): $(TEST_DIR)/test_softmax.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BENCHMARK_OBJ_SCALAR): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=0 -c $< -o $@

$(BENCHMARK_OBJ_AVX2): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=1 -mavx2 -c $< -o $@

$(BENCHMARK_OBJ_AVX2_VEXPF): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=2 -mavx2 -c $< -o $@

$(BENCHMARK_OBJ_ONLINE_SCALAR): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=3 -c $< -o $@

# Targets
$(TARGET): $(MAIN_OBJ) $(SCALAR_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)
	$(CC) $(CFLAGS) $^ -o $@ -lm

$(TEST_TARGET): $(TEST_SOFTMAX_OBJ) $(SCALAR_OBJ)
	$(CC) $(CFLAGS) $^ -o $@ -lm

test: $(TEST_TARGET)
	./$(TEST_TARGET)

# Benchmark Executables
benchmark: $(BENCHMARK_SCALAR) $(BENCHMARK_AVX2) $(BENCHMARK_AVX2_VEXPF) $(BENCHMARK_ONLINE_SCALAR)

BENCHMARK_COMMON = $(TEST_UTILS_OBJ) $(SCALAR_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)

$(BENCHMARK_SCALAR): $(BENCHMARK_OBJ_SCALAR) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_AVX2): $(BENCHMARK_OBJ_AVX2) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_AVX2_VEXPF): $(BENCHMARK_OBJ_AVX2_VEXPF) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_ONLINE_SCALAR): $(BENCHMARK_OBJ_ONLINE_SCALAR) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

# === Plot ===
plot: benchmark
	taskset -c 0 ./$(BENCHMARK_SCALAR)
	taskset -c 0 ./$(BENCHMARK_AVX2)
	taskset -c 0 ./$(BENCHMARK_AVX2_VEXPF)
	taskset -c 0 ./$(BENCHMARK_ONLINE_SCALAR)
	gnuplot $(PLOT_DIR)/plot.gp
	@echo "Plot saved to $(PLOT_OUTPUT)"
	open $(PLOT_OUTPUT)

clean:
	rm -rf $(BUILD_DIR) $(DATA_DIR) $(PLOT_OUTPUT)

