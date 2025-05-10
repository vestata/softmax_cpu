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
BENCHMARK_OBJ_SCALAR_FASTEXP = $(BUILD_DIR)/benchmark_scalar_fastexp.o
BENCHMARK_OBJ_AVX2    = $(BUILD_DIR)/benchmark_avx2.o
BENCHMARK_OBJ_AVX2_VEXPF = $(BUILD_DIR)/benchmark_avx2_vexpf.o
BENCHMARK_OBJ_ONLINE_SCALAR = $(BUILD_DIR)/benchmark_online_scalar.o

ACC_OBJ_SCALAR  = $(BUILD_DIR)/acc_scalar.o
ACC_OBJ_SCALAR_FASTEXP = $(BUILD_DIR)/acc_scalar_fastexp.o
ACC_OBJ_AVX2    = $(BUILD_DIR)/acc_avx2.o
ACC_OBJ_AVX2_VEXPF = $(BUILD_DIR)/acc_avx2_vexpf.o
ACC_OBJ_ONLINE_SCALAR = $(BUILD_DIR)/acc_online_scalar.o

# Executables
TARGET = $(BUILD_DIR)/main
TEST_TARGET = $(BUILD_DIR)/test_softmax

BENCHMARK_SCALAR = $(BUILD_DIR)/benchmark_scalar
BENCHMARK_SCALAR_FASTEXP = $(BUILD_DIR)/benchmark_scalar_fastexp
BENCHMARK_AVX2 = $(BUILD_DIR)/benchmark_avx2
BENCHMARK_AVX2_VEXPF = $(BUILD_DIR)/benchmark_avx2_vexpf
BENCHMARK_ONLINE_SCALAR = $(BUILD_DIR)/benchmark_online_scalar
PLOT_OUTPUT = $(PLOT_DIR)/softmax_plot.png

ACC_SCALAR = $(BUILD_DIR)/acc_scalar
ACC_SCALAR_FASTEXP = $(BUILD_DIR)/acc_scalar_fastexp
ACC_AVX2 = $(BUILD_DIR)/acc_avx2
ACC_AVX2_VEXPF = $(BUILD_DIR)/acc_avx2_vexpf
ACC_ONLINE_SCALAR = $(BUILD_DIR)/acc_online_scalar
ACC_PLOT_OUTPUT = $(PLOT_DIR)/acc_softmax_plot.png

.PHONY: all clean test benchmark plot

# Build directories
all: | $(BUILD_DIR) $(DATA_DIR) $(TARGET) $(TEST_TARGET) benchmark

$(BUILD_DIR):
	@mkdir -p $(BUILD_DIR)

$(DATA_DIR):
	@mkdir -p $(DATA_DIR)

# === Object Rules ===
$(TABLE_OBJ): $(SRC_DIR)/softmax.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(SCALAR_OBJ): $(SRC_DIR)/scalar.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(ONLINE_SCALAR_OBJ): $(SRC_DIR)/online_scalar.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@ -O2

$(AVX_OBJ): $(SRC_DIR)/avx.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -mavx2 -c $< -o $@

$(AVX_VEXPF_OBJ): $(SRC_DIR)/avx_vexpf.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -mavx2 -c $< -o $@

$(MAIN_OBJ): $(SRC_DIR)/main.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST_UTILS_OBJ): $(TEST_DIR)/test_utils.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(TEST_SOFTMAX_OBJ): $(TEST_DIR)/test_softmax.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(BENCHMARK_OBJ_SCALAR): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=0 -c $< -o $@

$(BENCHMARK_OBJ_SCALAR_FASTEXP): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=1 -c $< -o $@

$(BENCHMARK_OBJ_AVX2): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=2 -mavx2 -c $< -o $@

$(BENCHMARK_OBJ_AVX2_VEXPF): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=3 -mavx2 -c $< -o $@

$(BENCHMARK_OBJ_ONLINE_SCALAR): $(TEST_DIR)/benchmark.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=4 -c $< -o $@

$(ACC_OBJ_SCALAR): $(TEST_DIR)/benchmark_accuracy.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=0 -c $< -o $@

$(ACC_OBJ_SCALAR_FASTEXP): $(TEST_DIR)/benchmark_accuracy.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=1 -c $< -o $@

$(ACC_OBJ_AVX2): $(TEST_DIR)/benchmark_accuracy.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=2 -mavx2 -c $< -o $@

$(ACC_OBJ_AVX2_VEXPF): $(TEST_DIR)/benchmark_accuracy.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=3 -mavx2 -c $< -o $@

$(ACC_OBJ_ONLINE_SCALAR): $(TEST_DIR)/benchmark_accuracy.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -DSOFTMAX_VERSION=4 -c $< -o $@

# Targets
$(TARGET): $(MAIN_OBJ) $(SCALAR_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)
	$(CC) $(CFLAGS) $^ -o $@ -lm

$(TEST_TARGET): $(TEST_SOFTMAX_OBJ) $(SCALAR_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)
	$(CC) $(CFLAGS) $^ -o $@ -lm

test: $(TEST_TARGET)
	./$(TEST_TARGET)

# Benchmark Executables
benchmark: $(BENCHMARK_SCALAR) $(BENCHMARK_SCALAR_FASTEXP) $(BENCHMARK_AVX2) $(BENCHMARK_AVX2_VEXPF) $(BENCHMARK_ONLINE_SCALAR)

BENCHMARK_COMMON = $(TEST_UTILS_OBJ) $(SCALAR_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)

$(BENCHMARK_SCALAR): $(BENCHMARK_OBJ_SCALAR) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_SCALAR_FASTEXP): $(BENCHMARK_OBJ_SCALAR_FASTEXP) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_AVX2): $(BENCHMARK_OBJ_AVX2) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_AVX2_VEXPF): $(BENCHMARK_OBJ_AVX2_VEXPF) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(BENCHMARK_ONLINE_SCALAR): $(BENCHMARK_OBJ_ONLINE_SCALAR) $(BENCHMARK_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

# Accuracy Executables
accuracy: $(ACC_SCALAR) $(ACC_SCALAR_FASTEXP) $(ACC_AVX2) $(ACC_AVX2_VEXPF) $(ACC_ONLINE_SCALAR)

ACC_COMMON = $(TEST_UTILS_OBJ) $(SCALAR_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)

$(ACC_SCALAR): $(ACC_OBJ_SCALAR) $(ACC_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(ACC_SCALAR_FASTEXP): $(ACC_OBJ_SCALAR_FASTEXP) $(ACC_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(ACC_AVX2): $(ACC_OBJ_AVX2) $(ACC_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(ACC_AVX2_VEXPF): $(ACC_OBJ_AVX2_VEXPF) $(ACC_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

$(ACC_ONLINE_SCALAR): $(ACC_OBJ_ONLINE_SCALAR) $(ACC_COMMON)
	$(CC) $(CFLAGS) -mavx2 $^ -o $@ -lm

###################################################################
CSV_PREFIX := $(DATA_DIR)/scalar_opt_
GP_FILE    := $(PLOT_DIR)/plot_scalar_opt.gp
PNG_OUT    := $(PLOT_DIR)/scalar_opt_time.png

# scalar softmax with different GCC optimization
OPT_LEVELS := O0 O1 O2 O3 Ofast

CORE_OBJS  := $(TEST_UTILS_OBJ) $(AVX_OBJ) $(AVX_VEXPF_OBJ) \
              $(ONLINE_SCALAR_OBJ) $(TABLE_OBJ)

# build scalar_O*.o
define SCALAR_OBJ_TEMPLATE
$(BUILD_DIR)/scalar_$(1).o: $(SRC_DIR)/scalar.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -$(1) -c $$< -o $$@
endef
$(foreach o,$(OPT_LEVELS),$(eval $(call SCALAR_OBJ_TEMPLATE,$(o))))

# build branchmark_O*.o
define BENCH_TEMPLATE
$(BUILD_DIR)/bench_scalar_$(1): $(TEST_DIR)/benchmark.c $(BUILD_DIR)/scalar_$(1).o $(CORE_OBJS) | $(BUILD_DIR)
	$(CC) $(CFLAGS) -$(1) -DSOFTMAX_VERSION=0 $$^ -o $$@ -lm
endef
$(foreach o,$(OPT_LEVELS),$(eval $(call BENCH_TEMPLATE,$(o))))

.PHONY: scalar_opt_bench

# Build
scalar_opt_bench: $(foreach o,$(OPT_LEVELS),$(BUILD_DIR)/bench_scalar_$(o)) | $(DATA_DIR)
	@echo "=== start scalar safe softmax optimization benchmark ==="
	@for exe in $^ ; do \
		opt=$$(echo $$exe | sed -E 's/.*bench_scalar_(O[^/]*)/\1/'); \
		tmp=data/time_softmax_scalar.csv ; \
		out=$(CSV_PREFIX)$${opt}_time.csv ; \
		rm -f $$tmp ; \
		taskset -c 0 $$exe ; \
		if [ -f $$tmp ]; then mv $$tmp $$out; fi ; \
		echo "  ✓ $$out" ; \
	done
	@echo "=== Plot ==="
	@gnuplot $(GP_FILE)
	@echo "PNG_OUTPUT: $(PNG_OUT)"
	open $(PNG_OUT)

###################################################################

# Plot Execution Time
plot: benchmark
	taskset -c 0 ./$(BENCHMARK_SCALAR)
	taskset -c 0 ./$(BENCHMARK_SCALAR_FASTEXP)
	taskset -c 0 ./$(BENCHMARK_AVX2)
	taskset -c 0 ./$(BENCHMARK_AVX2_VEXPF)
	taskset -c 0 ./$(BENCHMARK_ONLINE_SCALAR)
	gnuplot $(PLOT_DIR)/plot.gp
	@echo "Plot saved to $(PLOT_OUTPUT)"
	open $(PLOT_OUTPUT)

# Plot Accuracy
acc: accuracy
	taskset -c 0 ./$(ACC_SCALAR)
	taskset -c 0 ./$(ACC_SCALAR_FASTEXP)
	taskset -c 0 ./$(ACC_AVX2)
	taskset -c 0 ./$(ACC_AVX2_VEXPF)
	taskset -c 0 ./$(ACC_ONLINE_SCALAR)
	gnuplot $(PLOT_DIR)/plot_acc.gp
	@echo "Plot saved to $(ACC_PLOT_OUTPUT)"
	open $(ACC_PLOT_OUTPUT)

clean:
	rm -rf $(BUILD_DIR) $(DATA_DIR) $(PLOT_OUTPUT) $(ACC_PLOT_OUTPUT)

